Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab2JOQFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:05:51 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:63234 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2JOQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:05:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,588,1344211200"; 
   d="scan'208";a="15176099"
Message-ID: <1350317146.18058.83.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: add quirk for Xen
 3.4 and shutdown watches.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Olaf Hering <olaf@aepfle.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Mon, 15 Oct 2012 17:05:46 +0100
In-Reply-To: <1349890849-17471-2-git-send-email-konrad.wilk@oracle.com>
References: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
	 <1349890849-17471-2-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 18:40 +0100, Konrad Rzeszutek Wilk wrote:
> The commit 254d1a3f02ebc10ccc6e4903394d8d3f484f715e, titled
> "xen/pv-on-hvm kexec: shutdown watches from old kernel" assumes that the
> XenBus backend can deal with reading of values from:
>  "control/platform-feature-xs_reset_watches":
> 
>     ... a patch for xenstored is required so that it
>     accepts the XS_RESET_WATCHES request from a client (see changeset
>     23839:42a45baf037d in xen-unstable.hg). Without the patch for xenstored
>     the registration of watches will fail and some features of a PVonHVM
>     guest are not available. The guest is still able to boot, but repeated
>     kexec boots will fail."
> 
> Sadly this is not true when using a Xen 3.4 hypervisor and booting a PVHVM
> guest. We end up hanging at:
> 
>   err = xenbus_scanf(XBT_NIL, "control",
>                         "platform-feature-xs_reset_watches", "%d", &supported);
> 
> This can easily be seen with guests hanging at xenbus_init:
> 
> NX (Execute Disable) protection: active
> SMBIOS 2.4 present.
> DMI: Xen HVM domU, BIOS 3.4.0 05/13/2011
> Hypervisor detected: Xen HVM
> Xen version 3.4.
> Xen Platform PCI: I/O protocol version 1
> ... snip ..
> calling  xenbus_init+0x0/0x27e @ 1
> 
> Reverting the commit or using the attached patch fixes the issue. This fix
> checks whether the hypervisor is older than 4.0 and if so does not try to
> perform the read.
> 
> Fixes-Oracle-Bug: 14708233
> CC: stable@vger.kernel.org
> CC: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xenbus/xenbus_xs.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index bce15cf..91f513b 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -47,6 +47,7 @@
>  #include <xen/xenbus.h>
>  #include <xen/xen.h>
>  #include "xenbus_comms.h"
> +#include <asm/xen/hypervisor.h>
>  
>  struct xs_stored_msg {
>  	struct list_head list;
> @@ -617,7 +618,18 @@ static struct xenbus_watch *find_watch(const char *token)
>  
>  	return NULL;
>  }
> +static bool xen_strict_xenbus_quirk()
> +{
> +	uint32_t eax, ebx, ecx, edx, base;
> +
> +	base = xen_cpuid_base();
> +	cpuid(base + 1, &eax, &ebx, &ecx, &edx);

This breaks on ARM because this is an x86 specific function. Can we
ifdef it or properly wrap it in an arch interface please.

> +
> +	if ((eax >> 16) < 4)
> +		return true;
> +	return false;
>  
> +}
>  static void xs_reset_watches(void)
>  {
>  	int err, supported = 0;
> @@ -625,6 +637,9 @@ static void xs_reset_watches(void)
>  	if (!xen_hvm_domain())
>  		return;
>  
> +	if (xen_strict_xenbus_quirk())
> +		return;
> +
>  	err = xenbus_scanf(XBT_NIL, "control",
>  			"platform-feature-xs_reset_watches", "%d", &supported);
>  	if (err != 1 || !supported)


