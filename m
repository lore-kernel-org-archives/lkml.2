Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2BYRjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 12:39:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2BYRja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 12:39:30 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=7mslLBvIq8MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=1n9kS7eAD8_eBuvvWhYA:9 a=PCdImurjUaFoyj6AyX0A:7 a=QEXdDO2ut3YA:10 a=n9GBPR9yFnkA:10 a=jeBq3FmKZ4MA:10 a=pA-VWmongMjqPXmP4tAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120225173928.251798134@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 25 Feb 2012 12:35:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 1/2] x86-64: Fix CFI annotations for NMI nesting code
References: <20120225173548.977089274@goodmis.org>
Content-Disposition: inline; filename=0001-x86-64-Fix-CFI-annotations-for-NMI-nesting-code.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jan Beulich <JBeulich@suse.com>

The saving and restoring of %rdx wasn't annotated at all, and the
jumping over sections where state gets partly restored wasn't handled
either.

Further, by folding the pushing of the previous frame in repeat_nmi
into that which so far was immediately preceding restart_nmi (after
moving the restore of %rdx ahead of that, since it doesn't get used
anymore when pushing prior frames), annotations of the replicated
frame creations can be made consistent too.

v2: Fully fold repeat_nmi into the normal code flow (adding a single
    redundant instruction to the "normal" code path), thus retaining
    the special protection of all instructions between repeat_nmi and
    end_repeat_nmi.

Link: http://lkml.kernel.org/r/4F478B630200007800074A31@nat28.tlf.novell.com

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   52 +++++++++++++++++++++++-----------------=
---
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1333d98..e0eca00 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1530,6 +1530,7 @@ ENTRY(nmi)
=20
 	/* Use %rdx as out temp variable throughout */
 	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
=20
 	/*
 	 * If %cs was not the kernel segment, then the NMI triggered in user
@@ -1554,6 +1555,7 @@ ENTRY(nmi)
 	 */
 	lea 6*8(%rsp), %rdx
 	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+	CFI_REMEMBER_STATE
=20
 nested_nmi:
 	/*
@@ -1585,10 +1587,12 @@ nested_nmi:
=20
 nested_nmi_out:
 	popq_cfi %rdx
+	CFI_RESTORE rdx
=20
 	/* No need to check faults here */
 	INTERRUPT_RETURN
=20
+	CFI_RESTORE_STATE
 first_nmi:
 	/*
 	 * Because nested NMIs will use the pushed location that we
@@ -1624,6 +1628,10 @@ first_nmi:
 	 * NMI may zero out. The original stack frame and the temp storage
 	 * is also used by nested NMIs and can not be trusted on exit.
 	 */
+	/* Do not pop rdx, nested NMIs will corrupt it */
+	movq (%rsp), %rdx
+	CFI_RESTORE rdx
+
 	/* Set the NMI executing variable on the stack. */
 	pushq_cfi $1
=20
@@ -1631,14 +1639,31 @@ first_nmi:
 	.rept 5
 	pushq_cfi 6*8(%rsp)
 	.endr
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+
+	/*
+	 * If there was a nested NMI, the first NMI's iret will return
+	 * here. But NMIs are still enabled and we can take another
+	 * nested NMI. The nested NMI checks the interrupted RIP to see
+	 * if it is between repeat_nmi and end_repeat_nmi, and if so
+	 * it will just return, as we are about to repeat an NMI anyway.
+	 * This makes it safe to copy to the stack frame that a nested
+	 * NMI will update.
+	 */
+repeat_nmi:
+	/*
+	 * Update the stack variable to say we are still in NMI (the update
+	 * is benign for the non-repeat case, where 1 was pushed just above
+	 * to this very stack slot).
+	 */
+	movq $1, 5*8(%rsp)
=20
 	/* Make another copy, this one may be modified by nested NMIs */
 	.rept 5
 	pushq_cfi 4*8(%rsp)
 	.endr
-
-	/* Do not pop rdx, nested NMIs will corrupt it */
-	movq 11*8(%rsp), %rdx
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+end_repeat_nmi:
=20
 	/*
 	 * Everything below this point can be preempted by a nested
@@ -1646,7 +1671,6 @@ first_nmi:
 	 * caused by an exception and nested NMI will start here, and
 	 * can still be preempted by another NMI.
 	 */
-restart_nmi:
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1675,26 +1699,6 @@ nmi_restore:
 	CFI_ENDPROC
 END(nmi)
=20
-	/*
-	 * If an NMI hit an iret because of an exception or breakpoint,
-	 * it can lose its NMI context, and a nested NMI may come in.
-	 * In that case, the nested NMI will change the preempted NMI's
-	 * stack to jump to here when it does the final iret.
-	 */
-repeat_nmi:
-	INTR_FRAME
-	/* Update the stack variable to say we are still in NMI */
-	movq $1, 5*8(%rsp)
-
-	/* copy the saved stack back to copy stack */
-	.rept 5
-	pushq_cfi 4*8(%rsp)
-	.endr
-
-	jmp restart_nmi
-	CFI_ENDPROC
-end_repeat_nmi:
-
 ENTRY(ignore_sysret)
 	CFI_STARTPROC
 	mov $-ENOSYS,%eax
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPSRzQAAoJEIy3vGnGbaoA6H4P/1zUfqarXtZR3K0AyuaV29aP
QRvJdRLbbc8RkXLAuyjN/KtDPMNHqm09UAEfjJ2Gko+pEl0etsSnYPSlc0UF+eUS
I1vOUsi0dClUMG/p+U0ivootyLiN9Supatn1B0m5vL2JbGjwGtfgqF1TugUvtVtb
KJgwU0cZg5PN5KniZpWFYqIH6I+J6VImYQ+sI+8YaSH99hzfmaqZsD34tczMuahj
q7T31xh8rDIqJV2jNQHkvY3+By+UW/lbW0Fu/+58VtSFeUm/OtV6PnLszUhQdPzc
ODrCRzMyXRUifRqkzmtnR+hAdIyJuDzgNAN7WhZ4Fa7bd7QV2fEW80FKtcsYckx4
4GzVGEhKY6nDue9YrrAm7S1ZTAadYcA+sC6X0CJneUzMiQdxWrogKhBfNs5wIV4w
Eyw7Qd7cnImQ/y5bJBqSjiP/ave4Ev8oIXkwwZWc3h4qiz7eMLO+BhCAUncmjBTi
3eUv/IJb97nvsSXRMfjGM9MTHOn64S7CbcrU0yzFZJVTT0jFL2ZsmqazGezMFk0c
HhbKaMyjNifmvNt83aoZ4Ra7kE+WrnH3W1RzmQNlADE4oeBIqcvqdOJlaVCMzXdJ
l5bNkpQ8gzNMesJzaeSR4AMlsEIM00cKLjUNhEXJq8VbEKyhao30+KoV+3qmjNCr
vhfIhkFBg4lb7nRnkoqV
=7ebO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
