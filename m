Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2EXGOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:14:19 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33278 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2EXGOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:14:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
References: <20120523002645.GA3490@redhat.com> <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 24 May 2012 08:13:55 +0200
Message-ID: <CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
Subject: Re: 3.4+ tty lockdep trace
To: Ming Lei <tom.leiming@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 3:06 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Dave,
>
> On Wed, May 23, 2012 at 8:26 AM, Dave Jones <davej@redhat.com> wrote:
>> From v3.4-4413-gfb09baf
>>
>> [   43.374948] =============================================
>> [   43.374991] [ INFO: possible recursive locking detected ]
>> [   43.375035] 3.4.0+ #24 Not tainted
>> [   43.375065] ---------------------------------------------
>> [   43.375108] sshd/639 is trying to acquire lock:
>> [   43.375157]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656d57>] tty_lock+0x37/0x80
>> [   43.375216]
>> [   43.375216] but task is already holding lock:
>> [   43.375268]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656d57>] tty_lock+0x37/0x80
>> [   43.375327]
>> [   43.375327] other info that might help us debug this:
>> [   43.375378]  Possible unsafe locking scenario:
>> [   43.375378]
>> [   43.375425]        CPU0
>> [   43.375447]        ----
>> [   43.375471]   lock(&tty->legacy_mutex);
>> [   43.375504]   lock(&tty->legacy_mutex);
>> [   43.375536]
>> [   43.375536]  *** DEADLOCK ***
>> [   43.375536]
>> [   43.375583]  May be due to missing lock nesting notation
>> [   43.375583]
>> [   43.375637] 2 locks held by sshd/639:
>> [   43.375675]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff813b0243>] tty_release+0x1c3/0x5d0
>> [   43.375740]  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656d57>] tty_lock+0x37/0x80
>> [   43.375802]
>> [   43.375802] stack backtrace:
>> [   43.375841] Pid: 639, comm: sshd Not tainted 3.4.0+ #24
>> [   43.375882] Call Trace:
>> [   43.377572]  [<ffffffff810b4604>] __lock_acquire+0x1584/0x1aa0
>> [   43.379286]  [<ffffffff810b51e2>] lock_acquire+0x92/0x1f0
>> [   43.380995]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
>> [   43.382700]  [<ffffffff816534f1>] mutex_lock_nested+0x71/0x3b0
>> [   43.384403]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
>> [   43.386094]  [<ffffffff81085521>] ? get_parent_ip+0x11/0x50
>> [   43.387794]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
>> [   43.389480]  [<ffffffff8165a68d>] ? sub_preempt_count+0x6d/0xd0
>> [   43.391176]  [<ffffffff813b0243>] ? tty_release+0x1c3/0x5d0
>> [   43.393003]  [<ffffffff81656d57>] tty_lock+0x37/0x80
>> [   43.394867]  [<ffffffff81656dc3>] tty_lock_pair+0x23/0x5c
>> [   43.396671]  [<ffffffff813b024e>] tty_release+0x1ce/0x5d0
>> [   43.398462]  [<ffffffff811a765c>] fput+0x12c/0x300
>> [   43.400292]  [<ffffffff811a23a9>] filp_close+0x69/0xa0
>> [   43.402084]  [<ffffffff811a2f2d>] sys_close+0xad/0x1a0
>> [   43.403871]  [<ffffffff8165e652>] system_call_fastpath+0x16/0x1b
>
> We have one patch to address the problem, could you test it from the link below?
>
>        http://marc.info/?l=linux-kernel&m=133765211309247&w=2

I'm still seeing the warning with this patch:

[   83.032572] trinity (4823): Using mlock ulimits for SHM_HUGETLB is deprecated
[   83.060427] type=1400 audit(1.288:2): op=linkat action=denied
pid=4820 comm="trinity" path=2F7472696E6974792F746D702F03 dev="9p"
ino=104345
[   83.190164]
[   83.191412] =============================================
[   83.196004] [ INFO: possible recursive locking detected ]
[   83.196004] 3.4.0-next-20120523-sasha-00004-gc6cd556 #272 Tainted:
G        W
[   83.196004] ---------------------------------------------
[   83.196004] trinity/4823 is trying to acquire lock:
[   83.196004]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82f6a5db>]
tty_lock_nested+0x7b/0x90
[   83.196004]
[   83.196004] but task is already holding lock:
[   83.196004]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82f6a5db>]
tty_lock_nested+0x7b/0x90
[   83.196004]
[   83.196004] other info that might help us debug this:
[   83.196004]  Possible unsafe locking scenario:
[   83.196004]
[   83.196004]        CPU0
[   83.196004]        ----
[   83.196004]   lock(&tty->legacy_mutex);
[   83.196004]   lock(&tty->legacy_mutex);
[   83.196004]
[   83.196004]  *** DEADLOCK ***
