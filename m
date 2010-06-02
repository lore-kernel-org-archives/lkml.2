Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0FBFxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:53:05 -0400
Received: from ozlabs.org ([203.10.76.45]:56389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab0FBFxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:53:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 15:22:58 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <20100602021029.GD10332@jenkins.ifup.org> <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021523.00357.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 02:05:10 pm Linus Torvalds wrote:
> 
> On Tue, 1 Jun 2010, Brandon Philips wrote:
> > 
> > FWIW, I tried this same idea initially and it breaks because the
> > kobject EEXIST is coming from mod_sysfs_init() which happens further
> > up in load_module() before the list_add_rcu().
> 
> Ahh, right. So we'd need to mvoe that down too. As Rusty says, the kobject 
> EEXIST warning should be fairly harmless - albeit annoying. Do things 
> actually _work_ with that thing apart from the kobject warning?
> 
> > I also tried the obvious variation of moving the list_add_rcu() up
> > to where the find_module is but got:
> 
> Yeah, I don't think moving it up will work, because then the module symbol 
> resolver will see itself before having set up the symbols. So I think we 
> need to expose it on the modules list only after having done the 
> "simplify_symbols()" etc.
> 
> I dunno.
> 
> Does this work?
> 
> (Caveat emptor - I tried to make sure the error cases nest correctly, and 
> it all compiles, but it's untested. As usual. Rusty mentioned a "see 
> testing patch", but I didn't see it. Maybe he did the same thing)

Yep, oops.  I am testing a similar thing, but a bit more of a cleanup
on the way.

Moved all the sysfs-exposing stuff to the end just after we put in the
list (and thus to after the find check).  In turn spawns a sysfs cleanup
(those funcs exposed for no good reason).  Also, your two-way deps patch
really wins since we need to walk the list to create the links.

Code soon...
Rusty
