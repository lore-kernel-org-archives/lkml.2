Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2JHPwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:52:05 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:4251
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab2JHPwA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:52:00 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h683h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Account for in-transit
 packets in the RESET path
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Account for in-transit
 packets in the RESET path
Thread-Index: AQHNoMWcxusn4sLRaUqO/CrO1v0WZJevlA5A
Date: Mon, 8 Oct 2012 15:51:09 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A1FCB6@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349201011-14572-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1349201011-14572-1-git-send-email-kys@microsoft.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, October 02, 2012 2:04 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Cc: KY Srinivasan; stable@vger.kernel.org
> Subject: [PATCH 1/1] Drivers: scsi: storvsc: Account for in-transit packets in the
> RESET path
> 
> Properly account for I/O in transit before returning from the RESET call.
> In the absense of this patch, we could have a situation where the host may
> respond to a command that was issued prior to the issuance of the RESET
> command at some arbitrary time after responding to the RESET command.
> Currently, the host does not do anything with the RESET command.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/storvsc_drv.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 528d52b..0144078 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1221,7 +1221,12 @@ static int storvsc_host_reset_handler(struct scsi_cmnd
> *scmnd)
>  	/*
>  	 * At this point, all outstanding requests in the adapter
>  	 * should have been flushed out and return to us
> +	 * There is a potential race here where the host may be in
> +	 * the process of responding when we return from here.
> +	 * Just wait for all in-transit packets to be accounted for
> +	 * before we return from here.
>  	 */
> +	storvsc_wait_to_drain(stor_device);
> 
>  	return SUCCESS;
>  }
> --
> 1.7.4.1

James,

This patch is critical for running Linux based workloads on our Cloud infrastructure - Azure.
Please let me know if there are any issues.

Regards,

K. Y



