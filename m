Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2CLQjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:39:39 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53305 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2CLQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:39:37 -0400
Date: Mon, 12 Mar 2012 17:39:11 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Mark A. Grondona" <mgrondona@llnl.gov>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120312163911.GC7255@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120308215716.GA5925@aftab>
 <4F59DC38.5080104@redhat.com>
 <20120309143806.GA11962@aftab>
 <4F5A329A.70702@redhat.com>
 <20120309184733.GB13745@aftab>
 <4F5A5E2D.4090408@redhat.com>
 <20120311113411.GB29175@aftab>
 <4F5C9B6C.2080904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5C9B6C.2080904@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 09:32:44AM -0300, Mauro Carvalho Chehab wrote:
> Well, this change can be done, but still we need to decide how to export it ;)
> 
> The new edac_mc_handle_error() with replaces all the legacy edac_mc_handle* calls
> does what the other calls used to do. I didn't change its behavior. Anyway, what
> it does for UE errors is:
> 
> 	...
> 	/* Some logic to get the memory DIMM labels */
>         trace_mc_error(type, mci->mc_idx, msg, label, location,
>                        detail, other_detail);
> 	
> 	if (type == HW_EVENT_ERR_CORRECTED) {
> 		...
>         } else {
> 		...
>                 if (edac_mc_get_log_ue())
>                         edac_mc_printk(mci, KERN_WARNING,
>                                 "UE %s on %s (%s%s %s)\n",
>                                 msg, label, location, detail, other_detail);
> 
>                 if (edac_mc_get_panic_on_ue())
>                         panic("UE %s on %s (%s%s %s)\n",
>                               msg, label, location, detail, other_detail);
> 
>                 edac_increment_ue_error(mci, enable_filter, pos);
>         }
> 
> So, it basically:
> 	1) prints the memory location and the DIMM label(s) of the memory(ies)
> 	   from where the error originates;
> 	2) if edac_mc_panic_on_ue is set, it will panic;
> 	3) otherwise, it will increment the UE error counters.
> 
> It shouldn't be hard to add a patch to disable the sysfs error UE counters if 
> edac_mc_panic_on_ue is enabled.

Err, the fact that you have UE counters doesn't have anything to do with
the request that you want to panic on an UE. Especially if conservative
systems would panic on the first UE anyway without asking software.

So what I meant was to make it optional in the core edac code whether
you want to install a UE counter in the ranks or not. So that, for
example, if amd64_edac doesn't want to have UE counters, it simply
says so and the core generates only CE counters per rank. Or, with
positive logic, an edac driver explicitly requests what counters it
wants installed.

> Anyway, an UE error with a 128 bits cacheline points to a location that has
> two DIMMs (or 4 DIMMs, on memory controllers with mirror mode enabled). So,
> incrementing a DIMM error counter doesn't seem to be the right thing to do.
> 
> Well, it may increment two DIMM error counters (or 4 DIMM error counters), but
> it would change the current behavior.
> 
> It should also be noticed that the MCA-based Intel memory controllers have the 
> (likely limited) capability of recovering from an UE error. So, an UE error 
> may not mean a fatal error. So, the UE error counter value can actually be
> bigger than 1.

Yes, that's why make it optional - if the hardware can support it,
it can have it. If it doesn't make sense, then no need for it - that
simple.

> 
> > 
> > [..]
> > 
> >> One alternative would simply to remove all those intermediate
> >> counters, letting userspace to count the errors via perf (provided
> >> that we have a proper location field).
> > 
> > Yes, that would be where we want to go eventually because I too don't
> > see any reason for those counters. Besides, they don't decay over time,
> > for example, say you have a DIMM which experiences a temporary failure
> > and generates k CEs. Then, the source of that error disappears and the
> > DIMM works fine for months.
> 
> Userspace applications may reset the error counters. There is a sysfs node
> for it.

No, I'm not talking about resetting but decaying. I.e., each
error counted has a certain validity and gets discarded
after a while - similar to the leaky bucket algorithm:
http://en.wikipedia.org/wiki/Leaky_bucket

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
