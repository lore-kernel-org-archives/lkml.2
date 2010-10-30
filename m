Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0J3XrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:47:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56900
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab0J3XrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:47:04 -0400
Date: Sat, 30 Oct 2010 16:47:27 -0700 (PDT)
Message-Id: <20101030.164727.28829030.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinR6XH30dHwPS23=sGYOJU8rO4+kwz+Uv_XRB-b@mail.gmail.com>
References: <20101029.125920.189692530.davem@davemloft.net>
	<AANLkTinR6XH30dHwPS23=sGYOJU8rO4+kwz+Uv_XRB-b@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2010 14:41:03 -0700

> On Fri, Oct 29, 2010 at 12:59 PM, David Miller <davem@davemloft.net> wrote:
>>
>> This has the verify_iovec() INT_MAX limiter change as well as:
> 
> I think you'd want this as well, to make sure that sendto/recvfrom
> don't generate invalid iovecs.
> 
> Feel free to add my sign-off (or just commit it as yourself) after
> giving it some testing.

Done, thanks.

> NOTE! On thing that struck me is that the VFS layer does the
> "access_ok()" on the pre-truncated size and pointer pair, and I think
> that is the correct thing to do. However, the socket layer (and this
> patch) just truncates the size, so even if the copy is then done
> correctly with the proper user access checking, it will not check that
> the whole original buffer was valid - only that the buffer it fills in
> is valid.
> 
> Now, this is not a security issue (since we're just not checking stuff
> that isn't getting filled in), but I think it's a QoI issue - it
> allows users to successfully pass in bogus buffers with huge sizes,
> and then if the thing only reads a few bytes it will all be ok.
> 
> That's not a new thing: the old code may not have truncated the sizes,
> but if you pass in a 2GB buffer size, 99.999% of all socket read calls
> obviously won't ever fill that 2GB, but will happily return with
> whatever is there in the socket now (especially with nonblocking IO
> etc). But I do wonder if we shouldn't do the access_ok() on the whole
> buffer, as a way to keep user code honest.

I honestly don't think it matters.

I suppose we could put the access_ok() check right before these
single-buffer truncations, and then also in the per-iovec check of
{compat_}verify_iovec().

But what would all of that really give us?

Ingrained in datagram socket handling is the idea that the whole
buffer will be processed, and for stream sockets partial buffer
transfers are OK.

And I think this aligns with how we implement and check things
right now.
