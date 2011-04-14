Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab1DNPGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:06:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56320 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab1DNPGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aleTRLqKkS1cmLsoWptKEVfiJMijT+XVc82Uln0KVBYNXi2/uXHRotEiJDjXYUKG+O
         YHdvL0CFRhh8u8yA4py5KrcOD2cmfqHAr1W8Qk98iB/n+N20/Zxgf4IJ3+sVfOfrf8dl
         GKkTtpRniAVNnO94NUFfWwTkjdf52g+sXf188=
Date: Fri, 15 Apr 2011 00:05:51 +0900
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v2] x86-64, NUMA: fix fakenuma boot failure
Message-ID: <20110414150551.GC21397@mtj.dyndns.org>
References: <20110413160239.D72A.A69D9226@jp.fujitsu.com>
 <20110413193219.GF3987@mtj.dyndns.org>
 <20110414095059.080E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414095059.080E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 14, 2011 at 09:51:00AM +0900, KOSAKI Motohiro wrote:
> hmm...  My carbon copy is not corrupted. Maybe crappy intermediate
> server override it ?

Sorry about that.  Problem was on my side.

The patch itself looks good to me now, so,

 Acked-by: Tejun Heo <tj@kernel.org>

but I have some nitpicky comments and it would be nice if you can
respin the patch with the suggested updates.

> Currently, numa=fake boot parameter is broken. If it's used, kernel
> doesn't boot and makes panic by zero divide error.

"kernel may panic due to devide by zero error depending on CPU
configuration"

> The zero divede is caused following line. (ie group->cpu_power==0)
> 
> update_sg_lb_stats()

Maybe it would be a good idea to prefix the above with filename, ie -
"kernel/sched_fail.c::update_sg_lb_stats()"

> This is regression  since commit e23bba6044 (x86-64, NUMA: Unify
> emulated distance mapping). Because It drop fake_physnodes() and
> then cpu-node mapping was changed.

"This is a regression caused by blah blah because it changes cpu ->
node mapping in the process of dropping fake_physnodes()"

> old) all cpus are assinged node 0
> now) cpus are assigned round robin
>      (the logic is implemented by numa_init_array())

It would be nice to note that the above happens only for CPUs which
lack explicit NUMA configuration information.

> Why round robin assignment doesn't work? Because init_numa_sched_groups_power()
> assume all logical cpus in the same physical cpu are assigned the same node.
  ^^^^^^                                           ^^^^^^^^^^^^
  assumes                                            share

> (Then it only account group_first_cpu()). But the simple round robin
                ^^^^^^^                   ^^^^^
              accounts for      probably ", and" would work better here
> broke the above assumption.
  ^^^^^
  breaks

> Thus, this patch implement to reassigne node-id if buggy firmware or numa
> emulation makes wrong cpu node map.

It would be nice if you can detail the solution a bit more.  What it's
doing, which configuration it affects and so on.

> +	/*
> +	 * Our CPU scheduler assume all logical cpus in the same physical cpu
> +	 * package are assigned the same node. But, Buggy ACPI table or NUMA
> +	 * emulation might assign them to different node. Fix it.
> +	*/

Care to make the above a docbook comment?

Thank you.

-- 
tejun
