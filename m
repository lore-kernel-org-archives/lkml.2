Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0FCNGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:06:52 -0400
Received: from ozlabs.org ([203.10.76.45]:55204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0FCNGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:06:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Thu, 3 Jun 2010 22:36:45 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006022336.53024.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006020750330.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006020750330.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006032236.46943.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 12:20:48 am Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Rusty Russell wrote:
> > 
> > Found another locking issue: the code which verifies we don't export over
> > an existing symbol needs to be atomic wrt. adding us to the list.
> 
> Yup.
> 
> And now that I'm looking at that call-chain (to see if it would make sense 
> to use some other more specific lock - doesn't look like it: all the 
> readers are using RCU and this is the only writer), I also give you this 
> trivial one-liner. It changes each_symbol() to not put that constant array 
> on the stack, resulting in changing
> 
>         movq    $C.388.31095, %rsi      #, tmp85
>         subq    $376, %rsp      #,
>         movq    %rdi, %rbx      # fn, fn
>         leaq    -208(%rbp), %rdi        #, tmp84
>         movq    %rbx, %rdx      # fn,
>         rep movsl
>         xorl    %esi, %esi      #
>         leaq    -208(%rbp), %rdi        #, tmp87
>         movq    %r12, %rcx      # data,
>         call    each_symbol_in_section.clone.0  #
> 
> into
> 
>         xorl    %esi, %esi      #
>         subq    $216, %rsp      #,
>         movq    %rdi, %rbx      # fn, fn  
>         movq    $arr.31078, %rdi        #,
>         call    each_symbol_in_section.clone.0  #
> 
> which is not so much about being obviously shorter and simpler because we 
> don't unnecessarily copy that constant array around onto the stack, but 
> also about having a much smaller stack footprint (376 vs 216 bytes - see 
> the update of 'rsp').
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

BTW, applied, thanks!

I've finished the cleanup now, and removed the noinline on load_module;
we're down to 124 bytes of stack for sys_init_module here (32 bit).

The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules

Eric Dumazet (1):
      module: module_unload_init() cleanup

Linus Torvalds (6):
      module: Make the 'usage' lists be two-way
      module: move find_module check to end
      module: refactor load_module
      module: refactor load_module part 2
      module: reduce stack usage for each_symbol()
      module: fix bne2 "gave up waiting for init of module libcrc32c"

Rusty Russell (18):
      module: fix kdb's illicit use of struct module_use.
      module: move sysfs exposure to end of load_module
      module: Make module sysfs functions private.
      module: make locking more fine-grained.
      module: verify_export_symbols under the lock
      module: fix bne2 "gave up waiting for init of module libcrc32c"
      module: refactor load_module part 3
      module: refactor load_module part 4
      module: refactor load_module part 5
      module: refactor out section header rewriting
      module: kallsyms functions take struct load_info
      module: layout_and_allocate
      module: sysfs cleanup
      module: pass load_info into other functions
      module: move module args strndup_user to just before use
      module: simplify per-cpu handling a little
      module: group post-relocation functions into post_relocation()
      module: cleanup comments, remove noinline

 include/linux/module.h      |   44 +--
 kernel/debug/kdb/kdb_main.c |   12 +-
 kernel/module.c             | 1361 ++++++++++++++++++++++++-------------------



