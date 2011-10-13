Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1JMFWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:22:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61065 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1JMFWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:22:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=LivNnbaDPfwuQS3vS4t3zR+S2b82Zv0GlTfEXrRH8uNV6xYBWJVbWFyxl0jBZ2Jya
	x0DnHU4qwDEe3isIbuM4w==
Date: Wed, 12 Oct 2011 22:22:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Satoru Moriya <satoru.moriya@hds.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <4E966564.5030902@redhat.com>
Message-ID: <alpine.DEB.2.00.1110122210030.7572@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com>
 <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com> <4E959292.9060301@redhat.com> <alpine.DEB.2.00.1110121316590.7646@chino.kir.corp.google.com> <4E966564.5030902@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Rik van Riel wrote:

> > I suggested a patch from BFS that would raise kswapd to the same priority
> > of the task that triggered it (not completely up to rt, but the highest
> > possible in that case) and I'm waiting to hear if that helps for Satoru's
> > test case before looking at alternatives.  We could also extend the patch
> > to raise the priority of an already running kswapd if a higher priority
> > task calls into the page allocator's slowpath.
> 
> This has the distinct benefit of making kswapd most active right
> at the same time the application is most active, which returns
> us to your first objection to the extra free kbytes patch (apps
> will suffer from kswapd cpu use).
> 

Not necessarily, it only raises the priority of kswapd to be the same as 
the application, although it'll never raise it to be realtime, that kicks 
it in the page allocator's slowpath.  If the application has a nice level 
of 0, it's a no-op.  That's very different from extra_free_kbytes which 
causes kswapd to do extra work regardless of the priority of the 
application that is allocating memory.  Raising the priority of kswapd for 
rt threads makes sense if they are going to deplete all memory, it makes 
no sense to allow a rt thread to allocate tons of memory and not even give 
kswapd a chance to compete.

> Furthermore, I am not sure that giving kswapd more CPU time is
> going to help, because kswapd could be stuck on some lock, held
> by a lower priority (or sleeping) context.
> 
> I agree that the BFS patch would be worth a try, and would be
> very pleasantly surprised if it worked, but I am not very
> optimistic about it...
> 

It may require a combination of Con's patch, increasing the priority of 
kswapd if a higher priority task kicks it in the page allocator, and an 
extra bonus on top of the high watermark if it was triggered by a 
rt-thread -- similar to ALLOC_HARDER but instead reclaiming to 
(high * 1.25).

If we're going to go with extra_free_kbytes, then I'd like to see the test 
case posted with a mathematical formula to show me what I should tune it 
to be depending on my machine's memory capacity and amount of free RAM 
when started (and I can use mem= to test it for various capacities).  For 
this to be merged, there should be a clear expression that shows what the 
ideal setting of the tunable should be rather than asking for trial-and-
error to see what works and what doesn't.  If such an expression doesn't 
exist, then it's clear that the necessary setting will vary significantly 
as the implementation changes from kernel to kernel.
