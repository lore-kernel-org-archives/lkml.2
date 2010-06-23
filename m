Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0FWWxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:53:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab0FWWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:53:14 -0400
Date: Wed, 23 Jun 2010 15:53:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 11
Message-Id: <20100623155303.65ead123.akpm@linux-foundation.org>
In-Reply-To: <201006151856.38882.rusty@rustcorp.com.au>
References: <20100611141738.cf8a6bbf.sfr@canb.auug.org.au>
	<20100611163124.bbc01d34.akpm@linux-foundation.org>
	<201006151856.38882.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 18:56:37 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sat, 12 Jun 2010 09:01:24 am Andrew Morton wrote:
> > On Fri, 11 Jun 2010 14:17:38 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).
> > 
> > Rusty broke your kernel!
> > 
> > oops: http://userweb.kernel.org/~akpm/IMG_20100611_155611.jpg
> > 
> > config: http://userweb.kernel.org/~akpm/stuff/config-akpm2-small.txt
> > 
> > (gdb) l *0xffffffff8105f9fb
> > 0xffffffff8105f9fb is in get_ksymbol (kernel/module.c:2784).
> > 2779                    if (mod->symtab[i].st_shndx == SHN_UNDEF)
> > 2780                            continue;
> > 2781    
> > 2782                    /* We ignore unnamed symbols: they're uninformative
> > 2783                     * and inserted at a whim. */
> > 2784                    if (mod->symtab[i].st_value <= addr
> > 2785                        && mod->symtab[i].st_value > mod->symtab[best].st_value
> > 2786                        && *(mod->strtab + mod->symtab[i].st_name) != '\0'
> > 2787                        && !is_arm_mapping_symbol(mod->strtab + mod->symtab[i].st_name))
> > 2788                            best = i;
> 
> Hmm, I can't reproduce this :(  I'm only 32 bit here, have to dig out my
> 64-bit machine tomorrow.
> 
> One wonders why we're in get_ksymbol at all.  Has something already gone
> horribly wrong?

Dunno - maybe it got into get_ksymbol() because something oopsed, and
oops tracing uses get_ksymbol().  There's no stack trace because stack
tracing uses get_ksymbol().

Anyway I retested next-20100623 and the verdict is ... you still suck!

I bisected it down to 4624469822455b4accc886557f6c997ccdd59066
("module: kallsyms functions take struct load_info").  I couldn't see
anything obviously wrong with it, but there's something screwy in
there..

<mooches off to bisect Yet Another Hang>
