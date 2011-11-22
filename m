Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1KVQ4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:56:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1KVQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:55:58 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=XCKjd2TsB517HzVXXugA:9 a=x2m7NYzP_0CyPK1U_h0A:7 a=QEXdDO2ut3YA:10 a=Ons5hyaRCJgMImtUx0IA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [ANNOUNCE] 3.0.9-rt26
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>, Carsten Emde <C.Emde@osadl.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AwhaUjzuZye9gvRK9Kmd"
Date: Tue, 22 Nov 2011 11:55:54 -0500
Message-ID: <1321980954.20742.38.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AwhaUjzuZye9gvRK9Kmd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm please to announce the 3.0.9-rt26 stable release.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 54b64aeec82d0079a8a469f4dca8fc5f8b5b8e1b


Or to build 3.0.9-rt26 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.9.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.9-rt26.p=
atch.xz


You can also build from 3.0.9-rt25 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.9-r=
t25-rt26.patch.xz


The broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.9-rt26=
.tar.xz

Enjoy,

-- Steve

Changes from 3.0.9-rt25:

---

John Kacur (2):
      softirq: Export in_serving_softirq()
      rcu: Fix macro substitution for synchronize_rcu_bh() on RT

Peter Zijlstra (1):
      x86: crypto: Reduce preempt disabled regions

Steven Rostedt (2):
      tracing: Show padding as unsigned short
      Linux 3.0.9-rt26

Thomas Gleixner (1):
      dm: Make rt aware

----
 arch/x86/crypto/aesni-intel_glue.c |   24 +++++++++++++-----------
 drivers/md/dm.c                    |    4 ++--
 include/linux/rcutree.h            |    2 +-
 kernel/softirq.c                   |    1 +
 kernel/trace/trace_events.c        |    2 +-
 localversion-rt                    |    2 +-
 6 files changed, 19 insertions(+), 16 deletions(-)
---------------------------
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-int=
el_glue.c
index feee8ff..81ec77c 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -288,14 +288,14 @@ static int ecb_encrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
+				nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -312,14 +312,14 @@ static int ecb_decrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -358,14 +358,14 @@ static int cbc_encrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -382,14 +382,14 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt(desc, &walk);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
@@ -444,18 +444,20 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 	err =3D blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
 	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	kernel_fpu_begin();
 	while ((nbytes =3D walk.nbytes) >=3D AES_BLOCK_SIZE) {
+		kernel_fpu_begin();
 		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &=3D AES_BLOCK_SIZE - 1;
 		err =3D blkcipher_walk_done(desc, &walk, nbytes);
 	}
 	if (walk.nbytes) {
+		kernel_fpu_begin();
 		ctr_crypt_final(ctx, &walk);
+		kernel_fpu_end();
 		err =3D blkcipher_walk_done(desc, &walk, 0);
 	}
-	kernel_fpu_end();
=20
 	return err;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 41abc6d..67207d6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1644,14 +1644,14 @@ static void dm_request_fn(struct request_queue *q)
 		if (map_request(ti, clone, md))
 			goto requeued;
=20
-		BUG_ON(!irqs_disabled());
+		BUG_ON_NONRT(!irqs_disabled());
 		spin_lock(q->queue_lock);
 	}
=20
 	goto out;
=20
 requeued:
-	BUG_ON(!irqs_disabled());
+	BUG_ON_NONRT(!irqs_disabled());
 	spin_lock(q->queue_lock);
=20
 delay_and_out:
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 7a25aea..3bf47dc 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -60,7 +60,7 @@ static inline void exit_rcu(void)
 #ifndef CONFIG_PREEMPT_RT_FULL
 extern void synchronize_rcu_bh(void);
 #else
-# define synchronize_rcu_bh()	synchronize_rcu()
+# define synchronize_rcu_bh	synchronize_rcu
 #endif
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index e8756aa..026a283 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -447,6 +447,7 @@ int in_serving_softirq(void)
 	preempt_enable();
 	return res;
 }
+EXPORT_SYMBOL(in_serving_softirq);
=20
 /*
  * Called with bh and local interrupts disabled. For full RT cpu must
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 37d3ffb..c71844c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -117,7 +117,7 @@ static int trace_define_common_fields(void)
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
 	__common_field(unsigned short, migrate_disable);
-	__common_field(int, padding);
+	__common_field(unsigned short, padding);
=20
 	return ret;
 }
diff --git a/localversion-rt b/localversion-rt
index c5b71f9..2e9afd4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26


--=-AwhaUjzuZye9gvRK9Kmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOy9QWAAoJEIy3vGnGbaoAAUQP/3DK72KW8fNCvyDoQFwIvYbQ
5Z4agCUOfyfYyvy2gc4XnNS9rYGK+j3rqnZQbOQUaFwOpSc5ZJtaUj0pUJjuklvC
+B2JORFRDEfIqSRI/ZPf2pw+9PW8rCGsq2s+3+6F593CTTVbk8j6uCck5pTBZgry
K1YkWhq7e4GMwFnbsj6v1F2ndI4RiqerVAmCuJAFqgT0NvARisbodCoOGeDZt/cv
2npnA3BNXEk6Y6dJ3tNfqtfmvBcFsAbOCbzz2DUOf3WT0FI9BfIrhfmYebtppkrn
u3t6M1zbo9ZTf+i/UbkFesPgIYEwopqJKrkF6l13jGGAZB9DYkW/6DOrxG36tewm
flt0mWgHZUWjpnAz4OHEBKkWr/ErJuIZ4odu2f0zRhr46hpPTJfZBbnOFQFQa+4L
Y6jDhiJrAEchoO4+WFsNI1VLEnWTM31VfoO3td+er9Ap0i2Oq9tcBor1hC95kgdX
OThYXQ5VTkJRyTcZezDjFleQN7CMQbAULu/5llmzKrE7G4CoH4wAGOuni2Lp8xQ1
k0tte65o4eJRcvxhLWxiwaEWnscep6j4sTrLHXEFtaRht73uzIND6vLu/5dN2xHQ
DfEoY7GUtyvRd9pln89foqGyZmuYUayAQrz9pqtbPWw2GoikiBzbHJIZtuT9xSZU
BiM8J+FrwChPlOKxLR/O
=tAH9
-----END PGP SIGNATURE-----

--=-AwhaUjzuZye9gvRK9Kmd--

