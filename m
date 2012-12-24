Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2LXT3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab2LXT3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:29:11 -0500
Date: Mon, 24 Dec 2012 17:28:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [Regression w/ patch] Media commit causes user space to
 misbahave (was: Re: Linux 3.8-rc1)
Message-ID: <20121224172838.162b3597@redhat.com>
In-Reply-To: <CA+55aFzX56kPPwSO97X=UyPaMzV5QRNG9ScN=nxnHFjmz=_8yA@mail.gmail.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
	<2183382.xv2VGtqdUf@vostro.rjw.lan>
	<20121223120822.233282ba@redhat.com>
	<CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com>
	<20121223182135.575cb915@redhat.com>
	<CA+55aFzX56kPPwSO97X=UyPaMzV5QRNG9ScN=nxnHFjmz=_8yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 23 Dec 2012 14:29:04 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Sun, Dec 23, 2012 at 12:21 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> >
> > Agreed: ENOENT was a bad choice, and it should be reverted.
> 
> Well, *any* other error value is likely a bad choice.

Well, UVC should return the same error codes as the other drivers,
for the same error types. That's what that patch was trying to fix
(unfortunately, doing the wrong thing).

> > What I'm trying to understand is why pulseaudio is complaining.
> > Is it because it only accepts EINVAL error code for media controls?
> 
> What I am trying to understand is why you even care, and how you could
> *possibly* ever even consider this to be a user-space bug.

Because there are other error codes that can be returned by other
drivers when this specific ioctl (VIDIOC_QUERYCTRL) is called.

Let me take one step back and explain what this patch were
trying to do.

What happens is that the V4L2 API is very complex (~80 ioctls).
In practice, that means that two drivers implementing the API
might behave a little different than the others, with causes
troubles on userspace. We're working to fix it, by testing all
of them using userspace testing tools.

In the specific case of VIDIOC_QUERYCTRL, most drivers now use
some functions inside the v4l2 core that warrants that they all
work the same way. 

UVC is an special case, as it can dynamically create media controls
in runtime. The new uvc 1.5 spec will make it even harder to use the
core.

So, UVC has its own implementation for this ioctl, with can
unfortunately led into a different behavior from userspace. This
was actually happening, and Laurent's (broken) patch were trying
to address it.

Unfortunately, the tool he used to test had a bug. So, he didn't
noticed that his patch were broken.

>From my side, when I saw Rafael's complaint, what I wanted were
just to understand a little more what happened, before
applying his patch. Sorry if I miss-expressed.

> Applications *do* care about error return values. There's no way in
> hell you can willy-nilly just change them. And if you do change them,
> and applications break, there is no way in hell you can then blame the
> application.

Yes. What we're trying to do is to make sure that all drivers will
return the same error codes, and not to change the API.

> Yes, I'm upset. Very upset. Why was the error value changed in the
> first place? There was no reason given, and it was changed to a
> completely idiotic value. And when applications - understandably -
> broke, you start asking "why?"
> 
> If applications didn't care about specific error values, then it
> wouldn't make sense to have more than one to begin with, and you
> shouldn't care which one that was. But since applications *do* care,
> and since we *do* have multiple error values, we stick to the old
> ones, unless there are some *very* good reasons not to.

Fully agreed.

> And those reasons really need to be very good, and spelled out and
> explained. In this case, none of that was even remotely the case.
> 
> So your question "why would pulseaudio care" is totally *irrelevant*,
> senseless, and has nothing to do with anything. Pulseaudio cares, and
> caring fundamentally makes sense. It's questioning that obvious fact
> that does not make sense!

With audio devices, pulseaudio opens devices on its start and keep it open
forever. 

>From Rafael's email, it seemed that newer versions could also be doing
something similar. On such case, this would likely break all drivers
(even on kernel 2.6 or earlier), because the drivers lock the streaming
capabilities to the firstly opened handler, due to hardware limitation
(the DMA engines at the hardware only support one transfer at the same
time). There's an ioctl that overrides its behavior, that should be called
by an application that wants to force its ownership, but most applications
don't use it.

Cheers,
Mauro
