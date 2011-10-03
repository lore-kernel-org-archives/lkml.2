Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab1JCVpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:45:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63858 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1JCVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
 <m21uuxirxi.fsf@firstfloor.org> <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
 <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com>
 <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>
 <20111003163559.GA3957@redhat.com> <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Oct 2011 14:45:23 -0700
X-Google-Sender-Auth: ZhTTt2MIGYon18Y3xUQrzHpHPfI
Message-ID: <CA+55aFyuZyNREYtKY7OacKar7KVD0pfPYyCo67kyGJkk063E7g@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 1:58 PM, Matt Fleming <matt@console-pimps.org> wrote:
>
> No, I don't think there was anything wrong with your testing method. I
> ran your command-line under Qemu and saw similar results - with the
> patches applied the single-threaded case slows down (not by 50%, it
> looks more like 25%, but that's still unacceptable and not at all what I
> had anticipated).

Splitting up locks fairly easily causes these kinds of problems.

On many modern microarchitectures, the serialization implied by
locking can be a *big* performance hit. If a system call goes from a
single big lock to two split locks, that can easily make that system
call very noticeably slower. The individual locks may protect a much
smaller section and be "more scalable", but the end result is actually
clearly worse performance.

We've had that several times when we've made smaller locks (in the VM
in particular). One big lock that you take once can be way better than
two small ones that you have to take in sequence (or, worse still,
nested - that's when you can *really* get into exponential badness).

And with even a very limited number of threads (or processes passing
signals back-and-forth) you can get a "train effect": two cores
accessing the same two locks in order, so that they get synchronized.
The "get synchronized" event itself might even be rare, but once it
happens, things can stay synchronized.

And if the second one always then ends up blocking and/or just causing
cacheline ping-pongs, that slowdown can go up by an absolutely huge
amount because you basically make the "rare" case be the common one.

                           Linus
