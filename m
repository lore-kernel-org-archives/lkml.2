Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0GTTNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:13:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50377 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0GTTNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:13:44 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 20 Jul 2010 21:14:58 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
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
Message-id: <op.vf5o28st7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 20:15:24 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:

> On Tue, 2010-07-20 at 17:51 +0200, Michal Nazarewicz wrote:
>> +** Use cases
>> +
>> +    Lets analyse some imaginary system that uses the CMA to see how
>> +    the framework can be used and configured.
>> +
>> +
>> +    We have a platform with a hardware video decoder and a camera
>> each
>> +    needing 20 MiB of memory in worst case.  Our system is written in
>> +    such a way though that the two devices are never used at the same
>> +    time and memory for them may be shared.  In such a system the
>> +    following two command line arguments would be used:
>> +
>> +        cma=r=20M cma_map=video,camera=r
>
> This seems inelegant to me.. It seems like these should be connected
> with the drivers themselves vs. doing it on the command like for
> everything. You could have the video driver declare it needs 20megs, and
> the the camera does the same but both indicate it's shared ..
>
> If you have this disconnected from the drivers it will just cause
> confusion, since few will know what these parameters should be for a
> given driver set. It needs to be embedded in the kernel.

I see your point but the problem is that devices drivers don't know the
rest of the system neither they know what kind of use cases the system
should support.


Lets say, we have a camera, a JPEG encoder, a video decoder and
scaler (ie. devices that scales raw image).  We want to support the
following 3 use cases:

1. Camera's output is scaled and displayed in real-time.
2. Single frame is taken from camera and saved as JPEG image.
3. A video file is decoded, scaled and displayed.

What is apparent is that camera and video decoder are never running
at the same time.  The same situation is with JPEG encoder and scaler.
 From this knowledge we can construct the following:

   cma=a=10M;b=10M cma_map=camera,video=a;jpeg,scaler=b

This may be a silly example but it shows that the configuration of
memory regions and device->regions mapping should be done after
some investigation rather then from devices which may have not enough
knowledge.


One of the purposes of the CMA framework is to make it let device
drivers completely forget about the memory management and enjoy
a simple API.


CMA core has a cma_defaults() function which can be called from
platform initialisation code.  It makes it easy to provide default
values for the cma and cma_map parameters.  This makes it possible
to provide a default which will work in many/most cases even if
user does not provide custom cma and/or cma_map parameters.


Having said that, some way of letting device drivers request
a region if one has not been defined for them may be a good idea.
I'll have to think about it...

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
