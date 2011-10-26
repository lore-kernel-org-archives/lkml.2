Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab1JZNxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:53:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38347 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680Ab1JZNxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:53:52 -0400
Date: Wed, 26 Oct 2011 15:52:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/urgent changes for v3.2
Message-ID: <20111026135218.GA30512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

This is a leftover from before the merge window, not quite making it 
into v3.1-final.

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (1):
      x86: Fix insn decoder for longer instruction


 arch/x86/lib/insn.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 9f33b98..374562e 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -22,14 +22,23 @@
 #include <asm/inat.h>
 #include <asm/insn.h>
 
-#define get_next(t, insn)	\
-	({t r; r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
+/* Verify next sizeof(t) bytes can be on the same instruction */
+#define validate_next(t, insn, n)	\
+	((insn)->next_byte + sizeof(t) + n - (insn)->kaddr <= MAX_INSN_SIZE)
+
+#define __get_next(t, insn)	\
+	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
+
+#define __peek_nbyte_next(t, insn, n)	\
+	({ t r = *(t*)((insn)->next_byte + n); r; })
 
-#define peek_next(t, insn)	\
-	({t r; r = *(t*)insn->next_byte; r; })
+#define get_next(t, insn)	\
+	({ if (unlikely(!validate_next(t, insn, 0))) goto err_out; __get_next(t, insn); })
 
 #define peek_nbyte_next(t, insn, n)	\
-	({t r; r = *(t*)((insn)->next_byte + n); r; })
+	({ if (unlikely(!validate_next(t, insn, n))) goto err_out; __peek_nbyte_next(t, insn, n); })
+
+#define peek_next(t, insn)	peek_nbyte_next(t, insn, 0)
 
 /**
  * insn_init() - initialize struct insn
@@ -158,6 +167,8 @@ vex_end:
 	insn->vex_prefix.got = 1;
 
 	prefixes->got = 1;
+
+err_out:
 	return;
 }
 
@@ -208,6 +219,9 @@ void insn_get_opcode(struct insn *insn)
 		insn->attr = 0;	/* This instruction is bad */
 end:
 	opcode->got = 1;
+
+err_out:
+	return;
 }
 
 /**
@@ -241,6 +255,9 @@ void insn_get_modrm(struct insn *insn)
 	if (insn->x86_64 && inat_is_force64(insn->attr))
 		insn->opnd_bytes = 8;
 	modrm->got = 1;
+
+err_out:
+	return;
 }
 
 
@@ -290,6 +307,9 @@ void insn_get_sib(struct insn *insn)
 		}
 	}
 	insn->sib.got = 1;
+
+err_out:
+	return;
 }
 
 
@@ -351,6 +371,9 @@ void insn_get_displacement(struct insn *insn)
 	}
 out:
 	insn->displacement.got = 1;
+
+err_out:
+	return;
 }
 
 /* Decode moffset16/32/64 */
@@ -373,6 +396,9 @@ static void __get_moffset(struct insn *insn)
 		break;
 	}
 	insn->moffset1.got = insn->moffset2.got = 1;
+
+err_out:
+	return;
 }
 
 /* Decode imm v32(Iz) */
@@ -389,6 +415,9 @@ static void __get_immv32(struct insn *insn)
 		insn->immediate.nbytes = 4;
 		break;
 	}
+
+err_out:
+	return;
 }
 
 /* Decode imm v64(Iv/Ov) */
@@ -411,6 +440,9 @@ static void __get_immv(struct insn *insn)
 		break;
 	}
 	insn->immediate1.got = insn->immediate2.got = 1;
+
+err_out:
+	return;
 }
 
 /* Decode ptr16:16/32(Ap) */
@@ -432,6 +464,9 @@ static void __get_immptr(struct insn *insn)
 	insn->immediate2.value = get_next(unsigned short, insn);
 	insn->immediate2.nbytes = 2;
 	insn->immediate1.got = insn->immediate2.got = 1;
+
+err_out:
+	return;
 }
 
 /**
@@ -496,6 +531,9 @@ void insn_get_immediate(struct insn *insn)
 	}
 done:
 	insn->immediate.got = 1;
+
+err_out:
+	return;
 }
 
 /**
