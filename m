Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2GJE1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 00:27:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7457 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2GJE1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 00:27:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jul 2012 21:23:37 -0700
Message-ID: <4FFBAEFF.5060407@nvidia.com>
Date: Tue, 10 Jul 2012 09:56:39 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
References: <Pine.LNX.4.44L0.1207091028200.1954-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1207091028200.1954-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Alan for your comments.

On Monday 09 July 2012 08:04 PM, Alan Stern wrote:
> On Mon, 9 Jul 2012, Venu Byravarasu wrote:
>
>> In functions itd_complete &  sitd_complete, a pointer
>> by name stream may get dereferenced after freeing it, when
>> iso_stream_put is called with stream->refcount = 2.
> I don't understand the problem.  Did you actually see this happen or is
> it only theoretical?

Yes it is a theoretical problem, as complained by Coverity.

>   	/* for each uframe with a packet */
>   	for (uframe = 0; uframe < 8; uframe++) {
> @@ -1783,7 +1784,8 @@ itd_complete (
>   			dev->devpath, stream->bEndpointAddress & 0x0f,
>   			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
>   	}
> -	iso_stream_put (ehci, stream);
> +	stream_ref_count = stream->refcount;
> +	iso_stream_put(ehci, stream);
> This iso_stream_put removes the reference held by the URB.  Before it
> is called, stream->refcount must be >= 3:
>
> 	refcount is set to 1 when the stream is created;
>
> 	each active URB holds a reference;
>
> 	each itd holds a reference.
>
> So after the call, the refcount value must be >= 2 and the stream could
> not have been deallocated.
>
>>   done:
>>   	itd->urb = NULL;
>> @@ -1797,7 +1799,7 @@ done:
>>   		 * Move it to a safe place until a new frame starts.
>>   		 */
>>   		list_move(&itd->itd_list, &ehci->cached_itd_list);
>> -		if (stream->refcount == 2) {
>> +		if (stream_ref_count == 3) {
> Therefore this seems unnecessary.

As per the logic you explained above, this change is not needed.
However coverity was complaining as below:

/kernel/drivers/usb/host/ehci-sched.c 1777 USE_AFTER_FREE Dereferencing 
freed pointer "stream"

Hence to pacify coverity, this change is done.
Please let me know if you see any other better way to handle it.

>>   			/* If iso_stream_put() were called here, stream
>>   			 * would be freed.  Instead, just prevent reuse.
>>   			 */
> Alan Stern
>

Thanks,
Venu
