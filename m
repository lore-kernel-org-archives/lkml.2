Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0IJHi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:38:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49425 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0IJHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:38:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Sep 2010 16:33:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mark Hills <mark@pogo.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: cgroup: rmdir() does not complete
Message-Id: <20100910163354.1f719c0d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LNX.2.01.1009100818480.5721@vega.localdomain>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
	<20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
	<20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
	<20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz>
	<20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.NEB.2.01.1009091051400.17759@jrf.vwaro.pbz>
	<20100909100909.GM4443@balbir.in.ibm.com>
	<alpine.NEB.2.01.1009091234230.26366@jrf.vwaro.pbz>
	<1284033017.402.8.camel@laptop>
	<alpine.NEB.2.01.1009091416100.26432@jrf.vwaro.pbz>
	<20100910111646.a03ed3ba.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LNX.2.01.1009100818480.5721@vega.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 08:28:00 +0100 (BST)
Mark Hills <mark@pogo.org.uk> wrote:

> On Fri, 10 Sep 2010, KAMEZAWA Hiroyuki wrote:
> 
> > On Fri, 10 Sep 2010 00:04:31 +0100 (BST)
> > Mark Hills <mark@pogo.org.uk> wrote:
> > > The report on the spinning process (23586) is dominated by calls from 
> > > mem_cgroup_force_empty.
> > > 
> > > It seems to show lru_add_drain_all and drain_all_stock_sync are causing 
> > > the load (I assume drain_all_stock_sync has been optimised out). But I 
> > > don't think this is as important as what causes the spin.
> > > 
> > 
> > I noticed you use FUSE and it seems there is a problem in FUSE v.s. memcg.
> > I wrote a patch (onto 2.6.36 but can be applied..)
> > 
> > Could you try this ? I'm sorry I don't use FUSE system and can't test
> > right now.
> 
> What makes you conclude that FUSE is in use? I do not think this is the 
> case. Or do you mean that it is a problem that the kernel is built with 
> FUSE support?
> 
You wrote 
> The test case I was running is similar to the above. With the Lustre 
> filesystem the problem takes 4 hours or more to show itself. Recently I 
> ran 4 threads for over 24 hours without it being seen -- I suspect some 
> external factor is involved.

I think Lustre FS is using FUSE. I'm wrong ?


> I _can_ test the patch, but I still cannot reliably reproduce the problem 
> so it will be hard to conclude whether the patch works or not. Is there a 
> way to build a test case for this?
> 

I'm sorry I'm not sure yet. But from your report, you have 6 pages of charge
which cannot be found by force_empty(). And I found FUSE's pipe copy code
inserts a page cache into radix-tree but not move them onto LRU.

So,
  - There are remaining pages which is out-of-LRU
  - FUSE's "move" code does something curious, add_to_page_cache() but not LRU.
  - You reporeted you use Lustre FS.

Then, I ask you. To test this, I have to study FUSE to write test module...
Maybe adding printk() to where I added gfp_mask modification of fuse/dev.c
can show something but...

We may have something other problem, but it seems this is one of them.

Thanks,
-Kame

