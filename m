Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1CPVTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:19:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1CPVTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FPE+4OBDW9sEviy81fMcpbqd5j0AANzUWr6J9itzXpPHruKs39h9Tj2+QpBRbHZ2jh
         SDrf6MWBVzePeYJoTz6A==
MIME-Version: 1.0
In-Reply-To: <20110316131324.GM2140@cmpxchg.org>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <20110311171006.ec0d9c37.akpm@linux-foundation.org> <AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
 <20110314202324.GG31120@redhat.com> <AANLkTinDNOLMdU7EEMPFkC_f9edCx7ZFc7=qLRNAEmBM@mail.gmail.com>
 <20110315184839.GB5740@redhat.com> <20110316131324.GM2140@cmpxchg.org>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 16 Mar 2011 14:19:26 -0700
Message-ID: <AANLkTim7q3cLGjxnyBS7SDdpJsGi-z34bpPT=MJSka+C@mail.gmail.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
To: Johannes Weiner <hannes@cmpxchg.org>
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
        Justin TerAvest <teravest@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 6:13 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Mar 15, 2011 at 02:48:39PM -0400, Vivek Goyal wrote:
>> On Mon, Mar 14, 2011 at 07:41:13PM -0700, Greg Thelen wrote:
>> > On Mon, Mar 14, 2011 at 1:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > > On Mon, Mar 14, 2011 at 11:29:17AM -0700, Greg Thelen wrote:
>> > >
>> > > [..]
>> > >> > We could just crawl the memcg's page LRU and bring things under control
>> > >> > that way, couldn't we?  That would fix it.  What were the reasons for
>> > >> > not doing this?
>> > >>
>> > >> My rational for pursuing bdi writeback was I/O locality.  I have heard that
>> > >> per-page I/O has bad locality.  Per inode bdi-style writeback should have better
>> > >> locality.
>> > >>
>> > >> My hunch is the best solution is a hybrid which uses a) bdi writeback with a
>> > >> target memcg filter and b) using the memcg lru as a fallback to identify the bdi
>> > >> that needed writeback.  I think the part a) memcg filtering is likely something
>> > >> like:
>> > >>  http://marc.info/?l=linux-kernel&m=129910424431837
>> > >>
>> > >> The part b) bdi selection should not be too hard assuming that page-to-mapping
>> > >> locking is doable.
>> > >
>> > > Greg,
>> > >
>> > > IIUC, option b) seems to be going through pages of particular memcg and
>> > > mapping page to inode and start writeback on particular inode?
>> >
>> > Yes.
>> >
>> > > If yes, this might be reasonably good. In the case when cgroups are not
>> > > sharing inodes then it automatically maps one inode to one cgroup and
>> > > once cgroup is over limit, it starts writebacks of its own inode.
>> > >
>> > > In case inode is shared, then we get the case of one cgroup writting
>> > > back the pages of other cgroup. Well I guess that also can be handeled
>> > > by flusher thread where a bunch or group of pages can be compared with
>> > > the cgroup passed in writeback structure. I guess that might hurt us
>> > > more than benefit us.
>> >
>> > Agreed.  For now just writing the entire inode is probably fine.
>> >
>> > > IIUC how option b) works then we don't even need option a) where an N level
>> > > deep cache is maintained?
>> >
>> > Originally I was thinking that bdi-wide writeback with memcg filter
>> > was a good idea.  But this may be unnecessarily complex.  Now I am
>> > agreeing with you that option (a) may not be needed.  Memcg could
>> > queue per-inode writeback using the memcg lru to locate inodes
>> > (lru->page->inode) with something like this in
>> > [mem_cgroup_]balance_dirty_pages():
>> >
>> >   while (memcg_usage() >= memcg_fg_limit) {
>> >     inode = memcg_dirty_inode(cg);  /* scan lru for a dirty page, then
>> > grab mapping & inode */
>> >     sync_inode(inode, &wbc);
>> >   }
>> >
>> >   if (memcg_usage() >= memcg_bg_limit) {
>> >     queue per-memcg bg flush work item
>> >   }
>>
>> I think even for background we shall have to implement some kind of logic
>> where inodes are selected by traversing memcg->lru list so that for
>> background write we don't end up writting too many inodes from other
>> root group in an attempt to meet the low background ratio of memcg.
>>
>> So to me it boils down to coming up a new inode selection logic for
>> memcg which can be used both for background as well as foreground
>> writes. This will make sure we don't end up writting pages from the
>> inodes we don't want to.
>
> Originally for struct page_cgroup reduction, I had the idea of
> introducing something like
>
>        struct memcg_mapping {
>                struct address_space *mapping;
>                struct mem_cgroup *memcg;
>        };
>
> hanging off page->mapping to make memcg association no longer per-page
> and save the pc->memcg linkage (it's not completely per-inode either,
> multiple memcgs can still refer to a single inode).
>
> We could put these descriptors on a per-memcg list and write inodes
> from this list during memcg-writeback.
>
> We would have the option of extending this structure to contain hints
> as to which subrange of the inode is actually owned by the cgroup, to
> further narrow writeback to the right pages - iff shared big files
> become a problem.
>
> Does that sound feasible?

If I understand your memcg_mapping proposal, then each inode could
have a collection of memcg_mapping objects representing the set of
memcg that were charged for caching pages of the inode's data.  When a
new file page is charged to a memcg, then the inode's set of
memcg_mapping would be scanned to determine if current's memcg is
already in the memcg_mapping set.  If this is the first page for the
memcg within the inode, then a new memcg_mapping would be allocated
and attached to the inode.  The memcg_mapping may be reference counted
and would be deleted when the last inode page for a particular memcg
is uncharged.

  page->mapping = &memcg_mapping
  inode->i_mapping = collection of memcg_mapping, grows/shrinks with [un]charge

Am I close?

I still have to think though the various use cases, but I wanted to
make sure I had the basic idea.
