Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1DHQno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:43:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34269 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab1DHQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sMcyKsbm3dplL8d6SSeqpxfuUrHqbMsONtmvWK5MgZwn7N29tCD2nYvE8FFsvVfFTn
         zSr+Lf9mUwVjjUOl92c62RJUBBSy3yPwKYf5mjj4off1M+u1Enn1DtdcRzp4e5I7a34c
         +mEu4Gvjagl1Q13zzM+B2NiaTTB3UuHnnB8lo=
Date: Fri, 8 Apr 2011 09:43:37 -0700
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86-64, NUMA: reimplement cpu node map initialization
 for fake numa
Message-ID: <20110408164337.GC3871@mtj.dyndns.org>
References: <20110408235739.A6B0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408235739.A6B0.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KOSAKI.

On Fri, Apr 08, 2011 at 11:56:20PM +0900, KOSAKI Motohiro wrote:
> This is regression since commit e23bba6044 (x86-64, NUMA: Unify
> emulated distance mapping). Because It drop fake_physnodes() and
> then cpu-node mapping was changed.
> 
> 	old) all cpus are assinged node 0
> 	now) cpus are assigned round robin
> 	     (the logic is implemented by numa_init_array())

I think it's slightly more complex than that.  If apicid -> NUMA node
mapping exists, the mapping (remapped during emulation) is always
used.  The RR assignment is only used for CPUs which didn't have node
assigned to it, most likely due to missing processor affinity entry.

I think, with or without the recent changes, numa_init_array() would
have assigned RR nodes to those uninitialized CPUs.  What changed is
that the same RR fallback is now used even when emulation is used now.

> Why round robin assignment doesn't work? Because init_numa_sched_groups_power()
> assume all logical cpus in a same physical cpu are assigned a same node.
> (Then it only account group_first_cpu()). But the simple round robin broke
> the assumption. Thus, this patch reimplement cpu node map initialization
> for fake numa.

Maybe I'm confused but I don't think this is the correct fix.  What
prevents RR assignment triggering the same problem when emulation is
not used?  If we're falling back every uninitialized cpu to node 0
after emulation, we should be doing that for !emulation path too and I
don't think that's what we want.  It seems like the emulation is just
triggering an underlying condition simplify because it's ending up
with different assignment and the same condition might as well trigger
without emulation.  Am I missing something?

Thanks.

-- 
tejun
