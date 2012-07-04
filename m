Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2GDQDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:03:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab2GDQDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:03:41 -0400
Message-ID: <4FF46951.7050808@redhat.com>
Date: Wed, 04 Jul 2012 18:03:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: implement MODE SELECT command
References: <1341400436-2546-1-git-send-email-pbonzini@redhat.com> <4FF4637A.6060901@mvista.com>
In-Reply-To: <4FF4637A.6060901@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 17:38, Sergei Shtylyov ha scritto:
> Hello.
> 
> On 07/04/2012 03:13 PM, Paolo Bonzini wrote:
> 
>> The cache_type file in sysfs lets users configure the disk cache in
>> write-through or write-back modes.  However, ata disks do not support
>> writing to the file because they do not implement the MODE SELECT
>> command.
> 
>> This patch adds a translation from MODE SELECT (for the caching page
>> only) to the ATA SET FEATURES command.
> 
>> Cc: Jeff Garzik <jgarzik@pobox.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  drivers/ata/libata-scsi.c |  147 +++++++++++++++++++++++++++++++++++++++++++--
>>  1 files changed, 142 insertions(+), 5 deletions(-)
> 
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 41cde45..e7702d3 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -3081,6 +3081,144 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>>  }
>>  
>>  /**
>> + *	ata_mselect_caching - Simulate MODE SELECT for caching info page
>> + *	@tf: taskfile to be filled
>> + *	@buf: input buffer
>> + *	@len: number of valid bytes in the input buffer
>> + *
>> + *	Prepare a taskfile to modify caching information for the device.
>> + *
>> + *	LOCKING:
>> + *	None.
>> + */
>> +static unsigned int ata_mselect_caching(struct ata_taskfile *tf, const u8 *buf,
>> +					int len)
>> +{
>> +	u8 wce;
> 
>    Empty line after declaration block wouldn't hurt...
> 
>> +	if (len == 0)
>> +		return 1;
>> +
>> +	/*
>> +	 * The first two bytes are a header, so offsets here are 2 less
>> +	 * than in ata_msense_caching.
>> +	 */
>> +	wce = buf[0] & (1 << 2);
> 
>    Perhaps it's worth denying the command if the other page fields dfifer from
> 'def_cache_mpage' (i.e. all zeros)?

I thought about it, but it seemed a useless complication.

>> +/**
>> + *	ata_scsi_mode_select_xlat - Translate MODE SELECT 6, 10 commands
>> + *	@qc: Storage for translated ATA taskfile
>> + *
>> + *	Converts a MODE SELECT command to an ATA SET FEATURES taskfile.
>> + *	Assume this is invoked for direct access devices (e.g. disks) only.
>> + *	There should be no block descriptor for other device types.
>> + *
>> + *	LOCKING:
>> + *	spin_lock_irqsave(host lock)
>> + */
>> +static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
>> +{
>> +	struct scsi_cmnd *scmd = qc->scsicmd;
>> +	struct ata_taskfile *tf = &qc->tf;
>> +	const u8 *cdb = scmd->cmnd;
>> +	const u8 *p;
>> +	u8 pg, spg;
>> +	unsigned six_byte, pg_len;
>> +	int len;
>> +
>> +	VPRINTK("ENTER\n");
>> +
>> +	/*
>> +	 * Get the command buffer.
>> +	 */
>> +	if (!scsi_sg_count(scmd))
>> +		goto invalid_fld;
>> +
>> +	p = page_address(sg_page(scsi_sglist(scmd)));
>> +
>> +	six_byte = (cdb[0] == MODE_SELECT);
>> +	if (six_byte) {
>> +		if (scmd->cmd_len < 5)
> 
>    Not 6?

This is just protecting the next access.  The last byte is unused.

>> +			goto invalid_fld;
>> +
>> +		len = cdb[4];
>> +	} else {
>> +		if (scmd->cmd_len < 9)
> 
>    Not 10?
>    And ata_scsiop_mode_sense() don't seem to check this...

Yeah, but other xlat functions do this, see ata_scsi_start_stop_xlat.  I
wasn't sure why, so I went for the safer option.

>    And I doubt "Invalid field in CDB" is a proper sense code in this situation.
> 
>> +			goto invalid_fld;
>> +
>> +		len = (cdb[7] << 8) | cdb[8];
>> +	}
> 
>> +	/*
>> +	 * No mode subpages supported (yet) but asking for _all_
>> +	 * subpages may be valid
>> +	 */
>> +	if (spg && (spg != ALL_SUB_MPAGES))
>> +		goto invalid_fld;
>> +	if (pg_len > len)
>> +		goto invalid_fld;
> 
>    It's valid to have buffer size less than data size.

Perhaps for MODE SENSE, but not for MODE SELECT.  Otherwise, where do
you get the mode data from?

Anyhow, checking buffer size vs. data size is done early, in

+	/* Test early for possible overrun.  */
+	if (scsi_sglist(scmd)->length < len)
+		goto invalid_fld;

not here.  What this check is doing, is ensuring that the page data does
not extend past the end of the buffer.

>> +	switch (pg) {
>> +	case CACHE_MPAGE:
>> +		if (ata_mselect_caching(tf, p, pg_len))
>> +			goto invalid_fld;
>> +		break;
>> +
>> +	default:		/* invalid page code */
>> +		goto invalid_fld;
> 
>    Page code is not a part of CDB, hence the sense code you'll return doesn't
> fit there.

Yes, invalid field in parameter list probably would be better.  Let me
know if I should respin.

Thanks for the review!

Paolo

>> +	}
>> +	return 0;
>> +
>> + invalid_fld:
>> +	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
>> +	/* "Invalid field in cbd" */
>> +	return 1;
> 
> MBR, Sergei
> 


