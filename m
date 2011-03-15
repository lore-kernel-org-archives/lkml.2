Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab1COXMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:12:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1COXMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:12:19 -0400
Date: Tue, 15 Mar 2011 19:11:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
Message-ID: <20110315231139.GE5740@redhat.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <20110311171006.ec0d9c37.akpm@linux-foundation.org>
 <AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
 <20110314202324.GG31120@redhat.com>
 <AANLkTinDNOLMdU7EEMPFkC_f9edCx7ZFc7=qLRNAEmBM@mail.gmail.com>
 <20110315212339.GC5740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110315212339.GC5740@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 05:23:39PM -0400, Vivek Goyal wrote:
> On Mon, Mar 14, 2011 at 07:41:13PM -0700, Greg Thelen wrote:
> > On Mon, Mar 14, 2011 at 1:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Mon, Mar 14, 2011 at 11:29:17AM -0700, Greg Thelen wrote:
> > >
> > > [..]
> > >> > We could just crawl the memcg's page LRU and bring things under control
> > >> > that way, couldn't we?  That would fix it.  What were the reasons for
> > >> > not doing this?
> > >>
> > >> My rational for pursuing bdi writeback was I/O locality.  I have heard that
> > >> per-page I/O has bad locality.  Per inode bdi-style writeback should have better
> > >> locality.
> > >>
> > >> My hunch is the best solution is a hybrid which uses a) bdi writeback with a
> > >> target memcg filter and b) using the memcg lru as a fallback to identify the bdi
> > >> that needed writeback.  I think the part a) memcg filtering is likely something
> > >> like:
> > >>  http://marc.info/?l=linux-kernel&m=129910424431837
> > >>
> > >> The part b) bdi selection should not be too hard assuming that page-to-mapping
> > >> locking is doable.
> > >
> > > Greg,
> > >
> > > IIUC, option b) seems to be going through pages of particular memcg and
> > > mapping page to inode and start writeback on particular inode?
> > 
> > Yes.
> > 
> > > If yes, this might be reasonably good. In the case when cgroups are not
> > > sharing inodes then it automatically maps one inode to one cgroup and
> > > once cgroup is over limit, it starts writebacks of its own inode.
> > >
> > > In case inode is shared, then we get the case of one cgroup writting
> > > back the pages of other cgroup. Well I guess that also can be handeled
> > > by flusher thread where a bunch or group of pages can be compared with
> > > the cgroup passed in writeback structure. I guess that might hurt us
> > > more than benefit us.
> > 
> > Agreed.  For now just writing the entire inode is probably fine.
> > 
> > > IIUC how option b) works then we don't even need option a) where an N level
> > > deep cache is maintained?
> > 
> > Originally I was thinking that bdi-wide writeback with memcg filter
> > was a good idea.  But this may be unnecessarily complex.  Now I am
> > agreeing with you that option (a) may not be needed.  Memcg could
> > queue per-inode writeback using the memcg lru to locate inodes
> > (lru->page->inode) with something like this in
> > [mem_cgroup_]balance_dirty_pages():
> > 
> >   while (memcg_usage() >= memcg_fg_limit) {
> >     inode = memcg_dirty_inode(cg);  /* scan lru for a dirty page, then
> > grab mapping & inode */
> >     sync_inode(inode, &wbc);
> >   }
> 
> Is it possible to pass mem_cgroup in writeback_control structure or in
> work structure which in turn will be set in writeback_control.  And
> modify writeback_inodes_wb() which will look that ->mem_cgroup is
> set. So instead of calling queue_io() it can call memcg_queue_io()
> and then memory cgroup can look at lru list and take its own decision
> on which inodes needs to be pushed for IO?

Thinking more about it, for foreground work probably your solution of
sync_inode() and writting actively in the context of dirtier is also
good. It has the disadvantage of that it does not take into account
IO less throttling but if forground IO is submitted in the context
of memcg process and we can do per process submitted IO accounting
and move nr_requests out of request queue. 

using memcg_queue_io() has one disadvantage that it will take memcg's
dirty inodes from ->b_dirty list and put on ->b_io list. That is
equivalent to prioritizing writeback of memcg inodes and it can starve
root cgroup inode's starvation.

May be we can use memcg_queue_io() for background writeout and
sync_inode() for foreground writeout. And design memcg in such a way
so that it moves one of its own inode on io_list and at the same it
moves one more inode which does not belong to it. That might help
in mitigating the issue of starving root cgroup and also help making
sure that we don't end up writting lot of other inodes before the
dirty background ratio of a cgroup is under control.

Also need to check how it is going to interact with IO less throttling.
My head is spinning now. It is complicated. Will read more code tomorrow.

Thanks
Vivek
