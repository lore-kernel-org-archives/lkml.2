Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab2CMFxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:53:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56515 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab2CMFwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:52:37 -0400
Date: Tue, 13 Mar 2012 16:52:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the uprobes tree with the tip tree
Message-Id: <20120313165235.506cbc4ab729bba3314ce9bb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_16_52_35_+1100_IIXJGsUbnGP09QJj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_16_52_35_+1100_IIXJGsUbnGP09QJj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

Today's linux-next merge of the uprobes tree got a conflict in
arch/x86/include/asm/compat.h between commits fca460f95e92 ("x32: Handle
the x32 system call flag") and a628b684d27d ("x32: Provide separate
is_ia32_task() and is_x32_task() predicates") from the tip tree and
commit 1e1e2cddc33d ("x86/trivial: use is_ia32_compat_task") from the
uprobes tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/compat.h
index 355edc0,a6ba59d..0000000
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@@ -223,39 -214,15 +229,41 @@@ static inline compat_uptr_t ptr_to_comp
 =20
  static inline void __user *arch_compat_alloc_user_space(long len)
  {
 -	struct pt_regs *regs =3D task_pt_regs(current);
 -	return (void __user *)regs->sp - len;
 +	compat_uptr_t sp;
 +
 +	if (test_thread_flag(TIF_IA32)) {
 +		sp =3D task_pt_regs(current)->sp;
 +	} else {
 +		/* -128 for the x32 ABI redzone */
 +		sp =3D percpu_read(old_rsp) - 128;
 +	}
 +
 +	return (void __user *)round_down(sp - len, 16);
 +}
 +
 +static inline bool is_ia32_task(void)
 +{
 +#ifdef CONFIG_IA32_EMULATION
 +	if (current_thread_info()->status & TS_COMPAT)
 +		return true;
 +#endif
 +	return false;
 +}
 +
 +static inline bool is_x32_task(void)
 +{
 +#ifdef CONFIG_X86_X32_ABI
 +	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
 +		return true;
 +#endif
 +	return false;
  }
 =20
+ #undef is_compat_task
+=20
 -static inline int is_compat_task(void)
 +static inline bool is_compat_task(void)
  {
 -	return current_thread_info()->status & TS_COMPAT;
 +	return is_ia32_task() || is_x32_task();
  }
 =20
  #endif /* _ASM_X86_COMPAT_H */

--Signature=_Tue__13_Mar_2012_16_52_35_+1100_IIXJGsUbnGP09QJj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXuCjAAoJEECxmPOUX5FE070P/15Z2yLvaFXKzGMz4fgu9you
lEh+IB563bWB+zgwVid2Nt6QDpeP9yRmFAp/Pann9ofqeUio0Q6FAyZOXhKEfjYe
zPXgJB/NYRCHcqpu1aG1NK5uMWBYRbPbDbGJAEPKKir2xZ2Jxa+hV8upmKPBvlAv
lkxldbN3WEKkLG5/8a+i5EZ6OQnXNyJbZLdfGxRajfIFJUiwtpHrzOJ2aDAqsBTy
/uBjONqiLftDwv7AYUMJpj831AK+XVUuO/0Xb4DUU1YtTVQByTYiC1PNxqNtmoJI
FvI+FQnbDeXU+QPP6Kq5igO1YYxJXNwh1JGrpe+qfYhQcH6cGQmbFkgdhlW6Nk7+
TNkHOdDJvkS6p8DJ39PEr5ki1Rb5PnSwghzoDbxpq3W4VKDcppmn8v1mSgXexBDe
KxQYf4lqCYnOqMfMS+B07OQrPop0Por+QfhZB5jCALEaKsjfMtSyYtXftcf8EmIu
hbNWJmQ/BUkBmaZtU1n10P7pleFV3RSAEKDh7jODi8jKdRcZyaxMNaosXbsIOunM
9QQg7NVccXXVpsD07l+wRlisB+K8nUyrNE/PRNGBUWHm+gv7WYPUcD1+fHTsIENN
zGsGy6qrnGpFwDUlT6bvuOCRyIAdeNx8Yfrtnvporu8DitS8hN821g49gSeW1UVP
YYjgAYmyEyDoUSwW5wcl
=WyvE
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_16_52_35_+1100_IIXJGsUbnGP09QJj--
