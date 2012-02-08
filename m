Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2BHRTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:19:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59937 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2BHRTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:19:16 -0500
Date: Wed, 8 Feb 2012 17:20:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Message-ID: <20120208172037.615a1fdd@pyramind.ukuu.org.uk>
In-Reply-To: <4F3141E4.8080902@codemonkey.ws>
References: <4F2AB552.2070909@redhat.com>
	<4F2B41D6.8020603@codemonkey.ws>
	<51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>
	<4F3117E5.6000105@redhat.com>
	<EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>
	<4F31241C.70404@redhat.com>
	<BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
	<4F3141E4.8080902@codemonkey.ws>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >    register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
> >    for (i = 1; i<  7; i++) {
> >      register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
> >      register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
> >    }
> 
> You can't easily serialize updates to that address with the kernel since two 
> threads are likely going to be accessing it at the same time.  That either means 
> an expensive sync operation or a reliance on atomic instructions.

Who cares

If your API is right this isn't a problem (and for IDE the guess that it
won't happen you will win 99.999% of the time).

In fact IDE you can do even better in many cases because you'll get a
single rep outsw you can trap and shortcut.

> But not all architectures offer non-word sized atomic instructions so it gets 
> fairly nasty in practice.

Thats their problem. We don't screwup the fast paths because some
hardware vendor screwed up that bit of their implementation. That's
*their* problem not everyone elses.

So on x86 IDE should be about 10 outb traps that can be predicted, a rep
outsw which can be shortcut and a completion set of inb/inw ops that can
be predicted.

You should hit userspace about once per IDE operation. Fix the hot paths
with good design and the noise doesn't matter.

Alan
