Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1J1Oze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:55:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43961 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1J1Ozd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <1319813252.23112.122.camel@edumazet-laptop>
References: <1319764761.23112.14.camel@edumazet-laptop> <20111028012521.GF25795@one.firstfloor.org>
 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
 <1319766293.6759.17.camel@deadeye> <1319770376.23112.58.camel@edumazet-laptop>
 <1319772566.6759.27.camel@deadeye> <1319777025.23112.67.camel@edumazet-laptop>
 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
 <1319803781.23112.113.camel@edumazet-laptop> <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
 <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com> <1319813252.23112.122.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Oct 2011 07:55:10 -0700
X-Google-Sender-Auth: WuQ6G2rGP245VWEHUuE2QLY4xK4
Message-ID: <CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 7:47 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> So we need a similar idea to remove the volatile from :
>
> static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
> {
> return ((1UL << (nr % BITS_PER_LONG)) &
>         (addr[nr / BITS_PER_LONG])) != 0;

Ho humm. Yeah, I think "test_bit()" falls under the same logic: we do
not want to combine multiple test-bits into one (because we know there
are people looping on it), and we do want to guarantee "access at most
once" semantics, but as with "atomic_read()" we should be able to
optimize away a totally unused test-bit.

The same "empty asm" trick would work there, I think, rather than
using "volatile" (well, the function declaration would still have
"volatile" because it's legal to use a volatile data type, but we'd
cast it away and use the asm trick for the access instead) .

Maybe we should make it a generic helper macro ("ACCESS_AT_MOST_ONCE()")?

Comments? I think I'm open to tested patches..

                      Linus
