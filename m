Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1HRXSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 19:18:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1HRXSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 19:18:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=f0VaPYQweCUkIroP3nK4afXYxS0gLk8tnPRhkhpXRYKLJSSaax0w65EKIj1JNY0ld
	w3NToFYAT6rmmg78bxPJw==
MIME-Version: 1.0
In-Reply-To: <20110818235719.50365b0b@lxorguk.ukuu.org.uk>
References: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
	<20110818235719.50365b0b@lxorguk.ukuu.org.uk>
Date: Thu, 18 Aug 2011 16:18:47 -0700
Message-ID: <CAPi7mHqV6Pgk5tSt+fJn_2aEZKZbO=aO78JXgw7MvDaW0musoQ@mail.gmail.com>
Subject: Re: [RFC 0/0] Introducing a generic socket offload framework
From: San Mehat <san@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davem@davemloft.net, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        digitaleric@google.com, mikew@google.com, miche@google.com,
        maccarro@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 3:57 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The Berkeley sockets coprocessor is a virtual PCI device which has the ability
>> to offload socket activity from an unmodified application at the BSD sockets
>
> Ok I think there is an important question here. Why is this being
> designed for a specific virtual interface. Unix has always had the notion
> that socket operations can be in part generic and that you can pass a
> properly designed program a socket without any notion of what it is for.

Sorry Alan if I wasn't clear, but I'm not quite sure what you're asking...

If you're asking 'why have you only spec'ed out a virtual interface
for this' then
my answer would be 'but of course you could design this in real hardware and
have a proper driver :)'. If you'd prefer that I call that out
specifically I'm happy to do so.

I have no desire to change the 'genericness' of sockets.. just the
opposite - i wish to
introduce the notion that sockets (can be) completely generic (when
offloaded) as far as
the guest is concerned.

>
>> Lastly, pushing socket processing back into the host allows for host-side
>> control of the network protocols used, which limits the potential congestion
>> problems that can arise when various guests are using their own congestion
>> control algorithms.
>
> Does that not depend which side does the congestion and who parcels out
> buffers ?

It does, and it does.

>
>> Since we wish to allow these paravirtualized sockets to coexist peacefully with
>> the existing Linux socket system, we've chosen to introduce the idea that a
>> socket can at some point transition from being managed by the O/S socket system
>> to a more enlightened 'hardware assisted' socket. The transition is managed by
>> a 'socket coprocessor' component which intercepts and gets first right of
>> refusal on handling certain global socket calls (connect, sendto, bind, etc...).
>> In this initial design, the policy on whether to transition a socket or not is
>> made by the virtual hardware, although we understand that further measurement
>> into operation latency is warranted.
>
> Q: whay happens about in process socket syscalls in another thread ?
> Thats always been the ugly in these cases either by intercepting or by
> swapping file operations on an object.
>
>>  * SOCK_HWASSIST
>>     Indicates socket operations are handled by hardware
>
> This guest only view means you can't use the abstraction for local
> sockets too.
>

To be honest, the way we're attempting to integrate is in such a way
that you *could*
offload AF_LOCAL sockets...  but that world gets a bit too much like
the 'Twilight Zone'
for my current linkings..

>> In order to support a variety of socket address families, addresses are
>> converted from their native socket family to an opaque string. Our initial
>> design formats these strings as URIs. The currently supported conversions are:
>
> That makes a lot of sense to me, because its a well understood
> abstraction and you can offload other stuff to this kind of generic
> socket including things like http protocol acceleration, SSL and so on.
>
> Plus its always been annoying that you can't open a socket, but a URI
> interface solves that...

Indeed.

>
>>  * We don't handle SOCK_SEQPACKET, SOCK_RAW, SOCK_RDM, or SOCK_PACKET sockets.
>
> But there is no reason SEQPACKET and RDM couldn't be added I assume?

No reason I can think of - we just did not have a specific requirement
for it at the time.

>
> Ok other questions
>
> Suppose instead you just add an abstracted socket interface of
>
>        AF_SOMETHING, PF_URI

Mike Waychison and I were saving the 'PF_URI' discussion for a future
date, but indeed
we're on the same wave-length :). Our initial requirements are for an
'extremely minimal
burden of support' on the userspace environments, so we decided to
open up a separate
discussion on PF_URI

>
> it would be easy to convert programs. It would be easier to write
> properly generic programs. It would be easy write some small helpers that
> are a good deal less insane than the existing inet ones. At that point
> you could turn the problem on its head. Instead of 'borrowing' sockets
> for a fairly specific concept of hw assist you ask the reverse question,
> who can accelerate this URI be it some kind of virtual machine interface,
> something funky like raw data over infiniband, or plain old 'use the
> TCP/IP stack'.

Completely agree.

>
> Your decision making code is going to be interesting but it only has to
> make the decision once in simple cases.

Yup.

>
> And yes there is still the complicated cases such as 'the routing table
> has changed from vitual host to via siberia now what' but I don't believe
> your proposal addresses that either.

Can you be more specific? If you mean solving the 'keeping your tcp connections
open to non virtual endpoints across a migration (or whatever)' then
no it doesn't :)

>
> Alan
>

Thanks man,

-san


-- 
San Mehat | Staff Software Engineer | san@google.com | 415-366-6172
