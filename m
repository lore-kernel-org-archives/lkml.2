Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1LLVg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:36:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56209 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753415Ab1LLVg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:36:27 -0500
Date: Mon, 12 Dec 2011 21:36:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111212213652.0855c892@pyramind.ukuu.org.uk>
In-Reply-To: <4EE64512.3080709@redhat.com>
References: <20111210132220.083204833@linutronix.de>
	<alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	<alpine.LFD.2.02.1112102144370.3020@ionos>
	<alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	<20111211103047.GA19299@elte.hu>
	<alpine.LFD.2.02.1112111459270.3020@ionos>
	<20111211155347.GA1297@elte.hu>
	<1323667836.4190.4.camel@lappy>
	<20111212111222.GA21121@elte.hu>
	<20111212112052.30a568f7@pyramind.ukuu.org.uk>
	<4EE64512.3080709@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 20:16:50 +0200
Avi Kivity <avi@redhat.com> wrote:

> On 12/12/2011 01:20 PM, Alan Cox wrote:
> > > [*] Also, those 10K cycles include some significant Qemu 
> > >     overhead - a couple of thousand cycles - that should be much 
> > >     lower in the tools/kvm case.
> >
> > Are all the traps going into qemu
> 
> Only the ones that go to devices modelled in userspace.
> 
> >  - is KVM still that braindead ?
> 
> How would you do it?

See my posting from years back about this...

Your trap handler returns the kernel a predictor tree (say a 1 page tree)
of the next expected ins out and actions - where the action is either
store, or trap out.

Each kernel trap then boils down to

Does this trap match an entry in the top of our predictor tree. Ie is it
an in/out (or equivalent mmio) that the driver has given us expected
behaviour for.

We could of course have several for different ranges of devices

	no - hit emulator and return position in predictor tree we failed
		at plus tree buffer if needed

	yes - follow the tree node

	For IN
		copy predicted byte/word/dword to tree buffer
		move along tree
		return

	For Out
		store store byte/word/dword in tree buffer
		(one of which can be used for discard)
		move along the tree
		return

Thats enough to do things like write predictors for the kernel console
emulating the serial fifo, to script PIO IDE transfers etc

The kernel side is miniscule and generic, the user space can migrate to
doing this where it pays off and not where it doesn't.


Alan
