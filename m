Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1CGQkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:40:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366Ab1CGQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:40:06 -0500
MIME-Version: 1.0
In-Reply-To: <20110307161658.GA9088@kroah.com>
References: <20110304163905.ed6dd630.sfr@canb.auug.org.au> <20110304171343.GE22173@kroah.com>
 <4D712750.1070402@redhat.com> <201103071507.37378.laurent.pinchart@ideasonboard.com>
 <20110307161658.GA9088@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Mar 2011 08:39:43 -0800
Message-ID: <AANLkTi=Yavz4=KYNgsR02yTmBU_+BigC9qCSdX4SrTF2@mail.gmail.com>
Subject: Re: Kernelspace firmware loaders (was: linux-next: manual merge of
 the staging tree with the v4l-dvb tree)
To: Greg KH <greg@kroah.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Igor M. Liplianin" <liplianin@me.by>,
        Ben Gamari <bgamari.foss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 8:16 AM, Greg KH <greg@kroah.com> wrote:
>
> If the code is just a "pass-through" to the hardware, I have no
> objection to the driver being in the kernel, if it needs to be in order
> to control the hardware properly.

.. or even if it doesn't "need to be", and you _could_ do it in user space.

We've had tons of problems with user space breakage and version skew
etc. It's often been a total pain to have user space-vs-kernel
components that support one version but not the other, making it hard
to upgrade the kernel independently of other things. The whole
experience with X-vs-drm has been very painful.

There are two cases where user-space drivers work fine:

 (a) if there is no kernel component to them at all. Think "this
driver would work on not just Linux, but on FreeBSD and UnixWare".
Examples of this would be the original X approach.

 (b) if there's a kernel driver which exports an interface that is
specified by the hardware (NOT specified by some "abstraction" layer),
and where the kernel just exports an interface and doesn't expect
anything back (ie the kernel is _strictly_ the lower-level driver,
there is no two-way "user space helps kernel" crap)

     A reasonable example of this would be the USB user space drivers:
the kernel interface is clearly _below_ (so the kernel does not depend
on user space), and the defined not by some crazy software interface,
but by the USB hardware standard.

But any other kind of mixing is just a big pain. Having a user-space
thing to set things up for a kernel driver is crazy crap. It
inevitably leads to "one or the other is broken, and people working on
one piece aren't the same people working on the other". Just don't do
it. Every time it's done, it leads to problems. You need special
programs to set things up etc. It's just f*cked up.

(An example of why it's crazy crap: it inevitably means that the
kernel can not "resume" a device. Because it now needs user space help
to get the device going again. Crazy. Don't do it. It's shit).

                               Linus
