Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2DWPMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:12:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32631 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2DWPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:12:38 -0400
Date: Mon, 23 Apr 2012 11:06:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, tony.luck@intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423150657.GA24481@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <20120423021827.GA13840@phenom.dumpdata.com>
 <20120423060921.GA29378@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423060921.GA29378@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This driver is not that much different from the APEI bridge to MCE code -
> > it just that instead of reading APEI blob data it reads it from an hypercall.
> 
> Let me ask you this: is APEI a virtualization solution of some sort?
> 
> No, it is the old windoze RAS crap but I guess Linux has to support it
> now too through BIOS. And x86 vendors will have to support it too.
> 
> So it is piece of the firmware we'd have to deal with too.
> 
> Now xen is a whole another deal - it is purely a piece of software.

Perfect. Software is more elastic than hardware - so the Xen ABI
for the MCE can be changed then to reflect the new format if required.
> 
> > The fix seems quite easy - you change the 'struct mce' and 'mce_log()'
> > along with the drivers that use it.
> 
> This is exactly what I have a problem with: having to take care of xen
> too. "No, Boris, nope, we cannot take your new feature because it breaks
> xen." and also "Have you tested this on xen too?" where the only thing I
> do is _hardware_ enablement and improving software support for it. And
> xen is not hardware...

Delegate testing to sub-maintainers. In this case that would be me
and Liu.

> 
> [..]
> 
> > If you are worried about breaking something, then you can just send
> > the change to me or Liu to test it out before committing API changes
> > in the MCE code.
> 
> This probably sounds good now but I don't think code changes like
> that ever run as smoothly. Whenever there's breakage, there'll always
> be people screaming against it - I just don't want code that enables

Right, regressions are bad.

> hardware to be crippled and unable to change because it breaks
> completely unrelated pieces - it is bad as it is now.

Can you point me to the existing examples of MCE's badness?

I remember the Greg KK's patches to the dynamic vs static and per-cpu
initialization - but that wasn't due to the MCE API. I think that
was due to Key Sievens transition from SysFS subsystem API to device API
patches that broke bunch of stuff.

> 
> > > And this has happened already with the whole microcode loading debacle.
> > 
> > My recollection is that the existing microcode API had major issues that
> > could not fixed. The only fix was to make it be very early in the bootup
> > processes and that is what hpa would like developers to focus on.
> 
> That was one side of the problem. The other was, AFAICR, creating a xen
> microcode driver which was "on the same level" as the hardware microcode
> drivers, which was completely bull*.

I think of Xen as the hypervisors on PowerPC boxes - for certain operations
you have to use hypercalls to do some hardware operations.

> 
> The problem is xen growing stuff everywhere in arch/x86/ and this way,
> maybe even unwillingly, crippling development of hardware-related
> features. I know you're willing to help and I know you mean it well, but
> there's always some other problem in practice.

I am not sure I see why we cannot fix the practical problems as they pop
up?

> 
> Now I keep wondering, why don't you guys simply create your own mcelog
> ring buffer and interface on the userspace tool side instead of hooking
> into lowlevel kernel stuff? I mean, the code is there, you simply have
> to copy it into arch/xen/ or whatever you have there. Why do you have to

Nowadays the kernel can transition to run under lguest, KVM, Xen or
baremetal as a single binary image instead of multiple compiled
kernels for a specific virtualization framework. As such, there is
no 'arch/xen,lguest,kvm', instead there is alternative_asm that patches
the low-level calls (set_pte, load_cr3, spinlock, time, etc), for the
appropiate virtualization (or CPU if done under baremetal) offering. Hence
the arch/x86 has expanded to support baremtal and virtualization
extensions in it (called paravirt_ops).

> hook into arch/x86/ instead of doing your own stuff?

I think what you are suggesting is to _not_ reuse existing APIs. That
seems counter-intuive to general software development. There are
exceptions of course - when the existing API needs to change a lot
(or needs to be thrown out), and there is this one little driver that
keeps on using the old interface and can't change - at that point I can
see the purpose of forking it. But until then - using existing APIs is
the way to go.

And I (along with Liu) will keep the Xen MCE driver evolving as it
needs to conform to the new kernel mcheck API.

> 
> > > So, my suggestion is to copy the pieces you need and create your own xen
> > > version of /dev/mcelog and add it to dom0 so that there's no hooking
> > > into baremetal code and whenever a dom0 kernel is running, you can
> > > reroute the mcelog userspace tool to read /dev/xen_mcelog or whatever
> > > and not hook into the x86 versions.
> > > 
> > > Because, if you'd hooked into it, just imagine one fine day, when we
> > > remove mcelog support, what screaming the xen people will be doing when
> > > mcelog doesn't work anymore.
> > 
> > You would have more screaming from the distro camp about removing
> > /dev/mcelog.
> 
> How do you know that? Don't you think that we probably would've talked
> to them already and made preparations for conversion first?

I was Googling around for it and I couldn't find anything that says
MCE is removed (which could be very well the fault of my poor
Googling-skills) and its replacement user-space program. Please do
point me to the URL so I can get some idea of what is brewing.

The one thing I saw was this https://lkml.org/lkml/2012/3/2/312 which
pointed to the /dev/mcelog struct changing (which then got NACK-ed), but
nothing about the internal 'struct mce' being dropped from drivers?

I couldn't find anything in the Documentation/feature-removal-schedule.txt 

There are hints of ras_printk and  /sys/devices/system/ras/agent but
they are related to printk (and I see that mce_log would use it too), but
that just seems to [from a driver perspective] to be the output code-paths
[like the MCE decoders] - and it allows to output to be put in a trace
buffer as well - instead of just in /dev/mcelog.

If the distros choose to stop using /dev/mcelog and use another mechanism
(and the MCE check drivers still do their job of collecting the data and
sending it downstream), then I don't see why "screaming the xen people will
be doing" - as they still get the MCE errors - in whatever way the distros
has choosen to present it.

> 
> > But if that is your choice, I would send you an email asking how I
> > need to retool this driver to work with the new MCE gen2 code that you
> > had in mind.
> 
> As I said above, I'm very sceptical this will ever work, I guess I'd
> have to live and see.
> 
> Now, with your own buffer solution, nothing breaks and all is happy,
> a win-win, if you wish. I think this is much simpler and easier a
> solution.

Not sure what you mean by 'own buffer solution'. Are you talking about
using the trace_mce_record or the ras_printk instead of the mce_log?
I would think that is the job of the MCE decoders?

Please keep in mind that this driver is not trying to decode anything -
it just lifting raw events, massaging them a bit, and sending them
downstream. Similar to how the APEI does it.
