Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1C3W3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:29:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45093 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab1C3W3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:29:45 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] vt: avoid BUG_ON in con_shutdown when con_open returns with error
Date: Wed, 30 Mar 2011 19:29:38 -0300
Message-Id: <1301524178-7925-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current vt code, if con_open fails we can end up triggering the
BUG_ON in con_shutdown as shown by the following trace:

------------[ cut here ]------------
kernel BUG at /build/buildd/linux-2.6.38/drivers/tty/vt/vt.c:2857!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0b.0/resource
Modules linked in: usb_storage uas iptable_filter ip_tables x_tables binfmt_misc snd_ens1371 gameport snd_ac97_codec ac97_bus snd_bt87x snd_pcm snd_seq_midi rc_pixelview snd_rawmidi tuner_simple tuner_types nouveau snd_seq_midi_event ir_lirc_codec tuner ttm lirc_dev tvaudio tda7432 snd_seq ir_sony_decoder drm_kms_helper snd_timer bttv v4l2_common videodev ir_jvc_decoder drm videobuf_dma_sg ir_rc6_decoder snd_seq_device videobuf_core ir_rc5_decoder snd ir_nec_decoder i2c_algo_bit btcx_risc rc_core tveeprom soundcore snd_page_alloc ppdev video parport_pc shpchp psmouse serio_raw lp parport usbhid hid firewire_ohci 8139too firewire_core floppy crc_itu_t

Pid: 4325, comm: Xorg Not tainted 2.6.38-7-generic #37-Ubuntu Compaq                          Presario PC                    /D850GB
EIP: 0060:[<c1313870>] EFLAGS: 00010246 CPU: 0
EIP is at con_shutdown+0x40/0x50
EAX: c02b8800 EBX: c02b8800 ECX: c204a638 EDX: c1313830
ESI: 00000000 EDI: 00000000 EBP: ceda9d2c ESP: ceda9d24
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process Xorg (pid: 4325, ti=ceda8000 task=c17e6500 task.ti=ceda8000)
Stack:
 c02b8800 c12ffb50 ceda9d38 c12ffb6a c02b8804 ceda9d48 c1273f3d c02b8800
 00000000 ceda9d50 c12ff909 ceda9d5c c12ffa46 c02b8800 ceda9de8 c1301f12
 0000c000 000000d0 00000000 00000007 00000000 c02b891c c02b8928 00000000
Call Trace:
 [<c12ffb50>] ? queue_release_one_tty+0x0/0x60
 [<c12ffb6a>] queue_release_one_tty+0x1a/0x60
 [<c1273f3d>] kref_put+0x2d/0x60
 [<c12ff909>] tty_kref_put+0x19/0x20
 [<c12ffa46>] release_tty+0x26/0x40
 [<c1301f12>] tty_release+0x332/0x4e0
 [<c150967f>] ? _raw_spin_lock_irqsave+0x2f/0x50
 [<c1050038>] ? console_unlock+0x98/0xe0
 [<c13022d0>] tty_open+0x210/0x420
 [<c112a805>] chrdev_open+0xa5/0x1c0
 [<c1125031>] __dentry_open+0xc1/0x280
 [<c112639e>] nameidata_to_filp+0x6e/0x80
 [<c112a760>] ? chrdev_open+0x0/0x1c0
 [<c11337ff>] finish_open+0xaf/0x1a0
 [<c11330a8>] ? do_path_lookup+0x68/0x120
 [<c1133e47>] do_filp_open+0x207/0x6e0
 [<c1041387>] ? enqueue_entity+0x247/0x2c0
 [<c1126406>] do_sys_open+0x56/0x120
 [<c104ca10>] ? sched_autogroup_create_attach+0xb0/0x120
 [<c11264fe>] sys_open+0x2e/0x40
 [<c1509904>] syscall_call+0x7/0xb
Code: 01 00 00 89 c3 85 f6 74 22 e8 4d c6 d3 ff c7 06 00 00 00 00 e8 42 c7 d3 ff 89 d8 e8 ab bf fe ff 8b 1c 24 8b 74 24 04 89 ec 5d c3 <0f> 0b 8d b4
[drm] nouveau 0000:01:00.0: GPU lockup - switching to software fbcon
26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 3e 8d
EIP: [<c1313870>] con_shutdown+0x40/0x50 SS:ESP 0068:ceda9d24
[drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
[drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
[drm] nouveau 0000:01:00.0: Output VGA-1 is running on CRTC 0 using output A
---[ end trace 58cc84d841200747 ]---

This happens because if con_open doesn't succeed, it doesn't set
tty->driver_data, returning an error in tty->ops->open inside tty_open,
which makes tty_release being called later. And as shown in the trace
above tty_release ends up calling con_shutdown with an unset driver_data,
triggering the BUG_ON.

The solution here is to set the shutdown callback only after we know the
con_open will return without error. In the case without shutdown set,
queue_release_one_tty will call tty_shutdown for us, so it's not a
problem not calling con_shutdown.

This fix is in vt only, and from what I see there is no other place we
can fix it (we may have tty_operations users like pty which don't want a
tty_shutdown when tty->ops->open fails). Also from a quick look, this is
a vt specific failure.

BugLink: http://bugs.launchpad.net/bugs/745025
Cc: stable@kernel.org
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/tty/vt/vt.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c83cdfb..98531ba 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -145,6 +145,7 @@ struct vc vc_cons [MAX_NR_CONSOLES];
 static const struct consw *con_driver_map[MAX_NR_CONSOLES];
 #endif
 
+static inline void con_ops_set_shutdown(void);
 static int con_open(struct tty_struct *, struct file *);
 static void vc_init(struct vc_data *vc, unsigned int rows,
 		    unsigned int cols, int do_clear);
@@ -2806,6 +2807,14 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 			tty->driver_data = vc;
 			vc->port.tty = tty;
 
+			/* We must set shutdown only here, otherwise
+			 * we returned from con_open with error, which
+			 * will make tty core call tty_release, that
+			 * in its call path makes con_shutdown being
+			 * called without tty->driver_data being set,
+			 * triggering the BUG_ON there */
+			con_ops_set_shutdown();
+
 			if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
 				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
@@ -2942,7 +2951,7 @@ static int __init con_init(void)
 }
 console_initcall(con_init);
 
-static const struct tty_operations con_ops = {
+static struct tty_operations con_ops = {
 	.open = con_open,
 	.close = con_close,
 	.write = con_write,
@@ -2958,10 +2967,15 @@ static const struct tty_operations con_ops = {
 	.start = con_start,
 	.throttle = con_throttle,
 	.unthrottle = con_unthrottle,
-	.resize = vt_resize,
-	.shutdown = con_shutdown
+	.resize = vt_resize
 };
 
+/* used by con_open to delay con_shutdown usage */
+static inline void con_ops_set_shutdown(void)
+{
+	con_ops.shutdown = con_shutdown;
+}
+
 static struct cdev vc0_cdev;
 
 static ssize_t show_tty_active(struct device *dev,
-- 
1.7.1

