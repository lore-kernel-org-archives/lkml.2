Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2HTN3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:29:33 -0400
Received: from mail.x86-64.org ([217.9.48.20]:51785 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab2HTN3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:29:30 -0400
Date: Mon, 20 Aug 2012 15:29:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file name
Message-ID: <20120820132919.GA24149@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-3-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345277729-8399-3-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 01:15:20AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Given a file's name, find its starting point in a cpio formated area. This will

	s/file's/file/				cpio-formatted

> be used to find microcode in combined initrd image. But this function is
> generic and could be used in other places.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/cpio.h |   10 +++
>  arch/x86/lib/Makefile       |    2 +
>  arch/x86/lib/cpio.c         |  179 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 191 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/cpio.h
>  create mode 100644 arch/x86/lib/cpio.c
> 
> diff --git a/arch/x86/include/asm/cpio.h b/arch/x86/include/asm/cpio.h
> new file mode 100644
> index 0000000..26a4333
> --- /dev/null
> +++ b/arch/x86/include/asm/cpio.h
> @@ -0,0 +1,10 @@
> +#include <stddef.h>
> +#include <stdbool.h>
> +
> +struct cpio_data {
> +	void *data;
> +	unsigned long size;
> +};
> +
> +extern struct cpio_data
> +find_cpio_data(const char *name, const void *data, size_t len);
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index b00f678..452a4b5 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -45,3 +45,5 @@ else
>          lib-y += copy_user_64.o copy_user_nocache_64.o
>  	lib-y += cmpxchg16b_emu.o
>  endif
> +
> +obj-y += cpio.o
> diff --git a/arch/x86/lib/cpio.c b/arch/x86/lib/cpio.c
> new file mode 100644
> index 0000000..70ac474
> --- /dev/null
> +++ b/arch/x86/lib/cpio.c
> @@ -0,0 +1,179 @@
> +/*
> + * findcpio.c
> + *
> + * Find a specific cpio member; must precede any compressed content.
> + *
> + *	Copyright (C) 2012	H Peter Anvin" <hpa@zytor.com>

				stray "

> + *				Fenghua Yu <fenghua.yu@intel.com>
> + */
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/swap.h>
> +#include <linux/slab.h>
> +#include <linux/sysctl.h>
> +#include <linux/bitmap.h>
> +#include <linux/signal.h>
> +#include <linux/printk.h>
> +#include <linux/proc_fs.h>
> +#include <linux/security.h>
> +#include <linux/ctype.h>
> +#include <linux/kmemcheck.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/kobject.h>
> +#include <linux/net.h>
> +#include <linux/sysrq.h>
> +#include <linux/highuid.h>
> +#include <linux/writeback.h>
> +#include <linux/ratelimit.h>
> +#include <linux/compaction.h>
> +#include <linux/hugetlb.h>
> +#include <linux/initrd.h>
> +#include <linux/key.h>
> +#include <linux/times.h>
> +#include <linux/limits.h>
> +#include <linux/dcache.h>
> +#include <linux/dnotify.h>
> +#include <linux/syscalls.h>

Why all those includes?

> +#include <asm/cpio.h>
> +
> +enum cpio_fields {
> +	C_MAGIC,
> +	C_INO,
> +	C_MODE,
> +	C_UID,
> +	C_GID,
> +	C_NLINK,
> +	C_MTIME,
> +	C_FILESIZE,
> +	C_MAJ,
> +	C_MIN,
> +	C_RMAJ,
> +	C_RMIN,
> +	C_NAMESIZE,
> +	C_CHKSUM,
> +	C_NFIELDS
> +};
> +
> +#if defined(__i386__) || defined(__x86_64__)
> +static size_t cpio_strlen(const char *name)
> +{
> +	size_t n = -1;
> +
> +	asm("repne; scasb"
> +	    : "+D" (name), "+c" (n)
> +	    : "a" (0));
> +
> +	return -2 - n;
> +}
> +
> +static int cpio_memcmp(const void *p1, const void *p2, size_t n)
> +{
> +	unsigned char rv;
> +
> +	asm("repe; cmpsb; setne %0"
> +	    : "=r" (rv), "+S" (p1), "+D" (p2), "+c" (n));
> +
> +	return rv;
> +}

I guess those are speed optimizations on x86, right? In any
case, can we reuse some of the already present ones like
memcmp in <arch/x86/boot/compressed/string.c> and strlen in
<arch/x86/lib/string_32.c>...

> +#else
> +static size_t cpio_strlen(const char *name)
> +{
> +	size_t n = 0;
> +
> +	while (*name++)
> +		n++;
> +
> +	return n;
> +}
> +
> +static int cpio_memcmp(const void *p1, const void *p2, size_t n)
> +{
> +	const unsigned char *u1 = p1;
> +	const unsigned char *u2 = p2;
> +	int d;
> +
> +	while (n--) {
> +		d = *u2++ - *u1++;
> +		if (d)
> +			return d;
> +	}
> +	return 0;
> +}
> +#endif

and, similarly the generic ones in lib/string.c?

> +
> +#define ALIGN4(p) ((void *)(((size_t)p + 3) & ~3))
> +
> +struct cpio_data find_cpio_data(const char *name, const void *data, size_t len)
> +{
> +	const size_t cpio_header_len = 8*C_NFIELDS - 2;
> +	struct cpio_data cd = { NULL, 0 };
> +	const char *p, *dptr, *nptr;
> +	unsigned int ch[C_NFIELDS], *chp, v;
> +	unsigned char c, x;
> +	size_t mynamesize = cpio_strlen(name) + 1;
> +	int i, j;
> +
> +	p = data;
> +
> +	while (len > cpio_header_len) {
> +		if (!*p) {
> +			/* All cpio headers need to be 4-byte aligned */
> +			p += 4;
> +			len -= 4;
> +			continue;
> +		}
> +
> +		j = 6;		/* The magic field is only 6 characters */

Maybe put all comments above the line they refer to, like above instead
of them trailing?

> +		chp = ch;
> +		for (i = C_NFIELDS; i; i--) {
> +			v = 0;
> +			while (j--) {
> +				v <<= 4;
> +				c = *p++;
> +
> +				x = c - '0';
> +				if (x < 10) {
> +					v += x;
> +					continue;
> +				}
> +
> +				x = (c | 0x20) - 'a';
> +				if (x < 6) {
> +					v += x + 10;
> +					continue;
> +				}
> +
> +				goto quit; /* Invalid hexadecimal */
> +			}
> +			*chp++ = v;
> +			j = 8;	/* All other fields are 8 characters */
> +		}
> +
> +		if ((ch[C_MAGIC] - 0x070701) > 1)
> +			goto quit; /* Invalid magic */
> +
> +		len -= cpio_header_len;
> +
> +		dptr = ALIGN4(p + ch[C_NAMESIZE]);
> +		nptr = ALIGN4(dptr + ch[C_FILESIZE]);
> +
> +		if (nptr > p + len || dptr < p || nptr < dptr)
> +			goto quit; /* Buffer overrun */
> +
> +		if ((ch[C_MODE] & 0170000) == 0100000 &&
> +		    ch[C_NAMESIZE] == mynamesize &&
> +		    !cpio_memcmp(p, name, mynamesize)) {
> +			cd.data = (void *)dptr;
> +			cd.size = ch[C_FILESIZE];
> +			return cd; /* Found it! */
> +		}
> +
> +		len -= (nptr - p);
> +		p = nptr;
> +	}
> +
> +quit:
> +	return cd;
> +}
> -- 
> 1.7.2
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
