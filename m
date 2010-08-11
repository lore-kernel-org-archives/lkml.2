Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0HKSdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:33:17 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58279 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab0HKSdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:33:16 -0400
Message-ID: <4C62EDEB.3030007@cs.wisc.edu>
Date: Wed, 11 Aug 2010 13:37:31 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: kxie@chelsio.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        rranjan@chelsio.com, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 2/3] cxgb4i v5: iscsi driver
References: <201008091753.o79HrTmr020149@localhost.localdomain>
In-Reply-To: <201008091753.o79HrTmr020149@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> +		cxgb4i_log_info("t4 device 0x%p, register failed.\n", lldi);
> +		return NULL;
> +	}
> +	cxgb4i_log_debug(1<<  CXGBI_DBG_DEV,
> +			"t4 0x%p,0x%x, ports %u,%s, chan %u, q %u,%u, wr %u.\n",
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
