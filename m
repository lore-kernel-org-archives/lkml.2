Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2LDHJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:09:01 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49776 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751784Ab2LDHI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:08:58 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 3/9] tty: Don't reschedule buffer work while closing
Date: Tue,  4 Dec 2012 02:07:39 -0500
Message-Id: <1354604865-10278-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent buffer work scheduling when called from n_tty_close(). Since
the ldisc has been halted and the tty soon-to-be-destructed, pending
work would be accessing an invalid tty and ldisc state. Fixes this:

[   38.051111] ------------[ cut here ]------------
[   38.052113] WARNING: at /home/peter/src/kernels/next/drivers/tty/n_tty.c:160 n_tty_set_room.part.6+0x8b/0xa0()
[   38.053916] Hardware name: Bochs
[   38.054819] Modules linked in: netconsole configfs bnep rfcomm bluetooth parport_pc ppdev snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq psmouse snd_timer serio_raw mac_hid snd_seq_device
snd microcode lp parport virtio_balloon soundcore i2c_piix4 snd_page_alloc floppy 8139too 8139cp
[   38.059704] Pid: 1564, comm: pty_kill Tainted: G        W    3.7.0-next-20121130+ttydebug-xeon #20121130+ttydebug
[   38.061578] Call Trace:
[   38.062491]  [<ffffffff81058b4f>] warn_slowpath_common+0x7f/0xc0
[   38.063448]  [<ffffffff81058baa>] warn_slowpath_null+0x1a/0x20
[   38.064439]  [<ffffffff8142dc2b>] n_tty_set_room.part.6+0x8b/0xa0
[   38.065381]  [<ffffffff8142dc82>] n_tty_set_room+0x42/0x80
[   38.066323]  [<ffffffff8142e6f2>] reset_buffer_flags+0x102/0x160
[   38.077508]  [<ffffffff8142e76d>] n_tty_flush_buffer+0x1d/0x90
[   38.078782]  [<ffffffff81046569>] ? default_spin_lock_flags+0x9/0x10
[   38.079734]  [<ffffffff8142e804>] n_tty_close+0x24/0x60
[   38.080730]  [<ffffffff81431b61>] tty_ldisc_close.isra.2+0x41/0x60
[   38.081680]  [<ffffffff81431bbb>] tty_ldisc_kill+0x3b/0x80
[   38.082618]  [<ffffffff81432a07>] tty_ldisc_release+0x77/0xe0
[   38.083549]  [<ffffffff8142b781>] tty_release+0x451/0x4d0
[   38.084525]  [<ffffffff811950be>] __fput+0xae/0x230
[   38.085472]  [<ffffffff8119524e>] ____fput+0xe/0x10
[   38.086401]  [<ffffffff8107aa88>] task_work_run+0xc8/0xf0
[   38.087334]  [<ffffffff8105ea56>] do_exit+0x196/0x4b0
[   38.088304]  [<ffffffff8106c77b>] ? __dequeue_signal+0x6b/0xb0
[   38.089240]  [<ffffffff8105ef34>] do_group_exit+0x44/0xa0
[   38.090182]  [<ffffffff8106f43d>] get_signal_to_deliver+0x20d/0x4e0
[   38.091125]  [<ffffffff81016979>] do_signal+0x29/0x130
[   38.092096]  [<ffffffff81431a9e>] ? tty_ldisc_deref+0xe/0x10
[   38.093030]  [<ffffffff8142a317>] ? tty_write+0xb7/0xf0
[   38.093976]  [<ffffffff81193f53>] ? vfs_write+0xb3/0x180
[   38.094904]  [<ffffffff81016b20>] do_notify_resume+0x80/0xc0
[   38.095830]  [<ffffffff81700492>] int_signal+0x12/0x17
[   38.096788] ---[ end trace 5f6f7a9651cd999b ]---

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3f704a9..574d099 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -149,7 +149,7 @@ static void n_tty_set_room(struct tty_struct *tty)
 	tty->receive_room = left;
 
 	/* Did this open up the receive buffer? We may need to flip */
-	if (left && !old_left) {
+	if (left && !old_left && !test_bit(TTY_CLOSING, &tty->flags)) {
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
 		/* see if ldisc has been killed - if so, this means that
-- 
1.8.0

