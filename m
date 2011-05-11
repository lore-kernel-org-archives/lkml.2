Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1EKQn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:43:26 -0400
Received: from smtp.nokia.com ([147.243.128.24]:23926 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab1EKQnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:43:24 -0400
Message-ID: <4DCA3F90.1080208@nokia.com>
Date: Wed, 11 May 2011 10:49:36 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: ext Michal Nazarewicz <mina86@mina86.com>
CC: <gregkh@suse.de>, <stern@rowland.harvard.edu>, <sshtylyov@mvista.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com> <1302015569-9668-2-git-send-email-roger.quadros@nokia.com> <op.vtg1yhef3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vtg1yhef3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.36.192]
X-OriginalArrivalTime: 11 May 2011 07:47:02.0419 (UTC) FILETIME=[9D920E30:01CC0FAF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like I somehow missed this mail.

On 04/05/2011 06:43 PM, ext Michal Nazarewicz wrote:
> On Tue, 05 Apr 2011 16:59:27 +0200, Roger Quadros <roger.quadros@nokia.com> wrote:
>> --- a/drivers/usb/gadget/storage_common.c
>> +++ b/drivers/usb/gadget/storage_common.c
>
>> +static int fsg_get_toc(struct fsg_lun *curlun, int msf, int format, u8 *buf)
>> +{
>> + int i, len;
>> + switch (format) {
>> + case 0:
>> + /* Formatted TOC */
>> + len = 4 + 2*8; /* 4 byte header + 2 descriptors */
>> + memset(buf, 0, len);
>> + buf[1] = len - 2; /* TOC Length excludes length field */
>> + buf[2] = 1; /* First track number */
>> + buf[3] = 1; /* Last track number */
>> + buf[5] = 0x16; /* Data track, copying allowed */
>> + buf[6] = 0x01; /* Only track is number 1 */
>> + store_cdrom_address(&buf[8], msf, 0);
>> +
>> + buf[13] = 0x16; /* Lead-out track is data */
>> + buf[14] = 0xAA; /* Lead-out track number */
>> + store_cdrom_address(&buf[16], msf, curlun->num_sectors);
>> + return len;
>> + break;
>
> Useless break. Or, you could put "return len;" at the end of the function.
>
Yes I will fix this.

>> +
>> + case 2:
>> + /* Raw TOC */
>> + len = 4 + 3*11; /* 4 byte header + 3 descriptors */
>> + memset(buf, 0, len); /* Header + A0, A1 & A2 descriptors */
>> + buf[1] = len - 2; /* TOC Length excludes length field */
>> + buf[2] = 1; /* First complete session */
>> + buf[3] = 1; /* Last complete session */
>> +
>> + buf += 4;
>> + /* fill in A0, A1 and A2 points */
>> + for (i = 0; i < 3; i++) {
>> + buf[0] = 1; /* Session number */
>> + buf[1] = 0x16; /* Data track, copying allowed */
>> + /* 2 - Track number 0 -> TOC */
>> + buf[3] = 0xA0 + i; /* A0, A1, A2 point */
>> + /* 4, 5, 6 - Min, sec, frame is zero */
>> + buf[8] = 1; /* Pmin: last track number */
>> + buf += 11; /* go to next track descriptor */
>> + }
>> + buf -= 11; /* go back to A2 descriptor */
>> +
>> + /* For A2, 7, 8, 9, 10 - zero, Pmin, Psec, Pframe of Lead out */
>> + store_cdrom_address(&buf[7], msf, curlun->num_sectors);
>> + return len;
>> + break;
>
> Same here.

ok

>
>> + default:
>> + /* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
>> + return -EINVAL;
>
> Can we fall back to the old behaviour here?

What old behaviour? I didn't understand.

>
>> + break;
>
> And here.
>
>> + }
>> +}
>


-- 
regards,
-roger
