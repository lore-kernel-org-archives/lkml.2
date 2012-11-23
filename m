Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2KWHgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:36:08 -0500
Received: from f287.mail.ru ([217.69.128.254]:39458 "EHLO f287.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412Ab2KWHgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:36:06 -0500
X-Greylist: delayed 4088 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2012 02:36:06 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QW50b24gVm9yb250c292?= <anton.vorontsov@linaro.org>
Cc: =?UTF-8?B?QW5kcmV3IE1vcnRvbg==?= <akpm@linux-foundation.org>,
        linaro-kernel@lists.linaro.org,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Sm9obiBTdHVsdHo=?= <john.stultz@linaro.org>,
        =?UTF-8?B?SmFzb24gV2Vzc2Vs?= <jason.wessel@windriver.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCAxMC8xMF0gQVJNOiBGSVE6IEdldCByaWQgb2YgaW5p?=
 =?UTF-8?B?dF9GSVEoKQ==?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [217.119.30.118]
Date: Fri, 23 Nov 2012 11:36:01 +0400
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net> <1353652071.755665772@f76.mail.ru> <20121123065002.GB27827@lizard>
In-Reply-To: <20121123065002.GB27827@lizard>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1353656161.911816605@f287.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAN7aAnV011559

> On Fri, Nov 23, 2012 at 10:27:51AM +0400, Alexander Shiyan wrote:
> > > On Fri, Nov 23, 2012 at 07:40:30AM +0400, Alexander Shiyan wrote:
> > > [...]
> > > > >  static unsigned long no_fiq_insn;
> > > > > +static int got_no_fiq_insn;
> > > > > @@ -78,11 +79,14 @@ void show_fiq_list(struct seq_file *p, int prec)
> > > > >  
> > > > >  void set_fiq_handler(void *start, unsigned int length)
> > > > >  {
> > > > > -#if defined(CONFIG_CPU_USE_DOMAINS)
> > > > > -	memcpy((void *)0xffff001c, start, length);
> > > > > -#else
> > > > > -	memcpy(vectors_page + 0x1c, start, length);
> > > > > +	unsigned long *addr = (void *)0xffff001c;
> > > > > +
> > > > > +#ifndef CONFIG_CPU_USE_DOMAINS
> > > > > +	addr = vectors_page + 0x1c;
> > > > >  #endif
> > > > > +	if (!cmpxchg(&got_no_fiq_insn, 0, 1))
> > > > > +		no_fiq_insn = *addr;
> > > > > +	memcpy(addr, start, length);
> > > > >  	flush_icache_range(0xffff001c, 0xffff001c + length);
> > > > >  	if (!vectors_high())
> > > > >  		flush_icache_range(0x1c, 0x1c + length);
> > > > > @@ -126,8 +130,3 @@ EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
> > > > > -
> > > > > -void __init init_FIQ(void)
> > > > > -{
> > > > > -	no_fiq_insn = *(unsigned long *)0xffff001c;
> > > > 
> > > > it seems that this is wrong. In this case we have an uninitialized variable and
> > > > sequential call claim_fiq and release_fiq could be fatal. FIXME please.
> > > 
> > > Um... I don't think I understand, can you please elaborate?
> > 
> > OK, I'll try to explain it.
> > At the end of the release_fiq function we have a call fiq_op. For the default
> > handler - is a fiq_def_op function, and we call this function with the option
> > "relinquish = 0", i.e. we want to restore old fiq_handler. But if we do not call
> > set_fiq_handler never before, we will have an uninitialized no_fiq_insn variable.
> 
> It should not matter when or in what order anyone calls the
> set_fiq_handler(), since it stores "no FIQ instruction" into no_fiq_insn
> at its first invocation:
> 
> 	if (!cmpxchg(&got_no_fiq_insn, 0, 1))
> 		no_fiq_insn = *addr;
> 
> If we never called set_fiq_handler() before, during release_fiq() we'll:
> 
> 1. Copy the initial instruction from the vector page to 'no_fiq_insn';
> 2. Copy the initial instruction from 'no_fiq_insn' to the vector page;
> 
> So no_fiq_insn gets initialized, then we just instantly write the same
> value back.

got_no_fiq_insn also not initialized.
I think as a whole on this issue requires additional comments from Russell
as the author of implementation.

PS: In any case, I can reproduce it and check it out if you send me a patchset
to my email as an attachment.


---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
