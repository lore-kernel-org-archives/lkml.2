Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0DNCAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:00:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57138 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0DNCAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:00:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Apr 2010 10:56:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][BUGFIX][PATCH] memcg: fix underflow of mapped_file stat
Message-Id: <20100414105608.d40c70ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100414104010.7a359d04.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
	<20100413151400.cb89beb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414095408.d7b352f1.nishimura@mxp.nes.nec.co.jp>
	<20100414100308.693c5650.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414104010.7a359d04.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 10:40:10 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 14 Apr 2010 10:03:08 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > > @@ -2563,6 +2565,15 @@ void mem_cgroup_end_migration(struct mem
> > > >  	 */
> > > >  	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
> > > >  		mem_cgroup_uncharge_page(target);
> > > > +	else {
> > > > +		/*
> > > > +		 * When a migrated file cache is remapped, it's not charged.
> > > > +		 * Verify it. Because we're under lock_page(), there are
> > > > +		 * no race with uncharge.
> > > > +		 */
> > > > +		if (page_mapped(target))
> > > > +			mem_cgroup_update_file_mapped(mem, target, 1);
> > > > +	}
> > > We cannot rely on page lock, because when we succeeded in page migration,
> > > "target" = "newpage" has already unlocked in move_to_new_page(). So the "target"
> > > can be removed from the radix-tree theoretically(it's not related to this
> > > underflow problem, though).
> > > Shouldn't we call lock_page(target) and check "if (!target->mapping)" to handle
> > > this case(maybe in another patch) ?
> > > 
> > Sounds reasonable. I think about that.
> > 
> 

Thinking again....new page is unlocked here. It means the new page may be
removed from radix-tree before commit_charge().

Haha, it seems totally wrong. please wait..

Thanks,
-Kame






