Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab2JQSmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:42:23 -0400
Received: from [213.199.154.205] ([213.199.154.205]:6499 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757649Ab2JQSmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:42:21 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432Izz1202h1d1ah1d2ahzz17326ah8275dh177df4hz2fh2a8h668h839h93fhd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <507EFCC3.1050304@am.sony.com>
Date: Wed, 17 Oct 2012 11:45:23 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ezequiel Garcia <elezegarcia@gmail.com>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>
Subject: Re: [Q] Default SLAB allocator
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>  <m27gqwtyu9.fsf@firstfloor.org>  <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>  <m2391ktxjj.fsf@firstfloor.org>  <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>  <alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com>  <CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com>  <alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com>  <CALF0-+WgfnNOOZwj+WLB397cgGX7YhNuoPXAK5E0DZ5v_BxxEA@mail.gmail.com>  <1350392160.3954.986.camel@edumazet-glaptop> <507DA245.9050709@am.sony.com>  <CALF0-+VLVqy_uE63_jL83qh8MqBQAE3vYLRX1mRQURZ4a1M20g@mail.gmail.com> <1350414968.3954.1427.camel@edumazet-glaptop>
In-Reply-To: <1350414968.3954.1427.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 12:16 PM, Eric Dumazet wrote:
> On Tue, 2012-10-16 at 15:27 -0300, Ezequiel Garcia wrote:
> 
>> Yes, we have some numbers:
>>
>> http://elinux.org/Kernel_dynamic_memory_analysis#Kmalloc_objects
>>
>> Are they too informal? I can add some details...
>>
>> They've been measured on a **very** minimal setup, almost every option
>> is stripped out, except from initramfs, sysfs, and trace.
>>
>> On this scenario, strings allocated for file names and directories
>> created by sysfs
>> are quite noticeable, being 4-16 bytes, and produce a lot of fragmentation from
>> that 32 byte cache at SLAB.
>>
>> Is an option to enable small caches on SLUB and SLAB worth it?
> 
> Random small web server :
> 
> # free
>              total       used       free     shared    buffers     cached
> Mem:       7884536    5412572    2471964          0     155440    1803340
> -/+ buffers/cache:    3453792    4430744
> Swap:      2438140      51164    2386976

8G is a small web server?  The RAM budget for Linux on one of
Sony's cameras was 10M.  We're not merely not in the same ballpark -
you're in a ballpark and I'm trimming bonsai trees... :-)

> # grep Slab /proc/meminfo
> Slab:             351592 kB
> 
> # egrep "kmalloc-32|kmalloc-16|kmalloc-8" /proc/slabinfo 
> kmalloc-32         11332  12544     32  128    1 : tunables    0    0    0 : slabdata     98     98      0
> kmalloc-16          5888   5888     16  256    1 : tunables    0    0    0 : slabdata     23     23      0
> kmalloc-8          76563  82432      8  512    1 : tunables    0    0    0 : slabdata    161    161      0
> 
> Really, some waste on these small objects is pure noise on SMP hosts.
In this example, it appears that if all kmalloc-8's were pushed into 32-byte slabs,
we'd lose about 1.8 meg due to pure slab overhead.  This would not be noise
on my system.

> (Waste on bigger objects is probably more important by orders of magnitude)

Maybe.

I need to run some measurements on systems that are more similar to what
we're deploying in products.  I'll see if I can share them.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

