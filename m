Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1FEJnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:43:16 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:64911 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1FEJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:43:14 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB4FA7.3050400@die-jansens.de>
Date: Sun, 05 Jun 2011 11:43:03 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop> <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop> <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de> <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de> <1307097052.2353.3061.camel@twins> <20110605081747.GA17920@elte.hu>
In-Reply-To: <20110605081747.GA17920@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 10:17, Ingo Molnar wrote:
>
> * Peter Zijlstra<peterz@infradead.org>  wrote:
>
>> On Fri, 2011-06-03 at 12:02 +0200, Arne Jansen wrote:
>>> On 03.06.2011 11:15, Peter Zijlstra wrote:
>>
>>>> Anyway, Arne, how long did you wait before power cycling the box? The
>>>> NMI watchdog should trigger in about a minute or so if it will trigger
>>>> at all (its enabled in your config).
>>>
>>> No, it doesn't trigger,
>>
>> Bummer.
>
> Is there no output even when the console is configured to do an
> earlyprintk? That will allow the NMI watchdog to punch through even a
> printk or scheduler lockup.
>
> Arne, you can turn this on via one of these:
>
>    earlyprintk=vga,keep
>    earlyprintk=serial,ttyS0,115200,keep

My grub conf looks like this now:
kernel /boot/vmlinuz-2.6.39-rc3+ root=LABEL=label panic=15 
console=ttyS0,9600 earlyprintk=serial,ttyS0,9600,keep quiet

>
> (the ',keep' portion is important to have it active even after the
> regular console has been switched on.)
>
> Could you also please check with the (untested) patch below applied?
> This will turn off *all* printk done by the NMI watchdog and switches
> it to do pure early_printk() - which does not use any locking so it
> should never lock up.
>
> [ If you keep seeing 'NMI watchdog tick' messages periodically
>    occuring after the lockup then i'll send a more complete patch that
>    shuts off the regular printk path and makes sure that all output is
>    early_printk() based only. ]
>
> earlyprintk=,keep with such a patch has let me down only on the
> rarest of occasions.
>
> ( Arne, please also double check on a working bootup that the NMI
>    watchdog is actually ticking, by checking the NMI counts in
>    /proc/interrupts go up slowly but surely on all CPUs. )

It does, but _very_ slowly. Some CPUs do not count up for tens of
minutes if the machine is idle. If I generate some load like 'make
tags', the counters go up quite quickly.
After 4 minutes and one 'make cscope' it looks like this:
NMI:          8         13         43          5          2          3 
        22          1   Non-maskable interrupts

But I never see a single tick on console or in dmesg, even when I
replace the early_printk with a printk.

Btw, I get one warn on boot, but it look irrelevant to me:
[   36.064321] ------------[ cut here ]------------
[   36.064328] WARNING: at kernel/printk.c:293 do_syslog+0xbf/0x550()
[   36.064330] Hardware name: X8SIL
[   36.064331] Attempt to access syslog with CAP_SYS_ADMIN but no 
CAP_SYSLOG (deprecated).
[   36.064333] Modules linked in: mpt2sas scsi_transport_sas raid_class
[   36.064338] Pid: 21625, comm: syslog-ng Not tainted 2.6.39-rc3+ #8
[   36.064340] Call Trace:
[   36.064344]  [<ffffffff81091f7a>] warn_slowpath_common+0x7a/0xb0
[   36.064347]  [<ffffffff81092051>] warn_slowpath_fmt+0x41/0x50
[   36.064351]  [<ffffffff8109d8a5>] ? ns_capable+0x25/0x60
[   36.064354]  [<ffffffff8109365f>] do_syslog+0xbf/0x550
[   36.064358]  [<ffffffff810c9575>] ? lock_release_holdtime+0x35/0x170
[   36.064362]  [<ffffffff811e17a7>] kmsg_open+0x17/0x20
[   36.064366]  [<ffffffff811d5f46>] proc_reg_open+0xa6/0x180
[   36.064368]  [<ffffffff811e1790>] ? kmsg_release+0x20/0x20
[   36.064371]  [<ffffffff811e1770>] ? read_vmcore+0x1d0/0x1d0
[   36.064374]  [<ffffffff811d5ea0>] ? proc_fill_super+0xb0/0xb0
[   36.064378]  [<ffffffff811790bb>] __dentry_open+0x15b/0x330
[   36.064382]  [<ffffffff8185d6e6>] ? _raw_spin_unlock+0x26/0x30
[   36.064385]  [<ffffffff81179379>] nameidata_to_filp+0x69/0x80
[   36.064388]  [<ffffffff81187a3a>] do_last+0x1da/0x840
[   36.064391]  [<ffffffff81188fdb>] path_openat+0xcb/0x3f0
[   36.064394]  [<ffffffff810ba5c5>] ? sched_clock_cpu+0xc5/0x100
[   36.064397]  [<ffffffff8118944a>] do_filp_open+0x7a/0xa0
[   36.064400]  [<ffffffff8185d6e6>] ? _raw_spin_unlock+0x26/0x30
[   36.064402]  [<ffffffff81196c12>] ? alloc_fd+0xf2/0x140
[   36.064405]  [<ffffffff8117a3d2>] do_sys_open+0x102/0x1e0
[   36.064408]  [<ffffffff8117a4db>] sys_open+0x1b/0x20
[   36.064412]  [<ffffffff81864dbb>] system_call_fastpath+0x16/0x1b
[   36.064414] ---[ end trace df959c735174f5f7 ]---


-Arne

>
> Thanks,
>
> 	Ingo
>
