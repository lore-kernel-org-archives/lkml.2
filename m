Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab2IFUv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:51:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61846 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab2IFUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:51:55 -0400
Message-ID: <50490CE7.2020806@redhat.com>
Date: Thu, 06 Sep 2012 22:51:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 3.6 1/2] target: remove pscsi_clear_cdb_lun
References: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>  <1346944410-19850-2-git-send-email-pbonzini@redhat.com> <1346957885.4162.509.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1346957885.4162.509.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 20:58, Nicholas A. Bellinger ha scritto:
> On Thu, 2012-09-06 at 17:13 +0200, Paolo Bonzini wrote:
>> The purpose of this function is to clear a LUN set in the CDB, in case
>> the initiator talking to us is speaking an old standards version.
>> However, as things stand, pscsi_clear_cdb_lun has two problems.  It
>> will "deceive" the guest by clearing the LUN bits on initial
>> commands (INQUIRY, TEST UNIT READY, etc.); but then it will let the
>> LUN bits through on reads, which will likely fail due to protection not
>> being enabled.  Second, not all commands are properly filtered, in
>> particular WRITE's WRPROTECT bits are cleared.
>>
>> This should be done by the fabric module rather than by PSCSI, if it
>> knows such initiators may be lying around _and_ it can assume that its
>> initiators do not really care about protection information.  Nuke it
>> from PSCSI.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> NAK.  This code was originally added to prevent certain pSCSI HBAs from
> going bonkers when they got a legacy SCSI LUN ID encoded within the CDB
> (eg: the fabric LUN ID) that's different from the physical SCSI LUN ID
> on an Parallel SCSI bus.

I understood, but what's good in making INQUIRY work, if the HBA will
equally go bonkers on the first actual I/O (READ/WRITE/VERIFY are all
affected)?

This is something the LLDs or the fabric module should be doing.  But I
guess it could be an attribute too.

Paolo

> If there are more special cases where the legacy SCSI LUN ID bit-range
> needs to be cleared than please add those missing bits, but I don't
> think it's yet safe to remove this completely for pSCSI w/ older LLDs.
> 
>>  drivers/target/target_core_pscsi.c |   26 --------------------------
>>  1 files changed, 0 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
>> index 5f7151d..a0fb2c3 100644
>> --- a/drivers/target/target_core_pscsi.c
>> +++ b/drivers/target/target_core_pscsi.c
>> @@ -1031,30 +1031,6 @@ fail:
>>  	return -ENOMEM;
>>  }
>>  
>> -/*
>> - * Clear a lun set in the cdb if the initiator talking to use spoke
>> - * and old standards version, as we can't assume the underlying device
>> - * won't choke up on it.
>> - */
>> -static inline void pscsi_clear_cdb_lun(unsigned char *cdb)
>> -{
>> -	switch (cdb[0]) {
>> -	case READ_10: /* SBC - RDProtect */
>> -	case READ_12: /* SBC - RDProtect */
>> -	case READ_16: /* SBC - RDProtect */
>> -	case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
>> -	case VERIFY: /* SBC - VRProtect */
>> -	case VERIFY_16: /* SBC - VRProtect */
>> -	case WRITE_VERIFY: /* SBC - VRProtect */
>> -	case WRITE_VERIFY_12: /* SBC - VRProtect */
>> -	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
>> -		break;
>> -	default:
>> -		cdb[1] &= 0x1f; /* clear logical unit number */
>> -		break;
>> -	}
>> -}
>> -
>>  static int pscsi_parse_cdb(struct se_cmd *cmd)
>>  {
>>  	unsigned char *cdb = cmd->t_task_cdb;
>> @@ -1067,8 +1043,6 @@ static int pscsi_parse_cdb(struct se_cmd *cmd)
>>  		return -EINVAL;
>>  	}
>>  
>> -	pscsi_clear_cdb_lun(cdb);
>> -
>>  	/*
>>  	 * For REPORT LUNS we always need to emulate the response, for everything
>>  	 * else the default for pSCSI is to pass the command to the underlying
> 
> 

