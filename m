Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2BILZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:25:57 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55941 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2BILZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:25:56 -0500
Date: Thu, 9 Feb 2012 11:27:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
Message-ID: <20120209112719.73ef546e@pyramind.ukuu.org.uk>
In-Reply-To: <4F33025D.2040301@redhat.com>
References: <1328623901-20628-1-git-send-email-ajax@redhat.com>
	<1328657985-13942-1-git-send-email-ajax@redhat.com>
	<20120208001724.7e5c7be4@pyramind.ukuu.org.uk>
	<4F31C417.30502@redhat.com>
	<20120208092611.49ada8c5@pyramind.ukuu.org.uk>
	<4F3280C7.1030401@redhat.com>
	<20120208143238.0003287e@pyramind.ukuu.org.uk>
	<4F33025D.2040301@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Besides, as noted (and cut), you need CAP_SYS_RAWIO anyway.

We need to enforce CAP_SYS_RAWIO for port access pretty much anyhow
because otherwise you can get from have fs access to having device access.

If you have CAP_SYS_RAWIO you can use ioperm/iopl.

> use case.  X can switch off of it and be faster for its use case, in 
> which context switch overhead is infinitely more important than modeset 
> taking another hundred micros.

That would only be the case for ioperm, not iopl. It's also a case you
can fix anyway. If a process clears its ioperm mask we can drop the
masks. That would help existing users too including existing X servers.

> > People will be shipping code using it for years.
> 
> You know, one of us is going to need to cite their sources here.  Thanks 
> for shutting down codesearch, google.

It even turns up being used with dd to waggle parallel port devices
despite the fact they have a proper API (which is the nasty problem with
ill defined interfaces of that nature)

> > So why hasn't it changed - because nobody has had a problem with it.
> 
> And now that I have a problem with it, I'm being told that I don't have 
> a problem with it.

It would be useful if you'd actually try and explain the problem rather
than pick a fight. I said nobody "has had", not nobody "is having"

> Except to support the case of booting vesa cards on non-x86.  A thing X 
> can actually do, you know.

And at that point you again need a much more controlled interface because
any off device port is likely to be wrong.

> 
> > iopl is functionally equivalent to your io port code. It's already in the
> > kernel, it already works and it's already maintained.
> >
> > To be useful a port interface really needs to aware of hotplug, device
> > mappings and the like. For VESA that's going to be pretty horrible both
> > because of the uncontrolled nature of the interface and because of the
> > vga "magic" both for ports and routing.
> >
> > An interface where you could do something like
> >
> > 	open a port channel
> > 	bind device X to port channel  (imports its I/O ranges)
> > 	bind portrange A-B to port channel (for nasties like the vga
> > 				ports)
> >
> > read/write in 1/2/4/(8 ?) byte chunks meaningfully
> >
> > 	close
> 
> This isn't sufficient.  VBIOS can call SBIOS.  SBIOS can poke any port 
> on the mainboard it wants. 

And may arbitarily corrupt the running of the system without any error
being detected - which I must admit was my primary experience of trying to
use the vesa support to boot a second video card some years back.

If it's not touching the video card registers then you should probably be
emulating it, because whatever it is touching isn't going to be safe - and
I guess for a lot of those ports you already are ?

What ports beyond the video card ones and the VGA range are getting
prodded by actual use cases ?

> More to the point I'm not concerned about hotplug here _at_ _all_.  If 
> you want hotplug at this level you write a kernel driver.  If you _want_ 

The only kernel driver you need for such a device hotplug case is the
trivial generic 'pulling the rug from under you' handling. We sort of
deal with this already for mmio.

> To solve a problem no one is having, or is going to have.  And which 
> wouldn't be sufficient for vesa regardless, short of the range of bound 
> ports being 0 to 65535.

If we are into thr world of problems no one is having then we have
iopl(). It works, it's in the kernel.

> Whatever.  I can continue to do this badly in userspace, or we could 
> take some very small changes to make it slightly better, or we could do 
> some enormous overengineered thing to fail to solve a non-problem.  Me, 
> I like simple and incremental.  I guess that doesn't count for much.

>From a kernel perspective APIs are things you get stuck with. Another
broken port interface isn't something I want us to be stuck with.
Especially when you've got iopl already and it's done the job fine for
about 17 years.

If there is a measurable performance cost then making ioperm spot empty
masks or providing a way to say 'I'm flushing my io permission map' ought
to do the trick or a helper thread in your app.



Alan

