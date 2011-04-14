Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab1DNP4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:56:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61345 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab1DNP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=TdVfmgaT5iOtaFG+9qLebnTGGy4wWQ+fN0DkpeMYdBZphItct+OvrnViV+nj2wG/5m
         oLF8RjD7O0shAp0vFa/NCQ1qlTz4aH2yqFmou1mSyEYGB5ac+Lrhaz44kB9ujc/hAX0O
         dyKzZ3wZdnbne9I2E6KXLgPERGlm8d7fsEP7U=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH] char: istallion: fix arbitrary kernel memory reads/writes
Date: Thu, 14 Apr 2011 19:56:25 +0400
Message-Id: <1302796585-29504-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stli_brdstats is defined as global variable.  After de-BKL-ization in
the patch b4eda9cb48eac1b7 an access to the variable is not serialized
anymore.  This leads to the race window between the check and the use
in stli_getbrdstats():

        if (copy_from_user(&stli_brdstats, bp, sizeof(combrd_t)))
                return -EFAULT;
        if (stli_brdstats.brd >= STL_MAXBRDS) <<<
                return -ENODEV;
        brdp = stli_brds[stli_brdstats.brd];  <<<

If one process calls COM_GETBRDSTATS ioctl() with sane .brd, second
process calls COM_GETBRDSTATS ioctl() with invalid .brd, and the
second process' copy_from_user() executes exactly between the check and
stli_brds[] indexation of the first process, then the first process gets
contents of memory at *stli_brds[stli_brdstats.brd] address.  Also
the resulting .nrpanels field may be too big, in this case
stli_brdstats.panels array overflows.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/staging/tty/istallion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tty/istallion.c b/drivers/staging/tty/istallion.c
index 0b26627..ca18cbf 100644
--- a/drivers/staging/tty/istallion.c
+++ b/drivers/staging/tty/istallion.c
@@ -186,7 +186,6 @@ static struct ktermios		stli_deftermios = {
  *	re-used for each stats call.
  */
 static comstats_t	stli_comstats;
-static combrd_t		stli_brdstats;
 static struct asystats	stli_cdkstats;
 
 /*****************************************************************************/
@@ -4005,6 +4004,7 @@ static int stli_getbrdstats(combrd_t __user *bp)
 {
 	struct stlibrd *brdp;
 	unsigned int i;
+	combrd_t stli_brdstats;
 
 	if (copy_from_user(&stli_brdstats, bp, sizeof(combrd_t)))
 		return -EFAULT;
-- 
1.7.0.4

