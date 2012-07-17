Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2GQIeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab2GQIe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:34:29 -0400
Message-ID: <50052390.7030908@redhat.com>
Date: Tue, 17 Jul 2012 10:34:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>  <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>  <50044D56.6000400@redhat.com> <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 09:45, James Bottomley ha scritto:
> On Mon, 2012-07-16 at 19:20 +0200, Paolo Bonzini wrote:
>> Il 16/07/2012 18:18, James Bottomley ha scritto:
>>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>>> index b583277..6d8ca08 100644
>>>>> --- a/drivers/scsi/scsi_lib.c
>>>>> +++ b/drivers/scsi/scsi_lib.c
>>>>> @@ -843,8 +843,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>>>>  	} else if (sense_valid && !sense_deferred) {
>>>>>  		switch (sshdr.sense_key) {
>>>>>  		case UNIT_ATTENTION:
>>>>> -			if (cmd->device->removable) {
>>>>> -				/* Detected disc change.  Set a bit
>>>>> +			if (cmd->device->removable &&
>>>>> +			    (sshdr.asc == 0x3a ||
>>>>> +			     (sshdr.asc == 0x28 && sshdr.ascq == 0x00))) {
>>>>> +				/* "No medium" or "Medium may have changed."
>>>>> +				 * This means a disc change.  Set a bit
>>> This type of change would likely cause a huge cascade of errors in real
>>> removable media devices.  Under the MMC standards, which a lot of the
>>> older removable discs seem to follow, UNIT ATTENTION indicates either
>>> medium change or device reset (which we check for and eat lower down);
>>> we can't rely on them giving proper SBC-2 sense codes.  If you want to
>>> pretend to be removable media, you have to conform to its standards.
>>
>> Would you accept a patch doing the opposite, i.e. passing some sense
>> codes such as PARAMETERS CHANGED and TARGET OPERATING CONDITIONS HAVE
>> CHANGED?
> 
> Could you explain what the problem actually is?  It looks like you had a
> reason to mark virtio-scsi as removable, even though it isn't, and now
> you want to add further hacks because being removable doesn't quite
> work.

It's not specific to virtio-scsi, in fact I expect that virtio-scsi will
be almost always used with non-removable disks.

However, QEMU's SCSI target is not used just for virtio-scsi (for
example it can be used for USB storage), and it lets you mark a disk as
removable---why? because there exists real hardware that presents itself
as an SBC removable disk.  The only thing that is specific to
virtualization, is support for online resizing (which generates a unit
attention condition CAPACITY DATA HAS CHANGED).

Paolo
