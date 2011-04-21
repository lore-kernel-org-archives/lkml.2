Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1DUTib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:38:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27804 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1DUTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AIi47lOxf9Ix85BMuQ6/Zj9dT2rwq+rMI9fQeGgsJH6xCLtB+V8Da8EjQK3+EPYBxk
         bskSrCPv2Dwh/OBlXqaQ==
Date: Thu, 21 Apr 2011 12:38:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110421220351.9180.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, KOSAKI Motohiro wrote:

> > diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> > --- a/arch/parisc/mm/init.c
> > +++ b/arch/parisc/mm/init.c
> > @@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
> >  	}
> >  	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
> >  
> > -	for (i = 0; i < npmem_ranges; i++)
> > +	for (i = 0; i < npmem_ranges; i++) {
> > +		node_set_state(i, N_NORMAL_MEMORY);
> >  		node_set_online(i);
> > +	}
> >  #endif
> 
> 
> I'm surprised this one. If arch code doesn't initialized N_NORMAL_MEMORY,
> (or N_HIGH_MEMORY. N_HIGH_MEMORY == N_NORMAL_MEMORY if CONFIG_HIGHMEM=n)
> kswapd is created only at node0. wow.
> 
> The initialization must be necessary even if !NUMA, I think. ;-)
> Probably we should have revisit all arch code when commit 9422ffba4a 
> (Memoryless nodes: No need for kswapd) was introduced, at least.
> 

I think we may want to just convert slub (and the memory controller) to 
use N_HIGH_MEMORY rather than N_NORMAL_MEMORY since nothing else uses it 
and the generic code seems to handle N_HIGH_MEMORY for all configs 
appropriately.
