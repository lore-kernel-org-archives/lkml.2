Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2DSTQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:16:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49440 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2DSTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:16:16 -0400
Date: Thu, 19 Apr 2012 15:11:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Steven Noonan <steven@uplinklabs.net>,
        Ben Guthro <ben@guthro.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org
Subject: Re: [PATCH 1/2] xen: implement apic ipi interface
Message-ID: <20120419191101.GA22339@phenom.dumpdata.com>
References: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
 <1334470172-3861-2-git-send-email-mlin@ss.pku.edu.cn>
 <20120419190217.GA29124@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419190217.GA29124@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F906475.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:02:17PM -0400, Konrad Rzeszutek Wilk wrote:
> On Sun, Apr 15, 2012 at 02:09:31PM +0800, Lin Ming wrote:
> > From: Ben Guthro <ben@guthro.net>
> > 
> > Map native ipi vector to xen vector.
> > Implement apic ipi interface with xen_send_IPI_one.
> 
> I keep on getting this (so PV guest without any SMP support,
> and with just PV frontend drivers):
> 
> 
> echo "CONFIG_PARAVIRT_GUEST=y" > linux.config
> echo "CONFIG_XEN=y" >> linux.config
> echo "CONFIG_XEN_XENBUS_FRONTEND=m" >> linux.config
> cat xen.config | grep FRONTEND >> linux.config
> echo "# CONFIG_XEN_PRIVILEGED_GUEST is not set" >> linux.config
> echo "# CONFIG_XEN_DOM0 is not set" >> linux.config
> echo "# CONFIG_ACPI is not set" >> linux.config
> echo "# CONFIG_PCI is not set" >> linux.config
> echo "# CONFIG_XENFS is not set" >> linux.config
> echo "# CONFIG_SMP is not set" >> linux.config
> 
> 
> make -j$((4 * 2)) -C /home/konrad/ssd/konrad/xtt-compile/linux O=/home/konrad/ssd/konrad/xtt-compile/linux-build- defconfig
> make[2]: Entering directory `/home/konrad/ssd/konrad/linux'
>   GEN     /home/konrad/ssd/konrad/xtt-compile/linux-build-/Makefile
> *** Default configuration is based on 'x86_64_defconfig'
> #
> # configuration written to .config
> 
> cat linux.config >> linux-build-/.config
> 
> make -j4 ..
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/built-in.o: In function `xen_start_kernel':
> (.init.text+0x5a8): undefined reference to `xen_send_IPI_allbutself'
> arch/x86/built-in.o: In function `xen_start_kernel':
> (.init.text+0x5b3): undefined reference to `xen_send_IPI_mask_allbutself'
> arch/x86/built-in.o: In function `xen_start_kernel':
> (.init.text+0x5be): undefined reference to `xen_send_IPI_mask'
> arch/x86/built-in.o: In function `xen_start_kernel':
> (.init.text+0x5c9): undefined reference to `xen_send_IPI_all'
> arch/x86/built-in.o: In function `xen_start_kernel':
> (.init.text+0x5d4): undefined reference to `xen_send_IPI_self'
> make[2]: *** [.tmp_vmlinux1] Error 1

And this fixes it [feel free to squash it in the patch]


commit dc4e2feaef1d22f8c4a257755af52a0b24e55a54
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Apr 19 15:09:08 2012 -0400

    xen/smp: Fix compile issues if no CONFIG_SMP
    
    Fixes:
    arch/x86/built-in.o: In function `xen_start_kernel':
    (.init.text+0x5a8): undefined reference to `xen_send_IPI_allbutself'
    arch/x86/built-in.o: In function `xen_start_kernel':
    (.init.text+0x5b3): undefined reference to `xen_send_IPI_mask_allbutself'
    arch/x86/built-in.o: In function `xen_start_kernel':
    (.init.text+0x5be): undefined reference to `xen_send_IPI_mask'
    arch/x86/built-in.o: In function `xen_start_kernel':
    (.init.text+0x5c9): undefined reference to `xen_send_IPI_all'
    arch/x86/built-in.o: In function `xen_start_kernel':
    (.init.text+0x5d4): undefined reference to `xen_send_IPI_self'
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 20b3b23..9cf8f35 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -868,12 +868,13 @@ static void set_xen_basic_apic_ops(void)
 	apic->icr_write = xen_apic_icr_write;
 	apic->wait_icr_idle = xen_apic_wait_icr_idle;
 	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
-
+#ifdef CONFIG_SMP
 	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
 	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
 	apic->send_IPI_mask = xen_send_IPI_mask;
 	apic->send_IPI_all = xen_send_IPI_all;
 	apic->send_IPI_self = xen_send_IPI_self;
+#endif
 }
 
 #endif
