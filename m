Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0ERWkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:40:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38337
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab0ERWkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:40:51 -0400
Date: Tue, 18 May 2010 15:40:59 -0700 (PDT)
Message-Id: <20100518.154059.139137292.davem@davemloft.net>
To: lethal@linux-sh.org
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, herbert@gondor.hengli.com.au,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100518223507.GB5933@linux-sh.org>
References: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	<20100518.142021.135951273.davem@davemloft.net>
	<20100518223507.GB5933@linux-sh.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>
Date: Wed, 19 May 2010 07:35:10 +0900

> On Tue, May 18, 2010 at 02:20:21PM -0700, David Miller wrote:
>> So one of two things should happen:
>> 
>> 1) SLOB conforms to SLAB/SLUB in it's test
>> 
>> 2) SLAB/SLUB conforms to SLOB in it's test
>> 
>> And yes this is an either-or, you can't say they are both valid.
> 
> I don't see any reason to punish SLOB for the assumptions that SLAB/SLUB
> arbitrarily took up, presumably on an architecture that should have
> specified its own alignment requirements and simply couldn't be bothered.
> Making SLAB redzoning work with arbitrary alignment is another matter
> entirely, and something that should probably be revisited.
> 
> Anything that assumes more than BYTES_PER_WORD is simply broken and
> should be reverted.

You can't make the default different in each allocator, PERIOD.

If you can't know what the default is, how in the world can you know
if you need to override it?  You can't.  It's a guess, and you can't
say otherwise.

All of the CPP tests like the one used by linux/crypto.h are
ludicrious.  It should absolutely be not necessary for any code to
duplicate this kind of calculation.

Instead, this sequence should be in linux/slab.h, and be used
universally by slab, slub, slob and anything that wants to know the
allocators alignment guarentees.

I don't even know of a 32-bit chip outside of x86 that doesn't
potentially emit alignment requiring 64-bit memory operations for
64-bit objects.  So what SLOB is doing with a different default is
even more strange.  And I bet you that even without the requirement,
x86 runs faster with 64-bit alignment of 64-bit objects.
