Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1JSBAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:00:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1JSA76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:59:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=sKolLDQWWG7VHhYxuL5eZVQgmKwD/I8M3FVRqvyj4gNqLUY9xnZNI+kRkv3He0Yrx
	ylcnkHj36f/kQbrlVNouA==
Date: Tue, 18 Oct 2011 17:59:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: munlock use mapcount to avoid terrible overhead
In-Reply-To: <m262jlzv1v.fsf@firstfloor.org>
Message-ID: <alpine.LSU.2.00.1110181757080.4283@sister.anvils>
References: <alpine.LSU.2.00.1110181700400.3361@sister.anvils> <m262jlzv1v.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Andi Kleen wrote:
> Hugh Dickins <hughd@google.com> writes:
> 
> > A process spent 30 minutes exiting, just munlocking the pages of a large
> > anonymous area that had been alternately mprotected into page-sized vmas:
> > for every single page there's an anon_vma walk through all the other
> > little vmas to find the right one.
> 
> We had the same problem recently after a mmap+touch workload: in this
> case it was hugepaged walking all these anon_vmas and the list was over
> 100k long. 
> 
> Had some data on this at plumbers:
> http://halobates.de/plumbers-fork-locks_v2.pdf
> 
> > A general fix to that would be a lot more complicated (use prio_tree on
> > anon_vma?), but there's one very simple thing we can do to speed up the
> > common case: if a page to be munlocked is mapped only once, then it is
> > our vma that it is mapped into, and there's no need whatever to walk
> > through all the others.
> 
> I think we need a generic fix, this problem does not only happen
> in munmap. 

Thanks for the pointer, Andi, I'll have to look into it when I've a
moment; but I don't look forward to making this area more complicated.

Hugh
