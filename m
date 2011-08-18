Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1HRW7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:59:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40389 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754846Ab1HRW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:59:37 -0400
Date: Thu, 18 Aug 2011 23:57:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: san@google.com (San Mehat)
Cc: davem@davemloft.net, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        digitaleric@google.com, mikew@google.com, miche@google.com,
        maccarro@google.com
Subject: Re: [RFC 0/0] Introducing a generic socket offload framework
Message-ID: <20110818235719.50365b0b@lxorguk.ukuu.org.uk>
In-Reply-To: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
References: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The Berkeley sockets coprocessor is a virtual PCI device which has the ability
> to offload socket activity from an unmodified application at the BSD sockets

Ok I think there is an important question here. Why is this being
designed for a specific virtual interface. Unix has always had the notion
that socket operations can be in part generic and that you can pass a
properly designed program a socket without any notion of what it is for.

> Lastly, pushing socket processing back into the host allows for host-side
> control of the network protocols used, which limits the potential congestion
> problems that can arise when various guests are using their own congestion
> control algorithms.

Does that not depend which side does the congestion and who parcels out
buffers ?

> Since we wish to allow these paravirtualized sockets to coexist peacefully with
> the existing Linux socket system, we've chosen to introduce the idea that a
> socket can at some point transition from being managed by the O/S socket system
> to a more enlightened 'hardware assisted' socket. The transition is managed by
> a 'socket coprocessor' component which intercepts and gets first right of
> refusal on handling certain global socket calls (connect, sendto, bind, etc...).
> In this initial design, the policy on whether to transition a socket or not is
> made by the virtual hardware, although we understand that further measurement
> into operation latency is warranted.

Q: whay happens about in process socket syscalls in another thread ?
Thats always been the ugly in these cases either by intercepting or by
swapping file operations on an object.

>  * SOCK_HWASSIST
>     Indicates socket operations are handled by hardware

This guest only view means you can't use the abstraction for local
sockets too.

> In order to support a variety of socket address families, addresses are
> converted from their native socket family to an opaque string. Our initial
> design formats these strings as URIs. The currently supported conversions are:

That makes a lot of sense to me, because its a well understood
abstraction and you can offload other stuff to this kind of generic
socket including things like http protocol acceleration, SSL and so on.

Plus its always been annoying that you can't open a socket, but a URI
interface solves that...

>  * We don't handle SOCK_SEQPACKET, SOCK_RAW, SOCK_RDM, or SOCK_PACKET sockets.

But there is no reason SEQPACKET and RDM couldn't be added I assume?

Ok other questions

Suppose instead you just add an abstracted socket interface of

	AF_SOMETHING, PF_URI

it would be easy to convert programs. It would be easier to write
properly generic programs. It would be easy write some small helpers that
are a good deal less insane than the existing inet ones. At that point
you could turn the problem on its head. Instead of 'borrowing' sockets
for a fairly specific concept of hw assist you ask the reverse question,
who can accelerate this URI be it some kind of virtual machine interface,
something funky like raw data over infiniband, or plain old 'use the
TCP/IP stack'.

Your decision making code is going to be interesting but it only has to
make the decision once in simple cases.

And yes there is still the complicated cases such as 'the routing table
has changed from vitual host to via siberia now what' but I don't believe
your proposal addresses that either.

Alan
