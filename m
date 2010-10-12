Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab0JLIoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:44:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45056 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab0JLIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:44:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Oct 2010 17:38:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrea Righi <arighi@develer.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 07/10] memcg: add dirty limits to mem_cgroup
Message-Id: <20101012173849.0ec845d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr931v7vdfxq.fsf@ninji.mtv.corp.google.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-8-git-send-email-gthelen@google.com>
	<20101005094302.GA4314@linux.develer.com>
	<xr93eic4wjlq.fsf@ninji.mtv.corp.google.com>
	<20101007091343.82ca9f7d.kamezawa.hiroyu@jp.fujitsu.com>
	<xr937hhuj19a.fsf@ninji.mtv.corp.google.com>
	<20101007094845.9e6a1b0f.kamezawa.hiroyu@jp.fujitsu.com>
	<xr93bp70febu.fsf@ninji.mtv.corp.google.com>
	<20101012095546.f23bb950.kamezawa.hiroyu@jp.fujitsu.com>
	<xr931v7vdfxq.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 00:32:33 -0700
Greg Thelen <gthelen@google.com> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> >> What are the cases where current->mm->owner->cgroups !=
> >> current->cgroups?
> >> 
> > In that case, assume group A and B.
> >
> >    thread(1) -> belongs to cgroup A  (thread(1) is mm->owner)
> >    thread(2) -> belongs to cgroup B
> > and
> >    a page    -> charnged to cgroup A
> >
> > Then, thread(2) make the page dirty which is under cgroup A.
> >
> > In this case, if page's dirty_pages accounting is added to cgroup B,
> > cgroup B' statistics may show "dirty_pages > all_lru_pages". This is
> > bug.
> 
> I agree that in this case the dirty_pages accounting should be added to
> cgroup A because that is where the page was charged.  This will happen
> because pc->mem_cgroup was set to A when the page was charged.  The
> mark-page-dirty code will check pc->mem_cgroup to determine which cgroup
> to add the dirty page to.
> 
> I think that the current vs current->mm->owner decision is in areas of
> the code that is used to query the dirty limits.  These routines do not
> use this data to determine which cgroup to charge for dirty pages.  The
> usage of either mem_cgroup_from_task(current->mm->owner) or
> mem_cgroup_from_task(current) in mem_cgroup_has_dirty_limit() does not
> determine which cgroup is added for dirty_pages.
> mem_cgroup_has_dirty_limit() is only used to determine if the process
> has a dirty limit.  As discussed, this is a momentary answer that may be
> wrong by the time decisions are made because the task may be migrated
> in-to/out-of root cgroup while mem_cgroup_has_dirty_limit() runs.  If
> the process has a dirty limit, then the process's memcg is used to
> compute dirty limits.  Using your example, I assume that thread(1) and
> thread(2) will git dirty limits from cgroup(A) and cgroup(B)
> respectively.
> 

Ok, thank you for clarification. Throttoling a thread based on its own
cgroup not based on mm->owner makes sense. Could you add a brief comment on
the code ?

Thanks,
-Kame

