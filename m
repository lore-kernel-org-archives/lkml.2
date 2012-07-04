Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2GDRWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 13:22:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49308 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2GDRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 13:22:17 -0400
Message-ID: <4FF47B71.4030603@mvista.com>
Date: Wed, 04 Jul 2012 21:20:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: implement MODE SELECT command
References: <1341400436-2546-1-git-send-email-pbonzini@redhat.com> <4FF4637A.6060901@mvista.com> <4FF46951.7050808@redhat.com>
In-Reply-To: <4FF46951.7050808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 08:03 PM, Paolo Bonzini wrote:

>>> The cache_type file in sysfs lets users configure the disk cache in
>>> write-through or write-back modes.  However, ata disks do not support
>>> writing to the file because they do not implement the MODE SELECT
>>> command.

>>> This patch adds a translation from MODE SELECT (for the caching page
>>> only) to the ATA SET FEATURES command.

>>> Cc: Jeff Garzik <jgarzik@pobox.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  drivers/ata/libata-scsi.c |  147 +++++++++++++++++++++++++++++++++++++++++++--
>>>  1 files changed, 142 insertions(+), 5 deletions(-)

>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>> index 41cde45..e7702d3 100644
>>> --- a/drivers/ata/libata-scsi.c
>>> +++ b/drivers/ata/libata-scsi.c
>>> @@ -3081,6 +3081,144 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>>>  }
>>>  
>>>  /**
>>> + *	ata_mselect_caching - Simulate MODE SELECT for caching info page
>>> + *	@tf: taskfile to be filled
>>> + *	@buf: input buffer
>>> + *	@len: number of valid bytes in the input buffer
>>> + *
>>> + *	Prepare a taskfile to modify caching information for the device.
>>> + *
>>> + *	LOCKING:
>>> + *	None.
>>> + */
>>> +static unsigned int ata_mselect_caching(struct ata_taskfile *tf, const u8 *buf,
>>> +					int len)
>>> +{
>>> +	u8 wce;

>>    Empty line after declaration block wouldn't hurt...

>>> +	if (len == 0)
>>> +		return 1;
>>> +
>>> +	/*
>>> +	 * The first two bytes are a header, so offsets here are 2 less
>>> +	 * than in ata_msense_caching.
>>> +	 */
>>> +	wce = buf[0] & (1 << 2);

>>    Perhaps it's worth denying the command if the other page fields dfifer from
>> 'def_cache_mpage' (i.e. all zeros)?

> I thought about it, but it seemed a useless complication.

   If you bothered to implement that, go all the way. :-)

>>> +/**
>>> + *	ata_scsi_mode_select_xlat - Translate MODE SELECT 6, 10 commands
>>> + *	@qc: Storage for translated ATA taskfile
>>> + *
>>> + *	Converts a MODE SELECT command to an ATA SET FEATURES taskfile.
>>> + *	Assume this is invoked for direct access devices (e.g. disks) only.
>>> + *	There should be no block descriptor for other device types.
>>> + *
>>> + *	LOCKING:
>>> + *	spin_lock_irqsave(host lock)
>>> + */
>>> +static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
>>> +{
[...]
>>> +	/*
>>> +	 * No mode subpages supported (yet) but asking for _all_
>>> +	 * subpages may be valid
>>> +	 */
>>> +	if (spg && (spg != ALL_SUB_MPAGES))
>>> +		goto invalid_fld;
>>> +	if (pg_len > len)
>>> +		goto invalid_fld;

>>    It's valid to have buffer size less than data size.

> Perhaps for MODE SENSE, but not for MODE SELECT.  Otherwise, where do
> you get the mode data from?

   They simply don't change?

> Anyhow, checking buffer size vs. data size is done early, in

> +	/* Test early for possible overrun.  */
> +	if (scsi_sglist(scmd)->length < len)
> +		goto invalid_fld;

> not here.  What this check is doing, is ensuring that the page data does
> not extend past the end of the buffer.

   That's what I say is valid. You can get incomplete data, according to the
buffer size. Though maybe it was only my impression...

>>> +	switch (pg) {
>>> +	case CACHE_MPAGE:
>>> +		if (ata_mselect_caching(tf, p, pg_len))
>>> +			goto invalid_fld;
>>> +		break;
>>> +
>>> +	default:		/* invalid page code */
>>> +		goto invalid_fld;

>>    Page code is not a part of CDB, hence the sense code you'll return doesn't
>> fit there.

> Yes, invalid field in parameter list probably would be better.

   Or "parameter not supported" (0x26/0x01).

> Let me know if I should respin.

   I'd prefer if you respin.

> Thanks for the review!

> Paolo

MBR, Sergei
