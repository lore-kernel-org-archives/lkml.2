Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2HaPPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:15:08 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:17850
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614Ab2HaPPG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:15:06 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah1220h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] hv: vmbus_drv: detect hyperv through x86_hyper
Thread-Topic: [PATCH] hv: vmbus_drv: detect hyperv through x86_hyper
Thread-Index: AQHNhzsMve0qAkXkSUaRlwoBL73BRpd0B9oQ
Date: Fri, 31 Aug 2012 15:14:44 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9309DDF86@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1346391164-34001-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1346391164-34001-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Friday, August 31, 2012 1:33 AM
> To: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Cc: Jason Wang; KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] hv: vmbus_drv: detect hyperv through x86_hyper
> 
> There are two reasons we need to use x86_hyper instead of
> query_hypervisor_presence():
> 
> - Not only hyperv but also other hypervisors such as kvm would set
>   X86_FEATURE_HYTPERVISOR, so query_hypervisor_presence() will return true
> even
>   in kvm. This may cause extra delay of 5 seconds before failing the probing in
>   kvm guest.
> - The hypervisor has been detected in init_hypervisor(), so no need to do the
>   work again.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Thanks Jason.

Acked-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hv/vmbus_drv.c |   25 ++-----------------------
>  1 files changed, 2 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index f40dd57..8e1a9ec 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -34,6 +34,7 @@
>  #include <linux/completion.h>
>  #include <linux/hyperv.h>
>  #include <asm/hyperv.h>
> +#include <asm/hypervisor.h>
>  #include "hyperv_vmbus.h"
> 
> 
> @@ -719,33 +720,11 @@ static struct acpi_driver vmbus_acpi_driver = {
>  	},
>  };
> 
> -/*
> - * query_hypervisor_presence
> - * - Query the cpuid for presence of windows hypervisor
> - */
> -static int query_hypervisor_presence(void)
> -{
> -	unsigned int eax;
> -	unsigned int ebx;
> -	unsigned int ecx;
> -	unsigned int edx;
> -	unsigned int op;
> -
> -	eax = 0;
> -	ebx = 0;
> -	ecx = 0;
> -	edx = 0;
> -	op = HVCPUID_VERSION_FEATURES;
> -	cpuid(op, &eax, &ebx, &ecx, &edx);
> -
> -	return ecx & HV_PRESENT_BIT;
> -}
> -
>  static int __init hv_acpi_init(void)
>  {
>  	int ret, t;
> 
> -	if (!query_hypervisor_presence())
> +	if (x86_hyper != &x86_hyper_ms_hyperv)
>  		return -ENODEV;
> 
>  	init_completion(&probe_event);
> --
> 1.7.1
> 
> 
> 



