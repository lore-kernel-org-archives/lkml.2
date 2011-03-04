Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811Ab1CDQLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:11:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46078 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703Ab1CDQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:11:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=bb0nyoM2Tw8aLiYiPBSZPEVm6g/838yE2FF+tk/LM3GkfS1M9tL5OHPohXcFuGwPaj
         C2iOY3sOzCOt0Yz3ZLcBQw+jwJ0Uh5jWGnP/SSjhQVh+1/llamPsgrllPw1ClXKAgoGL
         jI0sJ5nUDxISDS91ytwh04glv1Qs6HjicSu/0=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@lists.linux-foundation.org
Subject: [PATCH] power: disable hibernation if module loading is disabled
Date: Fri,  4 Mar 2011 19:11:24 +0300
Message-Id: <1299255084-4390-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
root) may not read/write arbitrary kernel memory.  In spite of it,
hibernation allows anyone with an access to either /dev/snapshot or
/sys/power/ make the full snapshot of the system.  This snapshot may be
freely changed and uploaded back.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 kernel/power/hibernate.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 1832bd2..1ac9eee 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -328,6 +328,9 @@ int hibernation_snapshot(int platform_mode)
 {
 	int error;
 
+	if (modules_disabled)
+		return -EPERM;
+
 	error = platform_begin(platform_mode);
 	if (error)
 		goto Close;
@@ -385,6 +388,9 @@ static int resume_target_kernel(bool platform_mode)
 {
 	int error;
 
+	if (modules_disabled)
+		return -EPERM;
+
 	error = dpm_suspend_noirq(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
-- 
1.7.0.4

