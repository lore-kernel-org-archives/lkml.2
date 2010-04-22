Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0DVOZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:25:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42413 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0DVOZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UFfqXLGblFZebWsgGUTE3IW/BF0Otyba3xpf1grgZvO3e0D1vdgsh455aURw8zTDPZ
         GJdz9QIL54UszCH5FB0+8r9PeV0ZINkasb+7w0lFrSOxpRUwEqRGQWy8HZGYEcBqkpiC
         vqE6hXSFaIv7JMnOTVQ5UgHWPhxSzGchaOy1c=
MIME-Version: 1.0
In-Reply-To: <20100422141404.GA30306@csn.ul.ie>
References: <alpine.DEB.2.00.1004211004360.4959@router.home>
	 <alpine.DEB.2.00.1004211027120.4959@router.home>
	 <20100421153421.GM30306@csn.ul.ie>
	 <alpine.DEB.2.00.1004211038020.4959@router.home>
	 <20100422092819.GR30306@csn.ul.ie>
	 <20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com>
	 <x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>
	 <20100422193106.9ffad4ec.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100422195153.d91c1c9e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100422141404.GA30306@csn.ul.ie>
Date: Thu, 22 Apr 2010 23:18:14 +0900
Message-ID: <p2y28c262361004220718m3a5e3e2ekee1fef7ebdae8e73@mail.gmail.com>
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 11:14 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Thu, Apr 22, 2010 at 07:51:53PM +0900, KAMEZAWA Hiroyuki wrote:
>> On Thu, 22 Apr 2010 19:31:06 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> > On Thu, 22 Apr 2010 19:13:12 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> > > On Thu, Apr 22, 2010 at 6:46 PM, KAMEZAWA Hiroyuki
>> > > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >
>> > > > Hmm..in my test, the case was.
>> > > >
>> > > > Before try_to_unmap:
>> > > >        mapcount=1, SwapCache, remap_swapcache=1
>> > > > After remap
>> > > >        mapcount=0, SwapCache, rc=0.
>> > > >
>> > > > So, I think there may be some race in rmap_walk() and vma handling or
>> > > > anon_vma handling. migration_entry isn't found by rmap_walk.
>> > > >
>> > > > Hmm..it seems this kind patch will be required for debug.
>> > >
>>
>> Ok, here is my patch for _fix_. But still testing...
>> Running well at least for 30 minutes, where I can see bug in 10minutes.
>> But this patch is too naive. please think about something better fix.
>>
>> ==
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> At adjust_vma(), vma's start address and pgoff is updated under
>> write lock of mmap_sem. This means the vma's rmap information
>> update is atoimic only under read lock of mmap_sem.
>>
>>
>> Even if it's not atomic, in usual case, try_to_ummap() etc...
>> just fails to decrease mapcount to be 0. no problem.
>>
>> But at page migration's rmap_walk(), it requires to know all
>> migration_entry in page tables and recover mapcount.
>>
>> So, this race in vma's address is critical. When rmap_walk meet
>> the race, rmap_walk will mistakenly get -EFAULT and don't call
>> rmap_one(). This patch adds a lock for vma's rmap information.
>> But, this is _very slow_.
>
> Ok wow. That is exceptionally well-spotted. This looks like a proper bug
> that compaction exposes as opposed to a bug that compaction introduces.
>
>> We need something sophisitcated, light-weight update for this..
>>
>
> In the event the VMA is backed by a file, the mapping i_mmap_lock is taken for
> the duration of the update and is  taken elsewhere where the VMA information
> is read such as rmap_walk_file()
>
> In the event the VMA is anon, vma_adjust currently talks no locks and your
> patch introduces a new one but why not use the anon_vma lock here? Am I
> missing something that requires the new lock?

rmap_walk_anon doesn't hold vma's anon_vma->lock.
It holds page->anon_vma->lock.

-- 
Kind regards,
Minchan Kim
