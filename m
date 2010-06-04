Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0FDBCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:02:08 -0400
Received: from ozlabs.org ([203.10.76.45]:42588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0FDBCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:02:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Fri, 4 Jun 2010 10:32:03 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006031450.53576.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006030916520.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006030916520.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006041032.04323.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 01:54:19 am Linus Torvalds wrote:
> 
> On Thu, 3 Jun 2010, Rusty Russell wrote:
> > 
> > However, you're right that it has potential.  I'll rename module_info to
> > load_info if you don't mind tho: contains more semantic punch IMHO.
> 
> Umm. One problem is that you will almost certainly eventually want to 
> expose that to the architecture "fixup" routines (ie things like 
> module_frob_arch_sections(), arch_mod_section_prepend()), and at that 
> point "load_info" is a horribly bad structure name, since it would show 
> up in <linux/module.h> and thus be exported all over.
> 
> At least call it "struct module_load_info". But yes, I do agree that the 
> "load" part is important.

Looking at the arch code, it has the advantage that it's self-contained.
They've been pleasantly undemanding from the core over the years; I think
archs doing tricky things with elf prefer to parse the object themselves
anyway.  And I'm not sure they want to revisit it, either.

So I don't think we'd win much from changing them.  I'm wrong later, I'll
prepend "module_" to the struct name as an internal change then hit them
all.

> I looked at that particularly when doing that whole
> 
> 	mod = setup_module_info(&info);
> 	if (IS_ERR(mod)) {
> 		err = PTR_ERR(mod);
> 		goto free_hdr;
> 	}
> 
> thing, because that made "mod" have _three_ totally different values 
> (error, before, after) when jumping out to the failure paths. 

Yep, it now is back to sanity.  Let's see if today's linux-next is
happy.

If so, do you want just the fixes or the whole refactoring too, while
it's nice and fresh?

Thanks!
Rusty.
