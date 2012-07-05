Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab2GELnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 07:43:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61320 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2GELnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 07:43:18 -0400
Message-ID: <4FF57DAA.8010405@mvista.com>
Date: Thu, 05 Jul 2012 15:42:34 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v2 2/2] ata: implement MODE SELECT command
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com> <1341481235-12708-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341481235-12708-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-07-2012 13:40, Paolo Bonzini wrote:

> The cache_type file in sysfs lets users configure the disk cache in
> write-through or write-back modes.  However, ata disks do not support
> writing to the file because they do not implement the MODE SELECT
> command.

> This patch adds a translation from MODE SELECT (for the caching page
> only) to the ATA SET FEATURES command.  The set of changeable parameters
> answered by MODE SENSE is also adjusted accordingly.

> Cc: Sergei Shtylyov <sshtylyov@mvista.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   drivers/ata/libata-scsi.c |  185 +++++++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 179 insertions(+), 6 deletions(-)

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d5aeb26..1cb88df 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[...]
> +/**
> + *	ata_scsiop_mode_select - Simulate MODE SELECT 6, 10 commands
> + *	@qc: Storage for translated ATA taskfile
> + *
> + *	Converts a MODE SELECT command to an ATA SET FEATURES taskfile.
> + *	Assume this is invoked for direct access devices (e.g. disks) only.
> + *	There should be no block descriptor for other device types.
> + *
> + *	LOCKING:
> + *	spin_lock_irqsave(host lock)
> + */
> +static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
> +{
> +	struct scsi_cmnd *scmd = qc->scsicmd;
> +	const u8 *cdb = scmd->cmnd;
> +	const u8 *p;
> +	u8 pg, spg;
> +	unsigned six_byte, pg_len, hdr_len;
> +	int len;
> +
> +	VPRINTK("ENTER\n");
> +
> +	six_byte = (cdb[0] == MODE_SELECT);
> +	if (six_byte) {
> +		if (scmd->cmd_len < 5)
> +			goto invalid_fld;

    Strictly speaking, it should be "invalid phase" error.

> +
> +		len = cdb[4];
> +	} else {
> +		if (scmd->cmd_len < 9)
> +			goto invalid_fld;

    The same.

> +
> +		len = (cdb[7] << 8) + cdb[8];
> +	}
> +	/* Test early for possible overrun.  */
> +	if (!scsi_sg_count(scmd) || scsi_sglist(scmd)->length < len)
> +		goto invalid_param_len;

     Strictly speaking, it's "data underrun" error.

> +	p = page_address(sg_page(scsi_sglist(scmd)));

    What if the S/G list spans multiple non-consecutive pages?

> +
> +	/* Move past header and block descriptors.  */
> +	if (six_byte)
> +		hdr_len = p[3] + 4;
> +	else
> +		hdr_len = (p[6] << 8) + p[7] + 8;
> +
> +	if (len < hdr_len)
> +		goto invalid_param_len;
> +
> +	len -= hdr_len;
> +	p += hdr_len;
> +	if (len == 0)
> +		goto skip;
> +
> +	/* Parse both possible formats for the mode page headers.  */
> +	pg = p[0] & 0x3f;
> +	if (p[0] & 0x40) {
> +		if (len < 4)
> +			goto invalid_param_len;
> +
> +		spg = p[1];
> +		pg_len = (p[2] << 8) | p[3];
> +		p += 4;
> +		len -= 4;
> +	} else {
> +		if (len < 2)
> +			goto invalid_param_len;
> +
> +		spg = 0;
> +		pg_len = p[1];
> +		p += 2;
> +		len -= 2;
> +	}
> +
> +	/*
> +	 * Only one page has changeable data, so we only support setting one
> +	 * page at a time.
> +	 */
> +	if (len < pg_len)
> +		goto invalid_param;

     Not 'invalid_param_len'?

> +
> +	/*
> +	 * No mode subpages supported (yet) but asking for _all_
> +	 * subpages may be valid
> +	 */
> +	if (spg && (spg != ALL_SUB_MPAGES))
> +		goto invalid_param;

    Rather "paramater not supported" (0x26/0x01)...

> +	if (pg_len > len)
> +		goto invalid_param_len;

    We have just checked this.

> +	switch (pg) {
> +	case CACHE_MPAGE:
> +		if (ata_mselect_caching(qc, p, pg_len) < 0)
> +			goto invalid_param;

    Rather "parameter not supported"?

> +		break;
> +
> +	default:		/* invalid page code */
> +		goto invalid_param;

    Rather "paramater not supported"...

> +	}
> +
> +	return 0;

MBR, Sergei
