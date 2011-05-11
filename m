Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1EKPs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:48:58 -0400
Received: from smtp.nokia.com ([147.243.1.47]:39393 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1EKPs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:56 -0400
Message-ID: <4DCA4043.40005@nokia.com>
Date: Wed, 11 May 2011 10:52:35 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: ext Michal Nazarewicz <mina86@mina86.com>
CC: <gregkh@suse.de>, <stern@rowland.harvard.edu>, <sshtylyov@mvista.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com> <1302015569-9668-3-git-send-email-roger.quadros@nokia.com> <op.vtg12opj3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vtg12opj3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.21.36.192]
X-OriginalArrivalTime: 11 May 2011 07:50:14.0251 (UTC) FILETIME=[0FE94BB0:01CC0FB0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 06:45 PM, ext Michal Nazarewicz wrote:
> On Tue, 05 Apr 2011 16:59:28 +0200, Roger Quadros <roger.quadros@nokia.com> wrote:
>> --- a/drivers/usb/gadget/file_storage.c
>> +++ b/drivers/usb/gadget/file_storage.c
>> @@ -1703,18 +1705,21 @@ static int do_read_toc(struct fsg_dev *fsg, struct
>> fsg_buffhd *bh)
>> return -EINVAL;
>> }
>> - memset(buf, 0, 20);
>> - buf[1] = (20-2); /* TOC data length */
>> - buf[2] = 1; /* First track number */
>> - buf[3] = 1; /* Last track number */
>> - buf[5] = 0x16; /* Data track, copying allowed */
>> - buf[6] = 0x01; /* Only track is number 1 */
>> - store_cdrom_address(&buf[8], msf, 0);
>> + format = fsg->cmnd[2] & 0xf;
>> + /*
>> + * Check if CDB is old style SFF-8020i
>> + * i.e. format is in 2 MSBs of byte 9
>> + * Mac OS-X host sends us this.
>> + */
>> + if (format == 0)
>> + format = (fsg->cmnd[9] >> 6) & 0x3;
>> - buf[13] = 0x16; /* Lead-out track is data */
>> - buf[14] = 0xAA; /* Lead-out track number */
>> - store_cdrom_address(&buf[16], msf, curlun->num_sectors);
>> - return 20;
>> + ret = fsg_get_toc(curlun, msf, format, buf);
>> + if (ret < 0) {
>> + curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
>> + return -EINVAL;
>> + }
>
> I'd drop the “return -EINVAL;” and let “return ret;” below handle it.
> This obviously also apply to patch to f_mass_storage.c (BTW. I would
> merge the two patches).

OK, I will fix this.
>
>> + return ret;
>> }
>
Thanks for review.

-- 
regards,
-roger
