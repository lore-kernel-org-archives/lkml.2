Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab1D2Un0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:43:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63514 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab1D2UnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lhpuebvrPD61LXYPYP+/PU6/S0J4B0HyLV73wu+q/0DYYDu/3RlYS6JKtVl/x9Dkim
         Q+QvmA1WM0OvRFwy4sQ1rpdx5j/5+Q+/Js1HyP4JPqOUahu5X2xOCoEkRGQF88f8X8x4
         rRUrcbBQzBYWkFSGPLBZ485otK2drQW4Wzz8g=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>
	<alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>
	<1304026464.2598.36.camel@mulgrave.site>
	<alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
Date: Fri, 29 Apr 2011 22:43:22 +0200
X-Google-Sender-Auth: JQriy38Vb1aqy2qv2R2mTOaOUeg
Message-ID: <BANLkTimT4899xDF99Fj37u_CgnkeBzoFzQ@mail.gmail.com>
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Rientjes <rientjes@google.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 23:41, David Rientjes <rientjes@google.com> wrote:
> On Thu, 28 Apr 2011, James Bottomley wrote:
>
>> > Since 4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) from
>> > 2.6.39-rc4, you can't actually select slub on m68k without CONFIG_ADVANCED
>> > and CONFIG_SINGLE_MEMORY_CHUNK because it otherwises defaults to
>> > discontigmem.
>> >
>> > James tested hppa64 with my N_NORMAL_MEMORY fix and found that it turned
>> > an SMP box into UP.  If you've tested slub on m68k without regressions,
>> > then perhaps you'd like to add a "|| M68K" to CONFIG_SLUB?
>>
>> To be honest, I really don't see that fixing it.  As soon as you
>> allocate memory beyond range zero, you move onto a non-zero node as far
>> as slub is concerned, and that will oops.
>>
>
> Possible nodes are represented in slub with N_NORMAL_MEMORY, so the
> kmem_cache_node structures are allocated and initialized based on this
> nodemask.  As long as the memory ranges map to nodes set in the nodemask,
> this should be fine.
>
>> I think what the N_NORMAL_MEMORY patch did is just make it take a whiile
>> before you start allocating from that range.  Try executing a memory
>> balloon on the platform; that was how we first demonstrated the problem
>> on parisc.
>>
>
> With parisc, you encountered an oops in add_partial() because the
> kmem_cache_node structure for the memory range returned by page_to_nid()
> was not allocated.  init_kmem_cache_nodes() takes care of this for all
> memory ranges set in N_NORMAL_MEMORY.
>
> Adding Christoph and Pekka to the cc if there is additional concerns about
> slub on this architecture.

My ARAnyM instance has

System Memory:	276480K
	 14 MB at 0x00000000 (ST-RAM)
	256 MB at 0x01000000 (alternate RAM)

and 137800KIB of swap, and survived the following program just fine:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    size_t size = 1048576;
    size_t total = 0;
    void *p;

    while (size) {
	p = malloc(size);
	if (!p) {
	    printf("Failed to allocate %zu bytes\n", size);
	    size /= 2;
	}
	memset(p, 0xaa, size);
	total += size;
	printf("Using %zu / 0x%zx bytes of memory\n", total, total);
    }

    printf("Finished!\n");
    return 0;
}

i.e. the OOM-killer just killed the program after it consumed all
available virtual
memory:

Out of memory: Kill process 1727 (malloctest) score 854 or sacrifice child
Killed process 1727 (malloctest) total-vm:361160kB, anon-rss:224164kB,
file-rss:0kB
malloctest: page allocation failure. order:0, mode:0x84d0

So SLUB really seems to work now.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
