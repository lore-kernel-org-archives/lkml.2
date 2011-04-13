Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1DMTc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:32:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52594 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab1DMTc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QszgKBSITXuyeZVHRGB8xofWJ5GdIG8Q9bLfOoDLumBsggFg12SCNC0dfvyqIne47f
         Pm6iuaHX+V+8eufWaUA1DRBQqIBRC9F3Qve9oYO75cv2FUG+hXzuM0LZeBUFLCm4mERm
         O14EFIX5uHyAkoM5RphjQFo+LK3yICB9P+Gas=
Date: Thu, 14 Apr 2011 04:32:19 +0900
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86-64, NUMA: fix fakenuma boot failure
Message-ID: <20110413193219.GF3987@mtj.dyndns.org>
References: <20110412153212.B514.A69D9226@jp.fujitsu.com>
 <20110412071318.GA10425@mtj.dyndns.org>
 <20110413160239.D72A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413160239.D72A.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 13, 2011 at 04:02:43PM +0900, KOSAKI Motohiro wrote:
> Your patch have two mistake.
> 
>  1) link_thread_siblings() is for HT
>     set_cpu_sibling_map() has another sibling calculations.
>  2) numa_set_node() is not enough. scheduler is using node_to_cpumask_map[] too.

Thanks for seeing this through but your patch is badly whitespace
broken.  Can you please check your mail setup and repost?  Also, some
comments below.

> btw, Please see cpu_coregroup_mask(). its return value depend on 
> sched_mc_power_savings and sched_smt_power_savings. then, we need to care
> both cpu_core_mask and cpu_llc_shared_mask. I think.

Hmmmm....

> +static void __cpuinit node_cpumap_same_phys(int cpu1, int cpu2)

What does the "phys" mean?  Maybe something like
check_cpu_siblings_on_same_node() is a better name?

> +	/*
> +	 * Our CPU scheduler assume all cpus in the same physical cpu package
> +	 * are assigned the same node. But, Buggy ACPI table or NUMA emulation
> +	 * might assigne them to different node. Fix it.
		typo

> +	*/
> +	if (node1 != node2) {
> +		pr_warning("CPU %d in node %d and CPU %d in node %d are in the same physical CPU. forcing same node %d\n",
> +			   cpu1, node1, cpu2, node2, node2);
> +
> +		numa_set_node(cpu1, node2);
> +		cpumask_set_cpu(cpu1, node_to_cpumask_map[node2]);
> +		cpumask_clear_cpu(cpu1, node_to_cpumask_map[node1]);

Maybe what you want is the following?

	numa_remove_cpu(cpu1);
	numa_set_node(cpu1, node2)
	numa_add_cpu(cpu1)

Thanks.

-- 
tejun
