Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2DMIZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:25:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43807 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab2DMIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <4F86ECD0.6060708@redhat.com>
References: <1333648371-24812-1-git-send-email-remi@remlab.net>
	<4F85B908.4070404@redhat.com>
	<201204112147.55348.remi@remlab.net>
	<CAAMvbhHviuwC0ik2ZY91ZgN4hZyqUbuk=qVcAOH0VYMhva4LeA@mail.gmail.com>
	<4F86ECD0.6060708@redhat.com>
Date: Fri, 13 Apr 2012 09:25:46 +0100
Message-ID: <CAAMvbhH+XkrHx=BA41gDy_GzQKdPLA5iWJL=eaNukH9wWGn80A@mail.gmail.com>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl() structs
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 April 2012 15:55, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 12-04-2012 05:04, James Courtier-Dutton escreveu:
>> 6) Add a #if #endif around the old API, so a user compiling their own
>> kernel can decide if the old API exists or not. User might want to do
>> this for security reasons.
>
> Add an #if block there will make the header very hard to deal with, as this
> is already complex enough without it. The V4L2 API header has 2420 lines.
> Such #if blocks will almost duplicate the header size.
>

But it will work.
If you change the kernel-user API, this is a necessary evil you really
just have to do.

For ALSA, we had a #define ALSA_API_5 and #define ALSA_API_9.
The application writer defined one of these before including the
header file, and this specified which API version the application
writer used. This handles the use from user space.

After about 2 years, you can remove the old API version, and the
header file is then cleaned up.

You need to think about it as an API change.
So, you are really going from V4L2 to V4L3.

The kernel side of things is a bit messier.
You have to use different IOCTLs for the old API than the new API for
every IOCTL that has a changed parameter passed to it.
We managed to avoid this particular nasty, because in ALSA we had
libasound. So, we implemented all the nasty stuff in libasound,
letting the kernel only have to implement one API, either the new or
the old. So long as you installed a new libasound, the old application
would stay working.

I don't think you have something like libasound for v4l2 that every
application is using, so I would probably go with implementing V4L3.
I.e. A brand new API for Video in Linux.
You could say the driver for moving from V4L2 to V4L3 would be
security due to problems with emums.
Note: You can still use enums in the header file, but just pass their
value over the api as an int and not an emun type.
See the /linux/include/sound/asound.h for an example.
