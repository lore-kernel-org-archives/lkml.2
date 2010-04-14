Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0DNJqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:46:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46126 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0DNJqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:46:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Apr 2010 18:42:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-Id: <20100414184213.f6bf11a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <w2u28c262361004140019pd8fe696ez609ece4a35527658@mail.gmail.com>
References: <20100414135945.2b0a1e0d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414054144.GH2493@dastard>
	<20100414145056.D147.A69D9226@jp.fujitsu.com>
	<y2x28c262361004132313r1e2ca71frd042d5460d897730@mail.gmail.com>
	<w2u28c262361004140019pd8fe696ez609ece4a35527658@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 16:19:02 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Apr 14, 2010 at 3:13 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> > On Wed, Apr 14, 2010 at 2:54 PM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> >>> On Wed, Apr 14, 2010 at 01:59:45PM +0900, KAMEZAWA Hiroyuki wrote:
> >>> > On Wed, 14 Apr 2010 11:40:41 +1000
> >>> > Dave Chinner <david@fromorbit.com> wrote:
> >>> >
> >>> > >  50)     3168      64   xfs_vm_writepage+0xab/0x160 [xfs]
> >>> > >  51)     3104     384   shrink_page_list+0x65e/0x840
> >>> > >  52)     2720     528   shrink_zone+0x63f/0xe10
> >>> >
> >>> > A bit OFF TOPIC.
> >>> >
> >>> > Could you share disassemble of shrink_zone() ?
> >>> >
> >>> > In my environ.
> >>> > 00000000000115a0 <shrink_zone>:
> >>> >    115a0:       55                      push   %rbp
> >>> >    115a1:       48 89 e5                mov    %rsp,%rbp
> >>> >    115a4:       41 57                   push   %r15
> >>> >    115a6:       41 56                   push   %r14
> >>> >    115a8:       41 55                   push   %r13
> >>> >    115aa:       41 54                   push   %r12
> >>> >    115ac:       53                      push   %rbx
> >>> >    115ad:       48 83 ec 78             sub    $0x78,%rsp
> >>> >    115b1:       e8 00 00 00 00          callq  115b6 <shrink_zone+0x16>
> >>> >    115b6:       48 89 75 80             mov    %rsi,-0x80(%rbp)
> >>> >
> >>> > disassemble seems to show 0x78 bytes for stack. And no changes to %rsp
> >>> > until retrun.
> >>>
> >>> I see the same. I didn't compile those kernels, though. IIUC,
> >>> they were built through the Ubuntu build infrastructure, so there is
> >>> something different in terms of compiler, compiler options or config
> >>> to what we are both using. Most likely it is the compiler inlining,
> >>> though Chris's patches to prevent that didn't seem to change the
> >>> stack usage.
> >>>
> >>> I'm trying to get a stack trace from the kernel that has shrink_zone
> >>> in it, but I haven't succeeded yet....
> >>
> >> I also got 0x78 byte stack usage. Umm.. Do we discussed real issue now?
> >>
> >
> > In my case, 0x110 byte in 32 bit machine.
> > I think it's possible in 64 bit machine.
> >
> > 00001830 <shrink_zone>:
> >    1830:       55                      push   %ebp
> >    1831:       89 e5                   mov    %esp,%ebp
> >    1833:       57                      push   %edi
> >    1834:       56                      push   %esi
> >    1835:       53                      push   %ebx
> >    1836:       81 ec 10 01 00 00       sub    $0x110,%esp
> >    183c:       89 85 24 ff ff ff       mov    %eax,-0xdc(%ebp)
> >    1842:       89 95 20 ff ff ff       mov    %edx,-0xe0(%ebp)
> >    1848:       89 8d 1c ff ff ff       mov    %ecx,-0xe4(%ebp)
> >    184e:       8b 41 04                mov    0x4(%ecx)
> >
> > my gcc is following as.
> >
> > barrios@barriostarget:~/mmotm$ gcc -v
> > Using built-in specs.
> > Target: i486-linux-gnu
> > Configured with: ../src/configure -v --with-pkgversion='Ubuntu
> > 4.3.3-5ubuntu4'
> > --with-bugurl=file:///usr/share/doc/gcc-4.3/README.Bugs
> > --enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
> > --enable-shared --with-system-zlib --libexecdir=/usr/lib
> > --without-included-gettext --enable-threads=posix --enable-nls
> > --with-gxx-include-dir=/usr/include/c++/4.3 --program-suffix=-4.3
> > --enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc
> > --enable-mpfr --enable-targets=all --with-tune=generic
> > --enable-checking=release --build=i486-linux-gnu --host=i486-linux-gnu
> > --target=i486-linux-gnu
> > Thread model: posix
> > gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4)
> >
> >
> > Is it depends on config?
> > I attach my config.
> 
> I changed shrink list by noinline_for_stack.
> The result is following as.
> 
> 
> 00001fe0 <shrink_zone>:
>     1fe0:       55                      push   %ebp
>     1fe1:       89 e5                   mov    %esp,%ebp
>     1fe3:       57                      push   %edi
>     1fe4:       56                      push   %esi
>     1fe5:       53                      push   %ebx
>     1fe6:       83 ec 4c                sub    $0x4c,%esp
>     1fe9:       89 45 c0                mov    %eax,-0x40(%ebp)
>     1fec:       89 55 bc                mov    %edx,-0x44(%ebp)
>     1fef:       89 4d b8                mov    %ecx,-0x48(%ebp)
> 
> 0x110 -> 0x4c.
> 
> Should we have to add noinline_for_stack for shrink_list?
> 

Hmm. about shirnk_zone(), I don't think uninlining functions directly called
by shrink_zone() can be a help.
Total stack size of call-chain will be still big.

Thanks,
-Kame


