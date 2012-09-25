Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2IYJqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:46:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61485 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IYJqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:46:48 -0400
Message-ID: <50617D95.7010005@gmail.com>
Date: Tue, 25 Sep 2012 11:47:01 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Sasha Levin <sasha.levin@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tty ldisc lockups in linux-next
References: <50617008.5000207@oracle.com> <506170BB.4040005@suse.cz> <50617171.8030601@gmail.com> <506171DA.9070102@suse.cz>
In-Reply-To: <506171DA.9070102@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 10:56 AM, Jiri Slaby wrote:
> On 09/25/2012 10:55 AM, Sasha Levin wrote:
>> On 09/25/2012 10:52 AM, Jiri Slaby wrote:
>>>> Hi all,
>>>>>
>>>>> While fuzzing with trinity in a KVM tools guest running linux-next kernel, I keep hitting the following lockup:
>>> Hi, I'm confused here. Is this different to what you reported a couple
>>> days ago? Doesn't reverting aa3c8af86382 help in the end?
>>
>> I was just about to send a reply to that mail saying that while reverting aa3c8af86382 reduces the odds for seeing it, it still
>> happens. You were faster than me :)
>>
>> But yes, it still happens even if I revert aa3c8af86382 or try applying your patch in that thread.
> 
> The patch won't help, it's kind of certain.
> 
> Instead I still wonder what process sits on the terminal. Could you
> investigate?
> 

It looks like sh is trying to read:

[  606.950194] sh              S 0000000000000001  4800  6260      1 0x00000000
[  606.950194]  ffff88000c0ddcc8 0000000000000082 ffffffff847baa68 0000000000000b02
[  606.950194]  ffff88000c0ddfd8 ffff88000c0ddfd8 ffff88000c0ddfd8 ffff88000c0ddfd8
[  606.950194]  ffff88000f578000 ffff88000c0bb000 ffff88000c0ddd98 ffff880040b4d000
[  606.950194] Call Trace:
[  606.950194]  [<ffffffff83a0be45>] schedule+0x55/0x60
[  606.950194]  [<ffffffff83a09dd5>] schedule_timeout+0x45/0x360
[  606.950194]  [<ffffffff83a0d54d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  606.950194]  [<ffffffff8117b13d>] ? trace_hardirqs_on+0xd/0x10
[  606.950194]  [<ffffffff83a0d574>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  606.950194]  [<ffffffff81b98271>] n_tty_read+0x4c1/0x9a0
[  606.950194]  [<ffffffff83a0d54d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  606.950194]  [<ffffffff8114d760>] ? try_to_wake_up+0x360/0x360
[  606.950194]  [<ffffffff81b922cf>] tty_read+0x8f/0x100
[  606.950194]  [<ffffffff8127187d>] vfs_read+0xad/0x180
[  606.950194]  [<ffffffff81271c10>] sys_read+0x50/0xa0
[  606.950194]  [<ffffffff83a0edcd>] system_call_fastpath+0x1a/0x1f

While init is trying to exit:

[  605.524940] init            D ffff88000d5b0000  3376     1      0 0x00000002
[  605.527502]  ffff88000d5adc28 0000000000000082 ffff88000d5adbe8 ffffffff81150ac5
[  605.529685]  ffff88000d5adfd8 ffff88000d5adfd8 ffff88000d5adfd8 ffff88000d5adfd8
[  605.530939]  ffff88000d613000 ffff88000d5b0000 ffff88000d5b08f0 7fffffffffffffff
[  605.532064] Call Trace:
[  605.532064]  [<ffffffff81150ac5>] ? sched_clock_local+0x25/0xa0
[  605.532064]  [<ffffffff83a0be45>] schedule+0x55/0x60
[  605.532064]  [<ffffffff83a09dd5>] schedule_timeout+0x45/0x360
[  605.532064]  [<ffffffff83a0d54d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  605.532064]  [<ffffffff8117b13d>] ? trace_hardirqs_on+0xd/0x10
[  605.532064]  [<ffffffff83a0d574>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  605.532064]  [<ffffffff81137af7>] ? prepare_to_wait+0x77/0x90
[  605.532064]  [<ffffffff81b9b2c6>] tty_ldisc_wait_idle.isra.7+0x76/0xb0
[  605.532064]  [<ffffffff81137cd0>] ? abort_exclusive_wait+0xb0/0xb0
[  605.532064]  [<ffffffff81b9c03b>] tty_ldisc_hangup+0x1cb/0x320
[  605.532064]  [<ffffffff81b933a2>] ? __tty_hangup+0x122/0x430
[  605.532064]  [<ffffffff81b933aa>] __tty_hangup+0x12a/0x430
[  605.532064]  [<ffffffff83a0d574>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  605.532064]  [<ffffffff81b955cc>] disassociate_ctty+0x6c/0x230
[  605.532064]  [<ffffffff8110e7e8>] do_exit+0x3d8/0xa90
[  605.532064]  [<ffffffff83a0e4d9>] ? retint_swapgs+0x13/0x1b
[  605.532064]  [<ffffffff8110ef64>] do_group_exit+0x84/0xd0
[  605.532064]  [<ffffffff8110efc2>] sys_exit_group+0x12/0x20
[  605.532064]  [<ffffffff83a0edcd>] system_call_fastpath+0x1a/0x1f

And the corresponding lock info:

[  606.950194] Showing all locks held in the system:
[  606.950194] 1 lock held by init/1:
[  606.950194]  #0:  (&tty->ldisc_mutex){+.+.+.}, at: [<ffffffff81b9bf92>] tty_ldisc_hangup+0x122/0x320
[  606.950194] 1 lock held by sh/6260:
[  606.950194]  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff81b98078>] n_tty_read+0x2c8/0x9a0

