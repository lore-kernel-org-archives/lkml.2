Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2BMVq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:46:26 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50490 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab2BMVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:46:24 -0500
Date: Mon, 13 Feb 2012 14:46:23 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Meelis Roos <mroos@linux.ee>
Cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120213214623.GJ11077@ponder.secretlab.ca>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
 <20120213080618.GA11077@ponder.secretlab.ca>
 <alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 11:20:36AM +0200, Meelis Roos wrote:
> > Try the following patch.  I suspect the new of_alias_scan() isn't careful
> > enough about which properties it dereferences:
> > 
> > ---
> > 
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index 133908a..9188caa 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1174,6 +1174,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
> >  		    !strcmp(pp->name, "linux,phandle"))
> >  			continue;
> >  
> > +		/* Check for null value or non-strings (no null termination) */
> > +		if (!pp->value || strnlen(pp->value, pp->length) == pp->length)
> > +			continue;
> > +
> >  		np = of_find_node_by_path(pp->value);
> >  		if (!np)
> >  			continue;
> > 
> 
> Yes, it probably gets past this problem but oopses in a different place:
> 
> [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
> [    0.000000] PROMLIB: Root node compatible: 
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.3.0-rc3-00188-g3ec1e88-dirty (mroos@korvits) (gcc version 4.6.2 (Debian 42
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] bootconsole [earlyprom0] enabled
> [    0.000000] ARCH: SUN4U
> [    0.000000] Ethernet address: 08:00:20:b6:ee:e2
> [    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
> [    0.000000] Remapping the kernel... done.
> [    0.000000] Unable to handle kernel NULL pointer dereference
> [    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
> [    0.000000] tsk->{mm,active_mm}->pgd = fffff800008c77d0
> [    0.000000]               \|/ ____ \|/
> [    0.000000]               "@'/ .. \`@"
> [    0.000000]               /_| \__/ |_\
> [    0.000000]                  \__U_/
> [    0.000000] swapper(0): Oops [#1]
> [    0.000000] TSTATE: 0000000080e01606 TPC: 0000000000645810 TNPC: 0000000000645814 Y: 00000037    Not d
> [    0.000000] TPC: <of_find_node_by_phandle+0x30/0x60>

Ugh; that looks bad.  If it failed there, then the global device node list
is corrupted.  I hate to ask you this, but would you be able to git bisect to
narrow down the commit that causes the problem?

g.
