Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab2DPFqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:46:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55075 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2DPFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:46:17 -0400
Date: Mon, 16 Apr 2012 15:46:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: linux-next: build failure after merge of the final tree (security
 tree related)
Message-Id: <20120416154607.302f7ae245472e1e917dacef@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_15_46_07_+1000_WQqOeLFStaGEdfqD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_15_46_07_+1000_WQqOeLFStaGEdfqD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect [-Werr=
or=3Dunused-value]
cc1: all warnings being treated as errors

Introduced by commit acf3b2c71ed2 ("seccomp: add SECCOMP_RET_ERRNO").  I
have applied the following hack fix that fixes the build, but the other
seven call sites of secure_computing() should be fixed up properly.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 16 Apr 2012 15:39:49 +1000
Subject: [PATCH] seccomp: hack fix for build failures with secure_computing
 return value change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/microblaze/kernel/ptrace.c |    2 +-
 arch/mips/kernel/ptrace.c       |    2 +-
 arch/powerpc/kernel/ptrace.c    |    2 +-
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/sh/kernel/ptrace_32.c      |    2 +-
 arch/sh/kernel/ptrace_64.c      |    2 +-
 arch/sparc/kernel/ptrace_64.c   |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrac=
e.c
index 6eb2aa9..9e3ffc9 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -136,7 +136,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *=
regs)
 {
 	long ret =3D 0;
=20
-	secure_computing(regs->r12);
+	(void)secure_computing(regs->r12);
=20
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 7c24c29..4f83d73 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -535,7 +535,7 @@ static inline int audit_arch(void)
 asmlinkage void syscall_trace_enter(struct pt_regs *regs)
 {
 	/* do the secure computing check first */
-	secure_computing(regs->regs[2]);
+	(void)secure_computing(regs->regs[2]);
=20
 	if (!(current->ptrace & PT_PTRACED))
 		goto out;
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 8d8e028..53cebc4 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1710,7 +1710,7 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret =3D 0;
=20
-	secure_computing(regs->gpr[0]);
+	(void)secure_computing(regs->gpr[0]);
=20
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 02f300f..96e0dea 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -719,7 +719,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *=
regs)
 	long ret =3D 0;
=20
 	/* Do the secure computing check first. */
-	secure_computing(regs->gprs[2]);
+	(void)secure_computing(regs->gprs[2]);
=20
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 9698671..cf55945 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -503,7 +503,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *=
regs)
 {
 	long ret =3D 0;
=20
-	secure_computing(regs->regs[0]);
+	(void)secure_computing(regs->regs[0]);
=20
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index bc81e07..3d3600f 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -522,7 +522,7 @@ asmlinkage long long do_syscall_trace_enter(struct pt_r=
egs *regs)
 {
 	long long ret =3D 0;
=20
-	secure_computing(regs->regs[9]);
+	(void)secure_computing(regs->regs[9]);
=20
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 6f97c07..6ddec1f 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -1062,7 +1062,7 @@ asmlinkage int syscall_trace_enter(struct pt_regs *re=
gs)
 	int ret =3D 0;
=20
 	/* do the secure computing check first */
-	secure_computing(regs->u_regs[UREG_G1]);
+	(void)secure_computing(regs->u_regs[UREG_G1]);
=20
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ret =3D tracehook_report_syscall_entry(regs);
--=20
1.7.10.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Apr_2012_15_46_07_+1000_WQqOeLFStaGEdfqD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi7IfAAoJEECxmPOUX5FEVeMP/1LstePWxJizbSKF2HFfVOKO
iUAtaM7SjlLjyxjq/aaAQm/waD+JniEFLuSaIB6JLOSuxMlQS9Zqbg7NZwu7C5ew
wMG+sYW7NZ/UO+F+pm6p3I8ZQMZEEX/pbvmeGaoQJqB0MKMBSsCeJTeGNCobVXwv
5dza0SyrBfymETfpU+FJZ5JCIyYKnLgkMEV8a6crzk8AbRiR7OiHayn2X0foQfXc
ypIi2i+94jb7K9rpcJ1c4Bwz/FtqQGHKPGwEbPR58fhctXNpqcRW1qSbwhsGE4bU
kvO9GIbzV3jP8n7QbThzy/EmF3vg5MwvizWZ93L1I2rdkZhotYgSEQQMmEqQ4l34
ACSU2itbuZBFxMUB6j3Srimqw/8+p88aqeNvqgaUpJsojNK7SmeBZdhan/AZLHFt
tGq3xNPOqtUazM/Kfhi313UcMDWlE74v+7AxE7xLKJ43zydpS8yDrdV9d8zMXfyV
ty0/rR+zd0okr9HPGCmasu9Cn6AdvsD9SqKZIKylsxVZXwnAW69PBchZJHRESfze
mR05WugseoUDjvyXpf1tveTQX6zz5e7wcgeXoutdIWZdgFC6smNC/PQmGKjqbrDe
gqNVxARPaIluR7fEJGx2JnCIili5xPHlbiEm/CsP+3bgg/gOi7E3ZfS7MJFdMXs/
XRurHkGhXds5qv6hMz1X
=y4S1
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_15_46_07_+1000_WQqOeLFStaGEdfqD--
