Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0HXHrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:47:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38168 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0HXHrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:47:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 16:42:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org,
        "nishimura\@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir\@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        m-ikeda@ds.jp.nec.com,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH 2/5] memcg: use array and ID for quick look up
Message-Id: <20100824164206.37595039.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr9339u4pi84.fsf@ninji.mtv.corp.google.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185917.87876cb0.kamezawa.hiroyu@jp.fujitsu.com>
	<xr9339u4pi84.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 00:44:59 -0700
Greg Thelen <gthelen@google.com> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Now, memory cgroup has an ID per cgroup and make use of it at
> >  - hierarchy walk,
> >  - swap recording.
> >
> > This patch is for making more use of it. The final purpose is
> > to replace page_cgroup->mem_cgroup's pointer to an unsigned short.
> >
> > This patch caches a pointer of memcg in an array. By this, we
> > don't have to call css_lookup() which requires radix-hash walk.
> > This saves some amount of memory footprint at lookup memcg via id.
> >
> > Changelog: 20100811
> >  - adjusted onto mmotm-2010-08-11
> >  - fixed RCU related parts.
> >  - use attach_id() callback.
> >
> > Changelog: 20100804
> >  - fixed description in init/Kconfig
> >
> > Changelog: 20100730
> >  - fixed rcu_read_unlock() placement.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  init/Kconfig    |   10 ++++++
> >  mm/memcontrol.c |   83 ++++++++++++++++++++++++++++++++++++++++++--------------
> >  2 files changed, 73 insertions(+), 20 deletions(-)
> >
> > Index: mmotm-0811/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0811.orig/mm/memcontrol.c
> > +++ mmotm-0811/mm/memcontrol.c
> > @@ -195,6 +195,7 @@ static void mem_cgroup_oom_notify(struct
> >   */
> >  struct mem_cgroup {
> >  	struct cgroup_subsys_state css;
> > +	int	valid; /* for checking validness under RCU access.*/
> >  	/*
> >  	 * the counter to account for memory usage
> >  	 */
> > @@ -294,6 +295,29 @@ static bool move_file(void)
> >  					&mc.to->move_charge_at_immigrate);
> >  }
> >  
> > +/* 0 is unused */
> > +static atomic_t mem_cgroup_num;
> > +#define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
> > +static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
> > +
> > +/* Must be called under rcu_read_lock */
> > +static struct mem_cgroup *id_to_memcg(unsigned short id)
> > +{
> > +	struct mem_cgroup *ret;
> > +	/* see mem_cgroup_free() */
> > +	ret = rcu_dereference_check(mem_cgroups[id], rch_read_lock_held());
> 
> I think this be rcu_read_lock_held() instead of rch_read_lock_held()?
> 
yes, mayb overwritten by following patch.. thank you for finding.


Thanks,
-Kame

