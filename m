Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2ADRAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:00:42 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:40741 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750936Ab2ADRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:00:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Q_U5t_wVM1mtm_mjn6mF3Ixw7q1TG1QkoHVuniy1whwOmXr
 CNWfMC.DU_xdppYSdn3op9ivAGcQ6iauTUyxkQxMsdRbDqpGfj2c9wJouGXt
 LMyqD4F5K5bORYDGmYYKNEhZIx0RJVoy7Xu42lZgx0_DcbHE56V4_TX.f.7U
 kjybZaDhgQMh52ZrdievKkRbl2ckJ0UQamqHkpH2f.FrFmQ5DSQnzToqD9mt
 49s6yiId7xFDXBDJNynvs5n7wBBXIz.Rxl0vMxZDNfoOqRdt8RYNzD02B900
 NACQuEEiqslSG2ghymn4jQk6T7nHSss2k.YljPZdcIgKqjuiELTAHp0yHTsU
 RFp.iGVKo4qu4oNp4SqKgFeJvc.aWlC0ZriOLMIayaJ3GJQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 4 Jan 2012 11:00:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <CA+55aFwOp1UbeexKSdQC6YwrA9pS-J5qdqs-68=H8T1GS4Nr1A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201041046290.29775@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com> <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home> <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home> <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com> <alpine.DEB.2.00.1112231031001.3482@router.home> <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
 <alpine.DEB.2.00.1201040906090.27157@router.home> <CA+55aFwOp1UbeexKSdQC6YwrA9pS-J5qdqs-68=H8T1GS4Nr1A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Linus Torvalds wrote:

> On Wed, Jan 4, 2012 at 7:30 AM, Christoph Lameter <cl@linux.com> wrote:
> >
> > As mentioned before the main point of the use of these operations (in the
> > form of __this_cpu_op_return) when the cpu is pinned is to reduce the
> > number of instructions. __this_cpu_add_return allows replacing ~ 5
> > instructions with one.
>
> And that's fine if it's something really core, and something *so*
> important that you can tell the difference between one instruction and
> three.
>
> Which isn't the case here. In fact, on many (most?) x86
> microarchitectures xadd is actually slower than a regular
> add-from-memory-and-store - the big advantage of it is that with the
> "lock" prefix you do get special atomicity guarantees, and some
> algorithms (is semaphores) do want to know the value of the add
> atomically in order to know if there were other things going on.

xadd is 3 cycles. add is one cycle.

What we are doing here is also the use of a segment override to allow us
to relocate the per cpu address to the current cpu. So we are already
getting two additions for the price of one xadd. If we manually calcualte
the address then we have another memory reference to get the per cpu
offset for this processor (otherwise we get it from the segment register).
And then we need to store the results. We use registers etc etc.

Cannot imagine that this would be the same speed.

The thing is, I care about maintainability and not having
> cross-architecture problems etc. And right now many of the cpulocal
> things are *much* more of a maintainability headache than they are
> worth.

The cpu local things and xadd support have been around for a pretty long
time in various forms and they work reliably. I have tried to add onto
this by adding the cmpxchg/cmpxchg_double functionalty which caused some
issues because of the fallback stuff. That seems to have been addressed
though since we were willing now to make the preempt/irq tradeoff that we
were not able to get agreement on during the cleanup of the old APIs a
year or so ago.
