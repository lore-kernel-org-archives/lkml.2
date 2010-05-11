Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab0EKDMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:12:16 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58515 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0EKDMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:12:13 -0400
Date: Tue, 11 May 2010 12:11:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
       Ambresh <a0393775@ti.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [PATCHv4 1/4] procfs: Introduce socinfo under /proc
Message-ID: <20100511031126.GA20453@linux-sh.org>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com> <20100510111259.GA14680@linux-sh.org> <20100510142248.GD11804@besouro.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510142248.GD11804@besouro.research.nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 05:22:48PM +0300, Eduardo Valentin wrote:
> On Mon, May 10, 2010 at 01:13:00PM +0200, ext Paul Mundt wrote:
> > You'll still need the show function, but all of the rest of this is just
> > duplicating what single_open() already does. If the socinfo string is
> > static you may also want to rework this a bit so you can just stash the
> > string in the proc_dir_entry private data. Combine this with something
> > like kstrdup() and you'll save yourself a bit of stack while you're at
> > it.
> 
> While still here, about cleaning this, so, let me see if I got your point.
> Basically, the file under fs/proc/socinfo.c whould do the thing with single_open &
> single_release, as you stated. But then there is the .show and its data.
> One idea would then be to have a function:
> 
> int register_socinfo_show(int (*show)(struct seq_file *, void *), void *data);
> 
> Which would be exported to other parts of the kernel (something placed under
> include/linux/socinfo.h for instance). Then the soc core code
> (like arch/arm/mach-omap[1,2]) would then register its local show function and pass its data.
> 
> This way I think we can avoid the exports inside .c files (as in this patch)
> and also pass the static char * needed during the show.
> 
> What do you think?
> 
Yes, you'll need something like that. kstrdup() also does an allocation,
but you're only going to be registering once and are unlikely to ever
unregister (particular since you have this configured as a bool) so that
doesn't really matter. On the other hand if the string itself is static
you can just pass that in with a static initializer, or have some sort of
opaque socinfo data structure that contains the strings you care about.
You'll always be able to get back at the pointer through the
proc_dir_entry private data.
