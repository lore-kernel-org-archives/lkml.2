Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab2DWGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:09:28 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36574 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2DWGJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:09:26 -0400
Date: Mon, 23 Apr 2012 08:09:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Borislav Petkov <bp@amd64.org>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        tony.luck@intel.com, x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423060921.GA29378@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <20120423021827.GA13840@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423021827.GA13840@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 10:18:27PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > This patch gets error information from xen hypervisor and convert
> > > > xen format error into linux format mcelog. This logic is basically
> > > > self-contained, not much touching other kernel components.
> > 
> > I have a problem with that statement above. This thing uses struct mce
> > and mce_log(), which are internal to x86, and whenever we want to change
> > anything there, we won't be able to because xen uses it too.
> 
> Huh? You mean this:
> 
>        m.misc = mc_bank->mc_misc;
>        m.status = mc_bank->mc_status;
>        m.addr = mc_bank->mc_addr;
>        m.tsc = mc_bank->mc_tsc;
>        m.bank = mc_bank->mc_bank;
>        m.finished = 1;
>        /*log this record*/
>        mce_log(&m);
> 
> ?
> 
> This driver is not that much different from the APEI bridge to MCE code -
> it just that instead of reading APEI blob data it reads it from an hypercall.

Let me ask you this: is APEI a virtualization solution of some sort?

No, it is the old windoze RAS crap but I guess Linux has to support it
now too through BIOS. And x86 vendors will have to support it too.

So it is piece of the firmware we'd have to deal with too.

Now xen is a whole another deal - it is purely a piece of software.

> The fix seems quite easy - you change the 'struct mce' and 'mce_log()'
> along with the drivers that use it.

This is exactly what I have a problem with: having to take care of xen
too. "No, Boris, nope, we cannot take your new feature because it breaks
xen." and also "Have you tested this on xen too?" where the only thing I
do is _hardware_ enablement and improving software support for it. And
xen is not hardware...

[..]

> If you are worried about breaking something, then you can just send
> the change to me or Liu to test it out before committing API changes
> in the MCE code.

This probably sounds good now but I don't think code changes like
that ever run as smoothly. Whenever there's breakage, there'll always
be people screaming against it - I just don't want code that enables
hardware to be crippled and unable to change because it breaks
completely unrelated pieces - it is bad as it is now.

> > And this has happened already with the whole microcode loading debacle.
> 
> My recollection is that the existing microcode API had major issues that
> could not fixed. The only fix was to make it be very early in the bootup
> processes and that is what hpa would like developers to focus on.

That was one side of the problem. The other was, AFAICR, creating a xen
microcode driver which was "on the same level" as the hardware microcode
drivers, which was completely bull*.

The problem is xen growing stuff everywhere in arch/x86/ and this way,
maybe even unwillingly, crippling development of hardware-related
features. I know you're willing to help and I know you mean it well, but
there's always some other problem in practice.

Now I keep wondering, why don't you guys simply create your own mcelog
ring buffer and interface on the userspace tool side instead of hooking
into lowlevel kernel stuff? I mean, the code is there, you simply have
to copy it into arch/xen/ or whatever you have there. Why do you have to
hook into arch/x86/ instead of doing your own stuff?

> > So, my suggestion is to copy the pieces you need and create your own xen
> > version of /dev/mcelog and add it to dom0 so that there's no hooking
> > into baremetal code and whenever a dom0 kernel is running, you can
> > reroute the mcelog userspace tool to read /dev/xen_mcelog or whatever
> > and not hook into the x86 versions.
> > 
> > Because, if you'd hooked into it, just imagine one fine day, when we
> > remove mcelog support, what screaming the xen people will be doing when
> > mcelog doesn't work anymore.
> 
> You would have more screaming from the distro camp about removing
> /dev/mcelog.

How do you know that? Don't you think that we probably would've talked
to them already and made preparations for conversion first?

> But if that is your choice, I would send you an email asking how I
> need to retool this driver to work with the new MCE gen2 code that you
> had in mind.

As I said above, I'm very sceptical this will ever work, I guess I'd
have to live and see.

Now, with your own buffer solution, nothing breaks and all is happy,
a win-win, if you wish. I think this is much simpler and easier a
solution.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
