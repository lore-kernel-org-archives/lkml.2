Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2L0WbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:31:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63898 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2L0WbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:31:12 -0500
Date: Thu, 27 Dec 2012 14:31:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even
 if slab is available
In-Reply-To: <CAOJsxLH4RzWdxdVXyn+eFc56JfJtije2jK1eWaBYVaoZSHuUBA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1212271428520.18214@chino.kir.corp.google.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <1356293711-23864-2-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
 <CAOJsxLH4RzWdxdVXyn+eFc56JfJtije2jK1eWaBYVaoZSHuUBA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2012, Pekka Enberg wrote:

> On Sun, 23 Dec 2012, Sasha Levin wrote:
> >> diff --git a/mm/bootmem.c b/mm/bootmem.c
> >> index 1324cd7..198a92f 100644
> >> --- a/mm/bootmem.c
> >> +++ b/mm/bootmem.c
> >> @@ -763,9 +763,6 @@ void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
> >>  void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
> >>                                  unsigned long align, unsigned long goal)
> >>  {
> >> -     if (WARN_ON_ONCE(slab_is_available()))
> >> -             return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> >> -
> >>       return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
> >>  }
> 
> I'm not sure what Sasha's patch is trying to do here but the fall-back
> is there simply to let the caller know it's calling the bootmem
> allocator *too late*. That is, the slab allocator is already up and
> running so you're expected to use that.
> 

The __alloc_bootmem_node() variant is intended to panic rather than return 
NULL so there are callers that do not check the return value.  I'm 
suggesting rather than removing the fallback to the slab allocator to 
check the return value and panic() here if kzalloc_node() returns NULL.  
The __alloc_bootmem_node_nopanic() variant needs not be changed.
