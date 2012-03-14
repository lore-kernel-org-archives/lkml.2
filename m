Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab2CNAaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:30:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44453 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab2CNAaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:30:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Mar 2012 09:28:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        gthelen@google.com, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [RFC REPOST] cgroup: removing css reference drain wait during
 cgroup removal
Message-Id: <20120314092828.3321731c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120313163914.GD7349@google.com>
References: <20120312213155.GE23255@google.com>
	<20120312213343.GF23255@google.com>
	<20120313151148.f8004a00.kamezawa.hiroyu@jp.fujitsu.com>
	<20120313163914.GD7349@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 09:39:14 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello, KAMEZAWA.
> 
> On Tue, Mar 13, 2012 at 03:11:48PM +0900, KAMEZAWA Hiroyuki wrote:
> > The trouble for pre_destroy() is _not_ refcount, Memory cgroup has its own refcnt
> > and use it internally. The problem is 'charges'. It's not related to refcnt.
> 
> Hmmm.... yeah, I'm not familiar with memcg internals at all.  For
> blkcg, refcnt matters but if it doesn't for memcg, great.
> 
> > Cgroup is designed to exists with 'tasks'. But memory may not be related to any
> > task...just related to a cgroup.
> > 
> > But ok, pre_destory() & rmdir() is complicated, I agree.
> > 
> > Now, we prevent rmdir() if we can't move charges to its parent. If pre_destory()
> > shouldn't fail, I can think of some alternatives.
> > 
> >  * move all charges to the parent and if it fails...move all charges to
> >    root cgroup.
> >    (drop_from_memory may not work well in swapless system.)
> 
> I think this one is better and this shouldn't fail if hierarchical
> mode is in use, right?
> 

Right.


> > I think.. if pre_destory() never fails, we don't need pre_destroy().
> 
> For memcg maybe, blkcg still needs it.
> 
> > >   The last one seems more tricky.  On destruction of cgroup, the
> > >   charges are transferred to its parent and the parent may not have
> > >   enough room for that.  Greg told me that this should only be a
> > >   problem for !hierarchical case.  I think this can be dealt with by
> > >   dumping what's left over to root cgroup with a warning message.
> > 
> > I don't like warning ;) 
> 
> I agree this isn't perfect but then again failing rmdir isn't perfect
> either and given that the condition can be wholly avoided in
> hierarchical mode, which should be the default anyway (is there any
> reason to keep flat mode except for backward compatibility?), I don't
> think the trade off is too bad.
> 

One reason is 'performance'. You can see performance trouble when you
creates deep tree of memcgs in hierarchy mode. The deeper memcg tree,
the more res_coutners will be shared.

For example, libvirt creates cgroup tree as

	/cgroup/memory/libvirt/qemu/GuestXXX/....
        /cgroup/memory/libvirt/lxc/GuestXXX/...

No one don't want to count up 4 res_coutner, which is very very heavy,
for handling independent workloads of "Guest".

IIUC, in general, even in the processes are in a tree, in major case
of servers, their workloads are independent.
I think FLAT mode is the dafault. 'heararchical' is a crazy thing which
cannot be managed.


Thanks,
-Kame

