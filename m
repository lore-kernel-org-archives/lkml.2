Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0HWR0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0HWR03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:26:29 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, npiggin@kernel.dk
Subject: Re: aio: bump i_count instead of using igrab
References: <20100823144755.GP21975@think>
	<20100823145031.GA1279@infradead.org> <20100823150023.GR21975@think>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Aug 2010 13:26:13 -0400
In-Reply-To: <20100823150023.GR21975@think> (Chris Mason's message of "Mon, 23
	Aug 2010 11:00:23 -0400")
Message-ID: <x49mxsd2qbu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

> On Mon, Aug 23, 2010 at 10:50:31AM -0400, Christoph Hellwig wrote:
>> On Mon, Aug 23, 2010 at 10:47:55AM -0400, Chris Mason wrote:
>> > The aio batching code is using igrab to get an extra reference on the
>> > inode so it can safely batch.  igrab will go ahead and take the global
>> > inode spinlock, which can be a bottleneck on large machines doing lots
>> > of AIO.
>> > 
>> > In this case, igrab isn't required because we already have a reference
>> > on the file handle.  It is safe to just bump the i_count directly
>> > on the inode.
>> > 
>> > Benchmarking shows this patch brings IOP/s on tons of flash up by about
>> > 2.5X.
>> 
>> There's some places in XFS where we do the same, and it showed up as a
>> bottle neck before.  Instead of open coding the increment we have
>> a wrapper that includes and assert that the numbers is always positive.
>> 
>> I think we really want a proper helper for general use instead of
>> completly opencoding it.
>> 
>
> Nick, this is about a 1 liner to fs/aio.c replacing igrab with
> atomic_inc directly on the inode reference count.
>
> I know your scalability tree gets rid of the global, but in this case I
> think it still makes sense to avoid the locking completely when the
> caller knows it is safe.  Do you already have something similar hiding
> in the scalability tree?

I opted for the safe route, initially, as I was not too familiar with
the locking.  If it's deemed safe to just do the increment, that works
for me.

Thanks for tracking this down, Chris!

Cheers,
Jeff
