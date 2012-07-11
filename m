Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2GKHGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:06:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9526 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2GKHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:06:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Jul 2012 00:02:18 -0700
Message-ID: <4FFD25CC.3050401@nvidia.com>
Date: Wed, 11 Jul 2012 12:35:48 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
References: <Pine.LNX.4.44L0.1207091028200.1954-100000@iolanthe.rowland.org> <4FFBAEFF.5060407@nvidia.com> <20120710144554.GC15912@kroah.com>
In-Reply-To: <20120710144554.GC15912@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 08:15 PM, gregkh@linuxfoundation.org wrote:
> On Tue, Jul 10, 2012 at 09:56:39AM +0530, Venu Byravarasu wrote:
>> Thanks Alan for your comments.
>>
>> On Monday 09 July 2012 08:04 PM, Alan Stern wrote:
>>> On Mon, 9 Jul 2012, Venu Byravarasu wrote:
>>>
>>>> In functions itd_complete &  sitd_complete, a pointer
>>>> by name stream may get dereferenced after freeing it, when
>>>> iso_stream_put is called with stream->refcount = 2.
>>> I don't understand the problem.  Did you actually see this happen or is
>>> it only theoretical?
>> Yes it is a theoretical problem, as complained by Coverity.
>>
>>>   	/* for each uframe with a packet */
>>>   	for (uframe = 0; uframe < 8; uframe++) {
>>> @@ -1783,7 +1784,8 @@ itd_complete (
>>>   			dev->devpath, stream->bEndpointAddress & 0x0f,
>>>   			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
>>>   	}
>>> -	iso_stream_put (ehci, stream);
>>> +	stream_ref_count = stream->refcount;
>>> +	iso_stream_put(ehci, stream);
>>> This iso_stream_put removes the reference held by the URB.  Before it
>>> is called, stream->refcount must be >= 3:
>>>
>>> 	refcount is set to 1 when the stream is created;
>>>
>>> 	each active URB holds a reference;
>>>
>>> 	each itd holds a reference.
>>>
>>> So after the call, the refcount value must be >= 2 and the stream could
>>> not have been deallocated.
>>>
>>>>   done:
>>>>   	itd->urb = NULL;
>>>> @@ -1797,7 +1799,7 @@ done:
>>>>   		 * Move it to a safe place until a new frame starts.
>>>>   		 */
>>>>   		list_move(&itd->itd_list, &ehci->cached_itd_list);
>>>> -		if (stream->refcount == 2) {
>>>> +		if (stream_ref_count == 3) {
>>> Therefore this seems unnecessary.
>> As per the logic you explained above, this change is not needed.
>> However coverity was complaining as below:
>>
>> /kernel/drivers/usb/host/ehci-sched.c 1777 USE_AFTER_FREE
>> Dereferencing freed pointer "stream"
>>
>> Hence to pacify coverity, this change is done.
> Why are you trying to "pacify" coverity, when the tool is wrong in this
> case?  Go poke the owners of that tool to get it to stop emitting this
> false warning.  Don't paper over it in the kernel.  Especially for a
> tool that none of us can run on our own.
>
> greg k-h
Thanks Greg for your comments.
In fact coverity team also mentioned this as one of the false positives.
Also as Alan mentioned that he'll be taking care of it in a different 
way, will stop working on this patch.

Thanks,
Venu

