Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200Ab2JDVs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:48:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934150Ab2JDVXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:23:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Samuel Thibault <sthibault@debian.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 10/52] staging: speakup_soft: Fix reading of init string
Date: Thu,  4 Oct 2012 14:21:01 -0700
Message-Id: <20121004210636.626738543@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 40fe4f89671fb3c7ded94190fb267402a38b0261 upstream.

softsynth_read() reads a character at a time from the init string;
when it finds the null terminator it sets the initialized flag but
then repeats the last character.

Additionally, if the read() buffer is not big enough for the init
string, the next read() will start reading from the beginning again.
So the caller may never progress to reading anything else.

Replace the simple initialized flag with the current position in
the init string, carried over between calls.  Switch to reading
real data once this reaches the null terminator.

(This assumes that the length of the init string can't change, which
seems to be the case.  Really, the string and position belong together
in a per-file private struct.)

Tested-by: Samuel Thibault <sthibault@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/speakup_soft.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -40,7 +40,7 @@ static int softsynth_is_alive(struct spk
 static unsigned char get_index(void);
 
 static struct miscdevice synth_device;
-static int initialized;
+static int init_pos;
 static int misc_registered;
 
 static struct var_t vars[] = {
@@ -194,7 +194,7 @@ static int softsynth_close(struct inode
 	unsigned long flags;
 	spk_lock(flags);
 	synth_soft.alive = 0;
-	initialized = 0;
+	init_pos = 0;
 	spk_unlock(flags);
 	/* Make sure we let applications go before leaving */
 	speakup_start_ttys();
@@ -239,13 +239,8 @@ static ssize_t softsynth_read(struct fil
 			ch = '\x18';
 		} else if (synth_buffer_empty()) {
 			break;
-		} else if (!initialized) {
-			if (*init) {
-				ch = *init;
-				init++;
-			} else {
-				initialized = 1;
-			}
+		} else if (init[init_pos]) {
+			ch = init[init_pos++];
 		} else {
 			ch = synth_buffer_getc();
 		}


