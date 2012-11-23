Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2KWF4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:56:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39950 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2KWF4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:56:40 -0500
Date: Thu, 22 Nov 2012 21:53:28 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linaro-kernel@lists.linaro.org,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/10] ARM: FIQ: Get rid of init_FIQ()
Message-ID: <20121123055328.GA21566@lizard>
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
 <1353631803-4853-10-git-send-email-anton.vorontsov@linaro.org>
 <1353642030.851395840@f20.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353642030.851395840@f20.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 07:40:30AM +0400, Alexander Shiyan wrote:
[...]
> >  static unsigned long no_fiq_insn;
> > +static int got_no_fiq_insn;
> > @@ -78,11 +79,14 @@ void show_fiq_list(struct seq_file *p, int prec)
> >  
> >  void set_fiq_handler(void *start, unsigned int length)
> >  {
> > -#if defined(CONFIG_CPU_USE_DOMAINS)
> > -	memcpy((void *)0xffff001c, start, length);
> > -#else
> > -	memcpy(vectors_page + 0x1c, start, length);
> > +	unsigned long *addr = (void *)0xffff001c;
> > +
> > +#ifndef CONFIG_CPU_USE_DOMAINS
> > +	addr = vectors_page + 0x1c;
> >  #endif
> > +	if (!cmpxchg(&got_no_fiq_insn, 0, 1))
> > +		no_fiq_insn = *addr;
> > +	memcpy(addr, start, length);
> >  	flush_icache_range(0xffff001c, 0xffff001c + length);
> >  	if (!vectors_high())
> >  		flush_icache_range(0x1c, 0x1c + length);
> > @@ -126,8 +130,3 @@ EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
> > -
> > -void __init init_FIQ(void)
> > -{
> > -	no_fiq_insn = *(unsigned long *)0xffff001c;
> 
> it seems that this is wrong. In this case we have an uninitialized variable and
> sequential call claim_fiq and release_fiq could be fatal. FIXME please.

Um... I don't think I understand, can you please elaborate?

Thanks,
Anton.
