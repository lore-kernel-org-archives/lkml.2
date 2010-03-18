Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0CRAtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:49:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50272 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab0CRAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:49:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Mar 2010 09:45:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrea Righi <arighi@develer.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
Message-Id: <20100318094519.cd1eed72.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100318085411.834e1e46.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
	<1268609202-15581-2-git-send-email-arighi@develer.com>
	<20100317115855.GS18054@balbir.in.ibm.com>
	<20100318085411.834e1e46.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 08:54:11 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 17 Mar 2010 17:28:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Andrea Righi <arighi@develer.com> [2010-03-15 00:26:38]:
> > 
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > Now, file-mapped is maintaiend. But more generic update function
> > > will be needed for dirty page accounting.
> > > 
> > > For accountig page status, we have to guarantee lock_page_cgroup()
> > > will be never called under tree_lock held.
> > > To guarantee that, we use trylock at updating status.
> > > By this, we do fuzzy accounting, but in almost all case, it's correct.
> > >
> > 
> > I don't like this at all, but in almost all cases is not acceptable
> > for statistics, since decisions will be made on them and having them
> > incorrect is really bad. Could we do a form of deferred statistics and
> > fix this.
> > 
> 
> plz show your implementation which has no performance regresssion.
> For me, I don't neee file_mapped accounting, at all. If we can remove that,
> we can add simple migration lock.
> file_mapped is a feattue you added. please improve it.
> 

BTW, I should explain how acculate this accounting is in this patch itself.

Now, lock_page_cgroup/unlock_page_cgroup happens when
	- charge/uncharge/migrate/move accounting

Then, the lock contention (trylock failure) seems to occur in conflict
with
	- charge, uncharge, migarate. move accounting

About dirty accounting, charge/uncharge/migarate are operation in synchronous
manner with radix-tree (holding treelock etc). Then no account leak.
move accounting is only source for inacculacy...but I don't think this move-task
is ciritial....moreover, we don't move any file pages at task-move, now.
(But Nishimura-san has a plan to do so.)
So, contention will happen only at confliction with force_empty.

About FILE_MAPPED accounting, it's not synchronous with radix-tree operaton.
Then, accounting-miss seems to happen when charge/uncharge/migrate/account move.
But
	charge .... we don't account a page as FILE_MAPPED before it's charged.
	uncharge .. usual operation in turncation is unmap->remove-from-radix-tree.
		    Then, it's sequential in almost all case. The race exists when...
		    Assume there are 2 threads A and B. A truncate a file, B map/unmap that.
		    This is very unusal confliction.
	migrate.... we do try_to_unmap before migrating pages. Then, FILE_MAPPED
		    is properly handled.
	move account .... we don't have move-account-mapped-file, yet.

Then, this trylock contention happens at contention with force_empty and truncate.


Then, main issue for contention is force_empty. But it's called for removing memcg,
accounting for such memcg is not important.
Then, I say "this accounting is Okay."

To do more accurate, we may need another "migration lock". But to get better
performance for root cgroup, we have to call mem_cgroup_is_root() before
taking lock and there will be another complicated race.

Bye,
-Kame












