Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1DLA73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1DLA72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:59:28 -0400
Date: Tue, 12 Apr 2011 02:58:56 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110412005856.GJ29444@random.random>
References: <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <4D9E6F6E.9050709@codemonkey.ws>
 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
 <4D9F150B.1030809@codemonkey.ws>
 <20110408192039.GJ29444@random.random>
 <20110409074009.GA25729@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110409074009.GA25729@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 09:40:09AM +0200, Ingo Molnar wrote:
> 
> * Andrea Arcangeli <aarcange@redhat.com> wrote:
> 
> > [...] I thought the whole point of a native kvm tool was to go all the 
> > paravirt way to provide max performance and maybe also depend on vhost as 
> > much as possible.

BTW, I should elaborate on the "all the paravirt way", going 100%
paravirt isn't what I meant. I was thinking at the performance
critical drivers mainly like storage and network. The kvm tool could
be more hackable and evolve faster by exposing a single hardware view
to the linux guest (using only paravirt whenever that improves
performance, like network/storage).

Whenever full emulation doesn't affect any fast path, it should be
preferred rather than inventing new paravirt interfaces for no
good.

That for example applies first and foremost to the EPT support which
is simpler and more optimal than any shadow paravirt pagetables. It'd
be a dead end to do all in paravirt performance-wise. I definitely
didn't mean any resemblance to lguest when I said full paravirt ;).
Sorry for the confusion.

> To me it's more than that: today i can use it to minimally boot test various 
> native bzImages just by typing:
> 
> 	kvm run ./bzImage
> 
> this will get me past most of the kernel init, up to the point where it would 
> try to mount user-space. ( That's rather powerful to me personally, as i 
> introduce most of my bugs to these stages of kernel bootup - and as a kernel 
> developer i'm not alone there ;-)
> 
> I would be sad if i were forced to compile in some sort of paravirt support, 
> just to be able to boot-test random native kernel images.
>
> Really, if you check the code, serial console and timer support is not a big 
> deal complexity-wise and it is rather useful:

Agree with that.

> 
>   git pull git://github.com/penberg/linux-kvm master
> 
> So i think up to a point hardware emulation is both fun to implement (it's fun 
> to be on the receiving end of hw calls, for a change) and a no-brainer to have 
> from a usability POV. How far it wants to go we'll see! :-)

About using the kvm tool as a debugging tool I don't see the point
though. It's very unlikely the kvm tool will ever be able to match
qemu power and capabilities for debugging, in fact qemu will allow you
to do basic debug of several device drivers too (e1000, IDE etc...). I
don't really see the point of the kvm tool as a debugging tool
considering how qemu is mature in terms of monitor memory inspection
commands and gdbstub for that, if it's debug you're going after adding
more features to the qemu monitor looks a better way to go.

The only way I see this useful is to lead it into a full performance
direction, using paravirt whenever it saves CPU (like virtio-blk,
vhost-net) and allow it to scale to hundred of cpus doing I/O
simultaneously and get there faster than qemu. Now smp scaling with
qemu-kvm driver backends hasn't been a big issue according to Avi, so
it's not like we're under pressure from it, but clearly someday it may
become a bigger issue and having less drivers to deal with (especially
only having vhost-blk in userland with vhost-net already being in the
kernel) may provide an advantage in allowing a more performance
oriented implementation of the backends without breaking lots of
existing and valuable full-emulated drivers.

In terms of pure kernel debugging I'm afraid this will be dead end and
for the kernel testing you describe I think qemu-kvm will work best
already. We already have a simpler kvm support in qemu (vs qemu-kvm)
and we don't want a third that is even slower than qemu kvm support,
so it has to be faster than qemu-kvm or nothing IMHO :).
