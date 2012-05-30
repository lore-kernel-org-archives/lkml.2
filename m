Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2E3LUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:20:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64161 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2E3LUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:20:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120530102226.GA28628@frolo.macqel>
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
	<20120530102226.GA28628@frolo.macqel>
Date: Wed, 30 May 2012 13:20:02 +0200
X-Google-Sender-Auth: 6n9YomdlcEKpA_v2RUYlPHPN8PE
Message-ID: <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(), and strnlen_user()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 12:22 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> On Tue, May 29, 2012 at 11:33:36PM +0200, Geert Uytterhoeven wrote:
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> Do we also want
>>
>>     select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE && !M68000)
>
> Sorry, I did not follow what happened to unaligned accesses, but
> CPU32 family (at least 68340) crashes on unaligned accesses.

We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?
But Freescale's website confirms both 68340 and 68360 are CPU32.

arch/m68k/include/asm/unaligned.h assumes CPU32 (CONFIG_MCPU32)
can do unaligned accesses:

#if defined(CONFIG_COLDFIRE) || defined(CONFIG_M68000)
#include <linux/unaligned/be_struct.h>
#include <linux/unaligned/le_byteshift.h>
#include <linux/unaligned/generic.h>

#define get_unaligned   __get_unaligned_be
#define put_unaligned   __put_unaligned_be

#else
/*
 * The m68k can do unaligned accesses itself.
 */
#include <linux/unaligned/access_ok.h>
#include <linux/unaligned/generic.h>

#define get_unaligned   __get_unaligned_be
#define put_unaligned   __put_unaligned_be

#endif

Is this wrong?

However, for CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
the question is not whether unaligned accesses are supported, but
whether they are more efficient than byte copies when copying larger blocks.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
