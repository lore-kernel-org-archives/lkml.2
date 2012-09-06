Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab2IFU6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:58:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33349 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2IFU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:58:32 -0400
Message-ID: <50490E73.7070601@redhat.com>
Date: Thu, 06 Sep 2012 22:58:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 3.6 2/2] target: use a bounce buffer in transport_kmap_data_sg
 for 0 or 1-page sglist
References: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>  <1346944410-19850-3-git-send-email-pbonzini@redhat.com> <1346959768.4162.540.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1346959768.4162.540.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 21:29, Nicholas A. Bellinger ha scritto:
> On Thu, 2012-09-06 at 17:13 +0200, Paolo Bonzini wrote:
>> This patch started with the aim of fixing START STOP UNIT to a PSCSI
>> device.  Right now, commands with a zero-size payload are skipped
>> completely.  This is wrong; such commands should be passed down to the
>> device and processed normally.  As a hint of this, we have a hack to
>> clear a unit attention state on a zero-size REQUEST SENSE.
> 
> The existing code for zero-size handling in transport_generic_new_cmd()
> is correct for virtual backends (eg: TRANSPORT_PLUGIN_VHBA_*), but as
> you've witnessed not correct for pSCSI passthrough ops.

It is not completely correct for virtual backends, for example I think
it will always return success for 0-block reads or writes, even if the
start LBA is out of range.  This is also something that I saw with
PSCSI, and is fixed by these patches.

Also, even though it handles zero-size, it doesn't handle a CDB with a
small but nonzero allocation length.  If you have such a CDB, you can
overflow the sglist.   If the fabric uses
transport_generic_map_mem_to_cmd, you may corrupt adjacent memory.

Besides, the cut-and-pasted REQUEST SENSE handling is a bit gross. :)

Fixing this properly, as it turns out, also fixes zero-size handling of
PSCSI.

> The only cases where an pSCSI backend ever uses transport_kmap_data_sg()
> today are:
> 
> - During REPORT_LUNS emulation
> 
> - During the MODE_SENSE hack in pscsi_transport_complete() to set the
>   proper WriteProtected bit based upon configfs fabric attribute
> 
> so I'd rather see two special case checks for zero-size CDBs with pSCSI,
> over adding these changes to transport_k[un]map_data_sg().

This would not fix the root cause, which is bad handling of short-sized
allocation lengths.

>> Luckily, transport_kmap_data_sg is not called on the I/O path, so we can
>> simply allocate a one-page bounce buffer there, which indeed also takes
>> care of zero-sized transfers.
>> ---
>>  drivers/target/target_core_transport.c |   62 ++++++++++++++-----------------
>>  1 files changed, 28 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 09028af..a77c8aa 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -2181,20 +2181,32 @@ EXPORT_SYMBOL(transport_generic_map_mem_to_cmd);
>>  
>>  void *transport_kmap_data_sg(struct se_cmd *cmd)
>>  {
>> +	u32 npages = DIV_ROUND_UP(cmd->data_length, PAGE_SIZE);
>>  	struct scatterlist *sg = cmd->t_data_sg;
>>  	struct page **pages;
>>  	int i;
>>  
>> -	BUG_ON(!sg);
>> +	BUG_ON(!sg && npages > 0);
>> +
>>  	/*
>>  	 * We need to take into account a possible offset here for fabrics like
>>  	 * tcm_loop who may be using a contig buffer from the SCSI midlayer for
>>  	 * control CDBs passed as SGLs via transport_generic_map_mem_to_cmd()
>> +	 *
>> +	 * This could cause overflows if the buffer is too small for the caller.
>> +	 * For example, the REQUEST_SENSE handler expects 8 bytes, but it is
>> +	 * possible to send a CDB with a small allocation length (e.g. 4 bytes).
>> +	 * In this case, we could have a single-page sglist with a large offset,
>> +	 * so that buf[7] is already inaccessible.
>> +	 *
>> +	 * But transport_kmap_data_sg is not called on the I/O path, so we can
>> +	 * simply allocate a one-page bounce buffer here.  This also takes care
>> +	 * of the case of zero-sized transfers.
>>  	 */
>> -	if (!cmd->t_data_nents)
>> -		return NULL;
>> -	else if (cmd->t_data_nents == 1)
>> -		return kmap(sg_page(sg)) + sg->offset;
>> +	if (npages <= 1) {
>> +		cmd->t_data_vmap = kzalloc(PAGE_SIZE, GFP_KERNEL);
>> +		return cmd->t_data_vmap;
>> +	}
>>  
>>  	/* >1 page. use vmap */
>>  	pages = kmalloc(sizeof(*pages) * cmd->t_data_nents, GFP_KERNEL);
>> @@ -2217,14 +2229,18 @@ EXPORT_SYMBOL(transport_kmap_data_sg);
>>  
>>  void transport_kunmap_data_sg(struct se_cmd *cmd)
>>  {
>> -	if (!cmd->t_data_nents) {
>> -		return;
>> -	} else if (cmd->t_data_nents == 1) {
>> -		kunmap(sg_page(cmd->t_data_sg));
>> -		return;
>> -	}
>> +	u32 npages = DIV_ROUND_UP(cmd->data_length, PAGE_SIZE);
>> +	if (npages <= 1) {
>> +		if (npages) {
>> +			struct scatterlist *sg = cmd->t_data_sg;
>> +			u8 *dest = kmap(sg_page(sg));
>> +			memcpy(dest + sg->offset, cmd->t_data_vmap, sg->length);
>> +			kunmap(sg_page(sg));
>> +		}
>> +		kfree(cmd->t_data_vmap);
>> +	} else
>> +		vunmap(cmd->t_data_vmap);
>>  
>> -	vunmap(cmd->t_data_vmap);
>>  	cmd->t_data_vmap = NULL;
>>  }
>>  EXPORT_SYMBOL(transport_kunmap_data_sg);
>> @@ -2290,28 +2306,6 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>>  		if (ret < 0)
>>  			goto out_fail;
>>  	}
>> -	/*
>> -	 * If this command doesn't have any payload and we don't have to call
>> -	 * into the fabric for data transfers, go ahead and complete it right
>> -	 * away.
>> -	 */
>> -	if (!cmd->data_length) {
>> -		spin_lock_irq(&cmd->t_state_lock);
>> -		cmd->t_state = TRANSPORT_COMPLETE;
>> -		cmd->transport_state |= CMD_T_ACTIVE;
>> -		spin_unlock_irq(&cmd->t_state_lock);
>> -
>> -		if (cmd->t_task_cdb[0] == REQUEST_SENSE) {
>> -			u8 ua_asc = 0, ua_ascq = 0;
>> -
>> -			core_scsi3_ua_clear_for_request_sense(cmd,
>> -					&ua_asc, &ua_ascq);
>> -		}
>> -
>> -		INIT_WORK(&cmd->work, target_complete_ok_work);
>> -		queue_work(target_completion_wq, &cmd->work);
>> -		return 0;
>> -	}
>>  
> 
> This code needs still needs to get called for all virtual backends of
> type !TRANSPORT_PLUGIN_PHBA_PDEV.

It is superseded by the new code in transport_kmap_data_sg.

Paolo
