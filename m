Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0JTT57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:57:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:41948 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab0JTT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:57:58 -0400
Date: Wed, 20 Oct 2010 21:57:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>, Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020215732.12c1a3ac@endymion.delvare>
In-Reply-To: <20101020183544.GA22966@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	<20101020094208.3136b9dd@endymion.delvare>
	<1287590363.1813.148.camel@Joe-Laptop>
	<20101020164929.GB22572@ericsson.com>
	<1287593660.1813.198.camel@Joe-Laptop>
	<20101020171806.GD22572@ericsson.com>
	<1287595700.1813.202.camel@Joe-Laptop>
	<20101020174846.GA22819@ericsson.com>
	<1287597762.1813.217.camel@Joe-Laptop>
	<20101020183544.GA22966@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 11:35:44 -0700, Guenter Roeck wrote:
> On Wed, Oct 20, 2010 at 02:02:42PM -0400, Joe Perches wrote:
> > On Wed, 2010-10-20 at 10:48 -0700, Guenter Roeck wrote:
> > > The modified define in kernel.org would only apply if pr_fmt isn't already defined,
> > > so that argument is not really correct. The real difference would be that you could
> > > then remove the individual pr_fmt defines from 211 files, and all users of pr_fmt
> > > without module name (ie those hard to read) would be easier to read/identify.
> > 
> > I think that's not a good idea for now,
> > though I agree with the general concept.
> > 
> > This is in kernel.h now.
> > 
> > #ifndef pr_fmt
> > #define pr_fmt(fmt) fmt
> > #endif
> > 
> > A lot of the pr_<level> calls already include
> > some internal prefix.
> > 
> > Try:
> > $ grep -rP --include=*.[ch] -oh "\bpr_\w+\s*\(\s*\"\w+:" * | \
> > 	cut -f2- -d"(" | sort | uniq -c | sort -rn
> > 
> > You're suggesting modifying 100+ files to get the
> > same output used now.
> > 
> Yes, plus another 200+ files to remove the then-unnecessary existing pr_fmt defines.

We're set to change a lot of files anyway, so we might as well do the
right thing now and be done with it.

> > I think doing something like this after some more
> > generally accepted agreement is reached on how best
> > to do it would be better.
> > 
> Sounds like the ~400 definitions of TRUE and FALSE in the code base I am working with here.
> 
> My take is that the time to reach such an agreement is now, to avoid cluttering more code
> with pr_fmt defines. The longer we wait, the more difficult it will get to reach an agreement,
> since more and more subsystems will be affected.
> 
> Personally, I think the pr_fmt cleanup should be more important than replacing printk
> with pr_<level>. But I'll defer to Jean's judgement on this one, and follow his lead.

I totally agree with you, Guenter. My initial reaction (which I did
post!) was exactly the same as yours. Adding a define for pr_fmt to all
drivers in the kernel tree is simply insane. If the default definition
of pr_fmt is not good enough, let's just make it better. Now. The whole
point of pr_*() and dev_*() message printing functions is to have
standard message formats common to all drivers across the tree. Not
providing a sane default value for pr_fmt goes against this goal.

As far as I can see, the only issue with defaulting to 'KBUILD_BASENAME
": " fmt' is that some drivers which include a hard-coded prefix in log
message will now have a redundant prefix. Should be easy enough to spot
and fix, right?

I would even go one step further and claim that making pr_fmt
configurable per driver is pointless. But this can be discussed
separately/later.

-- 
Jean Delvare
