Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1H1UgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 16:36:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59856 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1H1UgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 16:36:16 -0400
Date: Sun, 28 Aug 2011 16:35:54 -0400 (EDT)
Message-Id: <20110828.163554.2024158531156183815.davem@davemloft.net>
To: nmav@gnutls.org
Cc: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E5A3FCC.2030504@gnutls.org>
References: <4E5A3FCC.2030504@gnutls.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 28 Aug 2011 13:35:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Date: Sun, 28 Aug 2011 15:17:00 +0200

> The benchmark idea was to test the speed of initialization, encryption
> and deinitiation, as well as the encryption speed alone. These are the
> most common use cases of the frameworks (i.e. how they would be used
> by a cryptographic library).

Be sure to use splice() with AF_ALG for maximum performance.

For example, see the test program below.  You'll need to replace
"8192" with whatever the page size is on your cpu.

--------------------
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

static char buf[8192] __attribute__((__aligned__(8192)));

static void crypt_ssl(const char *key, char *iv, int i)
{
	AES_KEY akey;

	AES_set_encrypt_key(key, 128, &akey);

	while (i--)
		AES_cbc_encrypt(buf, buf, 8192, &akey, iv, 1);
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
	iov.iov_len = 8192;

	msg.msg_iovlen = 0;
	msg.msg_flags = MSG_MORE;

	while (i--) {
		sendmsg(opfd, &msg, 0);
		vmsplice(pipes[1], &iov, 1, SPLICE_F_GIFT);
		splice(pipes[0], NULL, opfd, NULL, 8192, 0);
		read(opfd, buf, 8192);
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

	for (i = 0; i < 8192; i++) {
		printf("%02x", (unsigned char)buf[i]);
	}
	printf("\n");

	return 0;
}
