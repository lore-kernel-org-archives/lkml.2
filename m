Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab0HPTlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:41:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47713 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0HPTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X8f/1w/dfLNWolxXtAgt7DwM8/DwCrcZZfQNdYH5Z3xlSAwAB927e93Paw0ndXBjbw
         ZixZN6HbxUR13ZGebpyu1s58upTW5yyfsKWsZVdBNlJu+6hLgdwo3t6Q9Ihl1QR7QwIY
         efPsddSqqjwivFTQdqNnpXci//IT4ROWwsf7k=
Message-ID: <4C699455.6020200@pobox.com>
Date: Mon, 16 Aug 2010 15:41:09 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Tejun Heo <tj@kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.35 libata support for > 512 byte sectors (e.g. 4K
 Native)
References: <AANLkTikSSmP5f1csa=xPTR=EqY4D5a=6t2oDVkZ7cA-v@mail.gmail.com> <CAC4B8726E86A142B27A9E9A2F2F12470149041A4E@rrsmsx505.amr.corp.intel.com> <AANLkTik4RNvaE5OrFq3NmZ+-9DKhAAaNQ3cdPg38zOr2@mail.gmail.com>
In-Reply-To: <AANLkTik4RNvaE5OrFq3NmZ+-9DKhAAaNQ3cdPg38zOr2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 03:17 PM, Grant Grundler wrote:
> On Sat, Aug 14, 2010 at 9:37 PM, Wilcox, Matthew R
> <matthew.r.wilcox@intel.com>  wrote:
>> If you will insist on sending to my Outlook address, you'll get replies in standard broken Outlook format.  You've been warned.
>
> You trumped my Gmail warning. I fold. :)
>
>>
>> ---
>>
>> +/* BUG: Big endian systems need accesses to "id" wrapped with le16_to_cpu().
>> + */
>>
>> No, it's already been converted.  See ata_dev_read_id().
>
> Ah - good. I'll remove the comment.
>
>>
>> I'm not sure about your use of a switch to set the sector size.  Have you checked the code that GCC generates for this?
>
> The switch probably sucks unless we could weight the order of the
> tests. E.g. common cases first. But it's just an implementation detail
> that is relatively easy to replace with the bitmap you had implemented
> before.
>
>>
>> All the places you dereference dev->sdev are within a callchain from ->queuecommand; sdev can't possibly go away.
>> It'd be clearer that this is the case if you used scmd->device->sector_size instead of dev->sdev->sector_size.
>
> Thank you - that looks much better to me too.
>
>> --
>>
>> @@ -516,7 +515,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
>>         memset(scsi_cmd, 0, sizeof(scsi_cmd));
>>
>>         if (args[3]) {
>> -               argsize = SECTOR_SIZE * args[3];
>> +               argsize = ATA_SECT_SIZE * args[3];
>>                 argbuf = kmalloc(argsize, GFP_KERNEL);
>>                 if (argbuf == NULL) {
>>                         rc = -ENOMEM;
>>
>> I think this is wrong.  The ioctl does PIO Data-in; as such, it should use the native sector size, not 512.
>> That said, there's a possibility of data corruption for programs which use this ioctl, assuming a 512-byte sector size when it's natively 4k.
>> This one's tricky and needs serious thought.  I might error it if sector_size isn't 512 bytes :-)
>> It's a legacy ioctl anyway, right?
>
> I have no idea. If it's tricky, I probably have it wrong.
> Anyone else have guidance here?

The main question is whether the size of a DRQ block changes, when LBA 
logical size changes?  I need to review the ATA8 specs in this area, but 
I would think some interfaces that return 512-byte pages for things like 
SMART info would be unchanged.  How do the drives behave for 
PIO-Data-{In,Out} commands that are not reading/writing user data, but 
rather drive metadata?

	Jeff



