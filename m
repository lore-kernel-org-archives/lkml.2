Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2BRKEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 05:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2BRKEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 05:04:14 -0500
Message-ID: <4F3F7784.9040709@redhat.com>
Date: Sat, 18 Feb 2012 12:03:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Arnd Bergmann <arnd@arndb.de>, qemu-devel@nongnu.org,
        Alexander Graf <agraf@suse.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>  <1328597934.6802.6.camel@concordia>  <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de>  <201202152221.36154.arnd@arndb.de> <1329354245.6976.25.camel@concordia>  <4F3D58CE.2070209@redhat.com> <1329437356.6991.8.camel@concordia>
In-Reply-To: <1329437356.6991.8.camel@concordia>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 02:09 AM, Michael Ellerman wrote:
> On Thu, 2012-02-16 at 21:28 +0200, Avi Kivity wrote:
> > On 02/16/2012 03:04 AM, Michael Ellerman wrote:
> > > > 
> > > > ioctl is good for hardware devices and stuff that you want to enumerate
> > > > and/or control permissions on. For something like KVM that is really a
> > > > core kernel service, a syscall makes much more sense.
> > >
> > > Yeah maybe. That distinction is at least in part just historical.
> > >
> > > The first problem I see with using a syscall is that you don't need one
> > > syscall for KVM, you need ~90. OK so you wouldn't do that, you'd use a
> > > multiplexed syscall like epoll_ctl() - or probably several
> > > (vm/vcpu/etc).
> > 
> > No.  Many of our ioctls are for state save/restore - we reduce that to
> > two.  Many others are due to the with/without irqchip support - we slash
> > that as well.  The device assignment stuff is relegated to vfio.
> > 
> > I still have to draw up a concrete proposal, but I think we'll end up
> > with 10-15.
>
> That's true, you certainly could reduce it, though by how much I'm not
> sure. On powerpc I'm working on moving the irq controller emulation into
> the kernel, and some associated firmware emulation, so that's at least
> one new ioctl. And there will always be more, whatever scheme you have
> must be easily extensible - ie. not requiring new syscalls for each new
> weird platform.

Most of it falls into read/write state, which is covered by two
syscalls.  There's probably need for configuration (wiring etc.); we
could call that pseudo-state with fake registers but I don't like that
very much.


> > > Secondly you still need a handle/context for those syscalls, and I think
> > > the most sane thing to use for that is an fd.
> > 
> > The context is the process (for vm-wide calls) and thread (for vcpu
> > local calls).
>
> Yeah OK I forgot you'd mentioned that. But isn't that change basically
> orthogonal to how you get into the kernel? ie. we could have the
> kvm/vcpu pointers in mm_struct/task_struct today?
>
> I guess it wouldn't win you much though because you still have the fd
> and ioctl overhead as well.
>

Yes.  I also dislike bypassing ioctl semantics (though we already do
that by requiring vcpus to stay on the same thread and vms on the same
process).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

