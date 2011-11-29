Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1K2TaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:30:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47096 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1K2TaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:30:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Nov 2011 11:29:51 -0800
X-Google-Sender-Auth: W_H-DV4z_FMCxmkWsJvqW6wkLN8
Message-ID: <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:02 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> The most important ones are from Christoph Lameter and Eric Dumazet that fix
> stability issues on non-x86 architectures.
>
> Christoph Lameter (1):
>      slub: use irqsafe_cpu_cmpxchg for put_cpu_partial

Quite frankly, I think "this_cpu_cmpxchg()" is pure crap, and this fix
was wrong, wrong, WRONG.

Dammit, the emulation is just bad.

The *only* architecture that implements "this_cpu_cmpxchg()" specially
seems to be x86.

So every other architecture uses the emulated one, AND THE EMULATED
ONE DOES NOT MATCH THE X86 SEMANTICS!

Sorry for shouting, but that's just *incredibly* stupid.

What's extra stupid is that s390 actually separately implements the
irq-safe version, and does it with code that seems to be generic, and
actually uses "cmpxchg()" like the regular "this_cpu_cmpxchg()" name
implies!

In other words, I would suggest that:

 - we get rid of that totally crazy idiotic "irqsafe" crap. The normal
one should be irq-safe. It's named "cmpxchg", for chrissake!

 - we make the non-arch-specific "this_cpu_cmpxchg()" use the correct
s390 routines instead of the pure and utter *shit* it uses now.

Yes, I'm upset. This "random percpu crap for SLUB" has been going on
too f*cking long, and it has been *continually* plagued by just pure
sh*t like this.

Seriously. Stop taking patches from Christoph in this area until they
have been vetted for sanity and completeness. This kind of ugly "let's
mis-name our functions in really subtle ways so that they work on x86
but nowhere else" needs to stop.

I pulled this crap because clearly it fixes a bug, but just stop it.
Show some TASTE!

                            Linus
