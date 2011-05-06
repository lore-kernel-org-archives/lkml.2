Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1EFGTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:19:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43762 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1EFGTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:19:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 May 2011 15:13:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCHv4] memcg: reclaim memory from node in round-robin
Message-Id: <20110506151302.a7256987.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110504142623.8aa3bddb.akpm@linux-foundation.org>
References: <20110427165120.a60c6609.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinx+4zXaO3rhHRUzr3m-K-2_NMTQw@mail.gmail.com>
	<20110428093513.5a6970c0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110428103705.a284df87.nishimura@mxp.nes.nec.co.jp>
	<20110428104912.6f86b2ee.kamezawa.hiroyu@jp.fujitsu.com>
	<20110504142623.8aa3bddb.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 14:26:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 28 Apr 2011 10:49:12 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 28 Apr 2011 10:37:05 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > +	if (time_after(mem->next_scan_node_update, jiffies))
> > > > +		return;
> > > > +
> > > Shouldn't it be time_before() or time_after(jiffies, next_scan_node_update) ?
> > > 
> > > Looks good to me, otherwise.
> > > 
> > 
> > time_after(a, b) returns true when a is after b.....you're right.
> > ==
> > Now, memory cgroup's direct reclaim frees memory from the current node.
> > But this has some troubles. In usual, when a set of threads works in
> > cooperative way, they are tend to on the same node. So, if they hit
> > limits under memcg, it will reclaim memory from themselves, it may be
> > active working set.
> > 
> > For example, assume 2 node system which has Node 0 and Node 1
> > and a memcg which has 1G limit. After some work, file cacne remains and
> > and usages are
> >    Node 0:  1M
> >    Node 1:  998M.
> > 
> > and run an application on Node 0, it will eats its foot before freeing
> > unnecessary file caches.
> > 
> > This patch adds round-robin for NUMA and adds equal pressure to each
> > node. When using cpuset's spread memory feature, this will work very well.
> > 
> > But yes, better algorithm is appreciated.
> 
> That ten-second thing is a gruesome and ghastly hack, but didn't even
> get a mention in the patch description?
> 
> Talk to us about it.  Why is it there?  What are the implications of
> getting it wrong?  What alternatives are there? 
> 

Ah, sorry I couldn't think of fix to that levet, I posted.

> It would be much better to work out the optimum time at which to rotate
> the index via some deterministic means.
> 
> If we can't think of a way of doing that then we should at least pace
> the rotation frequency via something saner than wall-time.  Such as
> number-of-pages-scanned.
> 


What I think now is using reclaim_stat or usigng some fairness based on
the ratio of inactive file caches. We can calculate the total sum of
recalaim_stat which gives us a scan_ratio for a whole memcg. And we can
calculate LRU rotate/scan ratio per node. If rotate/scan ratio is small,
it will be a good candidate of reclaim target. Hmm,

  - check which memory(anon or file) should be scanned.
    (If file is too small, rotate/scan ratio of file is meaningless.)
  - check rotate/scan ratio of each nodes.
  - calculate weights for each nodes (by some logic ?)
  - give a fair scan w.r.t node's weight.

Hmm, I'll have a study on this.

Thanks.
-Kame













