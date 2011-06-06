Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1FFVey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:34:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54864 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1FFVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u8cUDIRAEWjTPH8dOGWi7X+hU20cgo30tTzZBUcOPNHtHwNCYnbDuWJQ7JoEc0uCFh
         Iscm95WTkLewjSzUtR64974qtYnTykSeVXBHwmhSNgdRCt4U4DZDjZv72OPnxb/0s7J3
         06We9LSd979vl059ASZJACLLed49R/3qpEKfM=
Date: Mon, 6 Jun 2011 23:34:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to
 unhide debug options
Message-ID: <20110606213446.GA17026@somewhere.redhat.com>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
 <20110606165130.GA1844@leaf>
 <20110606181606.GB7862@somewhere>
 <20110606183939.GA2335@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606183939.GA2335@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:39:39AM -0700, Josh Triplett wrote:
> On Mon, Jun 06, 2011 at 08:16:09PM +0200, Frederic Weisbecker wrote:
> > On Mon, Jun 06, 2011 at 09:51:30AM -0700, Josh Triplett wrote:
> > > Several debugging options currently default to y, such as
> > > CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> > > want to turn those options off to save space; however, turning them off
> > > requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> > > CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> > > CONFIG_EXPERT exists specifically to unhide options potentially needed
> > > by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> > > CONFIG_DEBUG_KERNEL.
> > > 
> > > Change various debugging options to only reference DEBUG_KERNEL, not
> > > EXPERT.
> > 
> > Ok, so ideally this should have been done in two patches. They are both
> > different logical changes that don't imply the same.
> 
> Fair enough; I'd considered whether to split this patch or not, and
> ended up with "not" on the theory that this seemed like a case of "fix
> an API and fix up the callers", but I can easily split it in v4.

You haven't just fixed the API and propagated to the callers accordingly.
What you did is to fix the API and also completely change the behaviour of the callers.

You have changed EXPERT to imply DEBUG_KERNEL.
You'd have fixed the callers accordingly if you only changed "depend on EXPERT && DEBUG_KERNEL"
into "depend on EXPERT" in the callers, because if EXPERT => DEBUG_KERNEL then
(EXPERT && DEBUG_KERNEL) == EXPERT. Thus it would have fit into the same logic and
gathering the whole into a single patch would have made sense (although that's debatable, I
would have cut that personally, but we don't care at that level).

Now changing callers that "depend on EXPERT && DEBUG_KERNEL" to "depend on DEBUG_KERNEL" subscribes
to a completely different logical change. It has actually even nothing to deal with
the previous change. You can make that behaviour change even without having EXPERT => DEBUG_KERNEL.

So not only you gathered two different logical changes into a same patch, but the
two things even hardly have any connection together.

 
> > v2 was fine, and should be an independent change.
> > 
> > But some comment on what was added in this v3 below:
> > 
> > > Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed wrong,
> > > since EXPERT should not directly affect anything except the availability
> > > of other options.  (And EXPERT definitely shouldn't mean "implicitly
> > > turn off default safety features".)  Change it to default to y, which
> > > means that turning on EXPERT does not automatically disable it, but will
> > > provide the option to disable it.
> > > 
> > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > > ---
> > > 
> > > v3: Changed other debugging options to stop referencing EXPERT.
> > > 
> > >  arch/tile/Kconfig.debug |    2 +-
> > >  init/Kconfig            |    2 ++
> > >  lib/Kconfig.debug       |    6 +++---
> > >  3 files changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
> > > index ddbfc33..afc9cf3 100644
> > > --- a/arch/tile/Kconfig.debug
> > > +++ b/arch/tile/Kconfig.debug
> > > @@ -3,7 +3,7 @@ menu "Kernel hacking"
> > >  source "lib/Kconfig.debug"
> > >  
> > >  config EARLY_PRINTK
> > > -	bool "Early printk" if EXPERT && DEBUG_KERNEL
> > > +	bool "Early printk" if DEBUG_KERNEL
> > >  	default y
> > 
> > I don't understand why early_printk is default y. But that's debatable,
> > we may want to have any user able to run a raw vga console for debugging
> > requests.
> > 
> > Either:
> > 
> > - if we consider it's very important and mandatory, let's keep it "if EXPERT"
> > and default y.
> > 
> > - if we consider it's only used by kernel developers, it should be off by
> > default and depend on DEBUG_KERNEL only.
> 
> Note that this change occurs in arch/tile/Kconfig.debug; you'd have to
> ask the Tile architecture developers about the rationale there.  For the
> purposes of this change, I'd prefer not to make any semantic change
> there.  Based on your explanation, that probably means I should change
> it to "if EXPERT" rather than "if DEBUG_KERNEL", keeping the current
> behavior of "only experts can turn this off".  I'll do that in v4.

Ah it's in tile! I read that part too quickly, sorry. Yeah let them
deal with that and only have "depend on EXPERT"

> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -694,7 +694,7 @@ config DEBUG_HIGHMEM
> > >  	  Disable for production systems.
> > >  
> > >  config DEBUG_BUGVERBOSE
> > > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > > +	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL
> > 
> > I believe this should not be changed, let keep it how it is, or change to
> > "if EXPERT" because EXPERT selects DEBUG_KERNEL anyway.
> > 
> > There are no good reason to disable this option, except for some embedded
> > system perhaps, so EXPERT still make sense here. 
> 
> I guess this matches the rationale above for tile's EARLY_PRINTK; I'll
> use "if EXPERT" to preserve the behavior of "only experts can turn this
> off".

Cool.

> To me it seems equivalent to any other debug option, and I don't
> really see the harm in allowing users to turn it off if they turned on
> DEBUG_KERNEL, but nevertheless this patch shouldn't make that kind of
> semantic change.

It's not equivalent to other kernel debug options because unlike most other debug
options we don't want only kernel developers to enable it, we want everyone to
enable it.

If you let this option to be easily turned off, people may disable it by mistake
and then developers will suddenly receive useless bug reports, which can be
a frustrating experience.

There is no good reason to disable it except in some particular embedded cases I guess.
