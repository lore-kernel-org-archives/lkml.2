Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1LWLft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:35:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40756 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1LWLfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:35:48 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.169.13]
In-Reply-To: <CA+55aFzKU0GWqpQo2AzAawoVm=qPaJiwKTcifeYApyZP_Hj3nQ@mail.gmail.com>
References: <8739cbkgv2.fsf@rustcorp.com.au> <CA+55aFyvMkAtXPRxiFR+UpZKGHMhp8Vd9aYg1dkaoKMwD5MLcw@mail.gmail.com>
 <CA+55aFzKU0GWqpQo2AzAawoVm=qPaJiwKTcifeYApyZP_Hj3nQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 23 Dec 2011 13:35:26 +0200
Message-ID: <CAK=WgbacH1tXHJiHNKLNNsFA7-vnFT_J6vYOANh0wzGyUj8Zpg@mail.gmail.com>
Subject: Re: [RESENDx2] [PULL] virtio: fix barriers for virtio-mmio
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 11:35 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On x86, there really is never any reason to use the heavy memory
> barriers unless you are talking to a real device. And last I saw,
> "virtio" was still about virtual IO.

I reported this originally, so maybe I should describe our use case a
bit here (it's not virtio-mmio). It's a bit long, so apologizes in
advance.

Almost every SoC today have several additional cores (DSP or whatnot)
which usually employ some hardware multimedia accelerators and are
used to offload cpu-intensive tasks from the main application
processor. These other cores are used in an asymmetric multiprocessing
configurations, i.e. they run their own instance of operating system
(which can be some flavor of RTOS, or Linux, or whatnot. anything
goes).

Virtually every SoC vendor have this (lots of ARM vendors, but it's
definitely not limited to ARM), and they all have their own way of
controlling, and communicating with, those remote cores. And it's
usually rather big (tens of thousands loc), out-of-tree and very
vendor-specific code.

So we're trying to fix this by introducing some generic code that'd
control those remote cores and let drivers talk to them, which all
vendors could then use. I'll be sending you a 3.3 pull request for
this, but you can already take a look in linux-next at drivers/rpmsg
(inter-processor communication bus) and drivers/remoteproc (framework
for booting a remote core).

And rpmsg is using virtio to avoid implementing another shared memory
"wire" protocol. And of course to be able to reuse all the existing
virtio drivers (e.g. net, block, console) with a remote core backend.

Which leads me to the specific issue we have. On OMAP4, the virtio
kick is implemented using a memory-mapped mailbox device. After
updating a vring (which is mapped using ARM's Normal memory) and
before kicking the remote core (using the mailbox device which is
mapped using ARM's Device memory) we must use a "heavy" memory barrier
(i.e. ARM's DSB). Otherwise, if only an smp memory barrier is used
(i.e. DMB on ARM), the kick might jump ahead before the remote core
has observed the updates to the vrings. And then bad things happen.

We didn't want to inflict the performance degradation on the
virtualization use cases (which can run concurrently with the remote
core scenarios), hence the dynamic "IO or SMP barrier" thingy.

(Btw we don't have enough information about other
setups/configurations as other vendors just begin using virtio for
these kind of scenarios, but we guess this is probably isn't limited
to OMAP. Fixing it at the transport layer sounds reasonable, although
there are other ways to do this too).

Hope this makes sense,

Thanks,
Ohad.
