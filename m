Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1ECWlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:41:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1ECWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sL1iFy1XmzyJD9KPXWwRtqmzCz36a9DScVc0birHWh6ujKrmoRApxu8CWU61n478o6
         5X8w/I+ABo4sgGX5jxyw==
Date: Tue, 3 May 2011 15:40:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: James Bottomley <James.Bottomley@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
In-Reply-To: <BANLkTimT4899xDF99Fj37u_CgnkeBzoFzQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105031538470.27795@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg> <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com> <1304026464.2598.36.camel@mulgrave.site> <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
 <BANLkTimT4899xDF99Fj37u_CgnkeBzoFzQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Geert Uytterhoeven wrote:

> My ARAnyM instance has
> 
> System Memory:	276480K
> 	 14 MB at 0x00000000 (ST-RAM)
> 	256 MB at 0x01000000 (alternate RAM)
> 
> and 137800KIB of swap, and survived the following program just fine:
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> 
> int main(int argc, char *argv[])
> {
>     size_t size = 1048576;
>     size_t total = 0;
>     void *p;
> 
>     while (size) {
> 	p = malloc(size);
> 	if (!p) {
> 	    printf("Failed to allocate %zu bytes\n", size);
> 	    size /= 2;
> 	}
> 	memset(p, 0xaa, size);
> 	total += size;
> 	printf("Using %zu / 0x%zx bytes of memory\n", total, total);
>     }
> 
>     printf("Finished!\n");
>     return 0;
> }
> 
> i.e. the OOM-killer just killed the program after it consumed all
> available virtual
> memory:
> 
> Out of memory: Kill process 1727 (malloctest) score 854 or sacrifice child
> Killed process 1727 (malloctest) total-vm:361160kB, anon-rss:224164kB,
> file-rss:0kB
> malloctest: page allocation failure. order:0, mode:0x84d0
> 
> So SLUB really seems to work now.
> 

So we're in the unfortunate position where slub works fine for some 
architectures with DISCONTIGMEM and not with others.  It seems like the 
problems originating on James' hppa aren't related to slab allocation at 
all, though, so I'm wondering if we should rethink disallowing SLUB as it 
sits in Linus' tree right now for everything that uses DISCONTINGMEM 
without NUMA and not force them to enable CONFIG_BROKEN?

Perhaps change the kconfig entry to only block slub for parisc instead?
