Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1AFVjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:39:40 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44669 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1AFVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:39:39 -0500
Date: Fri, 7 Jan 2011 08:39:32 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110106213932.GA26538@gondor.apana.org.au>
References: <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 01:23:19PM -0800, Linus Torvalds wrote:
>
> Explanations of interface. Code. Who uses it? What are the actual
> performance benefits on real code?

You snipped out the bit in my reply where I expanded on it:

: Right.  This purpose of this interface is to access the async
: hardware crypto drivers that we have added over the past years.
:
: For a modern x86-64 CPU it isn't interesting at all.  It's mainly
: for other architectures where the CPU may not be able to keep up
: with say 10Gb/s IPsec traffic and the encryption and/or hashing
: must be offloaded.
:
: This is also why only hash and skcipher are supported as they
: are the main algorithm types supported by teh current async
: drivers in the kernel.

The interface is meant to be used by those whose CPU either cannot
provide adequate performance for encryption/hashing, or where they
need to preverse the CPU power for other tasks.  This is most
likely to be used on a non-x86 architecture, as most of our async
crypto drivers are for non-x86 architectures.

Users can be anything performing bulk encryptiong/hashing in user-
space, e.g., SSL (although there are plans to implement SSL in
the kernel as well), SSH, etc.

Here is the original cover email for the patches:

: On Tue, Sep 07, 2010 at 04:42:13PM +0800, Herbert Xu wrote:
: > 
: > This is what I am proposing for the Crypto API user-interface.
: > 
: > Note that this is the interface for operations.  There will be
: > a separate interface (most likely netlink) for configuring crypto
: > algorithms, e.g., picking a specific AES implementation as the
: > system default.
:
: OK I've gone ahead and implemented the user-space API for hashes
: and ciphers.
:
: To recap this interface is designed to allow user-space programs
: to access hardware cryptographic accelerators that we have added
: to the kernel.
:
: The intended usage scenario is where a large amount of data needs
: to be processed where the benefits offered by hardware acceleration
: that is normally unavailable in user-space (as opposed to ones
: such as the Intel AES instruction which may be used directly from
: user-space) outweigh the overhead of going through the kernel.
:
: In order to further minimise the overhead in these cases, this
: interface offers the option of avoiding copying data between
: user-space and the kernel where possible and appropriate.  For
: ciphers this means the use of the splice(2) interface instead of
: sendmsg(2)
:
: Here is a sample hash program (note that these only illustrate
: what the interface looks like and are not meant to be good examples
: of coding :)
:
: int main(void)
: {
: 	int opfd;
: 	int tfmfd;
: 	struct sockaddr_alg sa = {
: 		.salg_family = AF_ALG,
: 		.salg_type = "hash",
: 		.salg_name = "sha1"
: 	};
: 	char buf[20];
: 	int i;
:
: 	tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
:
: 	bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));
:
: 	opfd = accept(tfmfd, NULL, 0);
:
: 	write(opfd, "abc", 3);
: 	read(opfd, buf, 20);
:
: 	for (i = 0; i < 20; i++) {
: 		printf("%02x", (unsigned char)buf[i]);
: 	}
: 	printf("\n");
:
: 	close(opfd);
: 	close(tfmfd);
:
: 	return 0;
: }
:
: And here is one for ciphers:
:
: int main(void)
: {
: 	int opfd;
: 	int tfmfd;
: 	struct sockaddr_alg sa = {
: 		.salg_family = AF_ALG,
: 		.salg_type = "skcipher",
: 		.salg_name = "cbc(aes)"
: 	};
: 	struct msghdr msg = {};
: 	struct cmsghdr *cmsg;
: 	char cbuf[CMSG_SPACE(4) + CMSG_SPACE(20)];
: 	char buf[16];
: 	struct af_alg_iv *iv;
: 	struct iovec iov;
: 	int i;
:
: 	tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
:
: 	bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));
:
: 	setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY,
: 		   "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
: 		   "\x51\x2e\x03\xd5\x34\x12\x00\x06", 16);
:
: 	opfd = accept(tfmfd, NULL, 0);
:
: 	msg.msg_control = cbuf;
: 	msg.msg_controllen = sizeof(cbuf);
:
: 	cmsg = CMSG_FIRSTHDR(&msg);
: 	cmsg->cmsg_level = SOL_ALG;
: 	cmsg->cmsg_type = ALG_SET_OP;
: 	cmsg->cmsg_len = CMSG_LEN(4);
: 	*(__u32 *)CMSG_DATA(cmsg) = ALG_OP_ENCRYPT;
:
: 	cmsg = CMSG_NXTHDR(&msg, cmsg);
: 	cmsg->cmsg_level = SOL_ALG;
: 	cmsg->cmsg_type = ALG_SET_IV;
: 	cmsg->cmsg_len = CMSG_LEN(20);
: 	iv = (void *)CMSG_DATA(cmsg);
: 	iv->ivlen = 16;
: 	memcpy(iv->iv, "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
: 		       "\xb4\x22\xda\x80\x2c\x9f\xac\x41", 16);
:
: 	iov.iov_base = "Single block msg";
: 	iov.iov_len = 16;
:
: 	msg.msg_iov = &iov;
: 	msg.msg_iovlen = 1;
:
: 	sendmsg(opfd, &msg, 0);
: 	read(opfd, buf, 16);
:
: 	for (i = 0; i < 16; i++) {
: 		printf("%02x", (unsigned char)buf[i]);
: 	}
: 	printf("\n");
:
: 	close(opfd);
: 	close(tfmfd);
:
: 	return 0;
: }

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
