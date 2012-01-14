Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab2ANF1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:27:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49264 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2ANF1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120113153950.7426eee2.akpm@linux-foundation.org>
References: <CAJd=RBBF=K5hHvEwb6uwZJwS4=jHKBCNYBTJq-pSbJ9j_ZaiaA@mail.gmail.com>
	<20111222163604.GB14983@tiehlicka.suse.cz>
	<CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
	<20120104151632.05e6b3b0.akpm@linux-foundation.org>
	<CAJd=RBDOn22=CAFcEx9try8onsaHsweny_B1ZvnGJO-0h7eZAQ@mail.gmail.com>
	<20120113153950.7426eee2.akpm@linux-foundation.org>
Date: Sat, 14 Jan 2012 13:27:19 +0800
Message-ID: <CAJd=RBCz_UHDXVpeoOQM5u9oPySPyAn0vnUYgkJAUqib8EUZtA@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: undo change to page mapcount in fault handler
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 7:39 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Jan 2012 20:06:30 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
>
>> On Thu, Jan 5, 2012 at 7:16 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Fri, 23 Dec 2011 21:00:41 +0800
>> > Hillf Danton <dhillf@gmail.com> wrote:
>> >
>> >> Page mapcount should be updated only if we are sure that the page ends
>> >> up in the page table otherwise we would leak if we couldn't COW due to
>> >> reservations or if idx is out of bounds.
>> >
>> > It would be much nicer if we could run vma_needs_reservation() before
>> > even looking up or allocating the page.
>> >
>> > And afaict the interface is set up to do that: you run
>> > vma_needs_reservation() before allocating the page and then
>> > vma_commit_reservation() afterwards.
>> >
>> > But hugetlb_no_page() and hugetlb_fault() appear to have forgotten to
>> > run vma_commit_reservation() altogether. __Why isn't this as busted as
>> > it appears to be?
>>
>> Hi Andrew
>>
>> IIUC the two operations, vma_{needs, commit}_reservation, are folded in
>> alloc_huge_page(), need to break the pair?
>
> Looking at it again, it appears that the vma_needs_reservation() calls
> are used to predict whether a subsequent COW attempt is going to fail.
>
> If that's correct then things aren't as bad as I first thought.
> However I suspect the code in hugetlb_no_page() is a bit racy: the
> vma_needs_reservation() call should happen after we've taken
> page_table_lock.  As things stand, another thread could sneak in there
> and steal the reservation which this thread thought was safe.
>
> What do you think?
>

Hi Andrew

The case of no page, in the fault path, is handled after acquiring
hugetlb_instantiation_mutex, and on ohter hand, kmalloc is called
if new region required, so no race to check reservation needed but
after spinning page_table_lock.

Thanks
Hillf
