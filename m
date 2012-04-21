Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2DUKpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:45:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33141 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DUKpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:45:06 -0400
Date: Sat, 21 Apr 2012 12:45:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120421104502.GB17005@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120421041454.GA29704@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ x86 people.

On Sat, Apr 21, 2012 at 12:14:54AM -0400, Konrad Rzeszutek Wilk wrote:
> Should this driver reside in arch/x86/kernel/cpu/mcheck?

The fact that you raise such a question is already loaded with problems,
see below.

> I can keep it in drivers/xen, but I realized that perhaps it
> should be in a different location?
> > 
> > When MCA error occurs, it would be handled by xen hypervisor first,
> > and then the error information would be sent to dom0 for logging.
> > 
> > This patch gets error information from xen hypervisor and convert
> > xen format error into linux format mcelog. This logic is basically
> > self-contained, not much touching other kernel components.

I have a problem with that statement above. This thing uses struct mce
and mce_log(), which are internal to x86, and whenever we want to change
anything there, we won't be able to because xen uses it too.

And this has happened already with the whole microcode loading debacle.

So, my suggestion is to copy the pieces you need and create your own xen
version of /dev/mcelog and add it to dom0 so that there's no hooking
into baremetal code and whenever a dom0 kernel is running, you can
reroute the mcelog userspace tool to read /dev/xen_mcelog or whatever
and not hook into the x86 versions.

Because, if you'd hooked into it, just imagine one fine day, when we
remove mcelog support, what screaming the xen people will be doing when
mcelog doesn't work anymore.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
