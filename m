Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab1DAOuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:50:52 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32757 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753360Ab1DAOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:50:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GJ4nszgVM1k58wasmsK_HwgI4BiH.OCGqwdFV0Zo9jZyHIq
 3ue2jfI3PmHptMmWRzPPPpz7xgKq8kx97Jc3_FKUA2_i6bu.Ionf3RdpG.QW
 i_BXhXJMVMwkcEVKf1HDMmk.61vYL5p.bZx.MTVbYh75OLsayw6WTYzi.EQz
 aFpbF_0T0dMv9bKwpl5MsH4GUXYrGl_dyeMSL9mkd.c_i6TqLRl3aK07lg0c
 61azQrFYHO7mqyiMfgO0gO0Eb9dq36IVKi2YzY71ImrPPxKcfcwGp8LzEGaT
 WVJWInXGk9_Rk2pKpcKHjFthttSXnGwe89M1B8Ds.IqbHsJvB
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 1 Apr 2011 09:50:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
In-Reply-To: <20110401221921.A890.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104010945190.17929@router.home>
References: <20110331144145.0ECA.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103311451530.28364@router.home> <20110401221921.A890.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, KOSAKI Motohiro wrote:

> > On Thu, 31 Mar 2011, KOSAKI Motohiro wrote:
> >
> > > 1) zone reclaim doesn't work if the system has multiple node and the
> > >    workload is file cache oriented (eg file server, web server, mail server, et al).
> > >    because zone recliam make some much free pages than zone->pages_min and
> > >    then new page cache request consume nearest node memory and then it
> > >    bring next zone reclaim. Then, memory utilization is reduced and
> > >    unnecessary LRU discard is increased dramatically.
> >
> > That is only true if the webserver only allocates from a single node. If
> > the allocation load is balanced then it will be fine. It is useful to
> > reclaim pages from the node where we allocate memory since that keeps the
> > dataset node local.
>
> Why?
> Scheduler load balancing only consider cpu load. Then, usually memory
> pressure is no complete symmetric. That's the reason why we got the
> bug report periodically.

The scheduler load balancing also considers caching effects. It does not
consider NUMA effects aside from heuritics though. If processes are
randomly moving around then zone reclaim is not effective. Processes need
to stay mainly on a certain node and memory needs to be allocatable from
that node in order to improve performance. zone_reclaim is useless if you
toss processes around the box.

> btw, when we are talking about memory distance aware reclaim, we have to
> recognize traditional numa (ie external node interconnect) and on-chip
> numa have different performance characteristics. on-chip remote node access
> is not so slow, then elaborated nearest node allocation effort doesn't have
> so much worth. especially, a workload use a lot of short lived object.
> Current zone-reclaim don't have so much issue when using traditiona numa
> because it's fit your original design and assumption and administrators of
> such systems have good skill and don't hesitate to learn esoteric knobs.
> But recent on-chip and cheap numa are used for much different people against
> past. therefore new issues and claims were raised.

You can switch NUMA off completely at the bios level. Then the distances
are not considered by the OS. If they are not relevant then lets just
switch NUMA off. Managing NUMA distances can cause significant overhead.
