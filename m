Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab0IZLx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 07:53:58 -0400
Received: from fly.osdn.org.ua ([212.40.45.6]:35350 "EHLO fly.osdn.org.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab0IZLx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 07:53:57 -0400
Date: Sun, 26 Sep 2010 14:53:54 +0300
From: Michael Shigorin <mike@osdn.org.ua>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
        Alexander Chumachenko <ledest@gmail.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: fs hang in 2.6.27.y | Fwd: [Bug 15658] New: [PATCH] x86 constant_test_bit() prone to misoptimization with gcc-4.4
Message-ID: <20100926115354.GA30247@osdn.org.ua>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
	Alexander Chumachenko <ledest@gmail.com>,
	Glauber de Oliveira Costa <gcosta@redhat.com>
References: <20100827213629.GA11342@osdn.org.ua> <20100923165022.6982ffc1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20100923165022.6982ffc1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 23, 2010 at 04:50:22PM -0700, Andrew Morton wrote:
> Working around a gcc-4.4 bug is a good thing, and the patch cleans the
> code up anyway - is there a reason for casting away the `volatile const'?

It turned out that I translated the original assumption of _gcc_
fault (from our bugzilla) when the latter conclusion was that it
was correctly optimizing the code given that addr wasn't marked
as volatile.  My fault, sorry; fixed the commit comment this time.

> I changed the patch cosmetics a bit, see below.
> We don't have a Signed-off-by: for this patch - it would be
> good to have one, please.  We should at least have yours, as
> you sent the patch.

The simplicity of adding that somewhat went over my head --
please find attached the corrected original patch against HEAD
with Signed-off-by: for both of us.  led@ didn't change cosmetics
-- thanks for providing it anyways.

> Also, we prefer to have real names in kernel commits.
> Does "Led" refer to Alexander Chumachenko?

(just in case) Yes.

--=20
 ---- WBR, Michael Shigorin <mike@altlinux.ru>
  ------ Linux.Kiev http://www.linux.kiev.ua/

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-avoid-constant_test_bit-misoptimization-due-to-c.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 70e6a20b3720e522633f4b791f2f35e817d7ced3 Mon Sep 17 00:00:00 2001
From: Led <ledest@gmail.com>
Date: Thu, 1 Apr 2010 15:34:52 +0300
Subject: [PATCH] x86: avoid 'constant_test_bit()' misoptimization due to ca=
st to non-volatile

While debugging bit_spin_lock() hang, it was tracked down to gcc-4.4
misoptimization of non-inlined constant_test_bit() due to non-volatile
addr when 'const volatile unsigned long *addr' cast to 'unsigned long *'
with subsequent unconditional jump to pause (and not to the test) leading
to hang.

Compiling with gcc-4.3 or disabling CONFIG_OPTIMIZE_INLINING yields inlined
constant_test_bit() and correct jump, thus working around the kernel bug.

Other arches than asm-x86 may implement this slightly differently;
2.6.29 mitigates the misoptimization by changing the function prototype
(commit c4295fbb6048d85f0b41c5ced5cbf63f6811c46c) but probably fixing the i=
ssue
itself is better.

Signed-off-by: Alexander Chumachenko <ledest@gmail.com>
Signed-off-by: Michael Shigorin <mike@osdn.org.ua>

---
 arch/x86/include/asm/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 545776e..bafd80d 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -309,7 +309,7 @@ static inline int test_and_change_bit(int nr, volatile =
unsigned long *addr)
 static __always_inline int constant_test_bit(unsigned int nr, const volati=
le unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) !=3D 0;
+		(addr[nr / BITS_PER_LONG])) !=3D 0;
 }
=20
 static inline int variable_test_bit(int nr, volatile const unsigned long *=
addr)
--=20
1.7.2.3


--7JfCtLOvnd9MIVvH--

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMnzRRbsPDprYMm3IRArCWAJ9lTjMNStIvFxc3rfVDWIRsJJXdCACg2vi9
W6FjdO208LgTPZEgtBsggdg=
=/YG2
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
