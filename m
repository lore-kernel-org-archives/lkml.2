Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2CXWVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:21:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37096 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab2CXWV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:21:28 -0400
Message-ID: <4F6E48CD.9050002@zytor.com>
Date: Sat, 24 Mar 2012 15:21:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <4F6CD79A.8020805@zytor.com> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <20120324184238.GB13978@phenom.dumpdata.com> <4F6E1D6F.4000308@zytor.com> <20120324191718.GA3927@phenom.dumpdata.com>
In-Reply-To: <20120324191718.GA3927@phenom.dumpdata.com>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------080500020807000606090101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080500020807000606090101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The attached cpio-parsing code compiles to 458 bytes on x86-64 and 476
bytes on i386, and that is without any library dependencies at all.
Again, it will completely stop at the first compressed data item, so any
such kernel objects absolutely will have to be first.  In good Linux
tradition, it is also completely untested.

However, given that very reasonable size I would think that this is a
reasonable approach.  Anyone who has a better suggestion for the
namespace than "kernel/"?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------080500020807000606090101
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

/* Return true if this field is composed of valid hex digits */
static bool validhex(const char *ptr, int len)
{
	unsigned char c, x;

	while (len--) {
		c = *ptr++;

		x = c - '0';
		if (x < 10)
			continue;

		x = (c | 0x20) - 'a' + 10;
		if (x < 16)
			continue;

		return false;
	}

	return true;
}

/* Return the value of an already validated field */
static unsigned int hexval(const char *ptr, int len)
{
	unsigned int v = 0;
	unsigned char c, x;

	while (len--) {
		v <<= 4;
		c = *ptr++;

		x = c - '0';
		if (x < 10) {
			v += x;
			continue;
		}

		x = (c | 0x20) - 'a' + 10;
		v += x;
	}

	return v;
}

static int mystrlen(const char *name)
{
	int n = 0;

	while (*name++)
		n++;

	return n;
}

#if 0
# define memcmp(p1, p2, n) __builtin_memcmp(p1, p2, n)
#else
static int memcmp(const void *p1, const void *p2, size_t n)
{
	const unsigned char *u1 = p1;
	const unsigned char *u2 = p2;
	int d;

	while (n--) {
		d = *u2 - *u1;
		if (d)
			return d;
	}
	return 0;
}
#endif

#define ALIGN4(p) ((void *)(((size_t)p + 3) & ~3))

struct cpio_data find_cpio_data(const char *name, const void *data, size_t len)
{
	const size_t cpio_header_len = 6 + 8*C_NFIELDS;
	struct cpio_data cd = { NULL, 0 };
	const char *p, *dptr, *nptr;
	unsigned int magic, ch[C_NFIELDS], *chp;
	unsigned int mynamesize = mystrlen(name) + 1;
	int i;

	p = data;

	while (len > cpio_header_len) {
		if (!*p) {
			/* All cpio headers need to be 4-byte aligned */
			p += 4;
			len -= 4;
			continue;
		}

		if (!validhex(p, cpio_header_len))
			break;	/* Not a valid cpio header */

		magic = hexval(p, 6);
		if ((magic - 0x070701) > 1)
			break;	/* Not a valid cpio magic */

		p += 6;
		chp = ch;
		for (i = 0; i < C_NFIELDS; i++) {
			*chp++ = hexval(p, 8);
			p += 8;

		}

		len -= cpio_header_len;

		dptr = ALIGN4(p + ch[C_NAMESIZE]);
		nptr = ALIGN4(dptr + ch[C_FILESIZE]);

		if (nptr > p + len)
			break;	/* Buffer overrun */

		if ((ch[C_MODE] & 0170000) == 0100000 &&
		    ch[C_NAMESIZE] == mynamesize &&
		    memcmp(p, name, mynamesize)) {
			cd.data = (void *)dptr;
			cd.size = ch[C_FILESIZE];
			break;
		}

		len -= (nptr - p);
		p = nptr;
	}

	return cd;
}


--------------080500020807000606090101--
