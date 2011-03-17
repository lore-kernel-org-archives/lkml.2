Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1CQEmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 00:42:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20430 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1CQEmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 00:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PHeXoDPNBrkBSzDr7/JOSnHf3SxCf1PKbBQ2QR/EfqIqR9C1i1fkn79ThxZIr5oObJ
         2D8NvdRrd2MMIdubFQmA==
MIME-Version: 1.0
In-Reply-To: <20110316215214.GO2140@cmpxchg.org>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <20110311171006.ec0d9c37.akpm@linux-foundation.org> <AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
 <20110314202324.GG31120@redhat.com> <AANLkTinDNOLMdU7EEMPFkC_f9edCx7ZFc7=qLRNAEmBM@mail.gmail.com>
 <20110315184839.GB5740@redhat.com> <20110316131324.GM2140@cmpxchg.org>
 <AANLkTim7q3cLGjxnyBS7SDdpJsGi-z34bpPT=MJSka+C@mail.gmail.com> <20110316215214.GO2140@cmpxchg.org>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 16 Mar 2011 21:41:48 -0700
Message-ID: <AANLkTinCErw+0QGpXJ4+JyZ1O96BC7SJAyXaP4t5v17c@mail.gmail.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
To: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>,
        Curt Wohlgemuth <curtw@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 2:52 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Wed, Mar 16, 2011 at 02:19:26PM -0700, Greg Thelen wrote:
>> On Wed, Mar 16, 2011 at 6:13 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> > On Tue, Mar 15, 2011 at 02:48:39PM -0400, Vivek Goyal wrote:
>> >> I think even for background we shall have to implement some kind of logic
>> >> where inodes are selected by traversing memcg->lru list so that for
>> >> background write we don't end up writting too many inodes from other
>> >> root group in an attempt to meet the low background ratio of memcg.
>> >>
>> >> So to me it boils down to coming up a new inode selection logic for
>> >> memcg which can be used both for background as well as foreground
>> >> writes. This will make sure we don't end up writting pages from the
>> >> inodes we don't want to.
>> >
>> > Originally for struct page_cgroup reduction, I had the idea of
>> > introducing something like
>> >
>> >        struct memcg_mapping {
>> >                struct address_space *mapping;
>> >                struct mem_cgroup *memcg;
>> >        };
>> >
>> > hanging off page->mapping to make memcg association no longer per-page
>> > and save the pc->memcg linkage (it's not completely per-inode either,
>> > multiple memcgs can still refer to a single inode).
>> >
>> > We could put these descriptors on a per-memcg list and write inodes
>> > from this list during memcg-writeback.
>> >
>> > We would have the option of extending this structure to contain hints
>> > as to which subrange of the inode is actually owned by the cgroup, to
>> > further narrow writeback to the right pages - iff shared big files
>> > become a problem.
>> >
>> > Does that sound feasible?
>>
>> If I understand your memcg_mapping proposal, then each inode could
>> have a collection of memcg_mapping objects representing the set of
>> memcg that were charged for caching pages of the inode's data.  When a
>> new file page is charged to a memcg, then the inode's set of
>> memcg_mapping would be scanned to determine if current's memcg is
>> already in the memcg_mapping set.  If this is the first page for the
>> memcg within the inode, then a new memcg_mapping would be allocated
>> and attached to the inode.  The memcg_mapping may be reference counted
>> and would be deleted when the last inode page for a particular memcg
>> is uncharged.
>
> Dead-on.  Well, on which side you put the list - a per-memcg list of
> inodes, or a per-inode list of memcgs - really depends on which way
> you want to do the lookups.  But this is the idea, yes.
>
>>   page->mapping = &memcg_mapping
>>   inode->i_mapping = collection of memcg_mapping, grows/shrinks with [un]charge
>
> If the memcg_mapping list (or hash-table for quick find-or-create?)
> was to be on the inode side, I'd put it in struct address_space, since
> this is all about page cache, not so much an fs thing.
>
> Still, correct in general.
>

In '[PATCH v6 8/9] memcg: check memcg dirty limits in page writeback' Jan and
Vivek have had some discussion around how memcg and writeback mesh.
In my mind, the
discussions in 8/9 are starting to blend with this thread.

I have been thinking about Johannes' struct memcg_mapping.  I think the idea
may address several of the issues being discussed, especially
interaction between
IO-less balance_dirty_pages() and memcg writeback.

Here is my thinking.  Feedback is most welcome!

The data structures:
- struct memcg_mapping {
       struct address_space *mapping;
       struct mem_cgroup *memcg;
       int refcnt;
  };
- each memcg contains a (radix, hash_table, etc.) mapping from bdi to memcg_bdi.
- each memcg_bdi contains a mapping from inode to memcg_mapping.  This may be a
  very large set representing many cached inodes.
- each memcg_mapping represents all pages within an bdi,inode,memcg.  All
  corresponding cached inode pages point to the same memcg_mapping via
  pc->mapping.  I assume that all pages of inode belong to no more than one bdi.
- manage a global list of memcg that are over their respective background dirty
  limit.
- i_mapping continues to point to a traditional non-memcg mapping (no change
  here).
- none of these memcg_* structures affect root cgroup or kernels with memcg
  configured out.

The routines under discussion:
- memcg charging a new inode page to a memcg: will use inode->mapping and inode
  to walk memcg -> memcg_bdi -> memcg_mapping and lazily allocating missing
  levels in data structure.

- Uncharging a inode page from a memcg: will use pc->mapping->memcg to locate
  memcg.  If refcnt drops to zero, then remove memcg_mapping from the memcg_bdi.
  Also delete memcg_bdi if last memcg_mapping is removed.

- account_page_dirtied(): nothing new here, continue to set the per-page flags
  and increment the memcg per-cpu dirty page counter.  Same goes for routines
  that mark pages in writeback and clean states.

- mem_cgroup_balance_dirty_pages(): if memcg dirty memory usage if above
  background limit, then add memcg to global memcg_over_bg_limit list and use
  memcg's set of memcg_bdi to wakeup each(?) corresponding bdi flusher.  If over
  fg limit, then use IO-less style foreground throttling with per-memcg per-bdi
  (aka memcg_bdi) accounting structure.

- bdi writeback: will revert some of the mmotm memcg dirty limit changes to
  fs-writeback.c so that wb_do_writeback() will return to checking
  wb_check_background_flush() to check background limits and being
interruptible if
  sync flush occurs.  wb_check_background_flush() will check the global
  memcg_over_bg_limit list for memcg that are over their dirty limit.
  wb_writeback() will either (I am not sure):
  a) scan memcg's bdi_memcg list of inodes (only some of them are dirty)
  b) scan bdi dirty inode list (only some of them in memcg) using
     inode_in_memcg() to identify inodes to write.  inode_in_memcg(inode,memcg),
     would walk memcg- -> memcg_bdi -> memcg_mapping to determine if the memcg
     is caching pages from the inode.

- over_bground_thresh() will determine if memcg is still over bg limit.
  If over limit, then it per bdi per memcg background flushing will continue.
  If not over limit then memcg will be removed from memcg_over_bg_limit list.
