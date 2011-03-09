Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1CIWal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:30:41 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37729 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1CIWai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:30:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Kernelspace firmware loaders (was: linux-next: manual merge of the staging tree with the v4l-dvb tree)
Date: Wed, 9 Mar 2011 23:30:59 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r1; KDE/4.6.1; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Igor M. Liplianin" <liplianin@me.by>,
        Ben Gamari <bgamari.foss@gmail.com>
References: <20110304163905.ed6dd630.sfr@canb.auug.org.au> <20110307161658.GA9088@kroah.com> <AANLkTi=Yavz4=KYNgsR02yTmBU_+BigC9qCSdX4SrTF2@mail.gmail.com>
In-Reply-To: <AANLkTi=Yavz4=KYNgsR02yTmBU_+BigC9qCSdX4SrTF2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103092331.00774.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Monday 07 March 2011 17:39:43 Linus Torvalds wrote:
> On Mon, Mar 7, 2011 at 8:16 AM, Greg KH <greg@kroah.com> wrote:
> > If the code is just a "pass-through" to the hardware, I have no
> > objection to the driver being in the kernel, if it needs to be in order
> > to control the hardware properly.
> 
> .. or even if it doesn't "need to be", and you _could_ do it in user space.
> 
> We've had tons of problems with user space breakage and version skew
> etc. It's often been a total pain to have user space-vs-kernel
> components that support one version but not the other, making it hard
> to upgrade the kernel independently of other things. The whole
> experience with X-vs-drm has been very painful.
> 
> There are two cases where user-space drivers work fine:
> 
>  (a) if there is no kernel component to them at all. Think "this
> driver would work on not just Linux, but on FreeBSD and UnixWare".
> Examples of this would be the original X approach.
> 
>  (b) if there's a kernel driver which exports an interface that is
> specified by the hardware (NOT specified by some "abstraction" layer),
> and where the kernel just exports an interface and doesn't expect
> anything back (ie the kernel is _strictly_ the lower-level driver,
> there is no two-way "user space helps kernel" crap)
> 
>      A reasonable example of this would be the USB user space drivers:
> the kernel interface is clearly _below_ (so the kernel does not depend
> on user space), and the defined not by some crazy software interface,
> but by the USB hardware standard.
> 
> But any other kind of mixing is just a big pain. Having a user-space
> thing to set things up for a kernel driver is crazy crap. It
> inevitably leads to "one or the other is broken, and people working on
> one piece aren't the same people working on the other". Just don't do
> it. Every time it's done, it leads to problems. You need special
> programs to set things up etc. It's just f*cked up.
> 
> (An example of why it's crazy crap: it inevitably means that the
> kernel can not "resume" a device. Because it now needs user space help
> to get the device going again. Crazy. Don't do it. It's shit).

I agree with you on the pain introduced by mixing drivers with userspace 
helpers. However, I'm still concerned about having a full JTAG stack in the 
kernel.

The Altera JTAG driver is basically a firmware loader. There's nothing wrong 
with firmare loaders in the kernel per-se, we have plenty of them and they 
usually request firmware data from userspace (hopefully specially crafted for 
the Linux driver, or pre-processed when the firmware is extracted from a 
Windows driver) and more of less dump it to the device.

Now, if a vendor provided a firmware in the form of a Java bytecode file, 
requiring the kernel driver to implement a JVM to load the firmware into the 
device, would you accept it ? JTAG is not Java, but it still requires several 
non-trivial layers, from controller drivers (we need to support multiple APIs 
there, as controllers can range from simple bit-banging adapters to more 
complex and faster devices with a higher level interface) to binary firmware 
interpreters (and I'm really talking about intepreters here, not just parsers 
- the Altera firmware file requires a VM) with of course incompatible vendor-
specific formats.

-- 
Regards,

Laurent Pinchart
