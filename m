Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab1D2Xge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:36:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57882 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab1D2Xgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jx+uxt3oIh0vRZwCZcSwXYjSu8wnBTYmCSdxUf5SFRI444POcKnIPK0OCyNkZbyuJc
         ZJFQgJICZh6n8aI8pz1FQBrr7ICm2q5DK23y72WdXmQKjTNeKgfxbGRwIw/pQAq+LB2O
         pzqTMvbvglSUwfC7A4Hl+ZM840d+/9qK6MkWA=
Message-ID: <4DBB4B55.7000904@gmail.com>
Date: Sat, 30 Apr 2011 11:35:49 +1200
From: Michael Schmitz <schmitzmic@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: David Rientjes <rientjes@google.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>	<alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>	<1304026464.2598.36.camel@mulgrave.site>	<alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com> <BANLkTimT4899xDF99Fj37u_CgnkeBzoFzQ@mail.gmail.com>
In-Reply-To: <BANLkTimT4899xDF99Fj37u_CgnkeBzoFzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Thu, Apr 28, 2011 at 23:41, David Rientjes <rientjes@google.com> wrote:
>   
>> On Thu, 28 Apr 2011, James Bottomley wrote:
>>
>>     
>>
>>> I think what the N_NORMAL_MEMORY patch did is just make it take a whiile
>>> before you start allocating from that range.  Try executing a memory
>>> balloon on the platform; that was how we first demonstrated the problem
>>> on parisc.
>>>
>>>       
>> With parisc, you encountered an oops in add_partial() because the
>> kmem_cache_node structure for the memory range returned by page_to_nid()
>> was not allocated.  init_kmem_cache_nodes() takes care of this for all
>> memory ranges set in N_NORMAL_MEMORY.
>>
>> Adding Christoph and Pekka to the cc if there is additional concerns about
>> slub on this architecture.
>>     
>
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
Forgot to mention what I did for tests, on all kernels that I could 
actually boot: I ran slabinfo -l and slabinfo -T (saved the output in 
case anyone wants to analyze that), any kernel that survived this was 
considered good in the original bisect. The current fix was also tested 
on the actual hardware.

There were quite a few kernels that initially booted but died on the 
first slabinfo invocation. They invariably died at the e2fsck stage when 
rebooted after that.

Using your test, ARAnyM, 14MB/128MB RAM and 134MB swap:

Out of memory: Kill process 1376 (malloctest) score 944 or sacrifice child
Killed process 1376 (malloctest) total-vm:272756kB, anon-rss:135232kB, 
file-rss:0kB

Falcon CT60, 14MB/512MB no swap:

Out of memory: Kill process 8644 (malloctest) score 967 or sacrifice child
Killed process 8644 (malloctest) total-vm:512244kB, anon-rss:510088kB, 
file-rss:284kB

HTH,

  Michael


