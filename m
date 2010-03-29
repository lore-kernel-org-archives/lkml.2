Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0C2UHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:07:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51015 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C2UHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WiOOBOXhnB7uhZIvrpfKTmKOi/0M0Aqb9X+2ktBBm9XJ+c/SMp2hqsI6pFnpGvP4xF
         IdjGwGT9AONVelM1SIeBE7UEhTzzvyQj18FMoGbE5zdP7uIAs4NusNWQK5CfzNUf6pNA
         3yqgyyg4cm3rG48hAT1p+AalYiOreBhJgKGHg=
Subject: Re: Network performance - iperf
From: Eric Dumazet <eric.dumazet@gmail.com>
To: michal.simek@petalogix.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
In-Reply-To: <4BB09021.6020202@petalogix.com>
References: <4BB09021.6020202@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 22:07:38 +0200
Message-ID: <1269893258.1958.61.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 mars 2010 à 13:33 +0200, Michal Simek a écrit :
> Hi All,
> 
> I am doing several network benchmarks on Microblaze cpu with MMU.
> I am seeing one issue which is weird and I would like know where the 
> problem is.
> I am using the same hw design and the same Linux kernel. I have done 
> only change in memory size (in DTS).
> 
> 32MB: 18.3Mb/s
> 64MB: 15.2Mb/s
> 128MB: 10.6Mb/s
> 256MB: 3.8Mb/s
> 
> There is huge difference between systems with 32MB and 256MB ram.
> 
> I am running iperf TCP tests with these commands.
> On x86: iperf -c 192.168.0.105 -i 5 -t 50
> On microblaze: iperf -s
> 
> I look at pte misses which are the same on all configurations which 
> means that the number of do_page_fault exceptions is the same on all 
> configurations.
> I added some hooks to low level kernel code to be able to see number of 
> tlb misses. There is big differences between number of misses on system 
> with 256MB and 32MB. I measured two kernel settings. First column is 
> kernel with asm optimized memcpy/memmove function and the second is 
> without optimization. (Kernel with asm optimized lib functions is 30% 
> faster than system without optimization)
> 
> 32MB: 12703	13641
> 64MB: 1021750	655644
> 128MB: 1031644	531879
> 256MB: 1011322	430027
> 
> Most of them are data tlb misses. Microblaze MMU doesn't use any LRU 
> mechanism to find TLB victim that's why we there is naive TLB 
> replacement strategy based on incrementing counter. We using 2 tlbs for 
> kernel itself which are not updated that's why we can use "only" 62 TLBs 
> from 64.
> 

This probably has nothing to do with tcp stack, but trashing tlb on some
pathological cases (you have 62 entries, thats good for working size up
to 248 Kbytes, all included (program stack, program static & dynamic
data), given microblaze 4Kbytes page size.

You could try :

echo "4096 8192 32768" >/proc/sys/net/ipv4/tcp_rmem

to reduce memory footprint of iperf (or use iperf parameters)

Of course, I suppose kernel memory is 32 MB max, if you use only two
tlbs (16 Mbytes each) for kernel...



