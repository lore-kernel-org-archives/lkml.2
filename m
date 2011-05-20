Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab1ETAOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:14:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38122 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934968Ab1ETAMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:07 -0400
X-Sasl-enc: L3LAFNFjJ6JVTuhCsk8ax//9xtBdzDZtDKp9xkmbnEqU 1305850326
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/44] reboot: disable usermodehelper to prevent fs access
Date: Thu, 19 May 2011 17:10:53 -0700
Message-Id: <1305850262-9575-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
-- 
1.7.4.2

