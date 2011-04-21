Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1DUVTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:19:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1DUVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HYaUskdJ5r3n04U6kzHBGs2k+hTtRdionDqy0qLzKRcPcv5EMNIzl3X6t5I8hH/sWP
         GwMl9lfr0RTST7lYM+Sw==
Date: Thu, 21 Apr 2011 14:19:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <alpine.DEB.2.00.1104211500170.5741@router.home>
Message-ID: <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, Christoph Lameter wrote:

> In 32 bit configurations some architectures (like x86) provide nodes
> that have only high memory. Slab allocators only handle normal memory.
> SLAB operates in a kind of degraded mode in that case by falling back for
> each allocation to the nodes that have normal memory.
> 

Let's do this:

 - parisc: James has already queued "parisc: set memory ranges in 
   N_NORMAL_MEMORY when onlined" for 2.6.39, so all he needs now is 
   to merge a hybrid of the Kconfig changes requiring CONFIG_NUMA for 
   CONFIG_DISCONTIGMEM from KOSAKI-san and myself which also fix the 
   compile issues,

 - generic code: we pull check_for_regular_memory() out from under
   CONFIG_HIGHMEM so that N_NORMAL_MEMORY gets set appropriately for 
   all callers of free_area_init_nodes() from paging_init(); this fixes 
   ia64 and mips,

 - alpha, m32r, m68k: push the changes to those individual architectures 
   that I proposed earlier that set N_NORMAL_MEMORY for DISCONTINGMEM
   when memory regions have memory; KOSAKI-san says a couple of these
   architectures may be orphaned so hopefully Andrew can pick them up
   in -mm.

I'll reply to this email with the parisc Kconfig changes for James, the 
generic change to check_for_regular_memory() for Andrew, and the 
arch-specific changes to the appropriate maintainers and email lists (but 
may need to go through -mm if they aren't picked up).
