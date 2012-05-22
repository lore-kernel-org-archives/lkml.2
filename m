Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2EVJXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:23:30 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:17526 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757192Ab2EVJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:23:28 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M4F3EW-02-9SK-02
X-M-MSG: 
Date: Tue, 22 May 2012 11:23:54 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Message-ID: <20120522092354.GB18578@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 05:45:04AM +0000, Liu, Jinsong wrote:
> From 4df7496eea9e92a3e267ffb0a4b8f5e6e0c29c36 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Mon, 21 May 2012 05:07:47 +0800
> Subject: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform
> 
> When MCA error occurs, it would be handled by Xen hypervisor first,
> and then the error information would be sent to initial domain for logging.
> 
> This patch gets error information from Xen hypervisor and convert
> Xen format error into Linux format mcelog. This logic is basically
> self-contained, not touching other kernel components.
> 
> By using tools like mcelog tool users could read specific error information,
> like what they did under native Linux.
> 
> To test follow directions outlined in Documentation/acpi/apei/einj.txt
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If you're sending the patch, you need to be the last on the SOB-chain
and the SOB-chain has to show the proper path the patch took. See
<Documentation/SubmittingPatches>.

> ---
>  arch/x86/include/asm/xen/hypercall.h |    8 +
>  arch/x86/kernel/cpu/mcheck/mce.c     |    4 +-
>  arch/x86/xen/enlighten.c             |    9 +-
>  drivers/xen/Kconfig                  |    8 +
>  drivers/xen/Makefile                 |    1 +
>  drivers/xen/mcelog.c                 |  395 ++++++++++++++++++++++++++++++++++
>  include/linux/miscdevice.h           |    1 +
>  include/xen/interface/xen-mca.h      |  389 +++++++++++++++++++++++++++++++++
>  8 files changed, 809 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/xen/mcelog.c
>  create mode 100644 include/xen/interface/xen-mca.h
> 
> diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
> index 5728852..59c226d 100644
> --- a/arch/x86/include/asm/xen/hypercall.h
> +++ b/arch/x86/include/asm/xen/hypercall.h
> @@ -48,6 +48,7 @@
>  #include <xen/interface/sched.h>
>  #include <xen/interface/physdev.h>
>  #include <xen/interface/platform.h>
> +#include <xen/interface/xen-mca.h>
>  
>  /*
>   * The hypercall asms have to meet several constraints:
> @@ -302,6 +303,13 @@ HYPERVISOR_set_timer_op(u64 timeout)
>  }
>  
>  static inline int
> +HYPERVISOR_mca(struct xen_mc *mc_op)
> +{
> +	mc_op->interface_version = XEN_MCA_INTERFACE_VERSION;
> +	return _hypercall1(int, mca, mc_op);
> +}
> +
> +static inline int
>  HYPERVISOR_dom0_op(struct xen_platform_op *platform_op)
>  {
>  	platform_op->interface_version = XENPF_INTERFACE_VERSION;
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d086a09..24b2e86 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -57,8 +57,6 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
>  
>  int mce_disabled __read_mostly;
>  
> -#define MISC_MCELOG_MINOR	227
> -
>  #define SPINUNIT 100	/* 100ns */
>  
>  atomic_t mce_entry;
> @@ -1791,7 +1789,7 @@ static const struct file_operations mce_chrdev_ops = {
>  	.llseek			= no_llseek,
>  };
>  
> -static struct miscdevice mce_chrdev_device = {
> +struct miscdevice mce_chrdev_device = {
>  	MISC_MCELOG_MINOR,
>  	"mcelog",
>  	&mce_chrdev_ops,

You're still reusing those - pls, define your own 'struct miscdevice
mce_chrdev_device' in drivers/xen/ or somewhere convenient and
your own mce_chrdev_ops. The only thing you should be touching in
arch/x86/.../mcheck/ is the export of MISC_MCELOG_MINOR.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

