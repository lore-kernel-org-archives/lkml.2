Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1AEJeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1AEJef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:34:35 -0500
Message-ID: <4D243B1B.9060803@redhat.com>
Date: Wed, 05 Jan 2011 11:34:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110105173823.B658.A69D9226@jp.fujitsu.com> <4D2434F6.4020904@redhat.com> <20110105181414.B65E.A69D9226@jp.fujitsu.com>
In-Reply-To: <20110105181414.B65E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 11:30 AM, KOSAKI Motohiro wrote:
> >  On 01/05/2011 10:40 AM, KOSAKI Motohiro wrote:
> >  >  >   On 01/05/2011 04:39 AM, KOSAKI Motohiro wrote:
> >  >  >   >   >    On 01/04/2011 08:14 AM, KOSAKI Motohiro wrote:
> >  >  >   >   >    >    Also, If pthread_cond_signal() call sys_yield_to imlicitly, we can
> >  >  >   >   >    >    avoid almost Nehalem (and other P2P cache arch) lock unfairness
> >  >  >   >   >    >    problem. (probaby creating pthread_condattr_setautoyield_np or similar
> >  >  >   >   >    >    knob is good one)
> >  >  >   >   >
> >  >  >   >   >    Often, the thread calling pthread_cond_signal() wants to continue
> >  >  >   >   >    executing, not yield.
> >  >  >   >
> >  >  >   >   Then, it doesn't work.
> >  >  >   >
> >  >  >   >   After calling pthread_cond_signal(), T1 which cond_signal caller and T2
> >  >  >   >   which waked start to GIL grab race. But usually T1 is always win because
> >  >  >   >   lock variable is in T1's cpu cache. Why kernel and userland have so much
> >  >  >   >   different result? One of a reason is glibc doesn't have any ticket lock scheme.
> >  >  >   >
> >  >  >   >   If you are interesting GIL mess and issue, please feel free to ask more.
> >  >  >
> >  >  >   I suggest looking into an explicit round-robin scheme, where each thread
> >  >  >   adds itself to a queue and an unlock wakes up the first waiter.
> >  >
> >  >  I'm sure you haven't try your scheme. but I did. It's slow.
> >
> >  Won't anything with a heavily contented global/giant lock be slow?
> >  What's the average lock hold time per thread? 10%? 50%? 90%?
>
> Well, Of cource all of heavily contetion are slow. but we don't have to
> compare heavily contended with light contended. we have to compare
> heavily contended with heavily contended or light contended with light
> contended. If we are talking a scripting language VM, pipe benchmark
> show impressively FIFO overhead which like your propsed. Because
> pipe bench makes frequently GIL grab/ungrab storm. Similar to pipe
> bench showed our (very) old kernel's bottleneck. Sadly userspace have
> no way to implement per-cpu runqueue. I think.

A completely fair lock will likely be slower than an unfair lock.

> And, if we are talking a language VM, I can't say any average time. It
> depend on running script.

Pick some parallel compute intensive script, please.

-- 
error compiling committee.c: too many arguments to function

