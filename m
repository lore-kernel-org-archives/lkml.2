Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0GUMAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:00:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41604 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0GUMA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:00:28 -0400
Date: Wed, 21 Jul 2010 14:01:47 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Message-id: <op.vf6zo9vb7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
 <op.vf5o28st7p4s8u@pikus>
 <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 21:38:18 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:

> On Tue, 2010-07-20 at 21:14 +0200, Michał Nazarewicz wrote:
>> On Tue, 20 Jul 2010 20:15:24 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:
>>
>> > On Tue, 2010-07-20 at 17:51 +0200, Michal Nazarewicz wrote:
>> >> +** Use cases
>> >> +
>> >> +    Lets analyse some imaginary system that uses the CMA to see how
>> >> +    the framework can be used and configured.
>> >> +
>> >> +
>> >> +    We have a platform with a hardware video decoder and a camera
>> >> each
>> >> +    needing 20 MiB of memory in worst case.  Our system is written in
>> >> +    such a way though that the two devices are never used at the same
>> >> +    time and memory for them may be shared.  In such a system the
>> >> +    following two command line arguments would be used:
>> >> +
>> >> +        cma=r=20M cma_map=video,camera=r
>> >
>> > This seems inelegant to me.. It seems like these should be connected
>> > with the drivers themselves vs. doing it on the command like for
>> > everything. You could have the video driver declare it needs 20megs, and
>> > the the camera does the same but both indicate it's shared ..
>> >
>> > If you have this disconnected from the drivers it will just cause
>> > confusion, since few will know what these parameters should be for a
>> > given driver set. It needs to be embedded in the kernel.
>>
>> I see your point but the problem is that devices drivers don't know the
>> rest of the system neither they know what kind of use cases the system
>> should support.
>>
>>
>> Lets say, we have a camera, a JPEG encoder, a video decoder and
>> scaler (ie. devices that scales raw image).  We want to support the
>> following 3 use cases:
>>
>> 1. Camera's output is scaled and displayed in real-time.
>> 2. Single frame is taken from camera and saved as JPEG image.
>> 3. A video file is decoded, scaled and displayed.
>>
>> What is apparent is that camera and video decoder are never running
>> at the same time.  The same situation is with JPEG encoder and scaler.
>>  From this knowledge we can construct the following:
>>
>>    cma=a=10M;b=10M cma_map=camera,video=a;jpeg,scaler=b
>
> It should be implicit tho. If the video driver isn't using the memory
> then it should tell your framework that the memory is not used. That way
> something else can use it.

What you are asking for is:

	cma=a=100M cma_map=*/*=a

All devices will share the same region so that "if the video driver isn't
using the memory" then "something else can use it". (please excuse me quoting
you, it was stronger then me ;) ).

Driver has to little information to say whether it really stopped using
memory.  Maybe the next call will be to allocate buffers for frames and
initialise the chip?  Sure, some “good enough” defaults can be provided
(and the framework allows that) but still platform architect might need
more power.

> (btw, these strings your creating yikes, talk about confusing ..)

They are not that scary really.  Let's look at cma:

	a=10M;b=10M

Split it on semicolon:

	a=10M
	b=10M

and you see that it defines two regions (a and b) 10M each.

As of cma_map:

	camera,video=a;jpeg,scaler=b

Again split it on semicolon:

	camera,video=a
	jpeg,scaler=b

Now, substitute equal sign by "use(s) region(s)":

	camera,video	use(s) region(s):	a
	jpeg,scaler	use(s) region(s):	b

No black magic here. ;)

>> One of the purposes of the CMA framework is to make it let device
>> drivers completely forget about the memory management and enjoy
>> a simple API.
>
> The driver, and it's maintainer, are really the best people to know how
> much memory they need and when it's used/unused. You don't really want
> to architect them out.

This might be true if there is only one device but even then it's not
always the case.  If many devices need physically-contiguous memory
there is no way for them to communicate and share memory.  For best
performance someone must look at them and say who gets what.

Still, with updated version it will be possible for drivers to use
private regions.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
