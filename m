Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab1CDXCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:02:41 -0500
Received: from waste.org ([173.11.57.241]:58351 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab1CDXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:02:39 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTikQxOgYFLbc2KbEKgRYL1RCnkPE-T80-GBY2Cgj@mail.gmail.com>
References: <1299174652.2071.12.camel@dan> <1299185882.3062.233.camel@calx>
	 <1299186986.2071.90.camel@dan> <1299188667.3062.259.camel@calx>
	 <1299191400.2071.203.camel@dan>
	 <2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
	 <AANLkTimpfk8EHjVKYsJv0p_G7tS2yB-n=PPbD2v7xefV@mail.gmail.com>
	 <1299260164.8493.4071.camel@nimitz>
	 <AANLkTim+XcYiiM9u8nT659FHaZO1RPDEtyAgFtiA8VOk@mail.gmail.com>
	 <1299262495.3062.298.camel@calx>
	 <AANLkTimRN_=APe_PWMFe_6CHHC7psUbCYE-O0qc=mmYY@mail.gmail.com>
	 <1299270709.3062.313.camel@calx> <1299271377.2071.1406.camel@dan>
	 <AANLkTik6tAfaSr3wxdQ1u_Hd326TmNZe0-FQc3NuYMKN@mail.gmail.com>
	 <1299272907.2071.1415.camel@dan>
	 <AANLkTina+O77BFV+7mO9fX2aJimpO0ov_MKwxGtMwqG+@mail.gmail.com>
	 <1299275042.2071.1422.camel@dan>
	 <AANLkTikA=88EMs8RRm0RPQ+Q9nKj=2G+G86h5nCnV7Se@mail.gmail.com>
	 <AANLkTikQxOgYFLbc2KbEKgRYL1RCnkPE-T80-GBY2Cgj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 17:02:36 -0600
Message-ID: <1299279756.3062.361.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 00:14 +0200, Pekka Enberg wrote:
> On Sat, Mar 5, 2011 at 12:10 AM, Pekka Enberg <penberg@kernel.org> wrote:
> > I can think of four things that will make things harder for the
> > attacker (in the order of least theoretical performance impact):
> >
> >  (1) disable slub merging
> >
> >  (2) pin down random objects in the slab during setup (i.e. don't
> > allow them to be allocated)
> >
> >  (3) randomize the initial freelist
> >
> >  (4) randomize padding between objects in a slab
> >
> > AFAICT, all of them will make brute force attacks using the kernel
> > heap as an attack vector harder but won't prevent them.
> 
> There's also a fifth one:
> 
>   (5) randomize slab page allocation order
> 
> which will make it harder to make sure you have full control over a
> slab and figure out which allocation lands on it.

I think the real issue here is that it's too easy to write code that
copies too many bytes from userspace. Every piece of code writes its own
bound checks on copy_from_user, for instance, and gets it wrong by
hitting signed/unsigned issues, alignment issues, etc. that are on the
very edge of the average C coder's awareness. 

We need functions that are hard to abuse and coding patterns that are
easy to copy, easy to review, and take the tricky bits out of the hands
of driver writers.

I'm not really sure what that looks like yet, but a copy that does its
own bounds-checking seems like a start:

copy_from_user(dst, src, n, limit) # warning when limit is hit
copy_from_user_nw(dst, src, n, limit) # no warning version

-- 
Mathematics is the supreme nostalgia of our time.


