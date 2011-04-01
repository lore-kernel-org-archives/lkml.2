Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1DAH5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:57:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35050 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1DAH5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:57:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20110331082813.GN2879@balbir.in.ibm.com>
References: <20110331144145.0ECA.A69D9226@jp.fujitsu.com> <20110331082813.GN2879@balbir.in.ibm.com>
Message-Id: <20110401165752.A889.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri,  1 Apr 2011 16:56:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > 1) zone reclaim doesn't work if the system has multiple node and the
> >    workload is file cache oriented (eg file server, web server, mail server, et al). 
> >    because zone recliam make some much free pages than zone->pages_min and
> >    then new page cache request consume nearest node memory and then it
> >    bring next zone reclaim. Then, memory utilization is reduced and
> >    unnecessary LRU discard is increased dramatically.
> > 
> >    SGI folks added CPUSET specific solution in past. (cpuset.memory_spread_page)
> >    But global recliam still have its issue. zone recliam is HPC workload specific 
> >    feature and HPC folks has no motivation to don't use CPUSET.
> 
> I am afraid you misread the patches and the intent. The intent to
> explictly enable control of unmapped pages and has nothing
> specifically to do with multiple nodes at this point. The control is
> system wide and carefully enabled by the administrator.

Hm. OK, I may misread.
Can you please explain the reason why de-duplication feature need to selectable and
disabled by defaut. "explicity enable" mean this feature want to spot corner case issue??


> > 2) Before 2.6.27, VM has only one LRU and calc_reclaim_mapped() is used to
> >    decide to filter out mapped pages. It made a lot of problems for DB servers
> >    and large application servers. Because, if the system has a lot of mapped
> >    pages, 1) LRU was churned and then reclaim algorithm become lotree one. 2)
> >    reclaim latency become terribly slow and hangup detectors misdetect its
> >    state and start to force reboot. That was big problem of RHEL5 based banking
> >    system.
> >    So, sc->may_unmap should be killed in future. Don't increase uses.
> > 
> 
> Can you remove sc->may_unmap without removing zone_reclaim()? The LRU
> churn can be addressed at the time of isolation, I'll send out an
> incremental patch for that.

At least, I don't plan to do it. because current zone_reclaim() works good on SGI
HPC workload and uncareful change can lead to break them. In other word, they 
understand their workloads are HPC specific and they understand they do how.

I'm worry about to spread out zone_reclaim() usage _without_ removing its assumption.
I wrote following by last mail.

> In other words, you have to kill following three for getting ack 1) zone 
> reclaim oriented reclaim 2) filter based LRU scanning (eg sc->may_unmap)
> 3) fastpath overhead. 

But another ways is there, probably. If you can improve zone_reclaim() for more generic
workload and fitting so so much people, I'll ack this.

Thanks.


