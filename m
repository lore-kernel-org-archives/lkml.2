Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1CVOg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:36:57 -0400
Received: from smtp.nokia.com ([147.243.1.47]:36860 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab1CVOgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:36:54 -0400
Message-ID: <4D88B490.9060606@nokia.com>
Date: Tue, 22 Mar 2011 16:39:12 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
References: <Pine.LNX.4.44L0.1103221022340.2292-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103221022340.2292-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.23.108]
X-OriginalArrivalTime: 22 Mar 2011 14:36:17.0755 (UTC) FILETIME=[81097AB0:01CBE89E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 04:26 PM, ext Alan Stern wrote:
> On Tue, 22 Mar 2011, Roger Quadros wrote:
>
>> I have a question here.
>>
>> The host can request us to send less or more than the actual TOC size, since it
>> has no clue how big it is.
>> e.g. Linux host requests us to send only 12 bytes even though our formatted TOC
>> length is 20. In this case should we return fsg->data_size_from_cmnd instead of
>> actual TOC length?
>
> No.  Always return the actual TOC length.

OK.

>
>> e.g. Mac requests us to send 65534 bytes but our RAW TOC length is 37.
>> The file storage driver seems to be zero padding our data response. So we
>> respond with 65534 bytes, 37 of TOC and remaining zero padded.
>>
>> Can we do something like this to avoid unnecessary zero padded transfers?
>>
>>           ret = fsg_get_toc(curlun, msf, format, buf);
>>           if (ret<  0) {
>>                   curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
>>                   return -EINVAL;
>>           } else if (ret>  fsg->data_size_from_cmnd) {
>>                   ret = fsg->data_size_from_cmnd;
>>           } else {
>>                   fsg->residue = ret;
>>           }
>>           return ret;
>
> Not needed (and not correct).  The code at the end of do_scsi_command()
> already does this:
>
> 		reply = min((u32) reply, fsg->data_size_from_cmnd);
> 		...
> 		fsg->residue -= reply;
>

Oh yes, this explains why to return the actual TOC length in do_read_toc().

However, if host asked for data more than the TOC length then residue will be 
greater than zero and this will result in zero padded transfers.

Not a big issue but should we be fixing it?

one way could be to set fsg->residue to actual TOC length. in do_read_toc().

-- 
regards,
-roger
