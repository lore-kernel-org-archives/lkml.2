Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2C1Oe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:34:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32292 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2C1Oez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:34:55 -0400
Date: Wed, 28 Mar 2012 10:29:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
Message-ID: <20120328142928.GE18161@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <20120324003111.GA11777@andromeda.dapyr.net>
 <DE8DF0795D48FD4CA783C40EC8292335105AAF@SHSMSX101.ccr.corp.intel.com>
 <20120326163558.GC10236@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233510CE6F@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233510CE6F@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F732158.0088,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 10:48:53AM +0000, Liu, Jinsong wrote:
> >>> 
> >>> Liu,
> >>> 
> >>> With this patch: "  xen/enlighten: Expose MWAIT and MWAIT_LEAF if
> >>> hypervisor OKs it." which is now in 3.4-rc0:
> >>> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395)
> >>> it means that now that the drivers/acpi/acpi_pad.c can run
> >>> as is under Xen (as the MWAIT_LEAF is exposed) What is the impact
> >>> of that? Is the monitor call causing a trap to the hypervisor which
> >>> will ignore the call? Or will it have some more worrysome
> >>> consequences? 
> >>> 
> >> 
> >> IMO this patch doesn't affect acpi_pad logic (both native and xen
> >> acpi_pad). 
> > 
> > You are sure? The acpi_pad logic will now be activated so the native
> > driver 
> > will run under Xen. My question is - what is the impact of that?
> 
> I know what you mean now. What I mean is, w/ xen_acpi_pad patches, native acpi_pad only work under baremetal and xen_acpi_pad work under Xen (so no problem exposing mwait). What you mean is, w/o xen_acpi_pad patches, native acpi_pad will be actived under Xen and then risk occur ... I agree.

Can you test that? And see what happens please? I don't have the hardware
with _PUD.

> 
> But just curious, what's the purpose and benefit of exposing mwait to dom0? I remember xen against doing so before.

To expose deeper C-states to cstate.c so that xen-acpi-processor can then upload
said states to the hypervisor.

> 
> > 
> > My assumption is that the __monitor call will trap and we end up in
> > the hypervisor - so that is not so bad, but not sure.
> 
> Have you added code to hypervisor side (do_invalid_op)? if not, I think it would be problem (break dom0). Dom0 __monitor would trigger UD, then not handled by hypervisor, and bounce back to dom0 kernel, and kill itself.

No, that is why I am asking you.
> 
> But the point is, if exposing mwait, it would be risk for all logic which executed __monitor. So need add native_monitor/ xen_monitor.

Argh.
> 
> > 
> > But what I wonder is if what is the impact of the _OST call by the
> > native driver? 
> > 
> > Say the firmware tells us - please offline 4 CPUS (we have eight). We
> > enter 'acpi_pad_handle_notify' -  create four threads, and each
> > thread calls __monitor (which ends up in the hypervisor - and the
> > hypervisor might not persue the __monitor call).
> > 
> > During this time, the Linux kernel calls the _OST with 4 CPUs and ..
> > 
> > what then? What happens if the _OST values are actually ignored (as
> > it seems 
> > it would be in this case?) Is that OK? Or is that going to lead to the
> > firmware turning off some of the cores anyhow?
> 
> Hmm, if __monitor was tolerated silently as you assume, it would bring problem for _OST.

What kind of problems?
> 
> Thanks,
> Jinsong
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
