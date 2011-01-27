Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1A0ETU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 23:19:20 -0500
Received: from smtp-out.google.com ([74.125.121.67]:4903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1A0ETT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 23:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y/7E7Xq6npfJdL233X8JDKPAsOPQMx6wuElpPm0R/L4nk8Sd/ZEsu+PCeXGLBD908K
         14Clf8AfpUxcCM9cRHbw==
MIME-Version: 1.0
In-Reply-To: <E1PhSO8-0005yN-Dp@pomaz-ex.szeredi.hu>
References: <E1PftfG-0007w1-Ek@pomaz-ex.szeredi.hu>
	<20110120124043.GA4347@infradead.org>
	<E1PfvGx-00086O-IA@pomaz-ex.szeredi.hu>
	<alpine.LSU.2.00.1101212014330.4301@sister.anvils>
	<E1PhSO8-0005yN-Dp@pomaz-ex.szeredi.hu>
Date: Wed, 26 Jan 2011 20:19:15 -0800
Message-ID: <AANLkTimBR=CuMpWE2juJG2jsLsTqK=tc00sRrEjhkHg=@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same inode
From: Hugh Dickins <hughd@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, gurudas.pai@oracle.com,
        lkml20101129@newton.leun.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:47 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, 21 Jan 2011, Hugh Dickins wrote:
>> On Thu, 20 Jan 2011, Miklos Szeredi wrote:
>> > On Thu, 20 Jan 2011, Christoph Hellwig wrote:
>> > > On Thu, Jan 20, 2011 at 01:30:58PM +0100, Miklos Szeredi wrote:
>> > > >
>> > > > Truncate and hole punching already serialize with i_mutex.  Other
>> > > > callers of unmap_mapping_range() do not, and it's difficult to get
>> > > > i_mutex protection for all callers.  In particular ->d_revalidate(),
>> > > > which calls invalidate_inode_pages2_range() in fuse, may be called
>> > > > with or without i_mutex.
>> > >
>> > >
>> > > Which I think is mostly a fuse problem.  I really hate bloating the
>> > > generic inode (into which the address_space is embedded) with another
>> > > mutex for deficits in rather special case filesystems.
>> >
>> > As Hugh pointed out unmap_mapping_range() has grown a varied set of
>> > callers, which are difficult to fix up wrt i_mutex.  Fuse was just an
>> > example.
>> >
>> > I don't like the bloat either, but this is the best I could come up
>> > with for fixing this problem generally.  If you have a better idea,
>> > please share it.
>>
>> If we start from the point that this is mostly a fuse problem (I expect
>> that a thorough audit will show up a few other filesystems too, but
>> let's start from this point): you cite ->d_revalidate as a particular
>> problem, but can we fix up its call sites so that it is always called
>> either with, or much preferably without, i_mutex held?  Though actually
>> I couldn't find where ->d_revalidate() is called while holding i_mutex.
>
> lookup_one_len
> lookup_hash
>  __lookup_hash
>    do_revalidate
>     d_revalidate

Right, thanks.

>
> I don't see an easy way to get rid of i_mutex for lookup_one_len() and
> lookup_hash().
>
>> Failing that, can fuse down_write i_alloc_sem before calling
>> invalidate_inode_pages2(_range), to achieve the same exclusion?
>> The setattr truncation path takes i_alloc_sem as well as i_mutex,
>> though I'm not certain of its full coverage.
>
> Yeah, fuse could use i_alloc_sem or a private mutex, but that would
> leave the other uses of unmap_mapping_range() to sort this out for
> themsevels.

I had wanted to propose that for now you modify just fuse to use
i_alloc_sem for serialization there, and I provide a patch to
unmap_mapping_range() to give safety to whatever other cases there are
(I'm now sure there are other cases, but also sure that I cannot
safely identify them all and fix them correctly at source myself -
even if I found time to do the patches, they'd need at least a release
cycle to bed in with BUG_ONs).

I've spent quite a while on it, but not succeeded: even if I could get
around the restart_addr issue, we're stuck with the deadly embrace
when two are in unmap_mapping_range(), each repeatedly yielding to the
other, each having to start over again.  Anything I came up with was
inferior to the two alternatives you have proposed: your original
wait_on_bit patch, or your current unmap_mutex patch.

Your wait_on_bit patch doesn't bloat (and may be attractive to
enterprise distros seeking binary compatibility), but several of us
agreed with Andrew's comments:

> I do think this was premature optimisation.  The open-coded lock is
> hidden from lockdep so we won't find out if this introduces potential
> deadlocks.  It would be better to add a new mutex at least temporarily,
> then look at replacing it with a MiklosLock later on, when the code is
> bedded in.
>
> At which time, replacing mutexes with MiklosLocks becomes part of a
> general "shrink the address_space" exercise in which there's no reason
> to exclusively concentrate on that new mutex!

It really does seem a mutex too far; but we may let Peter do away with
all that lock breaking when/if his preemptibility patches go in, and
could cut it out at that time.  I don't see a good alternative.

Hugh
