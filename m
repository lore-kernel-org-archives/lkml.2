Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2BVRoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:44:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51603 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2BVRoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:44:00 -0500
Message-ID: <4F45293C.8050209@zytor.com>
Date: Wed, 22 Feb 2012 09:43:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Kent <raven@themaw.net>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: compat: autofs v5 packet size ambiguity - update
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com> <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com> <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com> <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com> <1329889428.2193.45.camel@perseus.themaw.net> <4F4484F0.9070501@zytor.com> <CA+55aFwUvuaGdnpwVQLQLF=DdqROmKqz65v+_DXHbebNhPqkLg@mail.gmail.com>
In-Reply-To: <CA+55aFwUvuaGdnpwVQLQLF=DdqROmKqz65v+_DXHbebNhPqkLg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 08:10 AM, Linus Torvalds wrote:
> 
> Well, the kernel gives the right semantics for pipes too - writes are
> guaranteed to be "atomic", so even in the presence of multiple writers
> you can trivially do packetized data.
> 
> You just have to (a) add the length to the packet and (b) do the
> length+packet write as a single write (which is limited to PIPE_SIZE -
> 4kB - for the atomicity guarantee).
> 
> If you don't have multiple concurrent writers without locking, the (b)
> part falls away entirely, of course.
> 
> Yes, for the reader side you need to be able to handle the fact that
> you can get more than one packet in one read() call, but sorting that
> out isn't hard either.
> 

What you describe above is pretty much how autofs 3 used to work; except
it would do one read() for the header including length and then another
read() for the body.  Of course, it could just have read ahead -- if you
read part of the next packet, it wouldn't really matter since at least
at that time the daemon was single-threaded and would have to loop back
anyway.

The PIPE_SIZE guarantee took care of the fact that this was a multiple
writer/single reader situation (since the writes happens in the context
of the process requesting a mount.)  Either way, SOCK_DGRAM and
SOCK_SEQPACKET would solve all of the problems and would Just Work, and
packet boundaries would then be explicit.

> But yeah, writing fixed-size data and then having a reader that reads
> fixed-size data is just not a very good approach. It's doubly bad when
> the "fixed size" isn't an explicit size that is documented in the
> protocol, but depends on data structures.

Indeed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

