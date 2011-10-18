Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1JRF4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 01:56:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1JRF4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 01:56:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=wQQM0sVq1r0roi0XDGikxwfg08BO3QEsjnzWGTVkfb/fKn/AwmGDZRaopeQtlfOU5
	7FG/n4G03CQD1FVVHljvg==
Date: Mon, 17 Oct 2011 22:56:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: gpio-ml-ioh: Support interrupt function
In-Reply-To: <4E9CC93B.4000800@dsn.lapis-semi.com>
Message-ID: <alpine.DEB.2.00.1110172251590.4880@chino.kir.corp.google.com>
References: <20111017201058.GA13916@elgon.mountain> <4E9CC93B.4000800@dsn.lapis-semi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Tomoya MORINAGA wrote:

> > The linux-next patch 54be566317b6 "gpio-ml-ioh: Support interrupt
> > function" generates a Sparse warning.
> > 
> > +               irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
> > +                                          GFP_KERNEL);
> >                                             ^^^^^^^^^^
> > 
> > The last argument should be a NUMA node, not a GFP_ flag.  I'm not
> > sure what the right fix is.  There are currently 5 callers in my
> > cscope for this function in linux-next.
> > 
> > 2 pass GFP_KERNEL which is wrong.

Right, all irq_alloc_descs() allocations are already implicitly 
GFP_KERNEL.

> > 2 pass 0 which maybe should be cpu_to_node(0)?
> > 1 passes -1 which maybe could be NUMA_NO_NODE?
> > 
> I can understand your saying.
> Seeing accepted other drivers, '0' or '-1' is used.

There's actually no guarantee in the kernel that node 0 has memory, so 
unless that is assured in the context then passing 0 would be wrong.

> Focusing on GPIO driver, gpio-pca953x.c uses '-1'.
> 

The slab layer guarantees that passing -1 will allocate on the node that 
is local to the cpu that the code is running on.  Unless there's a 
compelling reason to allocate on a different node, then this is what you 
want to use.

We try not to pass -1 directly, though, we try to use NUMA_NO_NODE 
wherever possible.
