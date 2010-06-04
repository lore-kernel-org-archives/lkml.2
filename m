Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0FDUJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:09:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab0FDUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:09:33 -0400
Date: Fri, 4 Jun 2010 13:04:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Luck <tony.luck@intel.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Dave Young <hidave.darkstar@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3
In-Reply-To: <AANLkTikN_3oLIFQ0CRiLwXUV79myy_aqriezdCgnZHFT@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006041255210.8175@i5.linux-foundation.org>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au> <AANLkTilr92GkR8bfgyjtb8ToYEEAv4oCsFsfsy04HJRU@mail.gmail.com> <AANLkTim6v2s-Q5BndAKLOZKaA1wYgbU3UKJwNy-6Jkki@mail.gmail.com> <201006032222.57411.rusty@rustcorp.com.au>
 <AANLkTikN_3oLIFQ0CRiLwXUV79myy_aqriezdCgnZHFT@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Tony Luck wrote:
> 
> At the point of dereference it looks like we were trying
> to load a 4-byte data object from offset 552 into the
> "struct module *" that wa returned by load_module().

Sounds like 'mod->num_ctors' loaded by do_mod_ctors(). It's a 4-byte field 
in roughly that area.

What does a NaT consumption fault mean, and does it give the invalid 
address it was loaded off? In the successful path of "load_module()", we 
will have dereferenced the "mod" pointer we return just before, so I 
wonder if there's some error case that incorrectly returns a positive 
errno instead of a negative one, and causes us to miss the "IS_ERR()" 
check or something.

There's a couple of checking routines in module.c that do not return a 
negative error, but instead return 0/1. The one I looked at was converted 
into a negative error, but there are several cases of

	if (err)
		return ERR_PTR(err)

and if something does that on a 0/1 value, it will return a bogus pointer.

		Linus
