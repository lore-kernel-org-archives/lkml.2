Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2JNOrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:47:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46756 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420Ab2JNOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:17 -0400
Message-Id: <20121014143537.616662297@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Samuel Thibault <sthibault@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 028/147] staging: speakup_soft: Fix reading of init string
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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

diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/speakup/speakup_soft.c
index 2a67610..e2f5c81 100644
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -40,7 +40,7 @@ static int softsynth_is_alive(struct spk_synth *synth);
 static unsigned char get_index(void);
 
 static struct miscdevice synth_device;
-static int initialized;
+static int init_pos;
 static int misc_registered;
 
 static struct var_t vars[] = {
@@ -194,7 +194,7 @@ static int softsynth_close(struct inode *inode, struct file *fp)
 	unsigned long flags;
 	spk_lock(flags);
 	synth_soft.alive = 0;
-	initialized = 0;
+	init_pos = 0;
 	spk_unlock(flags);
 	/* Make sure we let applications go before leaving */
 	speakup_start_ttys();
@@ -239,13 +239,8 @@ static ssize_t softsynth_read(struct file *fp, char *buf, size_t count,
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


