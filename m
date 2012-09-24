Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2IXOgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:36:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63368 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:37 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v4 2/4] compat: move compat_siginfo_t definition to asm/compat.h
Date: Mon, 24 Sep 2012 16:36:01 +0200
Message-Id: <1348497363-341-3-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
References: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparatory patch for the introduction of NT_SIGINFO elf note.

Make the location of compat_siginfo_t uniform across eight architectures
which have it. Now it can be pulled in by including asm/compat.h
or linux/compat.h.

Most of the copies are verbatim. compat_uid[32]_t had to be replaced by
__compat_uid[32]_t. compat_uptr_t had to be moved up before compat_siginfo_t
in asm/compat.h on a several architectures (tile already had it moved up).
compat_sigval_t had to be relocated from linux/compat.h to asm/compat.h.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/arm64/include/asm/compat.h       |   60 ++++++++++++++++++++++++++-
 arch/arm64/kernel/signal32.c          |   53 -----------------------
 arch/mips/include/asm/compat-signal.h |   62 ---------------------------
 arch/mips/include/asm/compat.h        |   69 +++++++++++++++++++++++++++++-
 arch/parisc/include/asm/compat.h      |   59 +++++++++++++++++++++++++-
 arch/parisc/kernel/signal32.h         |   52 -----------------------
 arch/powerpc/include/asm/compat.h     |   60 ++++++++++++++++++++++++++-
 arch/powerpc/include/asm/siginfo.h    |    1 -
 arch/powerpc/kernel/ppc32.h           |   51 ----------------------
 arch/s390/include/asm/compat.h        |   75 ++++++++++++++++++++++++++++++++-
 arch/s390/kernel/compat_linux.h       |   68 -----------------------------
 arch/sparc/include/asm/compat.h       |   61 ++++++++++++++++++++++++++-
 arch/sparc/include/asm/siginfo.h      |    1 -
 arch/sparc/kernel/signal32.c          |   52 -----------------------
 arch/tile/include/asm/compat.h        |   62 +++++++++++++++++++++++++++
 arch/tile/kernel/compat_signal.c      |   57 -------------------------
 arch/x86/include/asm/compat.h         |   74 ++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/ia32.h           |   67 -----------------------------
 include/linux/compat.h                |    5 --
 19 files changed, 513 insertions(+), 476 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index a670a33..37e610d 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -55,6 +55,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -130,6 +131,64 @@ typedef u32		compat_old_sigset_t;
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		/* The padding is the same size as AArch64. */
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid32_t _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid32_t _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			__compat_uid32_t _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			compat_uptr_t _addr; /* faulting insn/memory ref. */
+			short _addr_lsb; /* LSB of the reported address */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -139,7 +198,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index ac74c2f..0790a87 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -30,59 +30,6 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		/* The padding is the same size as AArch64. */
-		int _pad[SI_PAD_SIZE];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			__compat_uid32_t _uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;	/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;       /* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			__compat_uid32_t _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;	/* which child */
-			__compat_uid32_t _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			compat_uptr_t _addr; /* faulting insn/memory ref. */
-			short _addr_lsb; /* LSB of the reported address */
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-} compat_siginfo_t;
-
 struct compat_sigaction {
 	compat_uptr_t			sa_handler;
 	compat_ulong_t			sa_flags;
diff --git a/arch/mips/include/asm/compat-signal.h b/arch/mips/include/asm/compat-signal.h
index 368a99e..6599a90 100644
--- a/arch/mips/include/asm/compat-signal.h
+++ b/arch/mips/include/asm/compat-signal.h
@@ -10,68 +10,6 @@
 
 #include <asm/uaccess.h>
 
-#define SI_PAD_SIZE32   ((SI_MAX_SIZE/sizeof(int)) - 3)
-
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_code;
-	int si_errno;
-
-	union {
-		int _pad[SI_PAD_SIZE32];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			compat_uid_t _uid;	/* sender's uid */
-		} _kill;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;	/* which child */
-			compat_uid_t _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* IRIX SIGCHLD */
-		struct {
-			compat_pid_t _pid;	/* which child */
-			compat_clock_t _utime;
-			int _status;		/* exit code */
-			compat_clock_t _stime;
-		} _irix_sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			s32 _addr; /* faulting insn/memory ref. */
-		} _sigfault;
-
-		/* SIGPOLL, SIGXFSZ (To do ...)  */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-
-		/* POSIX.1b timers */
-		struct {
-			timer_t _tid;		/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;/* same as below */
-			int _sys_private;       /* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			compat_uid_t _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-	} _sifields;
-} compat_siginfo_t;
-
 static inline int __copy_conv_sigset_to_user(compat_sigset_t __user *d,
 	const sigset_t *s)
 {
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index b77df03..58277e0 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -43,6 +43,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -124,6 +125,73 @@ typedef u32		compat_old_sigset_t;	/* at least 32 bits */
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define SI_PAD_SIZE32	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_code;
+	int si_errno;
+
+	union {
+		int _pad[SI_PAD_SIZE32];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid_t _uid;	/* sender's uid */
+		} _kill;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			__compat_uid_t _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* IRIX SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			compat_clock_t _utime;
+			int _status;		/* exit code */
+			compat_clock_t _stime;
+		} _irix_sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			s32 _addr; /* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL, SIGXFSZ (To do ...)  */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+
+		/* POSIX.1b timers */
+		struct {
+			timer_t _tid;		/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;/* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid_t _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -133,7 +201,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index 760f331..db7a662 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -36,6 +36,7 @@ typedef s64	compat_s64;
 typedef u32	compat_uint_t;
 typedef u32	compat_ulong_t;
 typedef u64	compat_u64;
+typedef u32	compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t		tv_sec;
@@ -127,6 +128,63 @@ typedef u32		compat_old_sigset_t;	/* at least 32 bits */
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;      /* sender's pid */
+			unsigned int _uid;      /* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;            /* timer id */
+			int _overrun;           /* overrun count */
+			char _pad[sizeof(unsigned int) - sizeof(int)];
+			compat_sigval_t _sigval;        /* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;      /* sender's pid */
+			unsigned int _uid;      /* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;      /* which child */
+			unsigned int _uid;      /* sender's uid */
+			int _status;            /* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;     /* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;      /* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -136,7 +194,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/parisc/kernel/signal32.h b/arch/parisc/kernel/signal32.h
index c780084..08a88b5 100644
--- a/arch/parisc/kernel/signal32.h
+++ b/arch/parisc/kernel/signal32.h
@@ -55,58 +55,6 @@ struct k_sigaction32 {
 	struct compat_sigaction sa;
 };
 
-typedef struct compat_siginfo {
-        int si_signo;
-        int si_errno;
-        int si_code;
-
-        union {
-                int _pad[((128/sizeof(int)) - 3)];
-
-                /* kill() */
-                struct {
-                        unsigned int _pid;      /* sender's pid */
-                        unsigned int _uid;      /* sender's uid */
-                } _kill;
-
-                /* POSIX.1b timers */
-                struct {
-                        compat_timer_t _tid;            /* timer id */
-                        int _overrun;           /* overrun count */
-                        char _pad[sizeof(unsigned int) - sizeof(int)];
-                        compat_sigval_t _sigval;        /* same as below */
-                        int _sys_private;       /* not to be passed to user */
-                } _timer;
-
-                /* POSIX.1b signals */
-                struct {
-                        unsigned int _pid;      /* sender's pid */
-                        unsigned int _uid;      /* sender's uid */
-                        compat_sigval_t _sigval;
-                } _rt;
-
-                /* SIGCHLD */
-                struct {
-                        unsigned int _pid;      /* which child */
-                        unsigned int _uid;      /* sender's uid */
-                        int _status;            /* exit code */
-                        compat_clock_t _utime;
-                        compat_clock_t _stime;
-                } _sigchld;
-
-                /* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-                struct {
-                        unsigned int _addr;     /* faulting insn/memory ref. */
-                } _sigfault;
-
-                /* SIGPOLL */
-                struct {
-                        int _band;      /* POLL_IN, POLL_OUT, POLL_MSG */
-                        int _fd;
-                } _sigpoll;
-        } _sifields;
-} compat_siginfo_t;
-
 int copy_siginfo_to_user32 (compat_siginfo_t __user *to, siginfo_t *from);
 int copy_siginfo_from_user32 (siginfo_t *to, compat_siginfo_t __user *from);
 
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 88e602f..84fdf68 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -38,6 +38,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -114,6 +115,64 @@ typedef u32		compat_old_sigset_t;
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define SI_PAD_SIZE32	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[SI_PAD_SIZE32];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			__compat_uid_t _uid;		/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;		/* timer id */
+			int _overrun;			/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			__compat_uid_t _uid;		/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;		/* which child */
+			__compat_uid_t _uid;		/* sender's uid */
+			int _status;			/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
+		struct {
+			unsigned int _addr; /* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -123,7 +182,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/powerpc/include/asm/siginfo.h b/arch/powerpc/include/asm/siginfo.h
index 49495b0..ccce3ef 100644
--- a/arch/powerpc/include/asm/siginfo.h
+++ b/arch/powerpc/include/asm/siginfo.h
@@ -10,7 +10,6 @@
 
 #ifdef __powerpc64__
 #    define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
-#    define SI_PAD_SIZE32		((SI_MAX_SIZE/sizeof(int)) - 3)
 #endif
 
 #include <asm-generic/siginfo.h>
diff --git a/arch/powerpc/kernel/ppc32.h b/arch/powerpc/kernel/ppc32.h
index dc16aef..02fb0ee 100644
--- a/arch/powerpc/kernel/ppc32.h
+++ b/arch/powerpc/kernel/ppc32.h
@@ -16,57 +16,6 @@
 
 /* These are here to support 32-bit syscalls on a 64-bit kernel. */
 
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[SI_PAD_SIZE32];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			compat_uid_t _uid;		/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;			/* timer id */
-			int _overrun;			/* overrun count */
-			compat_sigval_t _sigval;		/* same as below */
-			int _sys_private;		/* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			compat_uid_t _uid;		/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;		/* which child */
-			compat_uid_t _uid;		/* sender's uid */
-			int _status;			/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
-		struct {
-			unsigned int _addr; /* faulting insn/memory ref. */
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-} compat_siginfo_t;
-
 #define __old_sigaction32	old_sigaction32
 
 struct __old_sigaction32 {
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 234f1d8..a34a9d6 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -65,6 +65,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -144,6 +145,79 @@ typedef u32		compat_old_sigset_t;	/* at least 32 bits */
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int	si_signo;
+	int	si_errno;
+	int	si_code;
+
+	union {
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			pid_t	_pid;	/* sender's pid */
+			uid_t	_uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;		/* timer id */
+			int _overrun;			/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			pid_t			_pid;	/* sender's pid */
+			uid_t			_uid;	/* sender's uid */
+			compat_sigval_t		_sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			pid_t			_pid;	/* which child */
+			uid_t			_uid;	/* sender's uid */
+			int			_status;/* exit code */
+			compat_clock_t		_utime;
+			compat_clock_t		_stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			__u32	_addr;	/* faulting insn/memory ref. - pointer */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int	_band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int	_fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
+/*
+ * How these fields are to be accessed.
+ */
+#define si_pid		_sifields._kill._pid
+#define si_uid		_sifields._kill._uid
+#define si_status	_sifields._sigchld._status
+#define si_utime	_sifields._sigchld._utime
+#define si_stime	_sifields._sigchld._stime
+#define si_value	_sifields._rt._sigval
+#define si_int		_sifields._rt._sigval.sival_int
+#define si_ptr		_sifields._rt._sigval.sival_ptr
+#define si_addr		_sifields._sigfault._addr
+#define si_band		_sifields._sigpoll._band
+#define si_fd		_sifields._sigpoll._fd
+#define si_tid		_sifields._timer._tid
+#define si_overrun	_sifields._timer._overrun
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -153,7 +227,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/s390/kernel/compat_linux.h b/arch/s390/kernel/compat_linux.h
index 5daff1d..d4d0239 100644
--- a/arch/s390/kernel/compat_linux.h
+++ b/arch/s390/kernel/compat_linux.h
@@ -23,74 +23,6 @@ struct old_sigaction32 {
        __u32			sa_flags;
        __u32			sa_restorer;	/* Another 32 bit pointer */
 };
- 
-typedef struct compat_siginfo {
-	int	si_signo;
-	int	si_errno;
-	int	si_code;
-
-	union {
-		int _pad[((128/sizeof(int)) - 3)];
-
-		/* kill() */
-		struct {
-			pid_t	_pid;	/* sender's pid */
-			uid_t	_uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;		/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;       /* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			pid_t			_pid;	/* sender's pid */
-			uid_t			_uid;	/* sender's uid */
-			compat_sigval_t		_sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			pid_t			_pid;	/* which child */
-			uid_t			_uid;	/* sender's uid */
-			int			_status;/* exit code */
-			compat_clock_t		_utime;
-			compat_clock_t		_stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			__u32	_addr;	/* faulting insn/memory ref. - pointer */
-		} _sigfault;
-                          
-		/* SIGPOLL */
-		struct {
-			int	_band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int	_fd;
-		} _sigpoll;
-	} _sifields;
-} compat_siginfo_t;
-
-/*
- * How these fields are to be accessed.
- */
-#define si_pid		_sifields._kill._pid
-#define si_uid		_sifields._kill._uid
-#define si_status	_sifields._sigchld._status
-#define si_utime	_sifields._sigchld._utime
-#define si_stime	_sifields._sigchld._stime
-#define si_value	_sifields._rt._sigval
-#define si_int		_sifields._rt._sigval.sival_int
-#define si_ptr		_sifields._rt._sigval.sival_ptr
-#define si_addr		_sifields._sigfault._addr
-#define si_band		_sifields._sigpoll._band
-#define si_fd		_sifields._sigpoll._fd    
-#define si_tid		_sifields._timer._tid
-#define si_overrun	_sifields._timer._overrun
 
 /* asm/sigcontext.h */
 typedef union
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index b8be20d..cef99fb 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -36,6 +36,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -147,6 +148,65 @@ typedef u32		compat_old_sigset_t;
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define SI_PAD_SIZE32	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[SI_PAD_SIZE32];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			unsigned int _uid;		/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;		/* timer id */
+			int _overrun;			/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			unsigned int _uid;		/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;		/* which child */
+			unsigned int _uid;		/* sender's uid */
+			int _status;			/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
+		struct {
+			u32 _addr; /* faulting insn/memory ref. */
+			int _trapno;
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -156,7 +216,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/sparc/include/asm/siginfo.h b/arch/sparc/include/asm/siginfo.h
index 215900f..dbc182c 100644
--- a/arch/sparc/include/asm/siginfo.h
+++ b/arch/sparc/include/asm/siginfo.h
@@ -3,7 +3,6 @@
 
 #if defined(__sparc__) && defined(__arch64__)
 
-#define SI_PAD_SIZE32	((SI_MAX_SIZE/sizeof(int)) - 3)
 #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
 #define __ARCH_SI_BAND_T int
 
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index a53e0a5..53e48f7 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -54,58 +54,6 @@ struct signal_frame32 {
 	/* __siginfo_rwin_t * */u32 rwin_save;
 } __attribute__((aligned(8)));
 
-typedef struct compat_siginfo{
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[SI_PAD_SIZE32];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			unsigned int _uid;		/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;			/* timer id */
-			int _overrun;			/* overrun count */
-			compat_sigval_t _sigval;		/* same as below */
-			int _sys_private;		/* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			unsigned int _uid;		/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;		/* which child */
-			unsigned int _uid;		/* sender's uid */
-			int _status;			/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
-		struct {
-			u32 _addr; /* faulting insn/memory ref. */
-			int _trapno;
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-}compat_siginfo_t;
-
 struct rt_signal_frame32 {
 	struct sparc_stackf32	ss;
 	compat_siginfo_t	info;
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 6e74450..3063e6f 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -110,6 +110,68 @@ struct compat_flock64 {
 
 typedef u32               compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define COMPAT_SI_PAD_SIZE	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[COMPAT_SI_PAD_SIZE];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+			int _overrun_incr;	/* amount to add to overrun */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;	/* faulting insn/memory ref. */
+#ifdef __ARCH_SI_TRAPNO
+			int _trapno;	/* TRAP # which caused the signal */
+#endif
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 3690f01..08b4fe1 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -55,63 +55,6 @@ struct compat_ucontext {
 	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
-#define COMPAT_SI_PAD_SIZE	((SI_MAX_SIZE - 3 * sizeof(int)) / sizeof(int))
-
-struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[COMPAT_SI_PAD_SIZE];
-
-		/* kill() */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;	/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;	/* not to be passed to user */
-			int _overrun_incr;	/* amount to add to overrun */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			unsigned int _pid;	/* which child */
-			unsigned int _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			unsigned int _addr;	/* faulting insn/memory ref. */
-#ifdef __ARCH_SI_TRAPNO
-			int _trapno;	/* TRAP # which caused the signal */
-#endif
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-};
-
 struct compat_rt_sigframe {
 	unsigned char save_area[C_ABI_SAVE_AREA_SIZE]; /* caller save area */
 	struct compat_siginfo info;
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index fedf32b..59c6c40 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -41,6 +41,7 @@ typedef s64 __attribute__((aligned(4))) compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64 __attribute__((aligned(4))) compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -124,6 +125,78 @@ typedef u32		compat_old_sigset_t;	/* at least 32 bits */
 
 typedef u32               compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+			int _overrun_incr;	/* amount to add to overrun */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGCHLD (x32 version) */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_s64 _utime;
+			compat_s64 _stime;
+		} _sigchld_x32;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;	/* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+
+		struct {
+			unsigned int _call_addr; /* calling insn */
+			int _syscall;	/* triggering system call number */
+			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
+		} _sigsys;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -209,7 +282,6 @@ typedef struct user_regs_struct32 compat_elf_gregset_t;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index b04cbdb..e623277 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -86,73 +86,6 @@ struct stat64 {
 	unsigned long long	st_ino;
 } __attribute__((packed));
 
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[((128 / sizeof(int)) - 3)];
-
-		/* kill() */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;	/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;	/* not to be passed to user */
-			int _overrun_incr;	/* amount to add to overrun */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			unsigned int _pid;	/* which child */
-			unsigned int _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGCHLD (x32 version) */
-		struct {
-			unsigned int _pid;	/* which child */
-			unsigned int _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_s64 _utime;
-			compat_s64 _stime;
-		} _sigchld_x32;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			unsigned int _addr;	/* faulting insn/memory ref. */
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-
-		struct {
-			unsigned int _call_addr; /* calling insn */
-			int _syscall;	/* triggering system call number */
-			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
-		} _sigsys;
-	} _sifields;
-} compat_siginfo_t;
-
 #define IA32_STACK_TOP IA32_PAGE_OFFSET
 
 #ifdef __KERNEL__
diff --git a/include/linux/compat.h b/include/linux/compat.h
index b0d1805..d0ced10 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -160,11 +160,6 @@ struct compat_ustat {
 	char			f_fpack[6];
 };
 
-typedef union compat_sigval {
-	compat_int_t	sival_int;
-	compat_uptr_t	sival_ptr;
-} compat_sigval_t;
-
 #define COMPAT_SIGEV_PAD_SIZE	((SIGEV_MAX_SIZE/sizeof(int)) - 3)
 
 typedef struct compat_sigevent {
-- 
1.7.7.6

