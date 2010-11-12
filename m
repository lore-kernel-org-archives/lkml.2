Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0KLBYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:24:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48098 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0KLBYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vn9Lb4Oku6fop6cou/oNeiJ+bUVaN5LdSbIeRg4FpNsHgJxV0SOupSJELu2MTg/b3D
         sTZibvK4KgwydeiHoPM7SAngUWU9HplBCWzWu2dx2jiUhaXz94STkJADOCUY9fQ7Cp0C
         A7aG2JmKtf2zcjptvlCbriTxQXpLXQIC0nuVg=
MIME-Version: 1.0
In-Reply-To: <20101109220506.GE3246@amd>
References: <20101109124610.GB11477@amd>
	<AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
	<1289319698.2774.16.camel@edumazet-laptop>
	<AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
	<20101109220506.GE3246@amd>
Date: Fri, 12 Nov 2010 12:24:21 +1100
Message-ID: <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
Subject: Re: [patch 1/6] fs: icache RCU free inodes
From: Nick Piggin <npiggin@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 9:05 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
>> On Tue, Nov 9, 2010 at 8:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >
>> > You can see problems using this fancy thing :
>> >
>> > - Need to use slab ctor() to not overwrite some sensitive fields of
>> > reused inodes.
>> >  (spinlock, next pointer)
>>
>> Yes, the downside of using SLAB_DESTROY_BY_RCU is that you really
>> cannot initialize some fields in the allocation path, because they may
>> end up being still used while allocating a new (well, re-used) entry.
>>
>> However, I think that in the long run we pretty much _have_ to do that
>> anyway, because the "free each inode separately with RCU" is a real
>> overhead (Nick reports 10-20% cost). So it just makes my skin crawl to
>> go that way.
>
> This is a creat/unlink loop on a tmpfs filesystem. Any real filesystem
> is going to be *much* heavier in creat/unlink (so that 10-20% cost would
> look more like a few %), and any real workload is going to have much
> less intensive pattern.

So to get some more precise numbers, on a new kernel, and on a nehalem
class CPU, creat/unlink busy loop on ramfs (worst possible case for inode
RCU), then inode RCU costs 12% more time.

If we go to ext4 over ramdisk, it's 4.2% slower. Btrfs is 4.3% slower, XFS
is about 4.9% slower.

Remember, this is on a ramdisk that's _hitting the CPU's L3 if not L2_
cache. A real disk, even a fast SSD, is going to do IO far slower.

And also remember that real workloads will not approach creat/unlink busy
loop behaviour of creating and destroying 800K files/s. So even if you were
creating and destroying 80K files per second per CPU, the overall slowdown
will be on the order of 0.4% (but really, we know that very few workloads
even do that much creat/unlink activity, otherwise we would be totally
bottlenecked on inode_lock long ago).

The next factor is that the slowdown from RCU is reduced if you creat and
destroy longer batches of inodes. If you create 1000, then destroy 1000
inodes in a busy loop, then the ramfs regression is reduced to a 4.5%
disadvantage with RCU, and ext4 disadvantage is down to 1%. Because you
lose a lot of your CPU cache advantages anyway.

And the fact is I have not been able to find anything except microbenchmarks
where I can detect any slowdown at all.

And you obviously have seen the actual benefits that come with this -- kernel
time to do path walking in your git workload is 2x faster even with
just a single
thread running.

So this is really not a "oh, maybe someone will see 10-20% slowdown", or even
1-2% slowdown. I would even be surprised at a 0.1-0.2% slowdown on a real
workload, but that would be about the order of magnitude I am prepared to live
with. If, in the very unlikely case we saw 1-2% type of magnitude, I would start
looking at improvements or ways to do SLAB_RCU.

Are you happy with that?
