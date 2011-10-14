Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1JNOzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:55:07 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:50409 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754904Ab1JNOzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:55:05 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: ghash: Avoid null pointer dereference if no key is set.
Date: Fri, 14 Oct 2011 10:37:20 -0400
Message-Id: <1318603040-1360-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ghash_update function passes a pointer to gf128mul_4k_lle which will
be NULL if ghash_setkey is not called or if the most recent call to
ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
up by returning an error code in the null case.

This is trivially triggered from unpriviliged userspace through the
AF_ALG interface by simply writing to the socket without setting a key.

  BUG: unable to handle kernel NULL pointer dereference at 00000670
  IP: [<d88c92d4>] gf128mul_4k_lle+0x23/0x60 [gf128mul]
  *pde = 00000000
  Oops: 0000 [#1] PREEMPT SMP
  Modules linked in: ghash_generic gf128mul algif_hash af_alg nfs lockd nfs_acl sunrpc bridge ipv6 stp llc

  Pid: 1502, comm: hashatron Tainted: G        W   3.1.0-rc9-00085-ge9308cf #32 Bochs Bochs
  EIP: 0060:[<d88c92d4>] EFLAGS: 00000202 CPU: 0
  EIP is at gf128mul_4k_lle+0x23/0x60 [gf128mul]
  EAX: d69db1f0 EBX: d6b8ddac ECX: 00000004 EDX: 00000000
  ESI: 00000670 EDI: d6b8ddac EBP: d6b8ddc8 ESP: d6b8dda4
   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
  Process hashatron (pid: 1502, ti=d6b8c000 task=d6810000 task.ti=d6b8c000)
  Stack:
   00000000 d69db1f0 00000163 00000000 d6b8ddc8 c101a520 d69db1f0 d52aa000
   00000ff0 d6b8dde8 d88d310f d6b8a3f8 d52aa000 00001000 d88d502c d6b8ddfc
   00001000 d6b8ddf4 c11676ed d69db1e8 d6b8de24 c11679ad d52aa000 00000000
  Call Trace:
   [<c101a520>] ? kmap_atomic_prot+0x37/0xa6
   [<d88d310f>] ghash_update+0x85/0xbe [ghash_generic]
   [<c11676ed>] crypto_shash_update+0x18/0x1b
   [<c11679ad>] shash_ahash_update+0x22/0x36
   [<c11679cc>] shash_async_update+0xb/0xd
   [<d88ce0ba>] hash_sendpage+0xba/0xf2 [algif_hash]
   [<c121b24c>] kernel_sendpage+0x39/0x4e
   [<d88ce000>] ? 0xd88cdfff
   [<c121b298>] sock_sendpage+0x37/0x3e
   [<c121b261>] ? kernel_sendpage+0x4e/0x4e
   [<c10b4dbc>] pipe_to_sendpage+0x56/0x61
   [<c10b4e1f>] splice_from_pipe_feed+0x58/0xcd
   [<c10b4d66>] ? splice_from_pipe_begin+0x10/0x10
   [<c10b51f5>] __splice_from_pipe+0x36/0x55
   [<c10b4d66>] ? splice_from_pipe_begin+0x10/0x10
   [<c10b6383>] splice_from_pipe+0x51/0x64
   [<c10b63c2>] ? default_file_splice_write+0x2c/0x2c
   [<c10b63d5>] generic_splice_sendpage+0x13/0x15
   [<c10b4d66>] ? splice_from_pipe_begin+0x10/0x10
   [<c10b527f>] do_splice_from+0x5d/0x67
   [<c10b6865>] sys_splice+0x2bf/0x363
   [<c129373b>] ? sysenter_exit+0xf/0x16
   [<c104dc1e>] ? trace_hardirqs_on_caller+0x10e/0x13f
   [<c129370c>] sysenter_do_call+0x12/0x32
  Code: 83 c4 0c 5b 5e 5f c9 c3 55 b9 04 00 00 00 89 e5 57 8d 7d e4 56 53 8d 5d e4 83 ec 18 89 45 e0 89 55 dc 0f b6 70 0f c1 e6 04 01 d6 <f3> a5 be 0f 00 00 00 4e 89 d8 e8 48 ff ff ff 8b 45 e0 89 da 0f
  EIP: [<d88c92d4>] gf128mul_4k_lle+0x23/0x60 [gf128mul] SS:ESP 0068:d6b8dda4
  CR2: 0000000000000670
  ---[ end trace 4eaa2a86a8e2da24 ]---
  note: hashatron[1502] exited with preempt_count 1
  BUG: scheduling while atomic: hashatron/1502/0x10000002
  INFO: lockdep is turned off.
  [...]

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 crypto/ghash-generic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

I checked all the other keyed hashes in crypto/ that I could see, and
none of them crash when run without a key.  However, they all produce
(presumably bogus) output in this case, so it may be prudent to make
them return an error, too, for consistency.  Alternately, we could try
to modify ghash so that it behaves like the other keyed hashes (and
doesn't crash) when no key is set.

I haven't had a chance to look for issues in any ciphers yet, or in
other hash modes.

diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index be44256..ef398ab 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -67,6 +67,9 @@ static int ghash_update(struct shash_desc *desc,
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *dst = dctx->buffer;
 
+	if (!ctx->gf128)
+		return -ENOKEY;
+
 	if (dctx->bytes) {
 		int n = min(srclen, dctx->bytes);
 		u8 *pos = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
-- 
1.7.3.4

