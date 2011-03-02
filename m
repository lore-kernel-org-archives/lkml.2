Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1CBObJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:31:09 -0500
Received: from smtp-out.google.com ([74.125.121.67]:48790 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1CBObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:31:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fZBZwPk8JfjmFpFskHWEj1KEPQwG2uh3fwVa/K8SQLFSg1zRydyAFH6nyQ3ZDMAz+r
         zOQnmlEZGDJbZqBjohOQ==
Date: Wed, 2 Mar 2011 06:30:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
In-Reply-To: <20110302102530.GB3319@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Tejun Heo wrote:

> From d968be2ff381c667bfd09795f82248558902a1ae Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 2 Mar 2011 11:22:14 +0100
> 
> NUMA distance table handling has the following problems.
> 
> * numa_reset_distance() uses numa_distance * sizeof(numa_distance[0])
>   as the table size when it should be using the square of
>   numa_distance.
> 
> * The same size miscalculation when allocation space for phys_dist in
>   numa_emulation().
> 
> * In numa_emulation(), phys_dist must be reserved; otherwise, the new
>   emulated distance table may overlap it.
> 
> Fix them and, while at it, take numa_distance_cnt resetting in
> numa_reset_distance() out of the if block to simplify the code a bit.
> 
> David Rientjes reported incorrect handling of distance table during
> emulation and Yinghai identified the above problems and wrote the
> original patch to fix the problems.  This patch is based on Yinghai's
> patch.
> 
> -v2: Ingo was unhappy with 80-column limit induced linebreaks.  Let
>      lines run over 80-column.
> 
> Reported-by: David Rientjes <rientjes@google.com>
> Patch-originally-from: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: David Rientjes <rientjes@google.com>

There's also this in numa_emulation() that isn't a safe assumption:

        /* make sure all emulated nodes are mapped to a physical node */
        for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
                if (emu_nid_to_phys[i] == NUMA_NO_NODE)
                        emu_nid_to_phys[i] = 0;

Node id 0 is not always online depending on how you setup your SRAT.  I'm 
not sure why emu_nid_to_phys[] would ever map a fake node id that doesn't 
exist to a physical node id rather than NUMA_NO_NODE, so I think it can 
just be removed.  Otherwise, it should be mapped to a physical node id 
that is known to be online.
