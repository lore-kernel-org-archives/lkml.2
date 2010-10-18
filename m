Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0JRNzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:55:10 -0400
Received: from mail.bugwerft.de ([212.112.241.193]:50585 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab0JRNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:55:04 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: s.neumann@raumfeld.com, linux-input@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 1/2] input: fix Ooops with EVIOCGABS/EVIOCSABS on devices without absinfo
Date: Mon, 18 Oct 2010 15:45:23 +0200
Message-Id: <1287409524-3032-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduced by the dynamic allocation of absinfo
for input devices. We need to bail out early for input devices which
don't have absolute axis.

Oct 18 14:44:52 jup kernel: [  929.664303] Pid: 2989, comm: input Not tainted 2.6.36-rc8+ #14 MS-7260/MS-7260
Oct 18 14:44:52 jup kernel: [  929.664318] EIP: 0060:[<c12bdc01>] EFLAGS: 00010246 CPU: 0
Oct 18 14:44:52 jup kernel: [  929.664331] EIP is at evdev_ioctl+0x4f8/0x59f
Oct 18 14:44:52 jup kernel: [  929.664341] EAX: 00000040 EBX: 00000000 ECX: 00000006 EDX: f45a1efc
Oct 18 14:44:52 jup kernel: [  929.664355] ESI: 00000000 EDI: f45a1efc EBP: f45a1f24 ESP: f45a1eb8
Oct 18 14:44:52 jup kernel: [  929.664369]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 18 14:44:52 jup kernel: [  929.664402]  f470da74 f6a30e78 f462c240 00000018 bfe4a260 00000000 f45b06fc 00000000
Oct 18 14:44:52 jup kernel: [  929.664429] <0> 000000c4 b769d000 c3544620 f470da74 f45b06fc f45b06fc f45a1f38 c107dd1f
Oct 18 14:44:52 jup kernel: [  929.664458] <0> f4710b74 000000c4 00000000 00000000 00000000 0000029d 00000a74 f4710b74
Oct 18 14:44:52 jup kernel: [  929.664500]  [<c107dd1f>] ? handle_mm_fault+0x2be/0x59a
Oct 18 14:44:52 jup kernel: [  929.664513]  [<c12bd709>] ? evdev_ioctl+0x0/0x59f
Oct 18 14:44:52 jup kernel: [  929.664524]  [<c1099d30>] ? do_vfs_ioctl+0x494/0x4d9
Oct 18 14:44:52 jup kernel: [  929.664538]  [<c10432a1>] ? up_read+0x16/0x29
Oct 18 14:44:52 jup kernel: [  929.664550]  [<c101c818>] ? do_page_fault+0x2ff/0x32d
Oct 18 14:44:52 jup kernel: [  929.664564]  [<c108d048>] ? do_sys_open+0xc5/0xcf
Oct 18 14:44:52 jup kernel: [  929.664575]  [<c1099db6>] ? sys_ioctl+0x41/0x61
Oct 18 14:44:52 jup kernel: [  929.664587]  [<c1002710>] ? sysenter_do_call+0x12/0x36
Oct 18 14:44:52 jup kernel: [  929.684570] ---[ end trace 11b83e923bd8f2bb ]---

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Sven Neumann <s.neumann@raumfeld.com>
---
 drivers/input/evdev.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c908c5f..afb64cf 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -669,6 +669,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 		if ((_IOC_NR(cmd) & ~ABS_MAX) == _IOC_NR(EVIOCGABS(0))) {
 
+			if (!dev->absinfo)
+				return -EINVAL;
+
 			t = _IOC_NR(cmd) & ABS_MAX;
 			abs = dev->absinfo[t];
 
@@ -684,6 +687,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 		if ((_IOC_NR(cmd) & ~ABS_MAX) == _IOC_NR(EVIOCSABS(0))) {
 
+			if (!dev->absinfo)
+				return -EINVAL;
+
 			t = _IOC_NR(cmd) & ABS_MAX;
 
 			if (copy_from_user(&abs, p, min_t(size_t,
-- 
1.7.1

