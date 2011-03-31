Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab1CaSIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:08:07 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:53064 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab1CaSID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:08:03 -0400
Date: Thu, 31 Mar 2011 14:07:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
In-reply-to: <20110331081800.GH5938@elte.hu>
Message-id: <alpine.LFD.2.02.1103311336320.9662@x980>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
 <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
 <20110331061247.GA24786@elte.hu> <alpine.LFD.2.02.1103310252160.8569@x980>
 <20110331081800.GH5938@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > hlt_works_ok was X86_32 only, initialized to 1, and never cleared.
> > > > 
> > > > On 32-bit kernels, this deletes a line from /proc/cpuinfo: "hlt_bug : no"
> > > 
> > > I think you missed the valid usecase where an old CPU with broken halt is 
> > > booted with the no-hlt boot parameter and does not want to crash in the HLT 
> > > instruction.
> > > 
> > > That "no-hlt" boot parameter does:
> > > 
> > >   arch/x86/kernel/cpu/bugs.c:     boot_cpu_data.hlt_works_ok = 0;
> > > 
> > > We can restrict compatibility, but *please* lets do it *explicitly*, not under 
> > > some 'remove unused code' pretense ...
> > > 
> > > Could you please list all CPU models that are affected?
> > 
> > "no-hlt" existed only for 32-bit, and there were exactly zero
> > automatic invocations of it.
> 
> Do we know whether a distro adds this to the boot line? Do we know about users 
> relying on it.

Impossible to know.

> > "idle=poll" does the same thing -- sans change a line
> > in /proc/cpuinfo.
> 
> It also has an effect on halt/poweroff, right?

Yes, if somebody invokes kernel_halt(), then it
uses stop_this_cpu(), which uses HLT unless this flag is cleared.

The functional change of deleting "no-hlt", which was the only
way to clear this flag, was in the previous patch, and so
I should have mentioned it here.

stop_this_cpu() is not in the poweroff path.

It is a different topic, but I'd be curious to know why
any users of the latest kernel on x86 might be invoking
kernel_halt() instead of kernel_power_off().

> > Do we really need both?
> 
> Probably not, as i said i do not disagree - i just think it should be more 
> explicit. Make it a: "users of CPU models X beware" commit title, not 'remove 
> inactive code' ...

My intent was to make the functional change in 1/9
and the NOP cleanup in 2/9.

> So please list the affected hardware and list the affected boot parameter 
> explicitly, in a well-titled commit that phases out this (very likely unused) 
> compatibility hack and *document* the idle=poll workaround for ancient 
> hardware.

There is no known list of affected hardware.

> There's still i386DX CPUs being manufactured these days - a 20+ years old CPU 
> design is surprisingly resilient to spurious patent claims, for obvious 
> reasons.
> 
> Really, there's no need to do things by stealth. There's few things worse than 
> doing the right thing for the wrong reason - it becomes a bad habit of subtly 
> broken thinking quickly.

I agree completely, which is why I've sent this patch -- twice, so far --
to 5000 of my closest friends, including you:-)

thanks,
-Len
