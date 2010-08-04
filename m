Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0HDB3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:29:08 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36130 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab0HDB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:29:06 -0400
Date: Wed, 4 Aug 2010 10:25:27 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mm 3/5] memcg scalable file stat accounting method
Message-Id: <20100804102527.d3bb4afc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100804101150.d7b05ce2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802191559.6af0cded.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804095513.6fef0a3d.nishimura@mxp.nes.nec.co.jp>
	<20100804101150.d7b05ce2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 10:11:50 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 4 Aug 2010 09:55:13 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > > @@ -1074,7 +1075,49 @@ static unsigned int get_swappiness(struc
> > >  	return swappiness;
> > >  }
> > >  
> > > -/* A routine for testing mem is not under move_account */
> > > +static void mem_cgroup_start_move(struct mem_cgroup *mem)
> > > +{
> > > +	int cpu;
> > > +	/* for fast checking in mem_cgroup_update_file_stat() etc..*/
> > > +	spin_lock(&mc.lock);
> > > +	for_each_possible_cpu(cpu)
> > > +		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
> > > +	spin_unlock(&mc.lock);
> > > +
> > > +	synchronize_rcu();
> > > +}
> > > +
> > > +static void mem_cgroup_end_move(struct mem_cgroup *mem)
> > > +{
> > > +	int cpu;
> > > +
> > > +	if (!mem)
> > > +		return;
> > Is this check necessary?
> > 
> 
> Yes, I hit NULL here.
> That happens migration=off case, IIRC.
> 
Ah, you're right.
Thank you for your clarification.

Daisuke Nishimura.
