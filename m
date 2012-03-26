Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2C0Oo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:44:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47221 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab2C0OoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:44:23 -0400
Date: Mon, 26 Mar 2012 12:35:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
Message-ID: <20120326163558.GC10236@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <20120324003111.GA11777@andromeda.dapyr.net>
 <DE8DF0795D48FD4CA783C40EC8292335105AAF@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335105AAF@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F71D20E.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 02:50:50AM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Fri, Feb 17, 2012 at 08:56:43AM +0000, Liu, Jinsong wrote:
> >>> From f66a2df1392bbe69426387657a220177be50d58a Mon Sep 17 00:00:00
> >>> 2001 
> >> From: Liu, Jinsong <jinsong.liu@intel.com>
> >> Date: Fri, 10 Feb 2012 20:32:50 +0800
> >> Subject: [PATCH 1/3] PAD helper for native and paravirt platform
> >> 
> >> This patch is PAD (Processor Aggregator Device) helper.
> >> It provides a native interface for natvie platform, and a template
> >> for paravirt platform, so that os can implicitly hook to proper ops
> >> accordingly. The paravirt template will further redirect to Xen pv
> >>  ops in later patch for Xen core parking.
> > 
> > Liu,
> > 
> > With this patch: "  xen/enlighten: Expose MWAIT and MWAIT_LEAF if
> > hypervisor OKs it." which is now in 3.4-rc0:
> > (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395)
> > it means that now that the drivers/acpi/acpi_pad.c can run
> > as is under Xen (as the MWAIT_LEAF is exposed) What is the impact
> > of that? Is the monitor call causing a trap to the hypervisor which
> > will ignore the call? Or will it have some more worrysome
> > consequences? 
> > 
> 
> IMO this patch doesn't affect acpi_pad logic (both native and xen acpi_pad).

You are sure? The acpi_pad logic will now be activated so the native driver
will run under Xen. My question is - what is the impact of that?

My assumption is that the __monitor call will trap and we end up in the hypervisor -
so that is not so bad, but not sure.

But what I wonder is if what is the impact of the _OST call by the native driver?

Say the firmware tells us - please offline 4 CPUS (we have eight). We enter
'acpi_pad_handle_notify' -  create four threads, and each thread calls __monitor
(which ends up in the hypervisor - and the hypervisor might not persue the
__monitor call).

During this time, the Linux kernel calls the _OST with 4 CPUs and ..

what then? What happens if the _OST values are actually ignored (as it seems
it would be in this case?) Is that OK? Or is that going to lead to the
firmware turning off some of the cores anyhow?


> For native acpi_pad, it need mwait to enter deep Cx (but irrelative to this patch);

The patch I pointed you to will expose the MWAIT_LEAF in the initial domain.
Meaning that the native acpi_pad code will run.

> For xen acpi_pad, it doesn't depend on whether hypervisor expose mwait or not. It simply parse 'pur' obj and then hypercall to hypervisor to do rest core_parking things (BTW, hypervisor core parking patches have checkin in as c/s 25095/25096).

I get that, but for right now lets just focus on the native driver. I would like
to understand not only how it should function in baremetal but also in the native case.

> 
> Thanks,
> Jinsong--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
