Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab0FJLYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:24:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab0FJLYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:24:03 -0400
Message-ID: <4C10CB39.70002@kernel.org>
Date: Thu, 10 Jun 2010 13:23:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: hmajxxlh@corbac.com, fuse-devel@lists.sourceforge.net, mszeredi@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] OSS Proxy Jack slave
References: <20100601092456.GA23572@alia.nute.net> <4C066CF4.2050902@gmail.com>	<20100605085045.GA5630@alia.nute.net> <4C0A1369.9010601@kernel.org> <E1OMICc-0005f8-G5@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OMICc-0005f8-G5@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 11:23:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

On 06/09/2010 12:08 PM, Miklos Szeredi wrote:
> I thought a bit about mmap in the last couple of days, and here's what
> I came up with.  This week I'll take a stab at implementing some of
> this (as a hack week project, let's say :).

Cool. :-)

> First, I think server side mmap might be nice to have but not strictly
> necessary.  I looked at osspd and it just memcopies in and out of the
> mmaped ring buffer.  Replacing those memcopies with explicit syscalls
> to get and put the data should work fine.  I doubt that the latency or
> CPU overhead introduced by the syscalls would actually matter in
> practice.

The latency and CPU overhead perse aren't problematic and for osspd,
copying in and out should be just fine as all update events are
clearly denoted.

> So we have the problem of how to do server initiated data transfer
> to/from kernel buffers.  We could introduce the following
> "notifications", which are initiated by the filesystem:
> 
> store request
>  u64 nodeid
>  u64 offset
>  u32 size
>  u32 padding
>  data...
> 
> retrieve request:
>  u64 request_id
>  u64 nodeid
>  u64 offset
>  u32 size
>  u32 padding
> 
> retrieve reply:
>  u64 request_id
>  data...
> 
> Notice the asymmetry, store doesn't need a reply but retrieve does.
> Which is unfortunate as it makes it harder to impelent on both the
> kernel side and the server side.

How does the kernel know when to issue store or retrieve?

> Next thing is how to deal with multiple buffers for each char device.
> For the above to continue to work we need to make sure there's a
> separate nodeid associated with each buffer.  The most general thing
> would be if MMAP reply contained a nodeid which identified the buffer.
> 
> Do you see any issues with the above?

It relates to the previous question but mmap can also be used without
all updates being notified by some kind of event where the server is
expected to watch the mmapped area and react which is okay if server
can share the mapped page but if it has to poll by copying data out of
kernel buffer each time, it can get prohibitively expensive unless it
can ask kernel "what changes since when?" which would be pretty nasty
to implement.

Thanks.

-- 
tejun
