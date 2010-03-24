Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab0CXRoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:44:07 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:55758 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab0CXRoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:44:04 -0400
Message-ID: <4BAA4EE4.3090900@nortel.com>
Date: Wed, 24 Mar 2010 11:41:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Brandon Black <blblack@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: behavior of recvmmsg() on blocking sockets
References: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>
In-Reply-To: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 17:43:59.0085 (UTC) FILETIME=[955CD1D0:01CACB79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 10:15 AM, Brandon Black wrote:
> [Not on the list, please CC responses]

Adding netdev to the CC list.

> Currently, my application code uses blocking UDP sockets and is
> basically structured like this:
> 
> while(1) {
>     recvmsg(fd, ...);
>     // do some work on the packet
>     sendmsg(fd, ...);
> }
> 
> It uses a thread-per-socket model

This doesn't scale well to large numbers of sockets....you get a lot of
unnecessary context switching.


, and the "do some work" code is very
> fast, and so this turns out to be more efficient than non-blocking
> techniques for my use case.  Today I started playing with 2.6.33's new
> recvmmsg(), hoping to convert my code like so (still on blocking
> sockets):
> 
> while(1) {
>     recvmmsg(fd, ...);
>     // do some work on up to N packets
>     // loop over sendmsg() foreach packet to be sent
>     //   (or sendmmsg() if/when that interface becomes available)
> }
> 
> The catch I ran into is that on a blocking socket, recvmmsg() will
> block until *all* vlen packets have been received.  The behavior I'd
> prefer for my use case would be for it to only block until at least
> one packet is available, not until all are available.  Or in code
> terms, the first internal call to recvmsg should use the supplied
> flags, and the rest of the recvmsg calls should use flags &
> MSG_DONTWAIT.  It's not clear to me which is the better default
> behavior, but I feel like at the very least there should be a flag
> that can switch behavior between the two possible interpretations of
> "blocking".

On a sufficiently fast CPU there will always only be 1 packet waiting
but we'll waste a lot of time doing one syscall per packet.

I suspect the intent is that you set the timeout to indicate the max
latency you're willing to accomodate.  Once the timeout expires then the
call will return with the packets received to that point.

Chris
