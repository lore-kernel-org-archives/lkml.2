Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2ARRU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:20:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49021 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2ARRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:20:55 -0500
Date: Wed, 18 Jan 2012 21:20:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120118172049.GC2889@moon>
References: <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
 <20120117144452.GG16213@moon>
 <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
 <20120118080103.GA2889@moon>
 <4F168CF3.5090400@gmail.com>
 <4F168E93.5010000@parallels.com>
 <4F168F8C.8090504@gmail.com>
 <20120118115700.GO1968@moon>
 <4F16F781.3040700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16F781.3040700@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 11:46:57AM -0500, KOSAKI Motohiro wrote:
> (1/18/12 6:57 AM), Cyrill Gorcunov wrote:
> >On Wed, Jan 18, 2012 at 04:23:24AM -0500, KOSAKI Motohiro wrote:
> >>(1/18/12 4:19 AM), Pavel Emelyanov wrote:
> >>>>I think Eric only said gt/lt compare is useful. We don't need to expose bare
> >>>>pointer order. example, kcmp(rotate(ptr, per-task-random-value)) is enough
> >>>>hide the critical information. I think.
> >>>
> >>>The per-task might break thinks up in case
> >>>
> >>>(tsk1->file != tsk2->file) && (rotate(tsk1->file, tsk1->random) == rotate(tsk2->file, tsk2->rotate))
> >>
> >>I meant,
> >>
> >>(tsk1->file != tsk2->file) && (rotate(tsk1->file, caller_task->random) == rotate(tsk2->file, caller_task->random))
> >>
> >>>
> >>>but I agree, that the overall idea of comparing not bare pointers, but those poisoned with
> >>>some global value can address the Peter's concerns about rootkits.
> >
> >Guys, can we stick with something simplier? I could use hashes here (again?!) or
> >even aes encoded pointers extended to 128 bits as it was proposed too. But
> >maybe we can live with something more simplier?
> 
> The problem of hashes is,
> 
>  - SHA1 didn't provide correct "equal or not" policy. (and I don't think sha1 is faster than kcmp)
>  - Poisoned pointer can be used to restore original bare pointer.
> 
> Do this have the same issue?

No, this rorate() helper seems to not have such problems (still sha1 provided
pretty well equal or not policy, aes with internals random too). The thing is
the ->random you choose here (which I suppose will be the number of bits to
rotate in former pointer and this way break order -- weak option too, you
will be rotating in modulo field).

> 
> >We could export EQ/NE for regular users (which might be usefull for less
> >frequently used objects such as namespaces I guess). And GT/LT for root
> >only.
> >
> >Does it look better? Does the change log tells enough?
> 
> I dislike. Just EQ/NE is better than "root only" behavior change. it's misleading.
> If you dislike GT/LT, please just delete it.
> 

EQ/NE remains here for everyone and behaves constantly for all users. For safety reason
only root can restore in-memory order, so I must admit I don't understand the problem.

If I'm root on a machine already, the memory order is least interesting thing for me,
really, but getting the root rights is really a problem for most cases in turn.

So we would preferred to have gt/lt ability at least for root. If there
absolutely no way to do so -- eq/ne is admisable and we can try to optimise
sorting somehow (still not sure if we will success) but it's not desirable.

	Cyrill
