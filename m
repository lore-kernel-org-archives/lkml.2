Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1LTJrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:47:35 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47778 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914Ab1LTJr1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
	<CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
Date: Tue, 20 Dec 2011 11:47:26 +0200
X-Google-Sender-Auth: eCbQ4sI2tkW0Q9dxaSnTNkNm2BM
Message-ID: <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(I'm CC'ing Tejun and Thomas.)

On Tue, Nov 29, 2011 at 10:02 AM, Pekka Enberg <penberg@kernel.org> wrote:
>> The most important ones are from Christoph Lameter and Eric Dumazet that fix
>> stability issues on non-x86 architectures.
>>
>> Christoph Lameter (1):
>>      slub: use irqsafe_cpu_cmpxchg for put_cpu_partial

On Tue, Nov 29, 2011 at 9:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Quite frankly, I think "this_cpu_cmpxchg()" is pure crap, and this fix
> was wrong, wrong, WRONG.
>
> Dammit, the emulation is just bad.
>
> The *only* architecture that implements "this_cpu_cmpxchg()" specially
> seems to be x86.
>
> So every other architecture uses the emulated one, AND THE EMULATED
> ONE DOES NOT MATCH THE X86 SEMANTICS!
>
> Sorry for shouting, but that's just *incredibly* stupid.
>
> What's extra stupid is that s390 actually separately implements the
> irq-safe version, and does it with code that seems to be generic, and
> actually uses "cmpxchg()" like the regular "this_cpu_cmpxchg()" name
> implies!
>
> In other words, I would suggest that:
>
>  - we get rid of that totally crazy idiotic "irqsafe" crap. The normal
> one should be irq-safe. It's named "cmpxchg", for chrissake!
>
>  - we make the non-arch-specific "this_cpu_cmpxchg()" use the correct
> s390 routines instead of the pure and utter *shit* it uses now.
>
> Yes, I'm upset. This "random percpu crap for SLUB" has been going on
> too f*cking long, and it has been *continually* plagued by just pure
> sh*t like this.
>
> Seriously. Stop taking patches from Christoph in this area until they
> have been vetted for sanity and completeness. This kind of ugly "let's
> mis-name our functions in really subtle ways so that they work on x86
> but nowhere else" needs to stop.

So, I actually looked into doing something like this and wasn't
actually able to understand the purpose of the various percpu
variants. It seems rather obvious that we can just drop the
non-irqsafe cmpxchg() variant but what about the rest of the percpu
ops? Why do we have preempt safe, irqsafe, and unsafe variants? How
are they supposed to be used?

To illustrate the issue, for "per cpu add" we have:

__this_cpu_add()
this_cpu_add()
irqsafe_cpu_add()
percpu_add()

Why do we need all of them?

                        Pekka
