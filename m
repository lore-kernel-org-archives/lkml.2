Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1CUP0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:26:35 -0400
Received: from smtp.nokia.com ([147.243.128.24]:58915 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1CUP0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:26:33 -0400
Message-ID: <4D876ECA.4010503@nokia.com>
Date: Mon, 21 Mar 2011 17:29:14 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <Pine.LNX.4.44L0.1103211017240.1978-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103211017240.1978-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.37.109]
X-OriginalArrivalTime: 21 Mar 2011 15:26:16.0676 (UTC) FILETIME=[521EC240:01CBE7DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 04:20 PM, ext Alan Stern wrote:
> On Mon, 21 Mar 2011, Roger Quadros wrote:
>
>> From: Roger Quadros<roger.quadros@nokia.com>
>>
>> fsg_get_toc can be used by both storage gadgets to build a CD-ROM
>> Table of Contents which can be used as data for READ_TOC command.
>> Currently fsg_get_toc supports two TOC formats, i.e.
>> format 0: Formatted TOC and format 2: Raw TOC.
>>
>> Raw TOC is required for CD-ROM emulation to work with Mac OS-X.
>>
>> Signed-off-by: Roger Quadros<roger.quadros@nokia.com>
>> ---
>>   drivers/usb/gadget/storage_common.c |   68 +++++++++++++++++++++++++++++++++++
>>   1 files changed, 68 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
>> index b015561..d47f148 100644
>> --- a/drivers/usb/gadget/storage_common.c
>> +++ b/drivers/usb/gadget/storage_common.c
>> @@ -655,6 +655,74 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
>>   	}
>>   }
>>
>> +/**
>> + * fsg_get_toc() - Builds a TOC with required format @format.
>> + * @curlun: The LUN for which the TOC has to be built
>> + * @msf: Min Sec Frame format or LBA format for address
>> + * @format: TOC format code
>> + * @buf: The buffer into which the TOC is built
>> + *
>> + * Builds a Table of Content which can be used as data for READ_TOC command.
>> + * The TOC simulates a single session, single track CD-ROM mode 1 disc.
>> + *
>> + * Returns number of bytes written to @buf, -EINVAL if format not supported.
>> + */
>> +static int fsg_get_toc(struct fsg_lun *curlun, int msf, int format, u8 *buf)
>> +{
>> +	int i, len;
>> +	switch (format) {
>> +	case 0:
>> +		/* Formatted TOC */
>> +		len = 4 + 2*8;		/* 4 byte header + 2 descriptors */
>> +		memset(buf, 0, len);
>> +		len -= 2;		/* TOC Length excludes length field */
>> +		buf[1] = len;		/* TOC data length */
>
> These two lines are wrong.  You should do:
>
> 		buf[1] = len - 2;	/* TOC data length excludes header */
>
> The way it is now, the function ends up returning 18 instead of 20,
> causing the wrong amount of data to be transmitted.

Yes indeed.

>
>> +		buf[2] = 1;		/* First track number */
>> +		buf[3] = 1;		/* Last track number */
>> +		buf[5] = 0x16;		/* Data track, copying allowed */
>> +		buf[6] = 0x01;		/* Only track is number 1 */
>> +		store_cdrom_address(&buf[8], msf, 0);
>> +
>> +		buf[13] = 0x16;		/* Lead-out track is data */
>> +		buf[14] = 0xAA;		/* Lead-out track number */
>> +		store_cdrom_address(&buf[16], msf, curlun->num_sectors);
>> +		return len;
>> +		break;
>> +
>> +	case 2:
>> +		/* Raw TOC */
>> +		len = 4 + 3*11;		/* 4 byte header + 3 descriptors */
>> +		memset(buf, 0, len);	/* Header + A0, A1&  A2 descriptors */
>> +		len -= 2;		/* TOC Length excludes length field */
>> +		buf[1] = len;		/* TOC data length */
>
> Same thing here.  I'm surprised it worked during testing.  Did you
> really check to see that the correct data was being sent?

I too am surprised. I tried playing a few videos without problems.
After you pointed out the problem I ran a checksum on the files and they match!!

But thanks for pointing out, I'll send a new patch.

-- 
regards,
-roger
