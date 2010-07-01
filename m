Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0GARgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:36:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab0GARgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20100630124049.GH21358@laptop>
References: <20100624030212.676457061@suse.de>
	<20100630113054.GL24712@dastard>
	<20100630124049.GH21358@laptop>
Date: Thu, 1 Jul 2010 10:35:35 -0700
Message-ID: <AANLkTilZHnTiTJRYtYAkAChvAZKy-ZD-7M0y5o3hvRr1@mail.gmail.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 5:40 AM, Nick Piggin <npiggin@suse.de> wrote:
>>
>> That's a pretty big ouch. Why does RCU freeing of inodes cause that
>> much regression? The RCU freeing is out of line, so where does the big
>> impact come from?
>
> That comes mostly from inability to reuse the cache-hot inode structure,
> and the cost to go over the deferred RCU list and free them after they
> get cache cold.

I do wonder if this isn't a big design bug.

Most of the time with RCU, we don't need to wait to actually do the
_freeing_ of the individual data structure, we only need to make sure
that the data structure remains of the same _type_. IOW, we can free
it (and re-use it), but the backing storage cannot be released to the
page cache. That's what SLAB_DESTROY_BY_RCU should give us.

Is that not possible in this situation? Do we really need to keep the
inode _identity_ around for RCU?

If you use just SLAB_DESTROY_BY_RCU, then inode re-use remains, and
cache behavior would be much improved. The usual requirement for
SLAB_DESTROY_BY_RCU is that you only touch a lock (and perhaps
re-validate the identity) in the RCU-reader paths. Could that be made
to work?

Because that 27% drop really is pretty distressing.

That said, open (of the non-creating kind), close, and stat are
certainly more important than creating and freeing files. So as a
trade-off, it's probably the right thing to do. But if we can get all
the improvement _without_ that big downside, that would obviously be
better yet.

                      Linus
