Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2LTTDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:03:52 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56946 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191Ab2LTTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:03:44 -0500
Message-ID: <1356030209.14984.4.camel@thor.lan>
Subject: Re: [PATCH v2 00/11] tty: Fix buffer work access-after-free
From: Peter Hurley <peter@hurleysoftware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, linux-kernel@vger.kernel.org
Date: Thu, 20 Dec 2012 14:03:29 -0500
In-Reply-To: <CA+1xoqdtkeuN+nAO5L56r77vrNs40mxwGkkgaCt3aA9=5G_e7g@mail.gmail.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com>
	 <1355849302.26487.15.camel@thor.lan>
	 <CA+1xoqdtkeuN+nAO5L56r77vrNs40mxwGkkgaCt3aA9=5G_e7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 15:38 -0500, Sasha Levin wrote:
> On Tue, Dec 18, 2012 at 11:48 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> > On Tue, 2012-12-18 at 10:44 -0500, Sasha Levin wrote:
> >> I'm still seeing that warning with the new patch series:
> >>
> >> [  549.561769] ------------[ cut here ]------------
> >> [  549.598755] WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xff/0x130()
> >> [  549.604058] scheduling buffer work for halted ldisc
> >> [  549.607741] Pid: 9417, comm: trinity-child28 Tainted: G      D W
> >> 3.7.0-next-20121217-sasha-00023-g8689ef9 #219
> >> [  549.652580] Call Trace:
> >> [  549.662754]  [<ffffffff81c432cf>] ? n_tty_set_room+0xff/0x130
> >> [  549.665458]  [<ffffffff8110cae7>] warn_slowpath_common+0x87/0xb0
> >> [  549.668257]  [<ffffffff8110cb71>] warn_slowpath_fmt+0x41/0x50
> >> [  549.671007]  [<ffffffff81c432cf>] n_tty_set_room+0xff/0x130
> >> [  549.673268]  [<ffffffff81c44597>] reset_buffer_flags+0x137/0x150
> >> [  549.675607]  [<ffffffff81c45b71>] n_tty_open+0x131/0x1c0
> >
> > This is a false-positive warning that means I need to refine the warning
> > condition to not include this code path.
> >
> > Thanks again.
> 
> I'm really having a hard time doing any fuzzing after applying this
> patch. I'm not sure it's related directly, but
> the ldisc hangup lockup happens quite quickly and every time, so I
> can't really get any good fuzzing done.

I think you mean this ldisc livelock, right?

[  243.840596] INFO: task init:1 blocked for more than 120 seconds.
[  243.844695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.850777] init            D 0000000000000000  3192     1      0 0x00000002
[  243.852430]  ffff8800bf909c28 0000000000000002 ffff8800bf909bc8 ffffffff8118018e
[  243.853722]  ffff8800bf909fd8 ffff8800bf909fd8 ffff8800bf909fd8 ffff8800bf909fd8
[  243.854901]  ffff8800bf970000 ffff8800bf900000 0000000000000007 ffff880063b1e8d0
[  243.856198] Call Trace:
[  243.856602]  [<ffffffff8118018e>] ? put_lock_stats.isra.16+0xe/0x40
[  243.857580]  [<ffffffff83ce7ab5>] schedule+0x55/0x60
[  243.858413]  [<ffffffff83ce5afa>] schedule_timeout+0x3a/0x370
[  243.859400]  [<ffffffff81183cd8>] ? trace_hardirqs_on_caller+0x118/0x140
[  243.860569]  [<ffffffff81183d0d>] ? trace_hardirqs_on+0xd/0x10
[  243.861554]  [<ffffffff83ce91bc>] ? _raw_spin_unlock_irqrestore+0x7c/0xa0
[  243.863046]  [<ffffffff8113c7a2>] ? prepare_to_wait+0x72/0x80
[  243.864064]  [<ffffffff81c463c5>] tty_ldisc_wait_idle.isra.6+0x75/0xb0
[  243.865209]  [<ffffffff8113c960>] ? abort_exclusive_wait+0xb0/0xb0
[  243.866272]  [<ffffffff81c465e2>] tty_ldisc_hangup_halt+0xd2/0x140
[  243.867337]  [<ffffffff81c46d75>] tty_ldisc_hangup+0xc5/0x1e0
[  243.868326]  [<ffffffff81c3e537>] __tty_hangup+0x137/0x440
[  243.869293]  [<ffffffff83ce91bc>] ? _raw_spin_unlock_irqrestore+0x7c/0xa0
[  243.870737]  [<ffffffff81c4062c>] disassociate_ctty+0x6c/0x230
[  243.871986]  [<ffffffff81113a5c>] do_exit+0x41c/0x580
[  243.873208]  [<ffffffff8107d964>] ? syscall_trace_enter+0x24/0x2e0
[  243.874720]  [<ffffffff81113c8a>] do_group_exit+0x8a/0xc0
[  243.876075]  [<ffffffff81113cd2>] sys_exit_group+0x12/0x20
[  243.877477]  [<ffffffff83ceac98>] tracesys+0xe1/0xe6
[  243.879065] 1 lock held by init/1:
[  243.880054]  #0:  (&tty->ldisc_mutex){+.+...}, at: [<ffffffff81c46d6d>] tty_ldisc_hangup+0xbd/0x1e0


> I'm not saying that this patch series is causing it, just saying that
> I can't really test it at this point due to
> that other lockup.

Well, I know why this is happening but I haven't quite figured out how
to fix it yet.

void tty_ldisc_hangup(struct tty_struct *tty)
{
	...
	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
	...
	mutex_lock(&tty->ldisc_mutex);
	...
	if (tty_ldisc_hangup_halt(tty)) {
		...

The 2 wakeups are meant to kick out waiters from the read and write
queues that already have ldisc references before waiting in
tty_ldisc_hangup_halt() for all the ldisc references to be released.

Although the ldisc hasn't yet been halted when the wakeups are 'sent',
that's not actually a problem because before a reader or writer will
sleep on its wait queue, it checks if the file pointer has been 'hung
up'.

static ssize_t n_tty_read(........)
{
	....
	add_wait_queue(&tty->read_wait, &wait);
	while (nr) {
		....
		set_current_state(TASK_INTERRUPTIBLE);
		....
		if (!input_available_p(tty, 0)) {
			....
hung up? ----->		if (tty_hung_up_p(file))
				break;
			....
no, sleep ---->		timeout = schedule_timeout(timeout);
			continue;
		}


But, console & vt file pointers are not 'hung up'.

static void __tty_hangup(.....)
{
	....
	list_for_each_entry(priv, &tty->tty_files, list) {
		....
		if (filp->f_op->write == redirected_tty_write)
			cons_filp = filp;
		if (filp->f_op->write != tty_write)
			continue;
		.....
		filp->f_op = &hung_up_tty_fops;
	}

So waking up a reader sleeping on a console file pointer does nothing.
It just goes back to sleep. Which means it doesn't release its ldisc
reference, which means everything waits for something that will never
happen.

I'm researching how best to fix this, but right now, I'm unsure what the
correct solution is, especially since this probably never worked.

In the meantime, you can use the patch below on top of my other patches
to reduce the frequency of this happening.

--- >% ---
Subject: [PATCH] tty: Kick waiters _after_ the ldisc is locked


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index a6d3078..7027bd3 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -603,6 +603,12 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
 
 	clear_bit(TTY_LDISC, &tty->flags);
 
+	/* Wakeup waiters so they can discover the tty is hupping, abort
+	 * their i/o loops, and release their ldisc references
+	 */
+	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
+	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
+
 	if (tty->ldisc) {	/* Not yet closed */
 		tty_unlock(tty);
 
@@ -874,12 +880,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		tty_ldisc_deref(ld);
 	}
 	/*
-	 * FIXME: Once we trust the LDISC code better we can wait here for
-	 * ldisc completion and fix the driver call race
-	 */
-	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
-	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
-	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY if need be.
 	 *
-- 
1.8.0.2

