Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1IFKxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:53:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34129 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1IFKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:53:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 6 Sep 2011 19:45:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
Message-Id: <20110906194545.0533ff1f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110906104915.GC25053@redhat.com>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
	<20110906095852.GA25053@redhat.com>
	<20110906190424.ad5cc647.kamezawa.hiroyu@jp.fujitsu.com>
	<20110906104915.GC25053@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011 12:49:15 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Sep 06, 2011 at 07:04:24PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 6 Sep 2011 11:58:52 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > 
> > > On Wed, Aug 17, 2011 at 11:50:53PM -0700, Greg Thelen wrote:
> > > > Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
> > > > unnecessarily disabling preemption when adjusting per-cpu counters:
> > > >     preempt_disable()
> > > >     __this_cpu_xxx()
> > > >     __this_cpu_yyy()
> > > >     preempt_enable()
> > > > 
> > > > This change does not disable preemption and thus CPU switch is possible
> > > > within these routines.  This does not cause a problem because the total
> > > > of all cpu counters is summed when reporting stats.  Now both
> > > > mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
> > > >     this_cpu_xxx()
> > > >     this_cpu_yyy()
> > > > 
> > > > Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > Signed-off-by: Greg Thelen <gthelen@google.com>
> > > 
> > > I just noticed that both cases have preemption disabled anyway because
> > > of the page_cgroup bit spinlock.
> > > 
> > > So removing the preempt_disable() is fine but we can even keep the
> > > non-atomic __this_cpu operations.
> > > 
> > > Something like this instead?
> > > 
> > > ---
> > > From: Johannes Weiner <jweiner@redhat.com>
> > > Subject: mm: memcg: remove needless recursive preemption disabling
> > > 
> > > Callsites of mem_cgroup_charge_statistics() hold the page_cgroup bit
> > > spinlock, which implies disabled preemption.
> > > 
> > > The same goes for the explicit preemption disabling to account mapped
> > > file pages in mem_cgroup_move_account().
> > > 
> > > The explicit disabling of preemption in both cases is redundant.
> > > 
> > > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> > 
> > Could you add comments as
> > "This operation is called under bit spin lock !" ?
> 
> I left it as is in the file-mapped case, because if you read the
> __this_cpu ops and go looking for who disables preemption, you see the
> lock_page_cgroup() immediately a few lines above.
> 
> But I agree that the charge_statistics() is much less obvious, so I
> added a line there.
> 
> Is that okay?
> 

seems nice.

Thanks,
-Kame

> > Nice catch.
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
> 
> Thanks!
> 
> ---
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> ---
>  mm/memcontrol.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -615,6 +615,7 @@ static unsigned long mem_cgroup_read_eve
>  	return val;
>  }
>  
> +/* Must be called with preemption disabled */
>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>  					 bool file, int nr_pages)
>  {
> 

