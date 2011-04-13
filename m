Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1DMNtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:49:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51140 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1DMNty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=av5B4qE58Cz+zg0zbr/hDmOjqc7zHag5of994kRpYSBsuPz9knzlL4zhnVMNRHNGcZ
         txeH/vGJAL+cTouk8DP9vqcF/ypsFupzCwgoGKrAfp9eKLr22Lolafww99NYsjDvRKtK
         9sC893WsEsB9JESGJ76RfuIdgIb+OMauoXeMg=
Subject: Re: 2.6.38 sbrk regression
From: raz ben yehuda <raziebe@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110413125146.GR29444@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
	 <20110413125146.GR29444@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 16:48:57 +0300
Message-ID: <1302702537.17200.1.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oddly I am failing to compile 2.6.38-rc, I am getting:
linux-2.6]$ make bzImage
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      arch/x86/lib/memmove_64.o
gcc: arch/x86/lib/memmove_64.c: No such file or directory
gcc: no input files
make[1]: *** [arch/x86/lib/memmove_64.o] Error 1
make: *** [arch/x86/lib] Error 2

and there is no such file. any idea ?

thank you

On Wed, 2011-04-13 at 14:51 +0200, Andrea Arcangeli wrote:
> Hi,
> CC'ing Mel.
> 
> On Wed, Apr 13, 2011 at 02:03:58PM +0300, raz ben yehuda wrote:
> > Andrea Hello
> > 
> > I am running the AIM benchmark suite looking for regressions in 2.6.38.
> > The test page_test tests sbrk(). 2.6.38 is 13% less than 2.6.27 and 11%
> > less than 2.6.37.
> > The regression starts somewhere in the THP patch:  
> > SHA1 4e9f64c42d0ba5eb0c78569435ada4c224332ce4  to
> > SHA1 152c9ccb75548c027fa3103efa4fa4e19a345449 . 
> > 
> > I cannot git bisect it any more as the kernel won't compile.
> > Even if i disable THP in the kernel I still get a regression. 
> > I performed the benchmark on Xeon blade 3GHZ. But it also happens in
> > other types of machines.
> > 
> > 2.6.38
> > Apr 13 13:31:16 2011 AIM Independent Resource Benchmark - Suite IX 5120
> > page_test 30010 85.0716       144621.79 System Allocations &Pages/second
> > 
> > 2.6.37
> > Apr 13 13:44:39 2011 AIM Independent Resource Benchmark - Suite IX 5120
> > page_test 5020 100.797       171354.58 System Allocations & Pages/second
> > 
> > I am going to profile it hopefully I will have more information.
> 
> The compaction kswapd caused regressions in fs benchs like specsfs,
> it's fixed in 2.6.39-rc. Obviously it will go away if you set
> CONFIG_COMPACTION=n, but 2.6.39-rc should work best with COMPACTION=y
> too. Could you try latest 2.6.39 git?
> 
> Also please make sure CONFIG_SLUB=n and CONFIG_SLAB=y. We must fix
> SLUB so it stops allocating with GFP_KERNEL in the higher order alloc,
> I think it should only do a quick check of the buddy with
> GFP_ATOMIC. The pageblock types are the thing that prevents
> fragmentation, no need of special logic for that in slub. It's
> unlikely that for short lived allocations succeeding the high order
> allocation provides enough speedup to the code using the memory, in
> order to at least break even with the cost of compacting the memory to
> succeed the allocation.


