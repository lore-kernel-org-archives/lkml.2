Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab1LFOwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:52:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab1LFOwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:52:44 -0500
MIME-Version: 1.0
In-Reply-To: <201112061441.25822.arnd@arndb.de>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
	<201112061255.56136.arnd@arndb.de>
	<CACVXFVPYUY-vpeoKJKX2XN7-0w+=seW0u3EaP=hD9m1Sy7nkTQ@mail.gmail.com>
	<201112061441.25822.arnd@arndb.de>
Date: Tue, 6 Dec 2011 22:52:41 +0800
Message-ID: <CACVXFVO8Uk808J9HgVv6ernd4x_QwN3YsAaERF=W8F=NQrLwQw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
From: Ming Lei <ming.lei@canonical.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 10:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 06 December 2011, Ming Lei wrote:
>> > Using an array added to the end of the v4l2_fd_result structure
>> > rather than a pointer would really make this easier IMHO.
>>
>> I have tried to do this, but video_usercopy needs a few changes
>> to handle array args if no indirect pointer is passed to kernel.
>
> Ah, I see. Or you would have to encode the array size into the
> ioctl command, which is also ugly in a different way.
>
>> I am not sure if media guys are happy to accept the changes, :-)
>
> Maybe Mauro can comment on which solution he prefers then, given
> the choice between:
>
> 1. adding another handler in drivers/media/video/v4l2-compat-ioctl32.c
>
> 2. passing a pointer that is casted to __u64 in user space an back
>   in the kernel
>
> 3. extending video_usercopy in some way to make this work, preferably
>   in a generic way.

Maybe this one is a good choice, and I think that it is worthy to
support the below kind of array parameter:

struct v4l2_fd_result {
	__u32   buf_index;
	__u32   face_cnt;
	__u32   reserved[6];
	struct v4l2_fd_detection fd[];
};

and it is not difficult to implement it in a generic way so that new
array parameters can be supported as 64/32 compatible.

> 4. using a variable command number like
>   #define VIDIOC_G_FD_RESULT(num)      _IOC(_IOC_READ|_IOC_WRITE,'V', 95, \
>                sizeof(struct v4l2_fd_result) + (num) * sizeof(struct v4l2_fd_detection)
>
> 5. requiring the interface to be simplified to return only a single
>   struct v4l2_fd_detection at a time

Maybe this one is not user friendly since other v4l2 interfaces provide
array parameters way, :-)

> I agree that none of these are nice. My preferred option would be last one,
> but I don't know how performance critical the interface is or if it would
> cause any races that you want to avoid.


thanks,
--
Ming Lei
