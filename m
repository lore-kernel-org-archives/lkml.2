Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab1JGNc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:32:27 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46853 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1JGNc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:32:26 -0400
X-AuditID: b753bd60-9d09fba000005c89-d1-4e8eff681778
X-AuditID: b753bd60-9d09fba000005c89-d1-4e8eff681778
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] x86: Fix insn decoder for longer instruction
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Fri, 07 Oct 2011 22:31:55 +0900
Message-ID: <20111007133155.10933.58577.stgit@localhost.localdomain>
In-Reply-To: <4E8EE885.9040703@hitachi.com>
References: <4E8EE885.9040703@hitachi.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix x86 insn decoder for hardening against invalid length
instructions. This adds length checkings for each byte-read
site and if it exceeds MAX_INSN_SIZE, returns immediately.
This can happen when decoding user-space binary.

Caller can check whether it happened by checking insn.*.got
member is set or not.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

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

