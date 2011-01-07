Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1AGAPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:15:07 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:53421 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1AGAPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:15:05 -0500
Date: Fri, 7 Jan 2011 11:14:59 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110107001459.GA32068@gondor.apana.org.au>
References: <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com> <20110106213932.GA26538@gondor.apana.org.au> <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com> <20110106223042.GA27080@gondor.apana.org.au> <AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com> <20110106225301.GA27358@gondor.apana.org.au> <AANLkTi=E3fqTos7A2fJ2PRKT=o5=sgWh+CzMv4G7P4rZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=E3fqTos7A2fJ2PRKT=o5=sgWh+CzMv4G7P4rZ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 03:25:32PM -0800, Linus Torvalds wrote:
>
> Ok. So can we actually get numbers for this?

As you alluded to, we need real non-x86 hardware to get some
proper numbers.  Unfortunately I'm currently a continent away
from my async hardware so all I can give you are software
numbers.

Anyway, here is a test program that does a set number (1024 * 1024)
of 4096-byte (total 4GB) encryptions with libssl and kernel crypto.
The result on my Core 2 (in a KVM VM FWIW) is:

lenny0:~# time ./test_crypto > /dev/null 

real    0m30.340s
user    0m0.172s
sys     0m30.166s
lenny0:~# time ./test_crypto software > /dev/null 

real    0m34.555s
user    0m34.550s
sys     0m0.004s
lenny0:~# 

I'm not claiming these numbers make any sense but this is just
a ballpark figure.

Dave, can you run this program on your N2 and see what it shows?

#include <fcntl.h>
#include <openssl/aes.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <linux/types.h>

#define AF_ALG 38
#define SOL_ALG 279

#define SPLICE_F_GIFT	(0x08)	/* pages passed in are a gift */

struct sockaddr_alg {
	__u16	salg_family;
	__u8	salg_type[14];
	__u32	salg_feat;
	__u32	salg_mask;
	__u8	salg_name[64];
};

struct af_alg_iv {
	__u32	ivlen;
	__u8	iv[0];
};

/* Socket options */
#define ALG_SET_KEY			1
#define ALG_SET_IV			2
#define ALG_SET_OP			3

/* Operations */
#define ALG_OP_DECRYPT			0
#define ALG_OP_ENCRYPT			1

static char buf[4096] __attribute__((__aligned__(4096)));

static void crypt_ssl(const char *key, char *iv, int i)
{
	AES_KEY akey;

	AES_set_encrypt_key(key, 128, &akey);

	while (i--)
		AES_cbc_encrypt(buf, buf, 4096, &akey, iv, 1);
}

static void crypt_kernel(const char *key, char *oiv, int i)
{
	int opfd;
	int tfmfd;
	struct sockaddr_alg sa = {
		.salg_family = AF_ALG,
		.salg_type = "skcipher",
		.salg_name = "cbc(aes)"
	};
	struct msghdr msg = {};
	struct cmsghdr *cmsg;
	char cbuf[CMSG_SPACE(4) + CMSG_SPACE(20)] = {};
	struct aes_iv {
		__u32 len;
		__u8 iv[16];
	} *iv;
	struct iovec iov;
	int pipes[2];

	pipe(pipes);

	tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);

	bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));

	setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY, key, 16);

	opfd = accept(tfmfd, NULL, 0);

	msg.msg_control = cbuf;
	msg.msg_controllen = sizeof(cbuf);

	cmsg = CMSG_FIRSTHDR(&msg);
	cmsg->cmsg_level = SOL_ALG;
	cmsg->cmsg_type = ALG_SET_OP;
	cmsg->cmsg_len = CMSG_LEN(4);
	*(__u32 *)CMSG_DATA(cmsg) = ALG_OP_ENCRYPT;

	cmsg = CMSG_NXTHDR(&msg, cmsg);
	cmsg->cmsg_level = SOL_ALG;
	cmsg->cmsg_type = ALG_SET_IV;
	cmsg->cmsg_len = CMSG_LEN(20);
	iv = (void *)CMSG_DATA(cmsg);
	iv->len = 16;
	memcpy(iv->iv, oiv, 16);

	iov.iov_base = buf;
	iov.iov_len = 4096;

	msg.msg_iovlen = 0;
	msg.msg_flags = MSG_MORE;

	while (i--) {
		sendmsg(opfd, &msg, 0);
		vmsplice(pipes[1], &iov, 1, SPLICE_F_GIFT);
		splice(pipes[0], NULL, opfd, NULL, 4096, 0);
		read(opfd, buf, 4096);
	}

	close(opfd);
	close(tfmfd);
	close(pipes[0]);
	close(pipes[1]);
}

int main(int argc, char **argv)
{
	int i;

	const char key[16] =
		"\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
		"\x51\x2e\x03\xd5\x34\x12\x00\x06";
	char iv[16] = 
		"\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
		"\xb4\x22\xda\x80\x2c\x9f\xac\x41";
	
	memcpy(buf, "Single block msg", 16);

	if (argc > 1)
		crypt_ssl(key, iv, 1024 * 1024);
	else
		crypt_kernel(key, iv, 1024 * 1024);

	for (i = 0; i < 4096; i++) {
		printf("%02x", (unsigned char)buf[i]);
	}
	printf("\n");

	return 0;
}

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
