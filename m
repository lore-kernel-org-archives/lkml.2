Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2BXPLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:11:45 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33603 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2BXPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:11:43 -0500
Date: Fri, 24 Feb 2012 10:08:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: ke.yu@intel.com, kevin.tian@intel.com, lenb@kernel.org,
        xen-devel@lists.xensource.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] processor passthru - upload _Cx and _Pxx data to
 hypervisor (v5).
Message-ID: <20120224150807.GA17879@phenom.dumpdata.com>
References: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
 <4F47733E020000780007497D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F47733E020000780007497D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F47A8A7.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:23:42AM +0000, Jan Beulich wrote:
> >>> On 23.02.12 at 23:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > This module (processor-passthru)  collects the information that the cpufreq
> > drivers and the ACPI processor code save in the 'struct acpi_processor' and
> > then uploads it to the hypervisor.
> 
> Thus looks conceptually wrong to me - there shouldn't be a need for a
> CPUFreq driver to be loaded in Dom0 (or your module should masquerade
> as the one and only suitable one).

I piggyback on the generic cpufreq drivers to collect the information they
have evaluated.

I can make the driver a cpufreq one but there does not seem to be a way
from the kernel to force a specific driver to say "use me". I could write
it naturally, but not sure what the usage case is except for the driver
I wrote. But perhaps there is also for the cpufreq powernow-k8 and acpi-processor
so that they can function without the need for strict compile order
(where powernow-k8 MUST be loaded before acpi-processor).

> 
> > On the hypervisor side, it requires this patch on AMD:
> > # HG changeset patch
> > # Parent aea8cfac8cf1afe397f2e1d422a852008d8a83fe
> > traps: AMD PM RDMSRs (MSR_K8_PSTATE_CTRL, etc)
> > 
> > The restriction to read and write the AMD power management MSRs is gated if 
> > the
> > domain 0 is the PM domain (so FREQCTL_dom0_kernel is set). But we can
> > relax this restriction and allow the privileged domain to read the MSRs
> > (but not write). This allows the priviliged domain to harvest the power
> > management information (ACPI _PSS states) and send it to the hypervisor.
> 
> Why would accessing these MSRs be necessary here, when it isn't
> for non-pvops? Perhaps only because you want a CPUFreq driver
> loaded?

Correct. The powernow-k8
> 
> Jan
> 
> > This patch works fine with older classic dom0 (2.6.32) and with
> > AMD K7 and K8 boxes.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > diff -r aea8cfac8cf1 xen/arch/x86/traps.c
> > --- a/xen/arch/x86/traps.c	Thu Feb 23 13:23:02 2012 -0500
> > +++ b/xen/arch/x86/traps.c	Thu Feb 23 13:29:00 2012 -0500
> > @@ -2484,7 +2484,7 @@ static int emulate_privileged_op(struct 
> >          case MSR_K8_PSTATE7:
> >              if ( boot_cpu_data.x86_vendor != X86_VENDOR_AMD )
> >                  goto fail;
> > -            if ( !is_cpufreq_controller(v->domain) )
> > +            if ( !is_cpufreq_controller(v->domain) && !IS_PRIV(v->domain) )
> >              {
> >                  regs->eax = regs->edx = 0;
> >                  break;
> 
> 
