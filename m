Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2BXKYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:24:00 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:58526 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2BXKXt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:2>);
	Fri, 24 Feb 2012 05:23:49 -0500
Message-Id: <4F47733E020000780007497D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 10:23:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <ke.yu@intel.com>, <kevin.tian@intel.com>, <lenb@kernel.org>,
        <xen-devel@lists.xensource.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] processor passthru - upload _Cx and _Pxx data to
 hypervisor (v5).
References: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.02.12 at 23:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> This module (processor-passthru)  collects the information that the cpufreq
> drivers and the ACPI processor code save in the 'struct acpi_processor' and
> then uploads it to the hypervisor.

Thus looks conceptually wrong to me - there shouldn't be a need for a
CPUFreq driver to be loaded in Dom0 (or your module should masquerade
as the one and only suitable one).

> On the hypervisor side, it requires this patch on AMD:
> # HG changeset patch
> # Parent aea8cfac8cf1afe397f2e1d422a852008d8a83fe
> traps: AMD PM RDMSRs (MSR_K8_PSTATE_CTRL, etc)
> 
> The restriction to read and write the AMD power management MSRs is gated if 
> the
> domain 0 is the PM domain (so FREQCTL_dom0_kernel is set). But we can
> relax this restriction and allow the privileged domain to read the MSRs
> (but not write). This allows the priviliged domain to harvest the power
> management information (ACPI _PSS states) and send it to the hypervisor.

Why would accessing these MSRs be necessary here, when it isn't
for non-pvops? Perhaps only because you want a CPUFreq driver
loaded?

Jan

> This patch works fine with older classic dom0 (2.6.32) and with
> AMD K7 and K8 boxes.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> diff -r aea8cfac8cf1 xen/arch/x86/traps.c
> --- a/xen/arch/x86/traps.c	Thu Feb 23 13:23:02 2012 -0500
> +++ b/xen/arch/x86/traps.c	Thu Feb 23 13:29:00 2012 -0500
> @@ -2484,7 +2484,7 @@ static int emulate_privileged_op(struct 
>          case MSR_K8_PSTATE7:
>              if ( boot_cpu_data.x86_vendor != X86_VENDOR_AMD )
>                  goto fail;
> -            if ( !is_cpufreq_controller(v->domain) )
> +            if ( !is_cpufreq_controller(v->domain) && !IS_PRIV(v->domain) )
>              {
>                  regs->eax = regs->edx = 0;
>                  break;



