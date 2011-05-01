Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1EAAoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 20:44:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46897 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1EAAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 20:44:00 -0400
Message-ID: <4DBCACAA.2080902@kernel.org>
Date: Sat, 30 Apr 2011 17:43:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()
References: <1304090924-8197-1-git-send-email-tj@kernel.org> <4DBB1C16.3070307@kernel.org> <20110430121734.GF29280@htj.dyndns.org> <20110430123330.GG29280@htj.dyndns.org>
In-Reply-To: <20110430123330.GG29280@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DBCACC0.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 05:33 AM, Tejun Heo wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> numa_cleanup_meminfo() trims each memblk between low (0) and high
> (max_pfn) limits and discard empty ones.  However, the emptiness
> detection incorrectly used equality test.  If the start of a memblk is
> higher than max_pfn, it is empty but fails the equality test and
> doesn't get discarded.
> 
> Fix it by using >= instead of ==.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> So, something like this.  Does this fix the problem you see?
> 
> Thanks.
> 
>  arch/x86/mm/numa_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: work/arch/x86/mm/numa.c
> ===================================================================
> --- work.orig/arch/x86/mm/numa.c
> +++ work/arch/x86/mm/numa.c
> @@ -191,7 +191,7 @@ int __init numa_cleanup_meminfo(struct n
>  		bi->end = min(bi->end, high);
>  
>  		/* and there's no empty block */
> -		if (bi->start == bi->end) {
> +		if (bi->start >= bi->end) {
>  			numa_remove_memblk_from(i--, mi);
>  			continue;
>  		}
this one works too
but print out is some strange
on 512g system got:

SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-1080000000
SRAT: Node 1 PXM 1 1080000000-2080000000
SRAT: Node 2 PXM 2 2080000000-3080000000
SRAT: Node 3 PXM 3 3080000000-4080000000
SRAT: Node 4 PXM 4 4080000000-5080000000
SRAT: Node 5 PXM 5 5080000000-6080000000
SRAT: Node 6 PXM 6 6080000000-7080000000
SRAT: Node 7 PXM 7 7080000000-8080000000
NUMA: Initialized distance table, cnt=8
NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
NUMA: Node 0 [0,80000000) + [100000000,1080000000) -> [0,1000000000)


first patch on 512g system got 
NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
NUMA: Node 0 [0,80000000) + [100000000,1000000000) -> [0,1000000000)

still thinking first one is more clean.

Thanks

Yinghai
