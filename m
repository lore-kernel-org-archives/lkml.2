Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2JZAFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:05:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:52316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab2JZAFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Denis Kirjanov <kirjanov@gmail.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [ 16/31] amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]
Date: Thu, 25 Oct 2012 17:04:23 -0700
Message-Id: <20121026000216.604656055@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 168bfeef7bba3f9784f7540b053e4ac72b769ce9 upstream.

If none of the elements in scrubrates[] matches, this loop will cause
__amd64_set_scrub_rate() to incorrectly use the n+1th element.

As the function is designed to use the final scrubrates[] element in the
case of no match, we can fix this bug by simply terminating the array
search at the n-1th element.

Boris: this code is fragile anyway, see here why:
http://marc.info/?l=linux-kernel&m=135102834131236&w=2

It will be rewritten more robustly soonish.

Reported-by: Denis Kirjanov <kirjanov@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/amd64_edac.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -161,8 +161,11 @@ static int __amd64_set_scrub_rate(struct
 	 * memory controller and apply to register. Search for the first
 	 * bandwidth entry that is greater or equal than the setting requested
 	 * and program that. If at last entry, turn off DRAM scrubbing.
+	 *
+	 * If no suitable bandwidth is found, turn off DRAM scrubbing entirely
+	 * by falling back to the last element in scrubrates[].
 	 */
-	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
+	for (i = 0; i < ARRAY_SIZE(scrubrates) - 1; i++) {
 		/*
 		 * skip scrub rates which aren't recommended
 		 * (see F10 BKDG, F3x58)
@@ -172,12 +175,6 @@ static int __amd64_set_scrub_rate(struct
 
 		if (scrubrates[i].bandwidth <= new_bw)
 			break;
-
-		/*
-		 * if no suitable bandwidth found, turn off DRAM scrubbing
-		 * entirely by falling back to the last element in the
-		 * scrubrates array.
-		 */
 	}
 
 	scrubval = scrubrates[i].scrubval;


