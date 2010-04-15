Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0DOA07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 20:26:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58951 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0DOA06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 20:26:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 15 Apr 2010 09:22:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: balbir@linux.vnet.ibm.com, Andrea Righi <arighi@develer.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
Message-Id: <20100415092258.9f837c12.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <p2k49b004811004140922v8b6c4c57j2dd435261ff2dd43@mail.gmail.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
	<20100318085411.834e1e46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318041944.GA18054@balbir.in.ibm.com>
	<20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com>
	<20100318162855.GG18054@balbir.in.ibm.com>
	<20100319102332.f1d81c8d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100319024039.GH18054@balbir.in.ibm.com>
	<20100319120049.3dbf8440.kamezawa.hiroyu@jp.fujitsu.com>
	<xr931veiplpr.fsf@ninji.mtv.corp.google.com>
	<20100414182904.2f72a63d.kamezawa.hiroyu@jp.fujitsu.com>
	<p2k49b004811004140922v8b6c4c57j2dd435261ff2dd43@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 09:22:41 -0700
Greg Thelen <gthelen@google.com> wrote:

> On Wed, Apr 14, 2010 at 2:29 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> >>       if (irqs_disabled()) {
> >>               if (! trylock_page_cgroup(pc))
> >>                       return;
> >>       } else
> >>               lock_page_cgroup(pc);
> >>
> >
> > I prefer trylock_page_cgroup() always.
> 
> What is your reason for preferring trylock_page_cgroup()?  I assume
> it's for code simplicity, but I wanted to check.
> 
> I had though about using trylock_page_cgroup() always, but I think
> that would make file_mapped accounting even more fuzzy that it already
> it is.  I was trying to retain the current accuracy of file_mapped and
> only make new counters, like writeback/dirty/etc (those obtained in
> interrupt), fuzzy.
> 

file_mapped should have different interface as mem_cgroup_update_stat_verrrry_safe().
or some.

I don't think accuracy is important (if it's doesn't go minus) but if people want,
I agree to keep it accurate.


> > I have another idea fixing this up _later_. (But I want to start from simple one.)
> >
> > My rough idea is following.  Similar to your idea which you gave me before.
> 
> Hi Kame-san,
> 
> I like the general approach.  The code I previously gave you appears
> to work and is faster than non-root memcgs using mmotm due to mostly
> being lockless.
> 
I hope so.

> > ==
> > DEFINE_PERCPU(account_move_ongoing);
> 
> What's the reason for having a per-cpu account_move_ongoing flag?
> Would a single system-wide global be sufficient?  I assume the
> majority of the time this value will not be changing because
> accounting moves are rare.
> 
> Perhaps all of the per-cpu variables are packed within a per-cpu
> cacheline making accessing it more likely to be local, but I'm not
> sure if this is true.
> 

Yes. this value is rarely updated but update is not enough rare to put
this value to read_mostly section. We see cacheline ping-pong by random
placement of global variables. This is performance critical.
Recent updates for percpu variables accessor makes access to percpu 
very efficient. I'd like to make use of it.

Thanks,
-Kame


