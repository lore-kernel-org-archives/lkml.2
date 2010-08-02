Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0HBThe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:37:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32672 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0HBThd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:37:33 -0400
Message-ID: <4C571DF2.5080100@kernel.org>
Date: Mon, 02 Aug 2010 12:35:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo> <4C57153F.7030107@zytor.com>
In-Reply-To: <4C57153F.7030107@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C571E4D.01D2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 11:58 AM, H. Peter Anvin wrote:
> On 08/02/2010 11:54 AM, Cyrill Gorcunov wrote:
>>
>> ok, fair enough, I just don't like nesting *.c inclusion you know but seems
>> it would be the only more-less clean way here.
>>
> 
> I don't mind it *as long as* the including file contains nothing but a
> single #include statement -- which is just another way to say "the same
> thing as this other file".  Don't combine files.
> 
> Look at most of the .c files in arch/x86/kernel/acpi/realmode/ for an
> example.

it seems I can not global variables in arch/x86/boot/compressed/misc.c

and misc.c already include some decompress .c like

#ifdef CONFIG_KERNEL_GZIP
#include "../../../../lib/decompress_inflate.c"
#endif

#ifdef CONFIG_KERNEL_BZIP2
#include "../../../../lib/decompress_bunzip2.c"
#endif

#ifdef CONFIG_KERNEL_LZMA
#include "../../../../lib/decompress_unlzma.c"
#endif

#ifdef CONFIG_KERNEL_LZO
#include "../../../../lib/decompress_unlzo.c"
#endif


this patch change to misc.c are following lines:

#define BOOT_BOOT_H
#include "../isdigit.h"
#include "../string.c"
#include "../printf.c"

...

static unsigned long fs;
static inline void set_fs(unsigned long seg)
{
        fs = seg << 4;  /* shift it back */
}
typedef unsigned long addr_t;
static inline char rdfs8(addr_t addr)
{
        return *((char *)(fs + addr));
}
#include "../cmdline.c"
static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
{
        return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
}
static inline int cmdline_find_option_bool(const char *option)
{
        return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
}
static int early_serial_base;
#include "../early_serial_console.c"

or put them in another file?

Thanks

Yinghai

Yinghai
