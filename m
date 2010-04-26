Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab0DZEGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 00:06:24 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54794 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0DZEGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 00:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E3uJ8Vi0JKosPjzAUscm85Cp5sLWssijk1aLztTXLHk8JTUu/wDjFslrx7ZSG2MAT+
         7ODcopldXZ9+/EMnVnY/JpsWYS0bBD698xzcoy9zPwGtGokwgzjxfHsuX0BcMl1tkfbI
         eFL6HuxJyaaNXIOdRUpBHNn/wDd+QdTPKkmp4=
MIME-Version: 1.0
In-Reply-To: <20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100423120148.9ffa5881.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100423095922.GJ30306@csn.ul.ie> <20100423155801.GA14351@csn.ul.ie>
	 <20100424110200.b491ec5f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100424104324.GD14351@csn.ul.ie>
	 <20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 26 Apr 2010 13:06:22 +0900
Message-ID: <o2l28c262361004252106k66375ed0v4970d6e2379b96e6@mail.gmail.com>
Subject: Re: [BUGFIX][mm][PATCH] fix migration race in rmap_walk
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 8:49 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Sat, 24 Apr 2010 11:43:24 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
>
>> On Sat, Apr 24, 2010 at 11:02:00AM +0900, KAMEZAWA Hiroyuki wrote:
>> > On Fri, 23 Apr 2010 16:58:01 +0100
>> > Mel Gorman <mel@csn.ul.ie> wrote:
>> >
>> > > > I had considered this idea as well as it is vaguely similar to how zones get
>> > > > resized with a seqlock. I was hoping that the existing locking on anon_vma
>> > > > would be usable by backing off until uncontended but maybe not so lets
>> > > > check out this approach.
>> > > >
>> > >
>> > > A possible combination of the two approaches is as follows. It uses the
>> > > anon_vma lock mostly except where the anon_vma differs between the page
>> > > and the VMAs being walked in which case it uses the seq counter. I've
>> > > had it running a few hours now without problems but I'll leave it
>> > > running at least 24 hours.
>> > >
>> > ok, I'll try this, too.
>> >
>> >
>> > > ==== CUT HERE ====
>> > >  mm,migration: Prevent rmap_walk_[anon|ksm] seeing the wrong VMA information by protecting against vma_adjust with a combination of locks and seq counter
>> > >
>> > > vma_adjust() is updating anon VMA information without any locks taken.
>> > > In constract, file-backed mappings use the i_mmap_lock. This lack of
>> > > locking can result in races with page migration. During rmap_walk(),
>> > > vma_address() can return -EFAULT for an address that will soon be valid.
>> > > This leaves a dangling migration PTE behind which can later cause a
>> > > BUG_ON to trigger when the page is faulted in.
>> > >
>> > > With the recent anon_vma changes, there is no single anon_vma->lock that
>> > > can be taken that is safe for rmap_walk() to guard against changes by
>> > > vma_adjust(). Instead, a lock can be taken on one VMA while changes
>> > > happen to another.
>> > >
>> > > What this patch does is protect against updates with a combination of
>> > > locks and seq counters. First, the vma->anon_vma lock is taken by
>> > > vma_adjust() and the sequence counter starts. The lock is released and
>> > > the sequence ended when the VMA updates are complete.
>> > >
>> > > The lock serialses rmap_walk_anon when the page and VMA share the same
>> > > anon_vma. Where the anon_vmas do not match, the seq counter is checked.
>> > > If a change is noticed, rmap_walk_anon drops its locks and starts again
>> > > from scratch as the VMA list may have changed. The dangling migration
>> > > PTE bug was not triggered after several hours of stress testing with
>> > > this patch applied.
>> > >
>> > > [kamezawa.hiroyu@jp.fujitsu.com: Use of a seq counter]
>> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> >
>> > I think this patch is nice!
>> >
>>
>> It looks nice but it still broke after 28 hours of running. The
>> seq-counter is still insufficient to catch all changes that are made to
>> the list. I'm beginning to wonder if a) this really can be fully safely
>> locked with the anon_vma changes and b) if it has to be a spinlock to
>> catch the majority of cases but still a lazy cleanup if there happens to
>> be a race. It's unsatisfactory and I'm expecting I'll either have some
>> insight to the new anon_vma changes that allow it to be locked or Rik
>> knows how to restore the original behaviour which as Andrea pointed out
>> was safe.
>>
> Ouch. Hmm, how about the race in fork() I pointed out ?

I thought it's possible.
Mel's test would take a long time to trigger BUG.
So I think we could solve one of problems. Remained one is about fork
race, I think.
Mel. Could you retry your test with below Kame's patch?
http://lkml.org/lkml/2010/4/23/58


-- 
Kind regards,
Minchan Kim
