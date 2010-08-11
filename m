Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab0HKUV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:21:58 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:29061 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab0HKUVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:21:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/3] cxgb4i v5: iscsi driver
Date: Wed, 11 Aug 2010 13:17:07 -0700
Message-ID: <8A71B368A89016469F72CD08050AD33408403C5F@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] cxgb4i v5: iscsi driver
Thread-Index: Acs5g6i2GAfLhWFOQ3iVYqg4oxOlKAADnLLw
References: <201008091753.o79HrTmr020149@localhost.localdomain> <4C62EDEB.3030007@cs.wisc.edu>
From: "Karen Xie" <kxie@chelsio.com>
To: "Mike Christie" <michaelc@cs.wisc.edu>, <open-iscsi@googlegroups.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Rakesh Ranjan" <rakesh@chelsio.com>,
        <James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are right. I will fix it to make sure iscsi transport
registration happens only once.
Thanks,
Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Wednesday, August 11, 2010 11:38 AM
To: open-iscsi@googlegroups.com
Cc: Karen Xie; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
Rakesh Ranjan; James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 2/3] cxgb4i v5: iscsi driver

On 08/09/2010 12:53 PM, kxie@chelsio.com wrote:
> +
> +static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
> +{
> +	struct cxgbi_device *cdev;
> +	struct port_info *pi;
> +	int i, rc;
> +
> +	cxgb4i_log_info("%s", version);
> +
> +	cdev = cxgbi_device_register(sizeof(*lldi), lldi->nports);
> +	if (!cdev) {
> +		cxgb4i_log_info("t4 device 0x%p, register failed.\n",
lldi);
> +		return NULL;
> +	}
> +	cxgb4i_log_debug(1<<  CXGBI_DBG_DEV,
> +			"t4 0x%p,0x%x, ports %u,%s, chan %u, q %u,%u, wr
%u.\n",
> +			cdev, lldi->adapter_type, lldi->nports,
> +			lldi->ports[0]->name, lldi->nchan, lldi->ntxq,
> +			lldi->nrxq, lldi->wr_cred);
> +	for (i = 0; i<  lldi->nrxq; i++)
> +			cxgb4i_log_debug(1<<  CXGBI_DBG_DEV,
> +				"t4 0x%p, rxq id #%d: %u.\n",
> +				cdev, i, lldi->rxq_ids[i]);
> +
> +	memcpy(cxgbi_cdev_priv(cdev), lldi, sizeof(*lldi));
> +	cdev->flags = CXGBI_FLAG_DEV_T4;
> +	cdev->pdev = lldi->pdev;
> +	cdev->ports = lldi->ports;
> +	cdev->nports = lldi->nports;
> +	cdev->mtus = lldi->mtus;
> +	cdev->nmtus = NMTUS;
> +	cdev->snd_win = cxgb4i_snd_win;
> +	cdev->rcv_win = cxgb4i_rcv_win;
> +	cdev->rx_credit_thres = cxgb4i_rx_credit_thres;
> +	cdev->skb_tx_rsvd = CXGB4I_TX_HEADER_LEN;
> +	cdev->skb_rx_extra = sizeof(struct cpl_iscsi_hdr);
> +	cdev->itp =&cxgb4i_iscsi_transport;
> +
> +	rc = cxgbi_iscsi_init(cdev);
> +	if (rc) {
> +		cxgb4i_log_info("t4 0x%p iscsi init failed\n", cdev);
> +		goto err_out;
> +	}

For each LLD (cxgb3i and cxgb4i) could it get called more than once? I 
mean if you had multiple cxgb3i HBAs could it get called once for each 
or is it called just once time for all cxgb3i hbas? If more than once 
the cxgbi_iscsi_init call to iscsi_register_transport would fail on the 
second call, because the iscsi class would not allow you to register the

same transport twice.
