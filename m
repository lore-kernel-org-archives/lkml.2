Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0DOASy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 20:18:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34322 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0DOASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 20:18:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 15 Apr 2010 09:14:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Greg Thelen <gthelen@google.com>, balbir@linux.vnet.ibm.com,
       Andrea Righi <arighi@develer.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
Message-Id: <20100415091444.aa743668.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100414140430.GB13535@redhat.com>
References: <20100317115855.GS18054@balbir.in.ibm.com>
	<20100318085411.834e1e46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318041944.GA18054@balbir.in.ibm.com>
	<20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318162855.GG18054@balbir.in.ibm.com>
	<20100319102332.f1d81c8d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100319024039.GH18054@balbir.in.ibm.com>
	<20100319120049.3dbf8440.kamezawa.hiroyu@jp.fujitsu.com>
	<xr931veiplpr.fsf@ninji.mtv.corp.google.com>
	<20100414182904.2f72a63d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414140430.GB13535@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 10:04:30 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Apr 14, 2010 at 06:29:04PM +0900, KAMEZAWA Hiroyuki wrote:

> Hi Kame-san,
> 
> May be I am missing something but how does it solve the issue of making sure
> lock_page_cgroup() is not held in interrupt context? IIUC, above code will
> make sure that for file cache accouting, lock_page_cgroup() is taken only
> if task migration is on. But say task migration is on, and then some IO
> completes and we update WRITEBACK stat (i think this is the one which can
> be called from interrupt context), then we will still take the
> lock_page_cgroup() and again run into the issue of deadlocks?
> 
Yes and No.

At "Set", IIRC, almost all updates against DIRTY and WRITBACK accountings
can be done under mapping->tree_lock, which disables IRQ always.
(ex. I don't mention TestSetPageWriteback but account_page_diritied().)
Then, save/restore irq flags is just a cost and no benefit, in such cases.
Of course, there are cases irqs doesn't enabled.

About FILE_MAPPED, it's not updated under mapping->tree_lock. 
So, we'll have race with charge/uncharge. We have to take lock_page_cgroup(), always.


So, I think we'll have 2 or 3 interfaces, finally.
	mem_cgroup_update_stat_fast()  // the caller must disable IRQ and lock_page()
and
	mem_cgroup_update_stat_locked() // the caller has lock_page().
and
	mem_cgroup_update_stat_safe()  // the caller don't have to do anything.

Why update_stat_fast() is for avoiding _unnecessary_ costs.
When we lock a page and disables IRQ, we don't have to do anything.
There are no races. 

But yes, it's complicated. I'd like to see what we can do.


Thanks,
-Kame


