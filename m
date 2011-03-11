Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1CKI3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:29:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49419 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1CKI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:29:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VwFkqNGNbh8nAajilbHesq+AQtKonB/WW/1btsp90eZz2251yt1guqQC4EFuidbn20
         8BFD/amk4Nm9+PnGsUFc4+KSzcEsnNb/RuJ6yUCeKtvDB90bW5RJS71qiymE4nmRFXWZ
         bAfCqp5ZhFgv3IWUdxqN9Q1jyDUVF+a1Ue4NM=
Date: Fri, 11 Mar 2011 09:29:38 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110311082938.GC13038@htj.dyndns.org>
References: <20110302165545.GR3319@htj.dyndns.org>
 <4D6E91EC.6040906@kernel.org>
 <20110302190208.GD28266@mtj.dyndns.org>
 <4D6E9541.2040201@kernel.org>
 <20110302191338.GE28266@mtj.dyndns.org>
 <4D6EA975.8070200@kernel.org>
 <20110302205704.GF28266@mtj.dyndns.org>
 <4D6EB335.8000306@kernel.org>
 <20110303061711.GG28266@mtj.dyndns.org>
 <4D791C9F.1010500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D791C9F.1010500@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Yinghai.

On Thu, Mar 10, 2011 at 10:46:55AM -0800, Yinghai Lu wrote:
> that will duplicate the code:
> 
>         nodes_parsed = numa_nodes_parsed;
>         numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
> 
>         for_each_node_mask(i, nodes_parsed)
>                 cnt = i;
>         cnt++;
> 
> in numa_alloc_distance().
> 
> Why just let numa_alloc_distance() to be called at first and return cnt ?

Look at your patch.  It exports numa_alloc_distanc() and calls the
function explicitly just to use for (i...) loop instead of
for_each_node_mask().

If you look at how numa_set_distance() is used, it's supposed to be
fire-and-forget thing.  Specific NUMA configuration implementations
provide the information to the generic code but they don't have to
care how it's managed or whether something fails for whatever reason
and I'd like to keep it that way.  It's a small distinction but small
abstractions and simplifications like that add up to make the code
base easier to understand and maintain.  And you wanna break that for
what?  for (i...) instead of for_each_node_mask().

Also, I don't think your patch is correct.  Even if there is phys_dist
table, emu distance tables should be built because emulated nids don't
map to physical nids one to one.  ie. Two different emulated nids can
share a physical node and the distance table should explicitly reflect
that.

Nobody cares if we spend a bit more cycles going over numa bitmap some
more times during boot for frigging NUMA emulation.  It doesn't matter
AT ALL.  Don't micro optimize where it doesn't matter at the cost of
code readability and maintainability.  It is actively harmful.

Thanks.

-- 
tejun
