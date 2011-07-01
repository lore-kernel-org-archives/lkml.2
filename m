Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1GABXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:23:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43302 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1GABXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:23:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 1 Jul 2011 10:16:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v2
Message-Id: <20110701101624.a10b7e34.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110630180653.1df10f38.akpm@linux-foundation.org>
References: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110630130134.63a1dd37.akpm@linux-foundation.org>
	<20110701085013.4e8cbb02.kamezawa.hiroyu@jp.fujitsu.com>
	<20110701092059.be4400f7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110630180653.1df10f38.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 18:06:53 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 1 Jul 2011 09:20:59 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri, 1 Jul 2011 08:50:13 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Thu, 30 Jun 2011 13:01:34 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > Ok, I'll check it. Maybe I miss !CONFIG_SWAP...
> > > 
> > 
> > v4 here. Thank you for pointing out. I could think of several ways but
> > maybe this one is good because using vm_swappines with !CONFIG_SWAP seems
> > to be a bug.
> 
> No, it isn't a bug - swappiness also controls the kernel's eagerness to
> unmap and reclaim mmapped pagecache.
> 

Oh, really ? I didn't understand that.


> > tested with allyesconfig/allnoconfig.
> 
> Did it break the above?
> 

Hmm. If !CONFIG_SWAP, get_scan_count() will see !nr_swap_pages and
set scan ratio as
  file: 100%
  anon: 0%



> > +#ifdef CONFIG_SWAP
> > +static int vmscan_swappiness(struct scan_control *sc)
> > +{
> > +	if (scanning_global_lru(sc))
> > +		return vm_swappiness;
> 
> Well that's a bit ugly - it assumes that all callers set
> scan_control.swappiness to vm_swappiness then never change it.  That
> may be true in the current code.
> 
> Ho hum, I guess that's a simplification we can make.
> 

We don't calculate kernel internal swappiness and just use vm_swappines
which the user specified. So, I thought it should not be in scan_control.



> > +	return mem_cgroup_swappiness(sc->mem_cgroup);
> > +}
> > +#else
> > +static int vmscan_swappiness(struct scan_control *sc)
> > +{
> > +	/* Now, this function is never called with !CONFIG_SWAP */
> > +	BUG();
> > +	return 0;
> > +}
> > +#endif
> >
> > ...
> >
> > @@ -1789,8 +1804,8 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
> >  	 * With swappiness at 100, anonymous and file have the same priority.
> >  	 * This scanning priority is essentially the inverse of IO cost.
> >  	 */
> > -	anon_prio = sc->swappiness;
> > -	file_prio = 200 - sc->swappiness;
> > +	anon_prio = vmscan_swappiness(sc);
> > +	file_prio = 200 - vmscan_swappiness(sc);
> 
> hah, this should go BUG if CONFIG_SWAP=n.  But it won't, because we
> broke get_scan_count().  It fails to apply vm_swappiness to file-backed
> pages if there's no available swap, which is daft.
> 
> I think this happened in 76a33fc380c9a ("vmscan: prevent
> get_scan_ratio() rounding errors") which claims "this patch doesn't
> really change logics, but just increase precision".
> 

Hmm, IIUC.
  - the controller of unmapping file cache is now sc->may_unmap
    - may_unmap is always set 1 unless zone_reclaim_mode.
    - vm_swappiness doesn't affect it now. 
  - file LRU contains both mapped and unmapped pages in the same manner
    - get_scan_count() cannot help decisiion of "map or unmap"
    -  Active/Inactive scan ratio is now determined by reclaim_stat.

Hmm, swappiness should affect active/inactive scan ratio ?

Thanks,
-Kame






