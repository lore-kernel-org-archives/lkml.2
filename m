Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0GOFAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 01:00:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40967 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab0GOFAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 01:00:13 -0400
Message-ID: <4C3E16EE.1010502@zytor.com>
Date: Wed, 14 Jul 2010 21:58:38 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org>	<AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com>	<4C3DF1BE.2070404@goop.org>	<4C3DF447.1000801@zytor.com>	<4C3DF519.6030406@goop.org>	<4C3DF7AF.7010402@zytor.com>	<4C3DFA88.5020007@goop.org>	<4C3DFD12.3050700@zytor.com>	<AANLkTikA8SO42kOgHZb-6YuhM7GPnmg81IAX5vEk_Cqk@mail.gmail.com>	<4C3E096B.8050505@zytor.com>	<AANLkTil5uvr9sWc_o3HmOsJ0iaJJjaMkkrMwF0BsEdHg@mail.gmail.com>	<4C3E11BD.2090503@zytor.com> <AANLkTilKr6wr_wAE0nzXDsffWYWNdGf2_EqMXzRSKJMu@mail.gmail.com> <4C3E27E7.3010706@goop.org>
In-Reply-To: <4C3E27E7.3010706@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:11 PM, Jeremy Fitzhardinge wrote:
>
> The question is "what are the real ordering semantics of asm volatile"?
> What ordering is enforced between other asm volatiles?  What ordering is
> enforced between asm volatiles and regular memory accesses? asm volatile
> and other code?
>
> The documentation discusses this to some extent, but mostly says "there
> are no ordering guarantees".  Older versions of gcc - 2.95, for example
> - are more explicit, saying that "asm volatiles" won't be moved out of
> their basic block (I think that's how I parse it, anyway).
>

I looked over the text, and I think you're confusing static reordering 
and duplication with execution reordering (gcc is indeed free to move 
around and even replicate asm volatile statements).  One thing is that 
the docs makes it perfectly clear that asm volatile is not ordered with 
respect to *non*-volatile operations (*all* the examples are 
volatile-nonvolatile.)  It says that asm volatile statements may not be 
"consecutive", i.e. gcc may generate code in between them, but all of 
this is well known and understood.

The other thing that the documentation *does* specifically make clear is 
that an "asm volatile" has an implicit dependency on all memory (as an 
input, as opposed to an output/clobber.)

I actually found the following statement in the gcc documentation, 
although it is in the section on C++ (6.1 in my version); the text, 
though, makes it clear that it applies to both C and C++:

Both the C and C++ standard have the concept of volatile objects.  These
are normally accessed by pointers and used for accessing hardware.  The
standards encourage compilers to refrain from optimizations concerning
accesses to volatile objects.  The C standard leaves it implementation
defined  as to what constitutes a volatile access.  The C++ standard
omits to specify this, except to say that C++ should behave in a
similar manner to C with respect to volatiles, where possible.  The
minimum either standard specifies is that at a sequence point all
previous accesses to volatile objects have stabilized and no subsequent
accesses have occurred.  Thus an implementation is free to reorder and
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
combine volatile accesses which occur between sequence points, but
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
cannot do so for accesses across a sequence point.  The use of
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
volatiles does not allow you to violate the restriction on updating
objects multiple times within a sequence point.

[My emphasis, obviously.]

I think that pretty much settles the matter, since any statement 
(including an asm statement) inherently has a sequence point before or 
after it.  However, I will file a gcc bug report to clarify.

	-hpa
