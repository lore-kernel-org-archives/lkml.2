Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2LNSYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:24:44 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:47984 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756905Ab2LNSX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:23:28 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 05/11] tty: Don't flush buffer when closing ldisc
Date: Fri, 14 Dec 2012 13:22:44 -0500
Message-Id: <1355509370-5883-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A buffer flush is both undesirable and unnecessary when the ldisc
is closing. A buffer flush performs the following:
 1. resets ldisc data fields to their initial state
 2. resets tty->receive_room to indicate more data can be sent
 3. schedules buffer work to receive more data
 4. signals a buffer flush has happened to linked pty in packet mode

Since the ldisc has been halted and the tty may soon be destructed,
buffer work must not be scheduled as that work might access
an invalid tty and ldisc state. Also, the ldisc read buffer is about
to be freed, so that's pointless.

Resetting the ldisc data fields is pointless as well since that
structure is about to be freed.

Resetting tty->receive_room is unnecessary, as it will be properly
reset if a new ldisc is reopened. Besides, resetting the original
receive_room value would be wrong since the read buffer will be
gone.

Since the packet mode flush is observable from userspace, this
behavior has been preserved.

The test jig originally authored by Ilya Zykov <ilya@ilyx.ru> and
signed off by him is included below. The test jig prompts the
following warnings which this patch fixes.

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

[ 2730.570602] ------------[ cut here ]------------
[ 2730.572130] WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0x107/0x140()
[ 2730.574904] scheduling buffer work for halted ldisc
[ 2730.578303] Pid: 9691, comm: trinity-child15 Tainted: G        W 3.7.0-rc8-next-20121205-sasha-00023-g59f0d85 #207
[ 2730.588694] Call Trace:
[ 2730.590486]  [<ffffffff81c41d77>] ? n_tty_set_room+0x107/0x140
[ 2730.592559]  [<ffffffff8110c827>] warn_slowpath_common+0x87/0xb0
[ 2730.595317]  [<ffffffff8110c8b1>] warn_slowpath_fmt+0x41/0x50
[ 2730.599186]  [<ffffffff81c41d77>] n_tty_set_room+0x107/0x140
[ 2730.603141]  [<ffffffff81c42fe7>] reset_buffer_flags+0x137/0x150
[ 2730.607166]  [<ffffffff81c43018>] n_tty_flush_buffer+0x18/0x90
[ 2730.610123]  [<ffffffff81c430af>] n_tty_close+0x1f/0x60
[ 2730.612068]  [<ffffffff81c461f2>] tty_ldisc_close.isra.4+0x52/0x60
[ 2730.614078]  [<ffffffff81c462ab>] tty_ldisc_reinit+0x3b/0x70
[ 2730.615891]  [<ffffffff81c46db2>] tty_ldisc_hangup+0x102/0x1e0
[ 2730.617780]  [<ffffffff81c3e537>] __tty_hangup+0x137/0x440
[ 2730.619547]  [<ffffffff81c3e869>] tty_vhangup+0x9/0x10
[ 2730.621266]  [<ffffffff81c48f1c>] pty_close+0x14c/0x160
[ 2730.622952]  [<ffffffff81c3fd45>] tty_release+0xd5/0x490
[ 2730.624674]  [<ffffffff8127fbe2>] __fput+0x122/0x250
[ 2730.626195]  [<ffffffff8127fd19>] ____fput+0x9/0x10
[ 2730.627758]  [<ffffffff81134602>] task_work_run+0xb2/0xf0
[ 2730.629491]  [<ffffffff811139ad>] do_exit+0x36d/0x580
[ 2730.631159]  [<ffffffff81113c8a>] do_group_exit+0x8a/0xc0
[ 2730.632819]  [<ffffffff81127351>] get_signal_to_deliver+0x501/0x5b0
[ 2730.634758]  [<ffffffff8106de34>] do_signal+0x24/0x100
[ 2730.636412]  [<ffffffff81204865>] ? user_exit+0xa5/0xd0
[ 2730.638078]  [<ffffffff81183cd8>] ? trace_hardirqs_on_caller+0x118/0x140
[ 2730.640279]  [<ffffffff81183d0d>] ? trace_hardirqs_on+0xd/0x10
[ 2730.642164]  [<ffffffff8106df78>] do_notify_resume+0x48/0xa0
[ 2730.643966]  [<ffffffff83cdff6a>] int_signal+0x12/0x17
[ 2730.645672] ---[ end trace a40d53149c07fce0 ]---

/*
 * pty_thrash.c
 *
 * Based on original test jig by Ilya Zykov <ilya@ilyx.ru>
 *
 * Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
 * Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
 */

static int fd;

static void error_exit(char *f, ...)
{
        va_list va;

        va_start(va, f);
        vprintf(f, va);
        printf(": %s\n", strerror(errno));
        va_end(va);

        if (fd >= 0)
                close(fd);

        exit(EXIT_FAILURE);
}

int main(int argc, char *argv[]) {
        int parent;
        char pts_name[24];
        int ptn, unlock;

        while (1) {

                fd = open("/dev/ptmx", O_RDWR);
                if (fd < 0)
                        error_exit("opening pty master");
                unlock = 0;
                if (ioctl(fd, TIOCSPTLCK, &unlock) < 0)
                        error_exit("unlocking pty pair");
                if (ioctl(fd, TIOCGPTN, &ptn) < 0)
                        error_exit("getting pty #");
                snprintf(pts_name, sizeof(pts_name), "/dev/pts/%d", ptn);

                child_id = fork();
                if (child_id == -1)
                        error_exit("forking child");

                if (parent) {
                        int err, id, status;
                        char buf[128];
                        int n;

                        n = read(fd, buf, sizeof(buf));
                        if (n < 0)
                                error_exit("master reading");
                        printf("%.*s\n", n-1, buf);

                        close(fd);

                        err = kill(child_id, SIGKILL);
                        if (err < 0)
                                error_exit("killing child");
                        id = waitpid(child_id, &status, 0);
                        if (id < 0 || id != child_id)
                                error_exit("waiting for child");

                } else { /* Child */

                        close(fd);
                        printf("Test cycle on slave pty %s\n", pts_name);
                        fd = open(pts_name, O_RDWR);
                        if (fd < 0)
                                error_exit("opening pty slave");

                        while (1) {
                                char pattern[] = "test\n";
                                if (write(fd, pattern, strlen(pattern)) < 0)
                                        error_exit("slave writing");
                        }

                }
        }

        /* never gets here */
        return 0;
}

Reported-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/tty/n_tty.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 41e58bf..3890f5b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1616,7 +1616,9 @@ static void n_tty_close(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	n_tty_flush_buffer(tty);
+	if (tty->link)
+		packet_mode_flush(tty);
+
 	kfree(ldata->read_buf);
 	kfree(ldata->echo_buf);
 	kfree(ldata);
-- 
1.8.0.1

