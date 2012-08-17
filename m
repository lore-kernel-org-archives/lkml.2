Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2HQMho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 08:37:44 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:28320 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756446Ab2HQMhd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 08:37:33 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z5c5oz9371I542M1432Izz1202hzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] hv: fail the probing immediately when we are not in
 hyperv platform
Thread-Topic: [PATCH] hv: fail the probing immediately when we are not in
 hyperv platform
Thread-Index: AQHNfGd063H3Q8yA4EWBu5J+Upvq2Jdd8Gfg
Date: Fri, 17 Aug 2012 12:36:56 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236C1D06@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1345200763-48077-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1345200763-48077-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Friday, August 17, 2012 6:53 AM
> To: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Cc: Jason Wang; KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] hv: fail the probing immediately when we are not in hyperv
> platform
> 
> We wait for about 5 seconds for the success of the hyperv registration even if
> we were not in hyperv platform. This is suboptimal, so the patch check the cpuid
> in the beginning of hv_acpi_init() instead of in vmbus_bus_init() to fail the
> probing immediately.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/hv/hv.c        |   25 -------------------------
>  drivers/hv/vmbus_drv.c |   25 +++++++++++++++++++++++++
>  2 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 86f8885..a18ee5d 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -38,28 +38,6 @@ struct hv_context hv_context = {
>  };
> 
>  /*
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
> -/*
>   * query_hypervisor_info - Get version info of the windows hypervisor
>   */
>  static int query_hypervisor_info(void)
> @@ -159,9 +137,6 @@ int hv_init(void)
>  	memset(hv_context.synic_message_page, 0,
>  	       sizeof(void *) * NR_CPUS);
> 
> -	if (!query_hypervisor_presence())
> -		goto cleanup;
> -
>  	max_leaf = query_hypervisor_info();
> 
>  	/* Write our OS info */
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4748086..a9192fd 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -753,10 +753,35 @@ static struct acpi_driver vmbus_acpi_driver = {
>  	},
>  };
> 
> +/*
> + * query_hypervisor_presence
> + * - Query the cpuid for presence of windows hypervisor
> + */
> +static int query_hypervisor_presence(void)
> +{
> +	unsigned int eax;
> +	unsigned int ebx;
> +	unsigned int ecx;
> +	unsigned int edx;
> +	unsigned int op;
> +
> +	eax = 0;
> +	ebx = 0;
> +	ecx = 0;
> +	edx = 0;
> +	op = HVCPUID_VERSION_FEATURES;
> +	cpuid(op, &eax, &ebx, &ecx, &edx);
> +
> +	return ecx & HV_PRESENT_BIT;
> +}
> +
>  static int __init hv_acpi_init(void)
>  {
>  	int ret, t;
> 
> +	if (!query_hypervisor_presence())
> +		return -ENODEV;
> +
>  	init_completion(&probe_event);
> 
>  	/*
> --
> 1.7.1

Thank you.

Acked-by:  K. Y. Srinivasan <kys@microsoft.com>



