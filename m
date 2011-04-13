Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab1DMAQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:16:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22081 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab1DMAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=d8noDbVPHR6EAnfpbJTaeWAGtFWHMEL/0aYPLyKSTCjCmJla4JhZbgVRjN8XMbHaeA
         aID1uQX5sJdugjsVnLjg==
Date: Tue, 12 Apr 2011 17:16:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robert Mueller <robm@fastmail.fm>
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <20110411172004.0361.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104121659510.10966@chino.kir.corp.google.com>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, KOSAKI Motohiro wrote:

> Recently, Robert Mueller reported zone_reclaim_mode doesn't work
> properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
> He is using Cyrus IMAPd and it's built on a very traditional
> single-process model.
> 

Let's add Robert to the cc to see if this is still an issue, it hasn't 
been re-reported in over six months.

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
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/topology.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index b91a40e..fc839bf 100644
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

I ack'd this because we use it internally and it never got pushed 
upstream, but I'm curious why it isn't being done only in the x86 
topology.h file if we're concerned with specific commodity hardware and 
implicitly affecting all architectures other than ia64 and powerpc.

It would be even better to get rid of RECLAIM_DISTANCE entirely since its 
fundamentally flawed without sanely configured SLITs per the ACPI spec, 
which specifies that these distances should be relative to the local 
distance of 10.  In this case, it would mean that the VM should prefer 
zone reclaim over remote node allocations when that memory takes 2x longer 
to access.  If your system doesn't have a SLIT, then remote nodes are 
assumed, possibly incorrectly, to have a latency 2x that of the local 
access.

We could probably do this if we measured the remote node memory access 
latency at boot and then define a threshold for turning zone_reclaim_mode 
on rather than relying on the distance at all.
