Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2IVIfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 04:35:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61128 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2IVIfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:35:31 -0400
Message-ID: <505D7862.2020105@gmail.com>
Date: Sat, 22 Sep 2012 10:35:46 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Shachar Shemesh <shachar@liveu.tv>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>, kzak@redhat.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] tty ldisc: Close/Reopen race prevention should check
 the proper flag
References: <4FEFF3DF.9000909@liveu.tv> <20120706212430.GA454@kroah.com> <4FF94BC6.3000704@liveu.tv> <20120709164402.GA14592@kroah.com> <4FFBB575.6050602@liveu.tv> <505A1C0D.3050906@suse.cz>
In-Reply-To: <505A1C0D.3050906@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 09:25 PM, Jiri Slaby wrote:
> On 07/10/2012 06:54 AM, Shachar Shemesh wrote:
>> > From: Shachar Shemesh <shachar@liveu.tv>
>> > 
>> > Commit acfa747b introduced the TTY_HUPPING flag to distinguish
>> > closed TTY from currently closing ones. The test in tty_set_ldisc
>> > still remained pointing at the old flag. This causes pppd to
>> > sometimes lapse into uninterruptible sleep when killed and
>> > restarted.
>> > 
>> > Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
>> > ---
>> > Tested with 3.2.20 kernel.
>> > 
>> > diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
>> > index 24b95db..a662a24 100644
>> > --- a/drivers/tty/tty_ldisc.c
>> > +++ b/drivers/tty/tty_ldisc.c
>> > @@ -658,7 +658,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>> >  		goto enable;
>> >  	}
>> >  
>> > -	if (test_bit(TTY_HUPPED, &tty->flags)) {
>> > +	if (test_bit(TTY_HUPPING, &tty->flags)) {
>> >  		/* We were raced by the hangup method. It will have stomped
>> >  		   the ldisc data and closed the ldisc down */
>> >  		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
> Yes, that makes the issue go away, but does not seem to be right too.
> There are two issues I see:
> * TTY_HUPPED has no use now. That is incorrect. Here should be a test
> for both flags, I think.
> * The change forces the set_ldisc path to always re-open the ldisc even
> if it the terminal is HUPPED.

This patch also causes hangs on newer kernels. Can it be reverted please?

[  482.860279] INFO: task init:1 blocked for more than 120 seconds.
[  482.864244] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.

[  482.867175] init            D ffff88000d618000  3424     1      0 0x00000002
[  482.869321]  ffff88000d5b9c28 0000000000000002 ffff88000d5b9be8 ffffffff8114ff65
[  482.870387]  ffff88000d5b9fd8 ffff88000d5b9fd8 ffff88000d5b9fd8 ffff88000d5b9fd8
[  482.871419]  ffff88000d618000 ffff88000d5b0000 ffff88000d5b08f0 7fffffffffffffff
[  482.872143] Call Trace:
[  482.872336]  [<ffffffff8114ff65>] ? sched_clock_local+0x25/0xa0
[  482.872796]  [<ffffffff839edb35>] schedule+0x55/0x60
[  482.873433]  [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[  482.874134]  [<ffffffff839ef25d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  482.874752]  [<ffffffff8117a5dd>] ? trace_hardirqs_on+0xd/0x10
[  482.875835]  [<ffffffff839ef284>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  482.876744]  [<ffffffff81136f97>] ? prepare_to_wait+0x77/0x90
[  482.877485]  [<ffffffff81b98ef6>] tty_ldisc_wait_idle.isra.7+0x76/0xb0
[  482.878428]  [<ffffffff81137170>] ? abort_exclusive_wait+0xb0/0xb0
[  482.879239]  [<ffffffff81b99bab>] tty_ldisc_hangup+0x1cb/0x320
[  482.879988]  [<ffffffff81b90d52>] ? __tty_hangup+0x122/0x430
[  482.880491]  [<ffffffff81b90d5a>] __tty_hangup+0x12a/0x430
[  482.880904]  [<ffffffff839ef284>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  482.881406]  [<ffffffff81b931fc>] disassociate_ctty+0x6c/0x230
[  482.882141]  [<ffffffff8110dc98>] do_exit+0x3d8/0xa90
[  482.882803]  [<ffffffff8117a5dd>] ? trace_hardirqs_on+0xd/0x10
[  482.883564]  [<ffffffff8110e414>] do_group_exit+0x84/0xd0
[  482.884261]  [<ffffffff8110e472>] sys_exit_group+0x12/0x20
[  482.884975]  [<ffffffff839f0ce8>] tracesys+0xe1/0xe6
[  482.885618] 1 lock held by init/1:
[  482.886059]  #0:  (&tty->ldisc_mutex){+.+.+.}, at: [<ffffffff81b99b02>]
tty_ldisc_hangup+0x122/0x320
[  482.941519] rcu-torture: rtc: ffffffff8647dc30 ver: 746 tfle: 0 rta: 746
rtaf: 0 rtf: 745 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 5116 onoff:
0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
[  482.941519] rcu-torture: Reader Pipe:  664658 22 0 0 0 0 0 0 0 0 0
[  482.941519] rcu-torture: Reader Batch:  664669 11 0 0 0 0 0 0 0 0 0
[  482.941519] rcu-torture: Free-Block Circulation:  745 745 745 745 745 745 745
745 745 745 0
[  542.942392] rcu-torture: rtc: ffffffff8647dc30 ver: 746 tfle: 0 rta: 746
rtaf: 0 rtf: 745 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 5116 onoff:
0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
[  542.942392] rcu-torture: Reader Pipe:  664658 22 0 0 0 0 0 0 0 0 0
[  542.942392] rcu-torture: Reader Batch:  664669 11 0 0 0 0 0 0 0 0 0
[  542.942392] rcu-torture: Free-Block Circulation:  745 745 745 745 745 745 745
745 745 745 0
[  547.040453] kworker/u:3 (4274) used greatest stack depth: 3200 bytes left
[  602.880374] INFO: task init:1 blocked for more than 120 seconds.
[  602.883834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  602.886219] init            D ffff88000d618000  3424     1      0 0x00000002
[  602.887347]  ffff88000d5b9c28 0000000000000002 ffff88000d5b9be8 ffffffff8114ff65
[  602.888383]  ffff88000d5b9fd8 ffff88000d5b9fd8 ffff88000d5b9fd8 ffff88000d5b9fd8
[  602.889554]  ffff88000d618000 ffff88000d5b0000 ffff88000d5b08f0 7fffffffffffffff
[  602.890851] Call Trace:
[  602.891240]  [<ffffffff8114ff65>] ? sched_clock_local+0x25/0xa0
[  602.892128]  [<ffffffff839edb35>] schedule+0x55/0x60
[  602.892902]  [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[  602.893738]  [<ffffffff839ef25d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  602.894713]  [<ffffffff8117a5dd>] ? trace_hardirqs_on+0xd/0x10
[  602.895656]  [<ffffffff839ef284>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  602.896680]  [<ffffffff81136f97>] ? prepare_to_wait+0x77/0x90
[  602.897557]  [<ffffffff81b98ef6>] tty_ldisc_wait_idle.isra.7+0x76/0xb0
[  602.898509]  [<ffffffff81137170>] ? abort_exclusive_wait+0xb0/0xb0
[  602.899415]  [<ffffffff81b99bab>] tty_ldisc_hangup+0x1cb/0x320
[  602.900363]  [<ffffffff81b90d52>] ? __tty_hangup+0x122/0x430
[  602.901241]  [<ffffffff81b90d5a>] __tty_hangup+0x12a/0x430
[  602.902052]  [<ffffffff839ef284>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  602.903020]  [<ffffffff81b931fc>] disassociate_ctty+0x6c/0x230
[  602.903848]  [<ffffffff8110dc98>] do_exit+0x3d8/0xa90
[  602.904642]  [<ffffffff8117a5dd>] ? trace_hardirqs_on+0xd/0x10
[  602.905518]  [<ffffffff8110e414>] do_group_exit+0x84/0xd0
[  602.906427]  [<ffffffff8110e472>] sys_exit_group+0x12/0x20
[  602.907449]  [<ffffffff839f0ce8>] tracesys+0xe1/0xe6
[  602.908579] 1 lock held by init/1:
[  602.909293]  #0:  (&tty->ldisc_mutex){+.+.+.}, at: [<ffffffff81b99b02>]
tty_ldisc_hangup+0x122/0x320
