Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1AFWxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:53:10 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:40892 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1AFWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:53:08 -0500
Date: Fri, 7 Jan 2011 09:53:01 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110106225301.GA27358@gondor.apana.org.au>
References: <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com> <20110106213932.GA26538@gondor.apana.org.au> <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com> <20110106223042.GA27080@gondor.apana.org.au> <AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 02:43:35PM -0800, Linus Torvalds wrote:
>
> Can you do the "bypass directly to the TCP stream" with the interface
> you added? It isn't at all obvious how it would work.

Yes it can.  The interface allows zero-copy in both directions
using the splice interface.  Here is a sample program demonstrating
zero-copy in-place encryption.  It doesn't send the result over TCP
but I'm sure you can imagine what that would look like.

Note that the final read(2) looks like it copies, but it doesn't.
The read(2) will setup SG lists using the user-space address and
place the encryption result in there directly.  In this case as
the source/destination addresses are identical, it performs in-place
encryption.

#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <linux/splice.h>
#include <linux/types.h>
#include <linux/af_alg.h>

static char buf[4096] __attribute__((__aligned__(4096)));

int main(void)
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
	char cbuf[CMSG_SPACE(4) + CMSG_SPACE(20)];
	struct aes_iv {
		__u32 len;
		__u8 iv[16];
	} *iv;
	struct iovec iov;
	int i;
	int pipes[2];

	pipe(pipes);

	tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);

	bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));

	setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY,
		   "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
		   "\x51\x2e\x03\xd5\x34\x12\x00\x06", 16);

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
	memcpy(iv->iv, "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
		       "\xb4\x22\xda\x80\x2c\x9f\xac\x41", 16);

	memcpy(buf, "Single block msg", 16);

	iov.iov_base = buf;
	iov.iov_len = 4096;

	msg.msg_iovlen = 0;
	msg.msg_flags = MSG_MORE;

	sendmsg(opfd, &msg, 0);
	vmsplice(pipes[1], &iov, 1, SPLICE_F_GIFT);
	splice(pipes[0], NULL, opfd, NULL, 16, 0);
	read(opfd, buf, 16);

	for (i = 0; i < 16; i++) {
		printf("%02x", (unsigned char)buf[i]);
	}
	printf("\n");

	close(opfd);
	close(tfmfd);

	return 0;

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
