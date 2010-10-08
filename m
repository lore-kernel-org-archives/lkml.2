Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0JHJEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:04:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51472 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0JHJEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:04:46 -0400
Date: Fri, 8 Oct 2010 14:34:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Message-ID: <20101008090427.GB5327@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101008104852.803E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101008104852.803E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-10-08 10:48:26]:

> Recently, Robert Mueller reported zone_reclaim_mode doesn't work
> properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
> He is using Cyrus IMAPd and it's built on a very traditional
> single-process model.
> 
>   * a master process which reads config files and manages the other
>     process
>   * multiple imapd processes, one per connection
>   * multiple pop3d processes, one per connection
>   * multiple lmtpd processes, one per connection
>   * periodical "cleanup" processes.
> 
> Then, there are thousands of independent processes. The problem is,
> recent Intel motherboard turn on zone_reclaim_mode by default and
> traditional prefork model software don't work fine on it.
> Unfortunatelly, Such model is still typical one even though 21th
> century. We can't ignore them.
> 
> This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> relatively cheap 2-4 socket machine are often used for tradiotional
> server as above. The intention is, their machine don't use
> zone_reclaim_mode.
> 
> Note: ia64 and Power have arch specific RECLAIM_DISTANCE definition.
> then this patch doesn't change such high-end NUMA machine behavior.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Bron Gondwana <brong@fastmail.fm>
> Cc: Robert Mueller <robm@fastmail.fm>
> Acked-by: Christoph Lameter <cl@linux.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/topology.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 64e084f..bfbec49 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -60,7 +60,7 @@ int arch_update_cpu_topology(void);
>   * (in whatever arch specific measurement units returned by node_distance())
>   * then switch on zone reclaim on boot.
>   */
> -#define RECLAIM_DISTANCE 20
> +#define RECLAIM_DISTANCE 30
>  #endif
>  #ifndef PENALTY_FOR_NODE_WITH_CPUS
>  #define PENALTY_FOR_NODE_WITH_CPUS	(1)

I am not sure if this makes sense, since RECLAIM_DISTANCE is supposed
to be a hardware parameter. Could you please help clarify what the
access latency of a node with RECLAIM_DISTANCE 20 to that of a node
with RECLAIM_DISTANCE 30 is? Has the hardware definition of reclaim
distance changed?

I suspect the side effect is the zone_reclaim_mode is not set to 1 on
bootup for the 2-4 socket machines you mention, which results in
better VM behaviour?

-- 
	Three Cheers,
	Balbir
