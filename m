Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0FIKIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:08:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40927 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab0FIKIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:08:21 -0400
To: Tejun Heo <tj@kernel.org>
CC: hmajxxlh@corbac.com, fuse-devel@lists.sourceforge.net, mszeredi@suse.cz,
       linux-kernel@vger.kernel.org
In-reply-to: <4C0A1369.9010601@kernel.org> (message from Tejun Heo on Sat, 05
	Jun 2010 11:05:45 +0200)
Subject: Re: [fuse-devel] OSS Proxy Jack slave
References: <20100601092456.GA23572@alia.nute.net> <4C066CF4.2050902@gmail.com>
	<20100605085045.GA5630@alia.nute.net> <4C0A1369.9010601@kernel.org>
Message-Id: <E1OMICc-0005f8-G5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jun 2010 12:08:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jun 2010, Tejun Heo wrote:
> Hello,
> 
> (cc'ing Miklos and mailing lists)
> 
> On 06/05/2010 10:50 AM, Mikael Bouillot wrote:
> > Just a quick question: have you reached some form of understanding
> > with Miklos Szeredi over the direct mmap in FUSE issue?
> > 
> > I've read the thread from February 2010, and though most of the
> > kernel material fly way over my head, I've got the general idea.
> > 
> > FUSD has had mmap support since around the time I started using
> > oss2jack, so I don't know exactly how many apps I use require it
> > (besides Quake3). I'll put a printf in my oss2jack's mmap() to
> > see what I'll be missing.
> > 
> > I could use a patched FUSE, but stopping to have to maintain a
> > piece of out-of-tree kernel code was The. Whole. Point. of
> > switching from FUSD to a CUSE-based system T_T
> 
> Miklos, any update on the mmap interface?

Sorry, got distracted by splice support on the fuse device.

I thought a bit about mmap in the last couple of days, and here's what
I came up with.  This week I'll take a stab at implementing some of
this (as a hack week project, let's say :).

First, I think server side mmap might be nice to have but not strictly
necessary.  I looked at osspd and it just memcopies in and out of the
mmaped ring buffer.  Replacing those memcopies with explicit syscalls
to get and put the data should work fine.  I doubt that the latency or
CPU overhead introduced by the syscalls would actually matter in
practice.

So we have the problem of how to do server initiated data transfer
to/from kernel buffers.  We could introduce the following
"notifications", which are initiated by the filesystem:

store request
 u64 nodeid
 u64 offset
 u32 size
 u32 padding
 data...

retrieve request:
 u64 request_id
 u64 nodeid
 u64 offset
 u32 size
 u32 padding

retrieve reply:
 u64 request_id
 data...

Notice the asymmetry, store doesn't need a reply but retrieve does.
Which is unfortunate as it makes it harder to impelent on both the
kernel side and the server side.

Next thing is how to deal with multiple buffers for each char device.
For the above to continue to work we need to make sure there's a
separate nodeid associated with each buffer.  The most general thing
would be if MMAP reply contained a nodeid which identified the buffer.

Do you see any issues with the above?

Thanks,
Miklos
