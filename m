Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1CJOzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:55:33 -0500
Received: from smtp.nokia.com ([147.243.128.24]:27669 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab1CJOzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:55:32 -0500
Message-ID: <4D78E61B.4020501@nokia.com>
Date: Thu, 10 Mar 2011 16:54:19 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <Pine.LNX.4.44L0.1103091057190.1965-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103091057190.1965-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 10 Mar 2011 14:54:21.0134 (UTC) FILETIME=[09D2FEE0:01CBDF33]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/09/2011 06:07 PM, ext Alan Stern wrote:
>> +	case 2:
>> +		/* Raw TOC */
>> +		memset(buf, 0, 37);	/* Header + A0, A1&  A2 descriptors */
>> +		buf[1] = 37;		/* 4 + 3*11 */
>
> According to the SFF8020i spec Table 128, TOC Data Length is 2 + 11 *
> (number of descriptors returned).  But that's probably a misprint.

It's probably right. I will fix it and verify if it works.
>
>> +		buf[2] = 1;		/* First complete session */
>> +		buf[3] = 2;		/* Last complete session */
>
> According to the spec, for drives that do not support multi-session,
> the First session number should be equal to the Last session number.
>
Right. good catch.

>
> On Wed, 9 Mar 2011, Roger Quadros wrote:
>
>> Mac OS-X expects CD-ROM TOC in raw format (i.e. format:2). It also
>> sends the READ_TOC CDB in old style SFF8020i format. i.e. 2 format bits
>> are encoded in MSBs of CDB byte 9.
>>
>> This patch will enable CD-ROM emulation to work with Mac OS-X. Tested on
>> Mac OS X v10.6.3.
>>
>> Signed-off-by: Roger Quadros<roger.quadros@nokia.com>
>> ---
>>   drivers/usb/gadget/file_storage.c |   32 +++++++++++++++++++-------------
>>   1 files changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
>> index a6eacb5..753ac94 100644
>> --- a/drivers/usb/gadget/file_storage.c
>> +++ b/drivers/usb/gadget/file_storage.c
>> @@ -1696,6 +1696,8 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>>   	int		msf = fsg->cmnd[1]&  0x02;
>>   	int		start_track = fsg->cmnd[6];
>>   	u8		*buf = (u8 *) bh->buf;
>> +	u8		format;
>> +	int		ret;
>>
>>   	if ((fsg->cmnd[1]&  ~0x02) != 0 ||		/* Mask away MSF */
>>   			start_track>  1) {
>> @@ -1703,18 +1705,22 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>>   		return -EINVAL;
>>   	}
>>
>> -	memset(buf, 0, 20);
>> -	buf[1] = (20-2);		/* TOC data length */
>> -	buf[2] = 1;			/* First track number */
>> -	buf[3] = 1;			/* Last track number */
>> -	buf[5] = 0x16;			/* Data track, copying allowed */
>> -	buf[6] = 0x01;			/* Only track is number 1 */
>> -	store_cdrom_address(&buf[8], msf, 0);
>> +	/*
>> +	 * Check if CDB is old style SFF-8020i
>> +	 * i.e. format is in 2 MSBs of byte 9
>> +	 * Mac OS-X host sends us this.
>> +	 */
>> +	format = (fsg->cmnd[9]>>  6)&  0x3;
>> +	if (format == 0)
>> +		format = fsg->cmnd[2]&  0xf;	/* new style MMC-2 */
>
> The spec says: "Format field definition: When Format in Byte 2 is zero,
> then Byte 9 is used."  This logic does not follow that description.
>

Yes indeed. I'll fix all this in v2. Thanks for review.

-- 
regards,
-roger
