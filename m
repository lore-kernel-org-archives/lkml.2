Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2JZNnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:43:40 -0400
Received: from www84.your-server.de ([213.133.104.84]:33009 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab2JZNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:43:38 -0400
Message-ID: <1351258964.10060.8.camel@wall-e>
Subject: Re: [PATCH] kfifo: remove unnecessary type check
From: Stefani Seibold <stefani@seibold.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Yuanhan Liu <yliu.null@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 26 Oct 2012 15:42:44 +0200
In-Reply-To: <20121026130408.GH2778@yliu-dev.sh.intel.com>
References: <1351215971-11639-1-git-send-email-yliu.null@gmail.com>
	 <1351229911.12511.1.camel@wall-e>
	 <20121026061145.GA2778@yliu-dev.sh.intel.com>
	 <1351234266.12511.23.camel@wall-e>
	 <20121026071757.GB2778@yliu-dev.sh.intel.com>
	 <1351243591.8719.2.camel@wall-e>
	 <20121026130408.GH2778@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 26.10.2012, 21:04 +0800 schrieb Yuanhan Liu:
> On Fri, Oct 26, 2012 at 11:26:31AM +0200, Stefani Seibold wrote:
> > Am Freitag, den 26.10.2012, 15:17 +0800 schrieb Yuanhan Liu:
> > > On Fri, Oct 26, 2012 at 08:51:06AM +0200, Stefani Seibold wrote:
> > > > Am Freitag, den 26.10.2012, 14:11 +0800 schrieb Yuanhan Liu:
> > > > > On Fri, Oct 26, 2012 at 07:38:31AM +0200, Stefani Seibold wrote:
> > > > > > Am Freitag, den 26.10.2012, 09:46 +0800 schrieb Yuanhan Liu:
> > > > > > > From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > > > > > 
> > > > > > > Firstly, this kind of type check doesn't work. It does something similay
> > > > > > > like following:
> > > > > > > 	void * __dummy = NULL;
> > > > > > > 	__buf = __dummy;
> > > > > > > 
> > > > > > > __dummy is defined as void *. Thus it will not trigger warnings as
> > > > > > > expected.
> > > > > > > 
> > > > > > > Second, we don't need that kind of check. Since the prototype
> > > > > > > of __kfifo_out is:
> > > > > > > 	unsigned int __kfifo_out(struct __kfifo *fifo,  void *buf, unsigned int len)
> > > > > > > 
> > > > > > > buf is defined as void *, so we don't need do the type check. Remove it.
> > > > > > > 
> > > > > > > LINK: https://lkml.org/lkml/2012/10/25/386
> > > > > > > LINK: https://lkml.org/lkml/2012/10/25/584
> > > > > > > 
> > > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
> > > > > > > Cc: Stefani Seibold <stefani@seibold.net>
> > > > > > > Cc: Fengguang Wu <fengguang.wu@intel.com>
> > > > > > > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > > > > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > > > > > ---
> > > > 
> 
> [snip]...
> 
> > > > 
> > > > Also you have to build the kfifo samples, since this example code use
> > > > all features of the kfifo API.
> > > > 
> > > > And again: The kfifo is designed to do the many things at compile time,
> > > > not at runtime. If you modify the code, you have to check the compiler
> > > > assembler output for no degradation, especially in kfifo_put, kfifo_get,
> > > > kfifo_in, kfifo_out, __kfifo_in and __kfifo_out. Prevent runtime checks
> > > > if you can do it at compile time. This is the basic reasons to do it in
> > > > macros.
> > > 
> > > Is it enought to check kernel/kfifo.o only? I build that file with
> > > and without this patch. And then  dump it by objdump -D kernel/fifo.o to
> > > /tmp/kfifo.dump.with and /tmp/kfifo.dump.without, respectively. And the
> > > two dump file are exactly same.
> > > 
> > 
> > No, since most of the code is inlined due performace reasons, you have
> > to hack the kfifo examples output code for regressions and code
> > increase.
> 
> In my test, this patch doesn't change anything. Here are some data to
> prove that:
> 
> $ make samples/kfifo/
> $ cp samples/kfifo/*.o /tmp/before/
> 
> $ git am this-patch
> $ make samples/kfifo/
> $ cp samples/kfifo/*.o /tmp/after/
> 
> $ for i in /tmp/before/*.o; do size $i /tmp/after/`basename $i`; done
>    text    data     bss     dec     hex filename
>    1939     464     456    2859     b2b /tmp/before/bytestream-example.o
>    1939     464     456    2859     b2b /tmp/after/bytestream-example.o
>    text    data     bss     dec     hex filename
>    1423     112     296    1831     727 /tmp/before/dma-example.o
>    1423     112     296    1831     727 /tmp/after/dma-example.o
>    text    data     bss     dec     hex filename
>    1864     624     376    2864     b30 /tmp/before/inttype-example.o
>    1864     624     376    2864     b30 /tmp/after/inttype-example.o
>    text    data     bss     dec     hex filename
>    1916     464     472    2852     b24 /tmp/before/record-example.o
>    1916     464     472    2852     b24 /tmp/after/record-example.o
> # You will see that it changed nothing.
> 
> 
> $ objdump -d /tmp/before/bytestream-example.o >/tmp/bytestream-example.before
> $ objdump -d /tmp/after/bytestream-example.o >/tmp/bytestream-example.after
> $ diff /tmp/bytestream.before /tmp/bytestream.after -urN
> --- bytestream.before   2012-10-26 20:55:33.645578668 +0800
> +++ bytestream.after    2012-10-26 20:55:26.520578669 +0800
> @@ -1,5 +1,5 @@
> 
> -/tmp/bytestream-example.o:     file format elf64-x86-64
> +/tmp/bytestream-example.o:     file format elf64-x86-64
> 
> # So, as you can see, expect the filename, they are same.
> 
> 
> So, Stefani, is it what you want? Does this looks OK to you?

Perfect. It looks okay for me and i hope for you too ;-)

Acked by stefani@seibold.net

Greetings,
Stefani


