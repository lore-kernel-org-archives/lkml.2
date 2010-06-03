Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0FCQ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:29:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0FCQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:29:44 -0400
Date: Thu, 3 Jun 2010 09:24:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006031450.53576.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006030916520.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006022336.53024.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006021038200.8175@i5.linux-foundation.org> <201006031450.53576.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Rusty Russell wrote:
> 
> However, you're right that it has potential.  I'll rename module_info to
> load_info if you don't mind tho: contains more semantic punch IMHO.

Umm. One problem is that you will almost certainly eventually want to 
expose that to the architecture "fixup" routines (ie things like 
module_frob_arch_sections(), arch_mod_section_prepend()), and at that 
point "load_info" is a horribly bad structure name, since it would show 
up in <linux/module.h> and thus be exported all over.

At least call it "struct module_load_info". But yes, I do agree that the 
"load" part is important.

> On top of this, I'm right now closing on another ideal of mine: encapsulate
> all the "before we move module" into one function.  That before vs. after
> always made me nervous...

Yeah, that should be trivial, and I agree that it would be good to not 
have "mod" mean two things in the same function. Especially with all the 
"goto failure-case", and some of the failure cases using "mod", it is a 
bit scary for it to point into the (before movement) 'hdr+len' structure, 
and then (after movement) into the relocated module allocations.

I looked at that particularly when doing that whole

	mod = setup_module_info(&info);
	if (IS_ERR(mod)) {
		err = PTR_ERR(mod);
		goto free_hdr;
	}

thing, because that made "mod" have _three_ totally different values 
(error, before, after) when jumping out to the failure paths. 

		Linus
