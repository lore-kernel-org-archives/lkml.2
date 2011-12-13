Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1LMKdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:33:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1LMKdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:33:06 -0500
Message-ID: <4EE729B3.9010809@redhat.com>
Date: Tue, 13 Dec 2011 12:32:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <1323667836.4190.4.camel@lappy> <20111212111222.GA21121@elte.hu> <20111212112052.30a568f7@pyramind.ukuu.org.uk> <4EE64512.3080709@redhat.com> <20111212213652.0855c892@pyramind.ukuu.org.uk>
In-Reply-To: <20111212213652.0855c892@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 11:36 PM, Alan Cox wrote:
> On Mon, 12 Dec 2011 20:16:50 +0200
> Avi Kivity <avi@redhat.com> wrote:
>
> > On 12/12/2011 01:20 PM, Alan Cox wrote:
> > > > [*] Also, those 10K cycles include some significant Qemu 
> > > >     overhead - a couple of thousand cycles - that should be much 
> > > >     lower in the tools/kvm case.
> > >
> > > Are all the traps going into qemu
> > 
> > Only the ones that go to devices modelled in userspace.
> > 
> > >  - is KVM still that braindead ?
> > 
> > How would you do it?
>
> See my posting from years back about this...

Must have missed it.

>
> Your trap handler returns the kernel a predictor tree (say a 1 page tree)
> of the next expected ins out and actions - where the action is either
> store, or trap out.
>
> Each kernel trap then boils down to
>
> Does this trap match an entry in the top of our predictor tree. Ie is it
> an in/out (or equivalent mmio) that the driver has given us expected
> behaviour for.
>
> We could of course have several for different ranges of devices
>
> 	no - hit emulator and return position in predictor tree we failed
> 		at plus tree buffer if needed
>
> 	yes - follow the tree node
>
> 	For IN
> 		copy predicted byte/word/dword to tree buffer
> 		move along tree
> 		return
>
> 	For Out
> 		store store byte/word/dword in tree buffer
> 		(one of which can be used for discard)
> 		move along the tree
> 		return
>
> Thats enough to do things like write predictors for the kernel console
> emulating the serial fifo, to script PIO IDE transfers etc
>
> The kernel side is miniscule and generic, the user space can migrate to
> doing this where it pays off and not where it doesn't.

Looks incredibly fragile.  As soon as the guest changes its behaviour a
tiny bit, this breaks.  It doesn't work for any device that has even a
bit of indirection (like IDE DMA), or needs timers, or is misdesigned in
any of the hundreds of ways hardware designers have discovered over the
years.  And in the end, performance is still low compared to a
paravirtual device that was designed for minimizing exits - an exit that
is terminated in the kernel is cheaper than userspace, but still very
expensive.

-- 
error compiling committee.c: too many arguments to function

