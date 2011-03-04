Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab1CDUh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:37:26 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:65456 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760139Ab1CDUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:37:25 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTimRN_=APe_PWMFe_6CHHC7psUbCYE-O0qc=mmYY@mail.gmail.com>
References: <1299174652.2071.12.camel@dan> <1299185882.3062.233.camel@calx>
	 <1299186986.2071.90.camel@dan> <1299188667.3062.259.camel@calx>
	 <1299191400.2071.203.camel@dan>
	 <2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
	 <AANLkTimpfk8EHjVKYsJv0p_G7tS2yB-n=PPbD2v7xefV@mail.gmail.com>
	 <1299260164.8493.4071.camel@nimitz>
	 <AANLkTim+XcYiiM9u8nT659FHaZO1RPDEtyAgFtiA8VOk@mail.gmail.com>
	 <1299262495.3062.298.camel@calx>
	 <AANLkTimRN_=APe_PWMFe_6CHHC7psUbCYE-O0qc=mmYY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 15:37:21 -0500
Message-ID: <1299271041.2071.1398.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 22:02 +0200, Pekka Enberg wrote:
> On Fri, Mar 4, 2011 at 8:14 PM, Matt Mackall <mpm@selenic.com> wrote:
> >> Of course, as you say, '/proc/meminfo' still does give you the trigger
> >> for "oh, now somebody actually allocated a new page". That's totally
> >> independent of slabinfo, though (and knowing the number of active
> >> slabs would neither help nor hurt somebody who uses meminfo - you
> >> might as well allocate new sockets in a loop, and use _only_ meminfo
> >> to see when that allocated a new page).
> >
> > I think lying to the user is much worse than changing the permissions.
> > The cost of the resulting confusion is WAY higher.
> 
> Yeah, maybe. I've attached a proof of concept patch that attempts to
> randomize object layout in individual slabs. I'm don't completely
> understand the attack vector so I don't make any claims if the patch
> helps or not.
> 
>                         Pekka

Thanks for your work on this.  The most general exploitation techniques
involving kernel SLUB/SLAB corruption involve manipulating heap state
such that an object that can be overflowed by the attacker resides
immediately before another object whose contents are worth overwriting,
or overflowing into the page following the slab.  The most common known
techniques involve overflowing into an allocated object with useful
contents such as a function pointer and then triggering these (various
IPC-related structs are often used for this).  It's also possible to
overflow into a free object and overwrite its free pointer, causing
subsequent allocations to result in a fake heap object residing in
userland being under an attacker's control.

This patch makes these techniques more difficult by making it hard to
know whether the last attacker-allocated object resides before a free or
allocated object.  Especially with vulnerabilities that only allow one
attempt at exploitation before recovery is needed to avoid trashing too
much heap state and causing a crash, this could go a long way.  I'd
still argue in favor of removing the ability to know how many objects
are used in a given slab, since randomizing objects doesn't help if you
know every object is allocated.

Of course people more knowledgeable on SLUB should look this over for
sanity's sake, but it looks good to me.

-Dan

