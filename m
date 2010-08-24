Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0HXInr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:43:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33024 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0HXInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:43:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 17:38:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org,
        "nishimura\@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir\@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        m-ikeda@ds.jp.nec.com,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH] memcg: use ID in page_cgroup
Message-Id: <20100824173839.d8285b85.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr93r5hojtly.fsf@ninji.mtv.corp.google.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820190132.43684862.kamezawa.hiroyu@jp.fujitsu.com>
	<xr93aaoco3ix.fsf@ninji.mtv.corp.google.com>
	<20100824165108.dd986751.kamezawa.hiroyu@jp.fujitsu.com>
	<xr93r5hojtly.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 01:35:37 -0700
Greg Thelen <gthelen@google.com> wrote:

> > rcu_read_lock() is just for delaying to discard object, not for avoiding
> > racy updates. All _updates_ requires proper lock or speculative logic as
> > atomic_inc_not_zero() etc... Basically, RCU is for avoiding use-after-free.
> 
> 
> Thanks for the info.  Referring to your original patch:
> > @@ -2014,11 +2025,11 @@ static int mem_cgroup_move_account(struc
> >  {
> >  	int ret = -EINVAL;
> >  	lock_page_cgroup(pc);
> > -	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
> > +	if (PageCgroupUsed(pc) && id_to_memcg(pc->mem_cgroup, true) == from) {
> >  		__mem_cgroup_move_account(pc, from, to, uncharge);
> >  		ret = 0;
> >  	}
> > -	unlock_page_cgroup(pc);
> > +	rcu_read_unlock();
> > 
> 
> It seems like mem_cgroup_move_account() is not balanced.  Why is
> lock_page_cgroup(pc) used to lock but rcu_read_unlock() used to unlock?
> 

Nice catch. It's bug. It seems my eyes were corrupted..
Will be fixed in the next version. Sorry for bad code.

Thanks,
-Kame

