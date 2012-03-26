Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2CZBhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:37:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46070 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab2CZBhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:37:23 -0400
Message-ID: <4F6FC838.7000904@zytor.com>
Date: Sun, 25 Mar 2012 18:36:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Thomas Renninger <trenn@suse.de>,
        eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <201203240402.38749.trenn@suse.de> <4F6D50DD.4050306@zytor.com> <20120324092451.GA3352@liondog.tnic> <4F6E1742.6060709@zytor.com> <20120325085420.GA12565@liondog.tnic>
In-Reply-To: <20120325085420.GA12565@liondog.tnic>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------080709060403040904020707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080709060403040904020707
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/25/2012 01:54 AM, Borislav Petkov wrote:
> 
> One other downside for this approach would be the need to have
> initrd/initramfs support always compiled into the kernel in order to do
> all those things but, hey, distro kernels already have that so we're
> probably stuck with it anyway.
> 

In theory we could make the early stuff independent of the initramfs
code in the kernel -- just like we always build in an initramfs.

Not that it matters much, at this point the no-initramfs configurations
are mostly theoretical.

I was able to shave a bit more off the code... optimizing for size can
be fun sometimes.  The code is now 442 bytes on x86-64 and 413 on i386
when compiled with -O2 -fomit-frame-pointer; with -Os
-fomit-frame-pointer it is 372/410... all of that without any library
calls or relocations of any kind (which means it should be safe to call
from the prepaging environment.)

	-hpa

--------------080709060403040904020707
Content-Type: text/x-csrc;
 name="findcpio.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="findcpio.c"

/*
 * findcpio.c
 *
 * Find a specific cpio member; must precede any compressed content.
 */

#include <stddef.h>
#include <stdbool.h>

struct cpio_data {
	void *data;
	unsigned long size;
};

enum cpio_fields {
	C_MAGIC,
	C_INO,
	C_MODE,
	C_UID,
	C_GID,
	C_NLINK,
	C_MTIME,
	C_FILESIZE,
	C_MAJ,
	C_MIN,
	C_RMAJ,
	C_RMIN,
	C_NAMESIZE,
	C_CHKSUM,
	C_NFIELDS
};

#if defined(__i386__) || defined(__x86_64__)
static size_t strlen(const char *name)
{
	size_t n = -1;

	asm("repne; scasb"
	    : "+D" (name), "+c" (n)
	    : "a" (0));

	return -2 - n;
}

static int memcmp(const void *p1, const void *p2, size_t n)
{
	unsigned char rv;

	asm("repe; cmpsb; setne %0"
	    : "=r" (rv), "+S" (p1), "+D" (p2), "+c" (n));

	return rv;
}
#else
static size_t strlen(const char *name)
{
	size_t n = 0;

	while (*name++)
		n++;

	return n;
}

static int memcmp(const void *p1, const void *p2, size_t n)
{
	const unsigned char *u1 = p1;
	const unsigned char *u2 = p2;
	int d;

	while (n--) {
		d = *u2++ - *u1++;
		if (d)
			return d;
	}
	return 0;
}
#endif

#define ALIGN4(p) ((void *)(((size_t)p + 3) & ~3))

struct cpio_data find_cpio_data(const char *name, const void *data, size_t len)
{
	const size_t cpio_header_len = 8*C_NFIELDS - 2;
	struct cpio_data cd = { NULL, 0 };
	const char *p, *dptr, *nptr;
	unsigned int ch[C_NFIELDS], *chp, v;
	unsigned char c, x;
	size_t mynamesize = strlen(name) + 1;
	int i, j;

	p = data;

	while (len > cpio_header_len) {
		if (!*p) {
			/* All cpio headers need to be 4-byte aligned */
			p += 4;
			len -= 4;
			continue;
		}

		j = 6;		/* The magic field is only 6 characters */
		chp = ch;
		for (i = C_NFIELDS; i; i--) {
			v = 0;
			while (j--) {
				v <<= 4;
				c = *p++;

				x = c - '0';
				if (x < 10) {
					v += x;
					continue;
				}

				x = (c | 0x20) - 'a';
				if (x < 6) {
					v += x + 10;
					continue;
				}

				goto quit; /* Invalid hexadecimal */
			}
			*chp++ = v;
			j = 8;	/* All other fields are 8 characters */
		}

		if ((ch[C_MAGIC] - 0x070701) > 1)
			goto quit; /* Invalid magic */

		len -= cpio_header_len;

		dptr = ALIGN4(p + ch[C_NAMESIZE]);
		nptr = ALIGN4(dptr + ch[C_FILESIZE]);

		if (nptr > p + len || dptr < p || nptr < dptr)
			goto quit; /* Buffer overrun */

		if ((ch[C_MODE] & 0170000) == 0100000 &&
		    ch[C_NAMESIZE] == mynamesize &&
		    !memcmp(p, name, mynamesize)) {
			cd.data = (void *)dptr;
			cd.size = ch[C_FILESIZE];
			return cd; /* Found it! */
		}

		len -= (nptr - p);
		p = nptr;
	}

quit:
	return cd;
}


--------------080709060403040904020707--
