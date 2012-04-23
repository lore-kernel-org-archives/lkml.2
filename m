Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2DWCYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:24:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38841 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DWCYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:24:03 -0400
Date: Sun, 22 Apr 2012 22:18:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, tony.luck@intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423021827.GA13840@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120421104502.GB17005@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This patch gets error information from xen hypervisor and convert
> > > xen format error into linux format mcelog. This logic is basically
> > > self-contained, not much touching other kernel components.
> 
> I have a problem with that statement above. This thing uses struct mce
> and mce_log(), which are internal to x86, and whenever we want to change
> anything there, we won't be able to because xen uses it too.

Huh? You mean this:

       m.misc = mc_bank->mc_misc;
       m.status = mc_bank->mc_status;
       m.addr = mc_bank->mc_addr;
       m.tsc = mc_bank->mc_tsc;
       m.bank = mc_bank->mc_bank;
       m.finished = 1;
       /*log this record*/
       mce_log(&m);

?

This driver is not that much different from the APEI bridge to MCE code -
it just that instead of reading APEI blob data it reads it from an hypercall.

Taking this a step forward, If you change the 'mce_log' or the 'struct mce'
won't you have a problem with the APEI one b/c it uses it too?

The fix seems quite easy - you change the 'struct mce' and 'mce_log()'
along with the drivers that use it.

If you are worried about breaking something, then you can just send
the change to me or Liu to test it out before committing API changes
in the MCE code.


> 
> And this has happened already with the whole microcode loading debacle.

My recollection is that the existing microcode API had major issues that
could not fixed. The only fix was to make it be very early in the bootup
processes and that is what hpa would like developers to focus on.

> 
> So, my suggestion is to copy the pieces you need and create your own xen
> version of /dev/mcelog and add it to dom0 so that there's no hooking
> into baremetal code and whenever a dom0 kernel is running, you can
> reroute the mcelog userspace tool to read /dev/xen_mcelog or whatever
> and not hook into the x86 versions.
> 
> Because, if you'd hooked into it, just imagine one fine day, when we
> remove mcelog support, what screaming the xen people will be doing when
> mcelog doesn't work anymore.

You would have more screaming from the distro camp about removing
/dev/mcelog. But if that is your choice, I would send you an email
asking how I need to retool this driver to work with the new MCE gen2
code that you had in mind.
