Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1CQOxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:53:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1CQOxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:53:07 -0400
Date: Thu, 17 Mar 2011 15:53:01 +0100
From: Jan Kara <jack@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
Message-ID: <20110317145301.GD4116@quack.suse.cz>
References: <20110311171006.ec0d9c37.akpm@linux-foundation.org>
 <AANLkTimT-kRMQW3JKcJAZP4oD3EXuE-Bk3dqumH_10Oe@mail.gmail.com>
 <20110314202324.GG31120@redhat.com>
 <AANLkTinDNOLMdU7EEMPFkC_f9edCx7ZFc7=qLRNAEmBM@mail.gmail.com>
 <20110315184839.GB5740@redhat.com>
 <20110316131324.GM2140@cmpxchg.org>
 <AANLkTim7q3cLGjxnyBS7SDdpJsGi-z34bpPT=MJSka+C@mail.gmail.com>
 <20110316215214.GO2140@cmpxchg.org>
 <AANLkTinCErw+0QGpXJ4+JyZ1O96BC7SJAyXaP4t5v17c@mail.gmail.com>
 <20110317124350.GQ2140@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317124350.GQ2140@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-03-11 13:43:50, Johannes Weiner wrote:
> > - mem_cgroup_balance_dirty_pages(): if memcg dirty memory usage if above
> >   background limit, then add memcg to global memcg_over_bg_limit list and use
> >   memcg's set of memcg_bdi to wakeup each(?) corresponding bdi flusher.  If over
> >   fg limit, then use IO-less style foreground throttling with per-memcg per-bdi
> >   (aka memcg_bdi) accounting structure.
> 
> I wonder if we could just schedule a for_background work manually in
> the memcg case that writes back the corresponding memcg_bdi set (and
> e.g. having it continue until either the memcg is below bg thresh OR
> the global bg thresh is exceeded OR there is other work scheduled)?
> Then we would get away without the extra list, and it doesn't sound
> overly complex to implement.
  But then when you stop background writeback because of other work, you
have to know you should restart it after that other work is done. For this
you basically need the list. With this approach of one-work-per-memcg
you also get into problems that one cgroup can livelock the flusher thread
and thus other memcgs won't get writeback. So you have to switch between
memcgs once in a while.

We've tried several approaches with global background writeback before we
arrived at what we have now and what seems to work at least reasonably...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
