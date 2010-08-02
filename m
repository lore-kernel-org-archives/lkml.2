Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0HBUjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:39:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41221 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0HBUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:39:19 -0400
Message-ID: <4C572CBB.1070403@zytor.com>
Date: Mon, 02 Aug 2010 13:38:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo> <4C57153F.7030107@zytor.com> <4C571DF2.5080100@kernel.org>
In-Reply-To: <4C571DF2.5080100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 12:35 PM, Yinghai Lu wrote:
> 
> it seems I can not global variables in arch/x86/boot/compressed/misc.c
> 

Well, that should be fixed, then.  If we can't use the linker for what
it's supposed to be used for it's just crap.

> and misc.c already include some decompress .c like
> 
> #ifdef CONFIG_KERNEL_GZIP
> #include "../../../../lib/decompress_inflate.c"
> #endif
> 
> #ifdef CONFIG_KERNEL_BZIP2
> #include "../../../../lib/decompress_bunzip2.c"
> #endif
> 
> #ifdef CONFIG_KERNEL_LZMA
> #include "../../../../lib/decompress_unlzma.c"
> #endif
> 
> #ifdef CONFIG_KERNEL_LZO
> #include "../../../../lib/decompress_unlzo.c"
> #endif
> 

Yes, I know; that's crap in a lot of ways too... the whole decompression
stuff is its own issue which is slowly being addressed.  It's not an
excuse to make the code crappier than it already is.

> 
> this patch change to misc.c are following lines:
> 
> #define BOOT_BOOT_H
> #include "../isdigit.h"
> #include "../string.c"
> #include "../printf.c"
> 
> ...
> 
> static unsigned long fs;
> static inline void set_fs(unsigned long seg)
> {
>         fs = seg << 4;  /* shift it back */
> }
> typedef unsigned long addr_t;
> static inline char rdfs8(addr_t addr)
> {
>         return *((char *)(fs + addr));
> }
> #include "../cmdline.c"
> static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
> {
>         return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
> }
> static inline int cmdline_find_option_bool(const char *option)
> {
>         return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
> }
> static int early_serial_base;
> #include "../early_serial_console.c"
> 
> or put them in another file?
> 

Hmf... games with set_fs() aren't a whole lot of fun at all.  I think it
would be better to define some wrappers specific to cmdline.c which
allow it to be using a real pointer in 32-bit mode.

I'll see if I can muck with it, it shouldn't take long.

	-hpa


