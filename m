Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030693Ab2ERLVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:21:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11197 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2ERLVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:21:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 May 2012 04:20:28 -0700
Date: Fri, 18 May 2012 14:21:04 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Mike Turquette <mturquette@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Clock register in early init
Message-ID: <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
References: <1337227884.2066.9.camel@pgaikwad-dt2>
 <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337316517.22560.19.camel@pgaikwad-dt2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 06:48:37AM +0200, Prashant Gaikwad wrote:
> Thanks for the reply Mike!!
> 
> On Thu, 2012-05-17 at 11:51 +0530, Mike Turquette wrote:
> > On 20120517-09:41, Prashant Gaikwad wrote:
> > > Hi Mike,
> > > 
> > > While porting Tegra to common clock framework I observed that if we try
> > > to allocate struct clk dynamically in early init, kernel panics since
> > > memory is not initialized yet.
> > > 
> > > In your clk-next for omap you are registering clocks in early init and
> > > clk_register allocates struct clk dynamically.
> > > 
> > > So, am I missing something here?
> > > 
> > 
> > You have the same problem as my platform (OMAP).  Please check out
> > include/linux/clk-private.h.  That is a really nasty terrible hack that
> > exists for statically initializing all data.  It exposes the definition
> > of struct clk (which is bad and violates the design philosophy that
> > struct clk should be an opaque cookie).
> > 
> > Please review Documentat/clk.txt to understand the rules around
> > clk-private.h.  Namely that you MUST separate your data from your clock
> > function definitions (the clk_ops should never know the definition of
> > struct clk).
> > 
> 
> Yes, currently I am also doing same for Tegra and it works well. clk_ops
> and clk initialization data are in separate files. clk_ops does not
> include clk-private.h so it does not know the definition of struct clk.
> 
> Will send patches for shortly.
> 
> > Finally, I really want to kill off clk-private.h.  Currently OMAP does
> > clock registration during early init and that is why this crap exists.
> > However we are going to move our clock initialization to be initcall
> > based at some point in the future.  No other platform (until now) was
> > using these macros in clk-private.h, so I had planned on removing them
> > after OMAP migrated.
> > 
> > What are the plans for Tegra?  I really don't want to have to support
> > this stuff.  Can you migrate your clock initialization to be initcall
> > based at some point in the future?
> > 
> 
> We had initcall based implementation in old kernel versions. It was
> moved to early init since some clocks were required for delay
> calibrations. It may be possible to migrate it be initcall based in
> future.

I don't think we can do it all dynamic. We need to have the clockfrequency
of the local timer at least, which depends on the PLLX frequency and
ultimately on HFOSC input frequency which is measured by the clock code at
boottime. I haven't figured out what else we need, but I wouldn't be surprised
to find some more gotchas. It might be possible to split the clocks into
'early init clocks' and normal clocks, but I would rather not go there.
Which advantages do you see in dynamically allocating all this?

Cheers,

Peter.
