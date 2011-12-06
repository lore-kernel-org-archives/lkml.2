Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1LFOlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:41:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1LFOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:41:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
Date: Tue, 6 Dec 2011 14:41:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com> <201112061255.56136.arnd@arndb.de> <CACVXFVPYUY-vpeoKJKX2XN7-0w+=seW0u3EaP=hD9m1Sy7nkTQ@mail.gmail.com>
In-Reply-To: <CACVXFVPYUY-vpeoKJKX2XN7-0w+=seW0u3EaP=hD9m1Sy7nkTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112061441.25822.arnd@arndb.de>
X-Provags-ID: V02:K0:8lDbAzL9fURr4sWWlW462ogeWKHzcF73GWy/ienE/8y
 pNfa20VJwFdzjM3mA5pupVLWNXX7QttaPFUeScDOuMd2eGm0HA
 xny6M70tZxH9ItBARZLSvC8AdVyhLxw9PmN05bf5qlK3daMBTl
 BfjA2YOT+8h+9xC6FZ2hVtV7M8jEiIY/Q1yZEFTymFuCGmET3/
 JcEVVfuInth9sVVrWOtWnJp06352dYqauwJ8Ep9KRRZE1p/El/
 OJRyumOSXn5RYC3MpfIMRD66B+dusV5gq+1/YAe19Pjm2WXJoG
 cnNQoUA0/Ukt+RO0ykcnRg4HsxFyms3O+XnTRy3nVuI4760JQq
 /X6GYH+Pjlty6kU3IUJM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 December 2011, Ming Lei wrote:
> > Using an array added to the end of the v4l2_fd_result structure
> > rather than a pointer would really make this easier IMHO.
> 
> I have tried to do this, but video_usercopy needs a few changes
> to handle array args if no indirect pointer is passed to kernel.

Ah, I see. Or you would have to encode the array size into the
ioctl command, which is also ugly in a different way.

> I am not sure if media guys are happy to accept the changes, :-)

Maybe Mauro can comment on which solution he prefers then, given
the choice between:

1. adding another handler in drivers/media/video/v4l2-compat-ioctl32.c

2. passing a pointer that is casted to __u64 in user space an back
   in the kernel

3. extending video_usercopy in some way to make this work, preferably
   in a generic way.

4. using a variable command number like
   #define VIDIOC_G_FD_RESULT(num)	_IOC(_IOC_READ|_IOC_WRITE,'V', 95, \
		sizeof(struct v4l2_fd_result) + (num) * sizeof(struct v4l2_fd_detection)

5. requiring the interface to be simplified to return only a single
   struct v4l2_fd_detection at a time

I agree that none of these are nice. My preferred option would be last one,
but I don't know how performance critical the interface is or if it would
cause any races that you want to avoid.

	Arnd
