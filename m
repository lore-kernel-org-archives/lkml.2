Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab1E0ABb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:01:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51739 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab1E0AB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:01:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 May 2011 08:54:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCHv4] memcg: reclaim memory from node in round-robin
Message-Id: <20110527085440.71035539.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110526125207.e02e5775.akpm@linux-foundation.org>
References: <20110427165120.a60c6609.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinx+4zXaO3rhHRUzr3m-K-2_NMTQw@mail.gmail.com>
	<20110428093513.5a6970c0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110428103705.a284df87.nishimura@mxp.nes.nec.co.jp>
	<20110428104912.6f86b2ee.kamezawa.hiroyu@jp.fujitsu.com>
	<20110504142623.8aa3bddb.akpm@linux-foundation.org>
	<20110506151302.a7256987.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526125207.e02e5775.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 12:52:07 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 6 May 2011 15:13:02 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > It would be much better to work out the optimum time at which to rotate
> > > the index via some deterministic means.
> > > 
> > > If we can't think of a way of doing that then we should at least pace
> > > the rotation frequency via something saner than wall-time.  Such as
> > > number-of-pages-scanned.
> > > 
> > 
> > 
> > What I think now is using reclaim_stat or usigng some fairness based on
> > the ratio of inactive file caches. We can calculate the total sum of
> > recalaim_stat which gives us a scan_ratio for a whole memcg. And we can
> > calculate LRU rotate/scan ratio per node. If rotate/scan ratio is small,
> > it will be a good candidate of reclaim target. Hmm,
> > 
> >   - check which memory(anon or file) should be scanned.
> >     (If file is too small, rotate/scan ratio of file is meaningless.)
> >   - check rotate/scan ratio of each nodes.
> >   - calculate weights for each nodes (by some logic ?)
> >   - give a fair scan w.r.t node's weight.
> > 
> > Hmm, I'll have a study on this.
> 
> How's the study coming along ;)
> 
> I'll send this in to Linus today, but I'll feel grumpy while doing so. 
> We really should do something smarter here - the magic constant will
> basically always be suboptimal for everyone and we end up tweaking its
> value (if we don't, then the feature just wasn't valuable in the first
> place) and then we add a tunable and then people try to tweak the
> default setting of the tunable and then I deride them for not setting
> the tunable in initscripts and then we have to maintain the stupid
> tunable after we've changed the internal implementation and it's all
> basically screwed up.
> 
> How to we automatically determine the optimum time at which to rotate,
> at runtime?
> 

Ah, I think I should check it after dirty page accounting comes...because
ratio of dirty pages is an important information..

Ok, what I think now is just comparing the number of INACTIVE_FILE or the number
of FILE CACHES per node. 

I think we can periodically update per-node and total amount of file caches
and we can record per-node 
   node-file-cache * 100/ total-file cache
information into memcg's per-node structure.

Then, I think we can do some scheduling like lottery scheduling, a scan proportional
to the ratio of file caches in the memcg. If it's better to check INACTIVE_ANON, 
I think swappiness can be used in above calcuration.

But yes, I or someone may be able to think of something much better.

Thanks,
-Kame





