Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1E2XOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:14:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56170 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1E2XNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nXTixKhdcYnj4H5nteBN4I+6n+3Ku2ZVrEfXwXXK0r2AucK+eksPY1BKDUbth5o0hZ
         tEsFac2l77fE5KeQnwbCnqCnVoR4C9fH0NOlSzDCvEWZWRtndIMe6e6CknHYf/Vj8bdz
         U/gha0+hpW+ogIbhjjiAG4KnTiXq74P4mLa9Q=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, x86@kernel.org
Subject: [PATCH 13/17] ptrace: add siginfo.si_pt_flags
Date: Mon, 30 May 2011 01:12:36 +0200
Message-Id: <1306710760-16440-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This essentially is a simple addition of a flag field but seems
complicated thanks to siginfo_t convolution.  _sigtrap struct, which
contains all the fields used by ptrace_notify[_locked]() and the new
_pt_flags, is added to siginfo._sifields union along with the field
abbreviation macro si_pt_flags; then, __SI_TRAP is defined to
implement copying of the new field to userland.

Two architectures - ia64 and mips - define their own versions of
siginfo_t and ia64 implements its own copy_siginfo_to_user().  Also,
x86, mips, parisc, powerpc, s390, sparc and tile have compat_siginfo_t
and copy_siginfo_to_user32() for 32bit compatibility.  All are updated
such that [compat_]siginfo_t have _sigtrap and all the fields are
copied out.

x86 is tested.  Affected code in mips, powerpc, s390 and sparc are
compile tested.  mips and tile are untested.

This patch doesn't actually make use of the new field.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org
---
 arch/ia64/include/asm/siginfo.h       |    7 +++++++
 arch/ia64/kernel/signal.c             |    5 +++++
 arch/mips/include/asm/compat-signal.h |    7 +++++++
 arch/mips/include/asm/siginfo.h       |    7 +++++++
 arch/mips/kernel/signal32.c           |    5 +++++
 arch/parisc/kernel/signal32.c         |    5 +++++
 arch/parisc/kernel/signal32.h         |    7 +++++++
 arch/powerpc/kernel/ppc32.h           |    7 +++++++
 arch/powerpc/kernel/signal_32.c       |    5 +++++
 arch/s390/kernel/compat_linux.h       |    7 +++++++
 arch/s390/kernel/compat_signal.c      |    5 +++++
 arch/sparc/kernel/signal32.c          |   12 ++++++++++++
 arch/tile/kernel/compat_signal.c      |   11 +++++++++++
 arch/x86/ia32/ia32_signal.c           |    4 ++++
 arch/x86/include/asm/ia32.h           |    7 +++++++
 include/asm-generic/siginfo.h         |   10 ++++++++++
 kernel/signal.c                       |    7 ++++++-
 17 files changed, 117 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/siginfo.h b/arch/ia64/include/asm/siginfo.h
index c8fcaa2..2cff1ce 100644
--- a/arch/ia64/include/asm/siginfo.h
+++ b/arch/ia64/include/asm/siginfo.h
@@ -70,6 +70,13 @@ typedef struct siginfo {
 			long _band;	/* POLL_IN, POLL_OUT, POLL_MSG (XPG requires a "long") */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			pid_t _pid;		/* sender's pid */
+			uid_t _uid;		/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 } siginfo_t;
 
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 7bdafc8..ee18366 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -142,6 +142,11 @@ copy_siginfo_to_user (siginfo_t __user *to, siginfo_t *from)
 			err |= __put_user(from->si_addr, &to->si_addr);
 			err |= __put_user(from->si_imm, &to->si_imm);
 			break;
+		      case __SI_TRAP >> 16:
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_pid, &to->si_pid);
+			err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+			break;
 		      case __SI_TIMER >> 16:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
diff --git a/arch/mips/include/asm/compat-signal.h b/arch/mips/include/asm/compat-signal.h
index 368a99e..47b2e4f 100644
--- a/arch/mips/include/asm/compat-signal.h
+++ b/arch/mips/include/asm/compat-signal.h
@@ -54,6 +54,13 @@ typedef struct compat_siginfo {
 			int _fd;
 		} _sigpoll;
 
+		/* SIGTRAP */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			compat_uid_t _uid;	/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
+
 		/* POSIX.1b timers */
 		struct {
 			timer_t _tid;		/* timer id */
diff --git a/arch/mips/include/asm/siginfo.h b/arch/mips/include/asm/siginfo.h
index 20ebeb8..6e8f0d6 100644
--- a/arch/mips/include/asm/siginfo.h
+++ b/arch/mips/include/asm/siginfo.h
@@ -96,6 +96,13 @@ typedef struct siginfo {
 			__ARCH_SI_BAND_T _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			pid_t _pid;		/* sender's pid */
+			__ARCH_SI_UID_T _uid;	/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 } siginfo_t;
 
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index aae9866..7e392e1 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -452,6 +452,11 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
+		case __SI_TRAP >> 16:
+			err |= __put_user(from->si_pid, &to->si_pid);
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+			break;
 		case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
 		case __SI_MESGQ >> 16:
 			err |= __put_user(from->si_pid, &to->si_pid);
diff --git a/arch/parisc/kernel/signal32.c b/arch/parisc/kernel/signal32.c
index e141324..ead8ca4 100644
--- a/arch/parisc/kernel/signal32.c
+++ b/arch/parisc/kernel/signal32.c
@@ -482,6 +482,11 @@ copy_siginfo_to_user32 (compat_siginfo_t __user *to, siginfo_t *from)
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
+		case __SI_TRAP >> 16:
+			err |= __put_user(from->si_pid, &to->si_pid);
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+			break;
 		case __SI_TIMER >> 16:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
diff --git a/arch/parisc/kernel/signal32.h b/arch/parisc/kernel/signal32.h
index c780084..8016f51 100644
--- a/arch/parisc/kernel/signal32.h
+++ b/arch/parisc/kernel/signal32.h
@@ -104,6 +104,13 @@ typedef struct compat_siginfo {
                         int _band;      /* POLL_IN, POLL_OUT, POLL_MSG */
                         int _fd;
                 } _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			unsigned int _pid;      /* sender's pid */
+			unsigned int _uid;      /* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
         } _sifields;
 } compat_siginfo_t;
 
diff --git a/arch/powerpc/kernel/ppc32.h b/arch/powerpc/kernel/ppc32.h
index dc16aef..4293542 100644
--- a/arch/powerpc/kernel/ppc32.h
+++ b/arch/powerpc/kernel/ppc32.h
@@ -64,6 +64,13 @@ typedef struct compat_siginfo {
 			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			compat_uid_t _uid;		/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 } compat_siginfo_t;
 
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index b96a3a0..d072458 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -716,6 +716,11 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *d, siginfo_t *s)
 		err |= __put_user(s->si_band, &d->si_band);
 		err |= __put_user(s->si_fd, &d->si_fd);
 		break;
+	case __SI_TRAP:
+		err |= __put_user(s->si_pid, &d->si_pid);
+		err |= __put_user(s->si_uid, &d->si_uid);
+		err |= __put_user(s->si_pt_flags, &d->si_pt_flags);
+		break;
 	case __SI_TIMER >> 16:
 		err |= __put_user(s->si_tid, &d->si_tid);
 		err |= __put_user(s->si_overrun, &d->si_overrun);
diff --git a/arch/s390/kernel/compat_linux.h b/arch/s390/kernel/compat_linux.h
index 9635d75..f8c973f 100644
--- a/arch/s390/kernel/compat_linux.h
+++ b/arch/s390/kernel/compat_linux.h
@@ -72,6 +72,13 @@ typedef struct compat_siginfo {
 			int	_band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int	_fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			pid_t		_pid;	/* sender's pid */
+			uid_t		_uid;	/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 } compat_siginfo_t;
 
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index eee9998..b3c9f6b 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -96,6 +96,11 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
+		case __SI_TRAP >> 16:
+			err |= __put_user(from->si_pid, &to->si_pid);
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+			break;
 		case __SI_TIMER >> 16:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 75fad42..c545212 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -102,6 +102,13 @@ typedef struct compat_siginfo{
 			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			unsigned int _uid;		/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 }compat_siginfo_t;
 
@@ -165,6 +172,11 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
+		case __SI_TRAP >> 16:
+			err |= __put_user(from->si_pid, &to->si_pid);
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+			break;
 		case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
 		case __SI_MESGQ >> 16:
 			err |= __put_user(from->si_pid, &to->si_pid);
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index a7869ad..6a45c4f 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -109,6 +109,13 @@ struct compat_siginfo {
 			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 };
 
@@ -219,6 +226,10 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *to, siginfo_t *from)
 		case __SI_POLL >> 16:
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
+		case __SI_TRAP >> 16:
+			err |= __put_user(from->si_uid, &to->si_uid);
+			err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+			break;
 		case __SI_TIMER >> 16:
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(ptr_to_compat(from->si_ptr),
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 588a7aa..1df88cc 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -85,6 +85,10 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			case __SI_POLL >> 16:
 				put_user_ex(from->si_fd, &to->si_fd);
 				break;
+			case __SI_TRAP:
+				put_user_ex(from->si_uid, &to->si_uid);
+				put_user_ex(from->si_pt_flags, &to->si_pt_flags);
+				break;
 			case __SI_TIMER >> 16:
 				put_user_ex(from->si_overrun, &to->si_overrun);
 				put_user_ex(ptr_to_compat(from->si_ptr),
diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index 1f7e625..7eab27a 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -126,6 +126,13 @@ typedef struct compat_siginfo {
 			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 } compat_siginfo_t;
 
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 0dd4e87..9ecabdf 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -90,6 +90,13 @@ typedef struct siginfo {
 			__ARCH_SI_BAND_T _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGTRAP */
+		struct {
+			__kernel_pid_t _pid;	/* sender's pid */
+			__ARCH_SI_UID_T _uid;	/* sender's uid */
+			unsigned int _pt_flags;
+		} _sigtrap;
 	} _sifields;
 } siginfo_t;
 
@@ -116,6 +123,7 @@ typedef struct siginfo {
 #define si_addr_lsb	_sifields._sigfault._addr_lsb
 #define si_band		_sifields._sigpoll._band
 #define si_fd		_sifields._sigpoll._fd
+#define si_pt_flags	_sifields._sigtrap._pt_flags
 
 #ifdef __KERNEL__
 #define __SI_MASK	0xffff0000u
@@ -126,6 +134,7 @@ typedef struct siginfo {
 #define __SI_CHLD	(4 << 16)
 #define __SI_RT		(5 << 16)
 #define __SI_MESGQ	(6 << 16)
+#define __SI_TRAP	(7 << 16)
 #define __SI_CODE(T,N)	((T) | ((N) & 0xffff))
 #else
 #define __SI_KILL	0
@@ -135,6 +144,7 @@ typedef struct siginfo {
 #define __SI_CHLD	0
 #define __SI_RT		0
 #define __SI_MESGQ	0
+#define __SI_TRAP	0
 #define __SI_CODE(T,N)	(N)
 #endif
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 434243e..3f131be 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1881,7 +1881,7 @@ static void ptrace_do_notify(int exit_code, int why)
 
 	memset(&info, 0, sizeof info);
 	info.si_signo = SIGTRAP;
-	info.si_code = exit_code;
+	info.si_code = __SI_TRAP | exit_code;
 	info.si_pid = task_pid_vnr(current);
 	info.si_uid = current_uid();
 
@@ -2534,6 +2534,11 @@ int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
 		err |= __put_user(from->si_band, &to->si_band);
 		err |= __put_user(from->si_fd, &to->si_fd);
 		break;
+	case __SI_TRAP:
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		err |= __put_user(from->si_pt_flags, &to->si_pt_flags);
+		break;
 	case __SI_FAULT:
 		err |= __put_user(from->si_addr, &to->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-- 
1.7.5.2

