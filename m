Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0FCFVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:21:00 -0400
Received: from ozlabs.org ([203.10.76.45]:56369 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0FCFU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:20:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Thu, 3 Jun 2010 14:50:52 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006022336.53024.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006021038200.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006021038200.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031450.53576.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 03:31:06 am Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Rusty Russell wrote:
> > 
> > And load_module is down to 259 lines.  The label chain at the end is no
> > shorter tho :(  I'll leave those cleanups until next merge window.
> 
> Btw, here's a patch that _looks_ large, but it really pretty trivial, and 
> sets things up so that it would be way easier to split off pieces of the 
> module loading.
> 
> The reason it looks large is that it creates a "module_info" structure 
> that contains all the module state that we're building up while loading, 
> instead of having individual variables for all the indices etc.
> 
> So the patch ends up being large, because every "symindex" access instead 
> becomes "info.index.sym" etc. That may be a few characters longer, but it 
> then means that we can just pass a pointer to that "info" structure 
> around. and let all the pieces fill it in very naturally.
> 
> As an example of that, the patch also moves the initialization of all 
> those convenience variables into a "setup_module_info()" function. And at 
> this point it really does become very natural to start to peel off some of 
> the error labels and move them into the helper functions - now the 
> "truncated" case is gone, and is handled inside that setup function 
> instead.
> 
> So maybe you don't like this approach, and it does make the variable 
> accesses a bit longer, but I don't think unreadably so. And the patch 
> really does look big and scary, but there really should be absolutely no 
> semantic changes - most of it was a trivial and mindless rename.
> 
> In fact, it was so mindless that I on purpose kept the existing helper 
> functions looking like this:
> 
> -       err = check_modinfo(mod, sechdrs, infoindex, versindex);
> +       err = check_modinfo(mod, info.sechdrs, info.index.info, info.index.vers);
> 
> rather than changing them to just take the "info" pointer. IOW, a second 
> phase (if you think the approach is ok) would change that calling 
> convention to just do
> 
> 	err = check_modinfo(mod, &info);
> 
> (and same for "layout_sections()", "layout_symtabs()" etc.) Similarly, 
> while right now it makes things _look_ bigger, with things like this:
> 
> 	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
> 
> becoming
> 
> 	info->index.vers = find_sec(info->hdr, info->sechdrs, info->secstrings, "__versions");
> 
> in the new "setup_module_info()" function, that's again just a result of 
> it being a search-and-replace patch. By using the 'info' pointer, we could 
> just change the 'find_sec()' interface so that it ends up being
> 
> 	info->index.vers = find_sec(info, "__versions");
> 
> instead, and then we'd actually have a shorter and more readable line. So 
> for a lot of those mindless variable name expansions there's would be room 
> for separate cleanups.
> 
> I didn't move quite everything in there - if we do this to layout_symtabs, 
> for example, we'd want to move the percpu, symoffs, stroffs, *strmap 
> variables to be fields in that module_info structure too. But that's a 
> much smaller patch, I moved just the really core stuff that is currently 
> being set up and used in various parts.
> 
> But even in this rough form, it removes close to 70 lines from that 
> function (but adds 22 lines overall, of course - the structure definition, 
> the helper function declarations and call-sites etc etc).

Applied.  I thought about the same thing but had the same doubts as you.

However, you're right that it has potential.  I'll rename module_info to
load_info if you don't mind tho: contains more semantic punch IMHO.

On top of this, I'm right now closing on another ideal of mine: encapsulate
all the "before we move module" into one function.  That before vs. after
always made me nervous...

Thanks!
Rusty.
