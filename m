Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1DUWM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:12:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1DUWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AlqJiO2AJDBSHz7rTHH05B2w1a0sEJ0CNzMqrf9mq5PaZHUM2HRXYxlVG9NGd+i0R+
         DU4xjKCN5Hh9Z68Wkv8g==
Date: Thu, 21 Apr 2011 15:12:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303422566.4025.56.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104211505320.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <1303421088.4025.52.camel@mulgrave.site> <alpine.DEB.2.00.1104211431500.20201@chino.kir.corp.google.com> <1303422566.4025.56.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, James Bottomley wrote:

> > Ok, it seems like there're two options for this release cycle:
> > 
> >  (1) merge the patch that enables CONFIG_NUMA for DISCONTIGMEM but only 
> >      do so if CONFIG_SLUB is enabled to avoid the build error, or
> 
> That's not an option without coming up with the rest of the numa
> fixes ... we can't basically force all SMP systems to become UP.
> 
> What build error, by the way?  There's only a runtime panic caused by
> slub.
> 

If you enable CONFIG_NUMA for ARCH_DISCONTIGMEM_ENABLE on parisc, it 
results in the same build error that you identified in

	http://marc.info/?l=linux-parisc&m=130326773918005

at least on my hppa64 compiler.

> >  (2) disallow CONFIG_SLUB for parisc with DISCONTIGMEM.
> 
> Well, that's this patch ... it will actually fix every architecture, not
> just parisc.
> 
> 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 56240e7..a7ad8fb 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1226,6 +1226,7 @@ config SLAB
> >           per cpu and per node queues.
> >  
> >  config SLUB
> > +       depends on BROKEN || NUMA || !DISCONTIGMEM
> >         bool "SLUB (Unqueued Allocator)"
> >         help
> >            SLUB is a slab allocator that minimizes cache line usage
> 
> 
> I already sent it to linux-arch and there's been no dissent; there have
> been a few "will that fix my slub bug?" type of responses.
> 

I was concerned about tile because it actually got all this right by using 
N_NORMAL_MEMORY appropriately and it uses slub by default, but it always 
enables NUMA at the moment so this won't impact it.

Acked-by: David Rientjes <rientjes@google.com>

I agree we can now defer "parisc: enable CONFIG_NUMA for DISCONTIGMEM and 
fix build errors" until parisc moves away from DISCONTIGMEM, its extracted 
away from CONFIG_NUMA, or the scheduler issues are debugged.
