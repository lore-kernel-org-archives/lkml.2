Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2GKHDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:03:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10860 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2GKHDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:03:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Jul 2012 00:03:30 -0700
Message-ID: <4FFD2531.2090503@nvidia.com>
Date: Wed, 11 Jul 2012 12:33:13 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Scan Subscription <scan-subscription@coverity.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
References: <Pine.LNX.4.44L0.1207091028200.1954-100000@iolanthe.rowland.org> <4FFBAEFF.5060407@nvidia.com>,<20120710144554.GC15912@kroah.com> <829BE905228AE14A9AE1A46E6F2E371605542A19B5@VA3DIAXVS891.RED001.local>
In-Reply-To: <829BE905228AE14A9AE1A46E6F2E371605542A19B5@VA3DIAXVS891.RED001.local>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 10:05 PM, Scan Subscription wrote:
> Hi Greg/Venu/Alan and others,
>
> The defect discussed in this thread was found in 2006, and was marked in Coverity Scan as false positive - intentional ( by linux developer or coverity admin that we don't know)...
>
> As a general rule,
> 1. what was discussed with some of the Linux folks, Focus on NEW defects...
> 2. Do NOT fix anything that is already marked as Intentional /False Positive
>
>
> For any defects found by Covierty Scan there could be potential 3 actions
> 1. Review and Fix the defect
> 2. Mark it as Intentional in Coverity Scan, and it will not appear as Defect in the future
> 3. Contact Coverity Scan-admin, if you would like to understand it more why it was flagged as defect.
>
> • As we all know, inherent in the technology foundation, static analysis will report some false positives. We put a lot of effort into our product to drive this rate to a very low, acceptable limit (commonly between 5% and 25%)
> • In order to address FPs, the SCAN part of our product offers a triage process that utilizes a persistent database based on defect hashing. This gives developers the option to declare a defect as FP and then never have to look at it again.
>
> For instance, 3 weeks ago, Coverity reported 7 new defects introduced based on recent code changes,  and as we can see in the various threads almost everything was fixed and committed by maintainer.
> But a  week after that, out of 6 new defects reported based on latest code change, 1 was ignored stating False positive, Intentional...
>
> I hope this clarifies the issue that was discussed here.

Thanks for your detailed mail.


> Thanks
>
> Coverity Scan-admin scan-admin@coverity.com
> Dakshesh Vyas | Technical Manager - SCAN
> Coverity | 185 Berry Street | Suite 6500, Lobby 3 | San Francisco, CA  94107
> Office: 415.935.2957 | dvyas@coverity.com
>
>
> ________________________________________
> From: linux-kernel-owner@vger.kernel.org [linux-kernel-owner@vger.kernel.org] On Behalf Of gregkh@linuxfoundation.org [gregkh@linuxfoundation.org]
> Sent: Tuesday, July 10, 2012 7:45 AM
> To: Venu Byravarasu
> Cc: Alan Stern; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
>
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
>>>      /* for each uframe with a packet */
>>>      for (uframe = 0; uframe < 8; uframe++) {
>>> @@ -1783,7 +1784,8 @@ itd_complete (
>>>                      dev->devpath, stream->bEndpointAddress & 0x0f,
>>>                      (stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
>>>      }
>>> -    iso_stream_put (ehci, stream);
>>> +    stream_ref_count = stream->refcount;
>>> +    iso_stream_put(ehci, stream);
>>> This iso_stream_put removes the reference held by the URB.  Before it
>>> is called, stream->refcount must be >= 3:
>>>
>>>      refcount is set to 1 when the stream is created;
>>>
>>>      each active URB holds a reference;
>>>
>>>      each itd holds a reference.
>>>
>>> So after the call, the refcount value must be >= 2 and the stream could
>>> not have been deallocated.
>>>
>>>>   done:
>>>>     itd->urb = NULL;
>>>> @@ -1797,7 +1799,7 @@ done:
>>>>              * Move it to a safe place until a new frame starts.
>>>>              */
>>>>             list_move(&itd->itd_list, &ehci->cached_itd_list);
>>>> -           if (stream->refcount == 2) {
>>>> +           if (stream_ref_count == 3) {
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


