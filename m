Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1EDVcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:32:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab1EDVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:32:29 -0400
Date: Wed, 4 May 2011 14:26:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCHv4] memcg: reclaim memory from node in round-robin
Message-Id: <20110504142623.8aa3bddb.akpm@linux-foundation.org>
In-Reply-To: <20110428104912.6f86b2ee.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110427165120.a60c6609.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinx+4zXaO3rhHRUzr3m-K-2_NMTQw@mail.gmail.com>
	<20110428093513.5a6970c0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110428103705.a284df87.nishimura@mxp.nes.nec.co.jp>
	<20110428104912.6f86b2ee.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 10:49:12 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 28 Apr 2011 10:37:05 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > +	if (time_after(mem->next_scan_node_update, jiffies))
> > > +		return;
> > > +
> > Shouldn't it be time_before() or time_after(jiffies, next_scan_node_update) ?
> > 
> > Looks good to me, otherwise.
> > 
> 
> time_after(a, b) returns true when a is after b.....you're right.
> ==
> Now, memory cgroup's direct reclaim frees memory from the current node.
> But this has some troubles. In usual, when a set of threads works in
> cooperative way, they are tend to on the same node. So, if they hit
> limits under memcg, it will reclaim memory from themselves, it may be
> active working set.
> 
> For example, assume 2 node system which has Node 0 and Node 1
> and a memcg which has 1G limit. After some work, file cacne remains and
> and usages are
>    Node 0:  1M
>    Node 1:  998M.
> 
> and run an application on Node 0, it will eats its foot before freeing
> unnecessary file caches.
> 
> This patch adds round-robin for NUMA and adds equal pressure to each
> node. When using cpuset's spread memory feature, this will work very well.
> 
> But yes, better algorithm is appreciated.

That ten-second thing is a gruesome and ghastly hack, but didn't even
get a mention in the patch description?

Talk to us about it.  Why is it there?  What are the implications of
getting it wrong?  What alternatives are there? 

It would be much better to work out the optimum time at which to rotate
the index via some deterministic means.

If we can't think of a way of doing that then we should at least pace
the rotation frequency via something saner than wall-time.  Such as
number-of-pages-scanned.

