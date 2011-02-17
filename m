Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1BQCoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:44:55 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34596 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab1BQCov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wsJRuWD3mWWcAEvSZFAmyiQyajMCfpFFVUhQxarsPSjYLoOLgwIZ3nEaCMee++KTv0
         BGl79fX+0huK/psnvLwzo1B2PahmaUHwqnZNYxt50esKiBmfXHCeL9hzAVKlHUj/MYco
         KEak0G3sqO3rrBiH1iGfKt4yIkSQ25ykGB0Zs=
MIME-Version: 1.0
In-Reply-To: <20110216.180347.71107177.davem@davemloft.net>
References: <4D5A90D0.9040403@free.fr>
	<AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com>
	<20110216.180347.71107177.davem@davemloft.net>
Date: Thu, 17 Feb 2011 10:43:57 +0800
Message-ID: <AANLkTim4NnyyFqprBoGpimquLP=6fjAanCrbqX=RXwC9@mail.gmail.com>
Subject: Re: WARNING: at kernel/lockdep.c:2323 trace_hardirqs_on_caller+0xb9/0x16c()
From: Yong Zhang <yong.zhang0@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: daniel.lezcano@free.fr, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:03 AM, David Miller <davem@davemloft.net> wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Thu, 17 Feb 2011 09:37:30 +0800
>
>> On Tue, Feb 15, 2011 at 10:42 PM, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
>>> Hi All,
>>>
>>> I am running a 2.6.38-rc4-next-20110215+ kernel on qemu x86_64 and the
>>> following traces appear in the console:
>>>
>>> Feb 15 15:00:24 lucid kernel: ------------[ cut here ]------------
>>> Feb 15 15:00:24 lucid kernel: WARNING: at kernel/lockdep.c:2323
>>> trace_hardirqs_on_caller+0xb9/0x16c()
>>> Feb 15 15:00:24 lucid kernel: Hardware name: Bochs
>>> Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Not tainted
>>> 2.6.38-rc4-next-20110215+ #74
>>> Feb 15 15:00:24 lucid kernel: Call Trace:
>>> Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff8102b8a5>] ?
>>> warn_slowpath_common+0x7b/0x93
>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
>>> _raw_spin_unlock_irq+0x2b/0x30
>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8102b8d2>] ?
>>> warn_slowpath_null+0x15/0x17
>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f796>] ?
>>> trace_hardirqs_on_caller+0xb9/0x16c
>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ?
>>> trace_hardirqs_on+0xd/0xf
>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
>>> _raw_spin_unlock_irq+0x2b/0x30
>>> Feb 15 15:00:24 lucid kernel: [<ffffffff812e167e>] ?
>>> do_ide_request+0x32/0x590
>>
>> Seems related to IDE SUBSYSTEM
>
> Which hasn't had any changes in the past release.

OK.

Cc'ing Tejun Heo

For the back trace, I think __blk_run_queue() is the ligament.
As from the comment of __blk_run_queue(), it must be called
with the queue lock and interrupts disabled. And the lock
is hold through spin_lock_irqsave(q->queue_lock, flags); at
blk_end_bidi_request().

But in do_ide_request(), it realse the lock through
spin_unlock_irq(q->queue_lock); which make the state
inconsistent.

BTW, do_ide_request() also say it might_sleep(), this warning
also trigger in Daniel's log.

Thanks,
Yong

-- 
Only stand for myself
