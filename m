Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118Ab2ERAhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:37:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38895 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761943Ab2ERAhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:37:13 -0400
Message-ID: <4FB599AC.1010807@zytor.com>
Date: Thu, 17 May 2012 17:37:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com> <4FB59474.2020505@zytor.com> <4FB597F3.3060909@gmail.com>
In-Reply-To: <4FB597F3.3060909@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like MIPS has a private definition of struct msqid64_ds, as do
most other architectures; the MIPS one is completely broken for user
space usages as it uses CONFIG_* macros:

#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
        unsigned long   __unused2;
#endif
        __kernel_time_t msg_rtime;      /* last msgrcv time */
#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
        unsigned long   __unused2;
#endif

It looks like the only users of asm-generic here are:

arch/microblaze/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
arch/score/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
arch/sh/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>
arch/x86/include/asm/msgbuf.h:#include <asm-generic/msgbuf.h>

... and unless I'm mistaken, x86 is the only one of those which isn't 32
bits only, which explains the reason it "works"...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

