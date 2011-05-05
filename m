Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab1EELcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 07:32:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1EELcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 07:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=jfq6rpo/LOvtttTgo9vAjHpxfwz3KpSmhytD4duXEyW7glqqCg5R8HoZ9HJP9iXTc9
         Z/qpn2U6laM314AHyRQ1ZthtrpldKukuhnwU8OYsSZWhgzZim3Bs8jMpHjV2yBcTKGmx
         eK1UiEeTrixt1XwJcg0esuEggTyU2EyilFuRQ=
Subject: [PATCH] reboot: disable usermodehelper to prevent fs access
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 05 May 2011 13:32:05 +0200
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.1 
Content-Transfer-Encoding: 7bit
Message-ID: <1304595126.1284.3.camel@zag>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] reboot: disable usermodehelper to prevent fs access

In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
should be on every system, the kernel forks processes during
shutdown, which try to access the rootfs, even when the
binary does not exist. It causes exceptions and long delays in
the disk driver, which gets read requests at the time it tries
to shut down the disk.

This patch disables all kernel-forked processes during reboot to
allow a clean poweroff.

Cc: Tejun Heo <htejun@gmail.com>
Tested-By: Anton Guda <atu@dmeti.dp.ua>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 sys.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index af468ed..70c4c51 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -314,6 +314,7 @@ void kernel_restart_prepare(char *cmd)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
 	system_state = SYSTEM_RESTART;
+	usermodehelper_disable();
 	device_shutdown();
 	sysdev_shutdown();
 	syscore_shutdown();
@@ -344,6 +345,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 	blocking_notifier_call_chain(&reboot_notifier_list,
 		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
 	system_state = state;
+	usermodehelper_disable();
 	device_shutdown();
 }
 /**


