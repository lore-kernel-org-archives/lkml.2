Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1CVOOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:14:47 -0400
Received: from smtp.nokia.com ([147.243.128.26]:43387 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1CVOOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:14:44 -0400
Message-ID: <4D88AF6F.4050508@nokia.com>
Date: Tue, 22 Mar 2011 16:17:19 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
References: <1300705159-24386-1-git-send-email-roger.quadros@nokia.com> <1300705159-24386-2-git-send-email-roger.quadros@nokia.com> <1300705159-24386-3-git-send-email-roger.quadros@nokia.com>
In-Reply-To: <1300705159-24386-3-git-send-email-roger.quadros@nokia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.23.108]
X-OriginalArrivalTime: 22 Mar 2011 14:14:24.0677 (UTC) FILETIME=[7261AD50:01CBE89B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/21/2011 12:59 PM, ext Roger Quadros wrote:
> @@ -1703,18 +1705,21 @@ static int do_read_toc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>   		return -EINVAL;
>   	}
>
> -	memset(buf, 0, 20);
> -	buf[1] = (20-2);		/* TOC data length */
> -	buf[2] = 1;			/* First track number */
> -	buf[3] = 1;			/* Last track number */
> -	buf[5] = 0x16;			/* Data track, copying allowed */
> -	buf[6] = 0x01;			/* Only track is number 1 */
> -	store_cdrom_address(&buf[8], msf, 0);
> +	format = fsg->cmnd[2]&  0xf;
> +	/*
> +	 * Check if CDB is old style SFF-8020i
> +	 * i.e. format is in 2 MSBs of byte 9
> +	 * Mac OS-X host sends us this.
> +	 */
> +	if (format == 0)
> +		format = (fsg->cmnd[9]>>  6)&  0x3;
>
> -	buf[13] = 0x16;			/* Lead-out track is data */
> -	buf[14] = 0xAA;			/* Lead-out track number */
> -	store_cdrom_address(&buf[16], msf, curlun->num_sectors);
> -	return 20;
> +	ret = fsg_get_toc(curlun, msf, format, buf);
> +	if (ret<  0) {
> +		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
> +		return -EINVAL;
> +	}
> +	return ret;
>   }


I have a question here.

The host can request us to send less or more than the actual TOC size, since it 
has no clue how big it is.
e.g. Linux host requests us to send only 12 bytes even though our formatted TOC 
length is 20. In this case should we return fsg->data_size_from_cmnd instead of 
actual TOC length?

e.g. Mac requests us to send 65534 bytes but our RAW TOC length is 37.
The file storage driver seems to be zero padding our data response. So we 
respond with 65534 bytes, 37 of TOC and remaining zero padded.

Can we do something like this to avoid unnecessary zero padded transfers?

         ret = fsg_get_toc(curlun, msf, format, buf);
         if (ret < 0) {
                 curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
                 return -EINVAL;
         } else if (ret > fsg->data_size_from_cmnd) {
                 ret = fsg->data_size_from_cmnd;
         } else {
                 fsg->residue = ret;
         }
         return ret;

-- 
regards,
-roger
