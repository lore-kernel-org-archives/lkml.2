Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1CIOG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:06:29 -0500
Received: from smtp.nokia.com ([147.243.128.26]:23802 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab1CIOG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:06:26 -0500
Message-ID: <4D7789F2.7000203@nokia.com>
Date: Wed, 9 Mar 2011 16:08:50 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Sergei Shtylyov <sshtylyov@mvista.com>
CC: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1299673300-16726-1-git-send-email-roger.quadros@nokia.com> <1299673300-16726-2-git-send-email-roger.quadros@nokia.com> <4D77836D.30009@ru.mvista.com>
In-Reply-To: <4D77836D.30009@ru.mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.24.199]
X-OriginalArrivalTime: 09 Mar 2011 14:06:10.0354 (UTC) FILETIME=[245F3920:01CBDE63]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/09/2011 03:41 PM, ext Sergei Shtylyov wrote:
> Hello.
>
>> --- a/drivers/usb/gadget/storage_common.c
>> +++ b/drivers/usb/gadget/storage_common.c
>> @@ -655,6 +655,85 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
>> }
>> }
>>
>> +/*
>
> The kerneldoc comments should start with "/**".

OK.

>
>> + * put_toc() - Builds a TOC with required format @format.
>
> The function is called gsg_get_toc, isn't it?

Yes :). My initial version was named put_toc(). will correct it.

>
>> + * @curlun: The LUN for which the TOC has to be built
>> + * @msf: Min Sec Frame format or LBA format for address
>> + * @format: TOC format code
>> + * @buf: the buffer into which the TOC is built
>> + *
>> + * Builds a Table of Content which can be used as data for READ_TOC command.
>> + * The TOC simulates a single session, single track CD-ROM mode 1 disc.
>> + *
>> + * Returns number of bytes written to @buf, -EINVAL if format not supported.
>> + */
>> +static int fsg_get_toc(struct fsg_lun *curlun, int msf, int format, u8 *buf)
>> +{
>> + switch (format) {
>> + case 0:
>> + /* Formatted TOC */
>> + memset(buf, 0, 20);
>> + buf[1] = (20-2); /* TOC data length */
>
> Parens not needed here. And kernel style assumes putting spacves around operators.

I copied case 0: code from file_storage.c. But will correct it.
>
>> + buf[2] = 1; /* First track number */
>> + buf[3] = 1; /* Last track number */
>> + buf[5] = 0x16; /* Data track, copying allowed */
>> + buf[6] = 0x01; /* Only track is number 1 */
>> + store_cdrom_address(&buf[8], msf, 0);
>> +
>> + buf[13] = 0x16; /* Lead-out track is data */
>> + buf[14] = 0xAA; /* Lead-out track number */
>> + store_cdrom_address(&buf[16], msf, curlun->num_sectors);
>> + return 20;
>> + break;
>> +
>> + case 2:
>> + /* Raw TOC */
>> + memset(buf, 0, 37); /* Header + A0, A1& A2 descriptors */
>> + buf[1] = 37; /* 4 + 3*11 */
>> + buf[2] = 1; /* First complete session */
>> + buf[3] = 2; /* Last complete session */
>> +
>> + buf += 4;
>> + /* A0 point */
>> + buf[0] = 1; /* Session number */
>> + buf[1] = 0x16; /* Data track, copying alowed */
>> + /* 2 - Track number 0 -> TOC */
>> + buf[3] = 0xA0; /* Point A0 */
>> + /* 4, 5, 6 - Min, sec, frame is zero */
>> + /* 7 - zero */
>> + buf[8] = 1; /* Pmin: 1st track number */
>> + /* 9 - disc type 0: CD-ROM/DA with 1st track in mode 1 */
>> + /* 10 - pframe 0 */
>> +
>> + buf += 11;
>> + /* A1 point*/
>> + buf[0] = 1; /* Session number */
>> + buf[1] = 0x16; /* Data track, copying alowed */
>> + /* 2 - Track number 0 -> TOC */
>> + buf[3] = 0xA1; /* Point A1 */
>> + /* 4, 5, 6 - Min, sec, frame is zero */
>> + /* 7, zero */
>> + buf[8] = 1; /* Pmin: last track number */
>> + /* 9, 10 - pmin and pframe are 0 */
>
> The above code is repetitive -- might be worth factoring out into a function.
>
I would leave it as it is as nobody else would use the function.

> OK, but where this function is called from?
>
from file_storage.c and f_mass_storage.c in the next two patches of this series.

-- 
regards,
-roger
