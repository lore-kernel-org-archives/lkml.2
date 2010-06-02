Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab0FBO4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:56:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357Ab0FBO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:56:03 -0400
Date: Wed, 2 Jun 2010 07:50:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006022336.53024.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006020750330.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006021523.00357.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006020006420.8175@i5.linux-foundation.org> <201006022336.53024.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> Found another locking issue: the code which verifies we don't export over
> an existing symbol needs to be atomic wrt. adding us to the list.

Yup.

And now that I'm looking at that call-chain (to see if it would make sense 
to use some other more specific lock - doesn't look like it: all the 
readers are using RCU and this is the only writer), I also give you this 
trivial one-liner. It changes each_symbol() to not put that constant array 
on the stack, resulting in changing

        movq    $C.388.31095, %rsi      #, tmp85
        subq    $376, %rsp      #,
        movq    %rdi, %rbx      # fn, fn
        leaq    -208(%rbp), %rdi        #, tmp84
        movq    %rbx, %rdx      # fn,
        rep movsl
        xorl    %esi, %esi      #
        leaq    -208(%rbp), %rdi        #, tmp87
        movq    %r12, %rcx      # data,
        call    each_symbol_in_section.clone.0  #

into

        xorl    %esi, %esi      #
        subq    $216, %rsp      #,
        movq    %rdi, %rbx      # fn, fn  
        movq    $arr.31078, %rdi        #,
        call    each_symbol_in_section.clone.0  #

which is not so much about being obviously shorter and simpler because we 
don't unnecessarily copy that constant array around onto the stack, but 
also about having a much smaller stack footprint (376 vs 216 bytes - see 
the update of 'rsp').

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Btw, feel free to consider all those peeling patches signed-off-on, since 
they seem to work.

> And load_module is down to 259 lines.  The label chain at the end is no
> shorter tho :(  I'll leave those cleanups until next merge window.

I don't think it's necessarily bad to have multiple exit targets (although 
9 is pushing it), if the thing is short enough that you can fairly easily 
see how they work. Not that it's quite there yet.

		Linus
---
 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 01e8874..2602264 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -227,7 +227,7 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 			    unsigned int symnum, void *data), void *data)
 {
 	struct module *mod;
-	const struct symsearch arr[] = {
+	static const struct symsearch arr[] = {
 		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
 		  NOT_GPL_ONLY, false },
 		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
