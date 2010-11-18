Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab0KRQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:09:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:57555 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0KRQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:09:28 -0500
Message-ID: <4CE54F9F.5000603@windriver.com>
Date: Thu, 18 Nov 2010 10:09:03 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf,hw_breakpoint: Initialize hardware api earlier
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com> <1289684273-26770-3-git-send-regression-fweisbec@gmail.com> <1289684766.2109.326.camel@laptop>  <4CDFE516.3050006@windriver.com> <1289942654.2109.671.camel@laptop>
In-Reply-To: <1289942654.2109.671.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 16:09:05.0389 (UTC) FILETIME=[EC6201D0:01CB873A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 03:24 PM, Peter Zijlstra wrote:
> On Sun, 2010-11-14 at 07:33 -0600, Jason Wessel wrote:
>> This sounds to me like it would be early enough.  I could certainly run
>> the simple test case in the patch to make sure it still works, if you
>> point me to your patch(es).  I imagine I should also test the hand off
>> procedure where the debugger uses the registers directly up until the
>> point that perf is capable of handling reservations for the hw
>> breakpoint slots.
>
> I had to actually write them -- I had some hacky things in my sysfs RFC.
> Find attached.

It is worth summarizing the out of band discussion for anyone following
this thread.

The patch set did not address the problem of initializing the
hw_breakpoint api early enough to allow the breakpoint register hand
off to work correctly.


> Index: linux-2.6/kernel/hw_breakpoint.c
> ===========================================================
> --- linux-2.6.orig/kernel/hw_breakpoint.c
> +++ linux-2.6/kernel/hw_breakpoint.c
> @@ -655,6 +655,6 @@ static int __init init_hw_breakpoint(voi
> 
>         return -ENOMEM;
>  }
> -core_initcall(init_hw_breakpoint);
> +early_initcall(init_hw_breakpoint);

An early_initcall is still well after smp_init() and not early enough
for the kgdb arch setup to succeed when transitioning from early
debugging to late debugging.

There is a patch pending in the tip tree which moves the
hw_breakpoint_api registration to the same time the other perf
callbacks register.  We will go with that for now.

In the long term picture, at some point we should have a hand off
function that tells an early user of the hw breakpoint registers to
stop using them.  Presently there is a small window of overlap where
perf and kgdb both might write to the hw break point registers up
until the late kgdb initialization completes.  Presently there are no
regression tests for this condition and it might be the case that no
one ever has to debug this area with a hardware breakpoint, so we'll
leave it as a TODO item for the time being.

Thanks,
Jason.
