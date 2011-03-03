Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1CCUHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:07:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:43392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab1CCUHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sZ5xRkMXdxdriXsJMKw8ifYo1NdW3W2WQ7IWLW+RGqqTvf7lDuY09TYTLHxC5q2kdb
         1rc17hXbzSvVrLSbL3YA==
Date: Thu, 3 Mar 2011 12:07:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
In-Reply-To: <4D6EB856.1010004@kernel.org>
Message-ID: <alpine.DEB.2.00.1103031205070.9993@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org> <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com> <20110302154215.GN3319@htj.dyndns.org> <4D6EB2C3.7040704@kernel.org> <4D6EB856.1010004@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Yinghai Lu wrote:

> david,
> 
> it looks like numa emu does not support that conf already.
> 
> old code:
> void __cpuinit numa_add_cpu(int cpu)
> {
>         unsigned long addr;
>         u16 apicid;
>         int physnid;
>         int nid = NUMA_NO_NODE;
> 
>         apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
>         if (apicid != BAD_APICID)
>                 nid = apicid_to_node[apicid];
>         if (nid == NUMA_NO_NODE)
>                 nid = early_cpu_to_node(cpu);
>         BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
> 

This isn't broken, the node must be online for the cpu to be bound to it.  
I'm specifically concerned about the case where the node is offline 
because it has no memory mapped to it and all cpus are bound to node 1, 
for instance.

The new emulation code needs to remove the assumption that node 0 always 
is online and become more robust since there's no such restriction in the 
ACPI spec.
