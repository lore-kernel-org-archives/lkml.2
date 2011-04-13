Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1DMPZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:25:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43985 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab1DMPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=DZARCG/Y6FBM4OyG6sM8jTZA6CxGpVtLP2zdW8QKmlpogdceth4B4MBVQk+kMtkf+K
         aMHDD9XwwB//lrsHewNoVH+tEC+GR2Atq3LoBYDNwelTasJFEW4zu0IyG44SGYUxvfwk
         p8A9tV8CkNckJZ70hXIE/Jfqvc8Ssh3kXz68E=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "Pintu Agarwal" <pintu_agarwal@yahoo.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Changli Gao" <xiaosuo@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>,
        azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Regarding memory fragmentation using malloc....
References: <112566.51053.qm@web162019.mail.bf1.yahoo.com>
Date: Wed, 13 Apr 2011 17:25:08 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtvuf5sk3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <112566.51053.qm@web162019.mail.bf1.yahoo.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 15:56:00 +0200, Pintu Agarwal  
<pintu_agarwal@yahoo.com> wrote:
> My requirement is, I wanted to measure memory fragmentation level in  
> linux kernel2.6.29 (ARM cortex A8 without swap).
> How can I measure fragmentation level(percentage) from /proc/buddyinfo ?

[...]

> In my linux2.6.29 ARM machine, the initial /proc/buddyinfo shows the  
> following:
> Node 0, zone      DMA     17     22      1      1      0      1       
> 1      0      0      0      0      0
> Node 1, zone      DMA     15    320    423    225     97     26       
> 1      0      0      0      0      0
>
> After running my sample program (with 16 iterations) the buddyinfo  
> output is as follows:
> Requesting <16> blocks of memory of block size <262144>........
> Node 0, zone      DMA     17     22      1      1      0      1       
> 1      0      0      0      0      0
> Node 1, zone      DMA     15    301    419    224     96     27       
> 1      0      0      0      0      0
>     nr_free_pages 169
>     nr_free_pages 6545
> *****************************************
>
>
> Node 0, zone      DMA     17     22      1      1      0      1       
> 1      0      0      0      0      0
> Node 1, zone      DMA     18      2    305    226     96     27       
> 1      0      0      0      0      0
>     nr_free_pages 169
>     nr_free_pages 5514
> -----------------------------------------
>
> The requested block size is 64 pages (2^6) for each block.
> But if we see the output after 16 iterations the buddyinfo allocates  
> pages only from Node 1 , (2^0, 2^1, 2^2, 2^3).
> But the actual allocation should happen from (2^6) block in buddyinfo.

No.  When you call malloc() only virtual address space is allocated.  The
actual allocation of physical space occurs when user space accesses the
memory (either reads or writes) and it happens page at a time.

As a matter of fact, if you have limited number of 0-order pages and
allocates in user space block of 64 pages later accessing the memory,
what really happens is that kernel allocates the 0-order pages and when
it runs out of those, splits a 1-order page into two 0-order pages and
takes one of those.

Because of MMU, fragmentation of physical memory is not an issue for
normal user space programs.

It becomes an issue once you deal with hardware that does not have MMU
nor support for scatter-getter DMA or with some big kernel structures.

/proc/buddyinfo tells you how many free pages of given order there are
in the system.  You may interpret it in such a way that the bigger number
of the low order pages the bigger fragmentation of physical memory.  If
there was no fragmentation (for some definition of the term) you'd get only
the highest order pages and at most one page for each lower order.

Again though, this fragmentation is not an issue for user space programs.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
