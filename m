Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1CWISK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:18:10 -0400
Received: from smtp.nokia.com ([147.243.1.48]:25838 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab1CWISH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:18:07 -0400
Message-ID: <4D89AD56.1080602@nokia.com>
Date: Wed, 23 Mar 2011 10:20:38 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
References: <Pine.LNX.4.44L0.1103221044370.2292-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103221044370.2292-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.24.38]
X-OriginalArrivalTime: 23 Mar 2011 08:17:43.0410 (UTC) FILETIME=[C8A53D20:01CBE932]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 05:13 PM, ext Alan Stern wrote:
> On Tue, 22 Mar 2011, Roger Quadros wrote:
>
>> However, if host asked for data more than the TOC length then residue will be
>> greater than zero and this will result in zero padded transfers.
>>
>> Not a big issue but should we be fixing it?
>>
>> one way could be to set fsg->residue to actual TOC length. in do_read_toc().
>
> The current behavior is required by the the Bulk-Only Transport
> specification.  The spec says (section 6.7.2, case (4) or (5)):
>
> If the device intends to send less data than the host indicated, then:
>      The device shall send the intended data.
> 	The device may send fill data to pad up to a total of
> 	dCBWDataTransferLength.
> 	If the device actually transfers less data than the host indicated,
> 	then:
> 	    The device may end the transfer with a short packet.
> 	    The device shall STALL the Bulk-In pipe.
>
> You're loading the mass-storage gadget with the "stall=n" module
> parameter, right?  Therefore the driver is not allowed to halt the

Yes i'm loading it with "stall=n".

> Bulk-In endpoint, and therefore the driver is not allowed to send less
> data than the host indicated, which means the data has to be padded.

Thanks. i got it now.

>
> On the other hand, I don't think any implementations would get upset if
> we simply ended the transfer with a short packet instead of adhering
> strictly to the spec.
>
> The patch below should do what you want.  I haven't tested it.

I tried your patch with the CD-ROM implementation and it works perfectly. I do 
not see the unnecessary zero padded transfers any more.

Do you think we should have this patch in? with the risk of not strictly 
adhering to spec for cases where controller cannot stall?

Maybe the term "controller cannot stall" itself does not adhere to bulk-only 
transport spec :).

>   static int throw_away_data(struct fsg_common *common)
>   {
>   	struct fsg_buffhd	*bh;
> @@ -1702,6 +1671,10 @@ static int finish_reply(struct fsg_commo
>   		if (common->data_size == 0) {
>   			/* Nothing to send */
>
> +		/* Don't know what to do if common->fsg is NULL */
> +		} else if (!common->fsg) {
> +			rc = -EIO;
> +
>   		/* If there's no residue, simply send the last buffer */
>   		} else if (common->residue == 0) {
>   			bh->inreq->zero = 0;
> @@ -1710,24 +1683,19 @@ static int finish_reply(struct fsg_commo
>   			common->next_buffhd_to_fill = bh->next;
>
>   		/*
> -		 * For Bulk-only, if we're allowed to stall then send the
> -		 * short packet and halt the bulk-in endpoint.  If we can't
> -		 * stall, pad out the remaining data with 0's.
> +		 * For Bulk-only, mark the end of the data with a short
> +		 * packet.  If we are allowed to stall, halt the bulk-in
> +		 * endpoint.  (Note: This violates the Bulk-Only Transport
> +		 * specification, which requires us to pad the data if we

violates the spec only if we are not allowed to stall (i.e. stall=n) right?

> +		 * don't halt the endpoint.  Presumably nobody will mind.)
>   		 */

-- 
regards,
-roger
