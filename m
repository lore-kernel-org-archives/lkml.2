Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1FFSj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:39:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58490 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1FFSju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:39:50 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Mon, 6 Jun 2011 11:39:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to
 unhide debug options
Message-ID: <20110606183939.GA2335@leaf>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
 <20110606165130.GA1844@leaf>
 <20110606181606.GB7862@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606181606.GB7862@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 08:16:09PM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 06, 2011 at 09:51:30AM -0700, Josh Triplett wrote:
> > Several debugging options currently default to y, such as
> > CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> > want to turn those options off to save space; however, turning them off
> > requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> > CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> > CONFIG_EXPERT exists specifically to unhide options potentially needed
> > by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> > CONFIG_DEBUG_KERNEL.
> > 
> > Change various debugging options to only reference DEBUG_KERNEL, not
> > EXPERT.
> 
> Ok, so ideally this should have been done in two patches. They are both
> different logical changes that don't imply the same.

Fair enough; I'd considered whether to split this patch or not, and
ended up with "not" on the theory that this seemed like a case of "fix
an API and fix up the callers", but I can easily split it in v4.

> v2 was fine, and should be an independent change.
> 
> But some comment on what was added in this v3 below:
> 
> > Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed wrong,
> > since EXPERT should not directly affect anything except the availability
> > of other options.  (And EXPERT definitely shouldn't mean "implicitly
> > turn off default safety features".)  Change it to default to y, which
> > means that turning on EXPERT does not automatically disable it, but will
> > provide the option to disable it.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> > 
> > v3: Changed other debugging options to stop referencing EXPERT.
> > 
> >  arch/tile/Kconfig.debug |    2 +-
> >  init/Kconfig            |    2 ++
> >  lib/Kconfig.debug       |    6 +++---
> >  3 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
> > index ddbfc33..afc9cf3 100644
> > --- a/arch/tile/Kconfig.debug
> > +++ b/arch/tile/Kconfig.debug
> > @@ -3,7 +3,7 @@ menu "Kernel hacking"
> >  source "lib/Kconfig.debug"
> >  
> >  config EARLY_PRINTK
> > -	bool "Early printk" if EXPERT && DEBUG_KERNEL
> > +	bool "Early printk" if DEBUG_KERNEL
> >  	default y
> 
> I don't understand why early_printk is default y. But that's debatable,
> we may want to have any user able to run a raw vga console for debugging
> requests.
> 
> Either:
> 
> - if we consider it's very important and mandatory, let's keep it "if EXPERT"
> and default y.
> 
> - if we consider it's only used by kernel developers, it should be off by
> default and depend on DEBUG_KERNEL only.

Note that this change occurs in arch/tile/Kconfig.debug; you'd have to
ask the Tile architecture developers about the rationale there.  For the
purposes of this change, I'd prefer not to make any semantic change
there.  Based on your explanation, that probably means I should change
it to "if EXPERT" rather than "if DEBUG_KERNEL", keeping the current
behavior of "only experts can turn this off".  I'll do that in v4.

> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -694,7 +694,7 @@ config DEBUG_HIGHMEM
> >  	  Disable for production systems.
> >  
> >  config DEBUG_BUGVERBOSE
> > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > +	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL
> 
> I believe this should not be changed, let keep it how it is, or change to
> "if EXPERT" because EXPERT selects DEBUG_KERNEL anyway.
> 
> There are no good reason to disable this option, except for some embedded
> system perhaps, so EXPERT still make sense here. 

I guess this matches the rationale above for tile's EARLY_PRINTK; I'll
use "if EXPERT" to preserve the behavior of "only experts can turn this
off".  To me it seems equivalent to any other debug option, and I don't
really see the harm in allowing users to turn it off if they turned on
DEBUG_KERNEL, but nevertheless this patch shouldn't make that kind of
semantic change.

- Josh Triplett
