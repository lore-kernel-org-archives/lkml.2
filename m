Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0KDVim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:38:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26931 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0KDVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:38:38 -0400
Date: Thu, 4 Nov 2010 22:27:42 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH] pohmelfs: remove unneeded conditionals before calls to
 crypto_destroy_tfm wrappers.
Message-ID: <alpine.LNX.2.00.1011042212460.15856@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

crypto_free_hash() and crypto_free_ablkcipher() are just wrappers around 
crypto_free_tfm() which is itself just a wrapper around 
crypto_destroy_tfm().
Passing crypto_destroy_tfm() a NULL pointer is valid, so there's no reason 
to check for NULL first.

Removing the unneeded conditionals (which is what the patch does) brings 
us the benefit of having to execute a few fewer test/branch instructions 
and also reduces object code size slightly:

before:
   text    data     bss     dec     hex filename
   8630     112    3312   12054    2f16 drivers/staging/pohmelfs/crypto.o

0000000000000cbe <pohmelfs_crypto_engine_exit>:
     cbe:       55                      push   %rbp
     cbf:       48 89 e5                mov    %rsp,%rbp
     cc2:       53                      push   %rbx
     cc3:       48 83 ec 08             sub    $0x8,%rsp
     cc7:       e8 00 00 00 00          callq  ccc <pohmelfs_crypto_engine_exit+0xe>
     ccc:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # cd3 <pohmelfs_crypto_engine_exit+0x15>
     cd3:       48 89 fb                mov    %rdi,%rbx
     cd6:       48 8b 7f 20             mov    0x20(%rdi),%rdi
     cda:       48 85 ff                test   %rdi,%rdi
     cdd:       74 0c                   je     ceb <pohmelfs_crypto_engine_exit+0x2d>
     cdf:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # ce6 <pohmelfs_crypto_engine_exit+0x28>
     ce6:       e8 58 fa ff ff          callq  743 <crypto_free_hash>
     ceb:       48 8b 7b 28             mov    0x28(%rbx),%rdi
     cef:       48 85 ff                test   %rdi,%rdi
     cf2:       75 09                   jne    cfd <pohmelfs_crypto_engine_exit+0x3f>
     cf4:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # cfb <pohmelfs_crypto_engine_exit+0x3d>
     cfb:       eb 16                   jmp    d13 <pohmelfs_crypto_engine_exit+0x55>
     cfd:       48 89 fe                mov    %rdi,%rsi
     d00:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # d07 <pohmelfs_crypto_engine_exit+0x49>
     d07:       e8 00 00 00 00          callq  d0c <pohmelfs_crypto_engine_exit+0x4e>
     d0c:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # d13 <pohmelfs_crypto_engine_exit+0x55>
     d13:       48 8b 7b 18             mov    0x18(%rbx),%rdi
     d17:       e8 00 00 00 00          callq  d1c <pohmelfs_crypto_engine_exit+0x5e>
     d1c:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # d23 <pohmelfs_crypto_engine_exit+0x65>
     d23:       5e                      pop    %rsi
     d24:       5b                      pop    %rbx
     d25:       c9                      leaveq 
     d26:       c3                      retq  

after:
   text    data     bss     dec     hex filename
   8604     112    3296   12012    2eec drivers/staging/pohmelfs/crypto.o

0000000000000cbe <pohmelfs_crypto_engine_exit>:
     cbe:       55                      push   %rbp
     cbf:       48 89 e5                mov    %rsp,%rbp
     cc2:       53                      push   %rbx
     cc3:       48 83 ec 08             sub    $0x8,%rsp
     cc7:       e8 00 00 00 00          callq  ccc <pohmelfs_crypto_engine_exit+0xe>
     ccc:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # cd3 <pohmelfs_crypto_engine_exit+0x15>
     cd3:       48 89 fb                mov    %rdi,%rbx
     cd6:       48 8b 7f 20             mov    0x20(%rdi),%rdi
     cda:       e8 64 fa ff ff          callq  743 <crypto_free_hash>
     cdf:       48 8b 7b 28             mov    0x28(%rbx),%rdi
     ce3:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # cea <pohmelfs_crypto_engine_exit+0x2c>
     cea:       48 89 fe                mov    %rdi,%rsi
     ced:       e8 00 00 00 00          callq  cf2 <pohmelfs_crypto_engine_exit+0x34>
     cf2:       48 8b 7b 18             mov    0x18(%rbx),%rdi
     cf6:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # cfd <pohmelfs_crypto_engine_exit+0x3f>
     cfd:       e8 00 00 00 00          callq  d02 <pohmelfs_crypto_engine_exit+0x44>
     d02:       48 ff 05 00 00 00 00    incq   0x0(%rip)        # d09 <pohmelfs_crypto_engine_exit+0x4b>
     d09:       5e                      pop    %rsi
     d0a:       5b                      pop    %rbx
     d0b:       c9                      leaveq 
     d0c:       c3                      retq   


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 crypto.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/pohmelfs/crypto.c b/drivers/staging/pohmelfs/crypto.c
index 2fdb3e0..6540864 100644
--- a/drivers/staging/pohmelfs/crypto.c
+++ b/drivers/staging/pohmelfs/crypto.c
@@ -130,10 +130,8 @@ err_out_exit:
 
 void pohmelfs_crypto_engine_exit(struct pohmelfs_crypto_engine *e)
 {
-	if (e->hash)
-		crypto_free_hash(e->hash);
-	if (e->cipher)
-		crypto_free_ablkcipher(e->cipher);
+	crypto_free_hash(e->hash);
+	crypto_free_ablkcipher(e->cipher);
 	kfree(e->data);
 }
 



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

