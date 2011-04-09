Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1DIMl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 08:41:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62770 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1DIMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 08:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=LD4xSSq0wzNlEqiBSaC71jKE8mxI0B8UBBRdLZ6eIqLhuCi0VatDYNOi174OxkoJKd
         bTSEkUi6Ing+7sdxtJaYSMSl0CbjdCeiw4wKC182okjZ4a5pYsJ6a22Sinepw77aDJfM
         wS7i4io6Y46Eyvia+Kg3cu7xooh82uGo5Wy48=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] char: istallion: fix arbitrary kernel memory reads/writes
Date: Sat,  9 Apr 2011 16:41:22 +0400
Message-Id: <1302352882-20802-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stli_brdstats is defined as global variable.  After de-BKL-ization in
the patch b4eda9cb48eac1b7 an access to the variable is not serialized
anymore.  This leads to the TOCTOU in stli_getbrdstats():

        if (copy_from_user(&stli_brdstats, bp, sizeof(combrd_t)))
                return -EFAULT;
        if (stli_brdstats.brd >= STL_MAXBRDS)  <<<<
                return -ENODEV;
        brdp = stli_brds[stli_brdstats.brd];   <<<<

If one process calls COM_GETBRDSTATS ioctl() with sane .brd, second
process calls COM_GETBRDSTATS ioctl() with invalid .brd, and the
second process' copy_from_user() executes exactly between the check and
stli_brds[] indexation of the first process, then the first process gets
contents of memory at *stli_brds[stli_brdstats.brd] address.  Also
the resulting .nrpanels field may be too big, in this case
stli_brdstats.panels array overflows.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/char/istallion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7c6de4c..232c5e0 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
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

