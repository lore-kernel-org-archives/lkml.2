Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1LEMHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:07:13 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51361 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1LEMGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:06:15 -0500
X-AuditID: b753bd60-9518dba000007b1b-d1-4edcb3b4490c
X-AuditID: b753bd60-9518dba000007b1b-d1-4edcb3b4490c
Subject: [PATCH 5/6] x86: Update instruction decoder to support new AVX formats
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 05 Dec 2011 21:05:57 +0900
Message-ID: <20111205120557.15475.13236.stgit@cloud>
In-Reply-To: <20111205120520.15475.82983.stgit@cloud>
References: <20111205120520.15475.82983.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since new Intel software developers manual introduces
new format for AVX instruction set (including AVX2),
it is important to update x86-opcode-map.txt to fit
those changes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/lib/x86-opcode-map.txt      |  606 +++++++++++++++++++---------------
 arch/x86/tools/gen-insn-attr-x86.awk |   21 +
 2 files changed, 345 insertions(+), 282 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index a793da5..5b83c51 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -1,5 +1,11 @@
 # x86 Opcode Maps
 #
+# This is (mostly) based on following documentations.
+# - Intel(R) 64 and IA-32 Architectures Software Developer's Manual Vol.2
+#   (#325383-040US, October 2011)
+# - Intel(R) Advanced Vector Extensions Programming Reference
+#   (#319433-011,JUNE 2011).
+#
 #<Opcode maps>
 # Table: table-name
 # Referrer: escaped-name
@@ -15,10 +21,13 @@
 # EndTable
 #
 # AVX Superscripts
-#  (VEX): this opcode can accept VEX prefix.
-#  (oVEX): this opcode requires VEX prefix.
-#  (o128): this opcode only supports 128bit VEX.
-#  (o256): this opcode only supports 256bit VEX.
+#  (v): this opcode requires VEX prefix.
+#  (v1): this opcode only supports 128bit VEX.
+#
+# Last Prefix Superscripts
+#  - (66): the last prefix is 0x66
+#  - (F3): the last prefix is 0xF3
+#  - (F2): the last prefix is 0xF2
 #
 
 Table: one byte opcode
@@ -199,8 +208,8 @@ a0: MOV AL,Ob
 a1: MOV rAX,Ov
 a2: MOV Ob,AL
 a3: MOV Ov,rAX
-a4: MOVS/B Xb,Yb
-a5: MOVS/W/D/Q Xv,Yv
+a4: MOVS/B Yb,Xb
+a5: MOVS/W/D/Q Yv,Xv
 a6: CMPS/B Xb,Yb
 a7: CMPS/W/D Xv,Yv
 a8: TEST AL,Ib
@@ -233,8 +242,8 @@ c0: Grp2 Eb,Ib (1A)
 c1: Grp2 Ev,Ib (1A)
 c2: RETN Iw (f64)
 c3: RETN
-c4: LES Gz,Mp (i64) | 3bytes-VEX (Prefix)
-c5: LDS Gz,Mp (i64) | 2bytes-VEX (Prefix)
+c4: LES Gz,Mp (i64) | VEX+2byte (Prefix)
+c5: LDS Gz,Mp (i64) | VEX+1byte (Prefix)
 c6: Grp11 Eb,Ib (1A)
 c7: Grp11 Ev,Iz (1A)
 c8: ENTER Iw,Ib
@@ -320,14 +329,19 @@ AVXcode: 1
 # 3DNow! uses the last imm byte as opcode extension.
 0f: 3DNow! Pq,Qq,Ib
 # 0x0f 0x10-0x1f
-10: movups Vps,Wps (VEX) | movss Vss,Wss (F3),(VEX),(o128) | movupd Vpd,Wpd (66),(VEX) | movsd Vsd,Wsd (F2),(VEX),(o128)
-11: movups Wps,Vps (VEX) | movss Wss,Vss (F3),(VEX),(o128) | movupd Wpd,Vpd (66),(VEX) | movsd Wsd,Vsd (F2),(VEX),(o128)
-12: movlps Vq,Mq (VEX),(o128) | movlpd Vq,Mq (66),(VEX),(o128) | movhlps Vq,Uq (VEX),(o128) | movddup Vq,Wq (F2),(VEX) | movsldup Vq,Wq (F3),(VEX)
-13: mpvlps Mq,Vq (VEX),(o128) | movlpd Mq,Vq (66),(VEX),(o128)
-14: unpcklps Vps,Wq (VEX) | unpcklpd Vpd,Wq (66),(VEX)
-15: unpckhps Vps,Wq (VEX) | unpckhpd Vpd,Wq (66),(VEX)
-16: movhps Vq,Mq (VEX),(o128) | movhpd Vq,Mq (66),(VEX),(o128) | movlsps Vq,Uq (VEX),(o128) | movshdup Vq,Wq (F3),(VEX)
-17: movhps Mq,Vq (VEX),(o128) | movhpd Mq,Vq (66),(VEX),(o128)
+# NOTE: According to Intel SDM opcode map, vmovups and vmovupd has no operands
+# but it actually has operands. And also, vmovss and vmovsd only accept 128bit.
+# MOVSS/MOVSD has too many forms(3) on SDM. This map just shows a typical form.
+# Many AVX instructions lack v1 superscript, according to Intel AVX-Prgramming
+# Reference A.1
+10: vmovups Vps,Wps | vmovupd Vpd,Wpd (66) | vmovss Vx,Hx,Wss (F3),(v1) | vmovsd Vx,Hx,Wsd (F2),(v1)
+11: vmovups Wps,Vps | vmovupd Wpd,Vpd (66) | vmovss Wss,Hx,Vss (F3),(v1) | vmovsd Wsd,Hx,Vsd (F2),(v1)
+12: vmovlps Vq,Hq,Mq (v1) | vmovhlps Vq,Hq,Uq (v1) | vmovlpd Vq,Hq,Mq (66),(v1) | vmovsldup Vx,Wx (F3) | vmovddup Vx,Wx (F2)
+13: vmovlps Mq,Vq (v1) | vmovlpd Mq,Vq (66),(v1)
+14: vunpcklps Vx,Hx,Wx | vunpcklpd Vx,Hx,Wx (66)
+15: vunpckhps Vx,Hx,Wx | vunpckhpd Vx,Hx,Wx (66)
+16: vmovhps Vdq,Hq,Mq (v1) | vmovlhps Vdq,Hq,Uq (v1) | vmovhpd Vdq,Hq,Mq (66),(v1) | vmovshdup Vx,Wx (F3)
+17: vmovhps Mq,Vq (v1) | vmovhpd Mq,Vq (66),(v1)
 18: Grp16 (1A)
 19:
 1a:
@@ -345,14 +359,14 @@ AVXcode: 1
 25:
 26:
 27:
-28: movaps Vps,Wps (VEX) | movapd Vpd,Wpd (66),(VEX)
-29: movaps Wps,Vps (VEX) | movapd Wpd,Vpd (66),(VEX)
-2a: cvtpi2ps Vps,Qpi | cvtsi2ss Vss,Ed/q (F3),(VEX),(o128) | cvtpi2pd Vpd,Qpi (66) | cvtsi2sd Vsd,Ed/q (F2),(VEX),(o128)
-2b: movntps Mps,Vps (VEX) | movntpd Mpd,Vpd (66),(VEX)
-2c: cvttps2pi Ppi,Wps | cvttss2si  Gd/q,Wss (F3),(VEX),(o128) | cvttpd2pi Ppi,Wpd (66) | cvttsd2si Gd/q,Wsd (F2),(VEX),(o128)
-2d: cvtps2pi Ppi,Wps | cvtss2si Gd/q,Wss (F3),(VEX),(o128) | cvtpd2pi Qpi,Wpd (66) | cvtsd2si Gd/q,Wsd (F2),(VEX),(o128)
-2e: ucomiss Vss,Wss (VEX),(o128) | ucomisd  Vsd,Wsd (66),(VEX),(o128)
-2f: comiss Vss,Wss (VEX),(o128) | comisd  Vsd,Wsd (66),(VEX),(o128)
+28: vmovaps Vps,Wps | vmovapd Vpd,Wpd (66)
+29: vmovaps Wps,Vps | vmovapd Wpd,Vpd (66)
+2a: cvtpi2ps Vps,Qpi | cvtpi2pd Vpd,Qpi (66) | vcvtsi2ss Vss,Hss,Ey (F3),(v1) | vcvtsi2sd Vsd,Hsd,Ey (F2),(v1)
+2b: vmovntps Mps,Vps | vmovntpd Mpd,Vpd (66)
+2c: cvttps2pi Ppi,Wps | cvttpd2pi Ppi,Wpd (66) | vcvttss2si Gy,Wss (F3),(v1) | vcvttsd2si Gy,Wsd (F2),(v1)
+2d: cvtps2pi Ppi,Wps | cvtpd2pi Qpi,Wpd (66) | vcvtss2si Gy,Wss (F3),(v1) | vcvtsd2si Gy,Wsd (F2),(v1)
+2e: vucomiss Vss,Wss (v1) | vucomisd  Vsd,Wsd (66),(v1)
+2f: vcomiss Vss,Wss (v1) | vcomisd  Vsd,Wsd (66),(v1)
 # 0x0f 0x30-0x3f
 30: WRMSR
 31: RDTSC
@@ -388,65 +402,66 @@ AVXcode: 1
 4e: CMOVLE/NG Gv,Ev
 4f: CMOVNLE/G Gv,Ev
 # 0x0f 0x50-0x5f
-50: movmskps Gd/q,Ups (VEX) | movmskpd Gd/q,Upd (66),(VEX)
-51: sqrtps Vps,Wps (VEX) | sqrtss Vss,Wss (F3),(VEX),(o128) | sqrtpd Vpd,Wpd (66),(VEX) | sqrtsd Vsd,Wsd (F2),(VEX),(o128)
-52: rsqrtps Vps,Wps (VEX) | rsqrtss Vss,Wss (F3),(VEX),(o128)
-53: rcpps Vps,Wps (VEX) | rcpss Vss,Wss (F3),(VEX),(o128)
-54: andps Vps,Wps (VEX) | andpd Vpd,Wpd (66),(VEX)
-55: andnps Vps,Wps (VEX) | andnpd Vpd,Wpd (66),(VEX)
-56: orps Vps,Wps (VEX) | orpd Vpd,Wpd (66),(VEX)
-57: xorps Vps,Wps (VEX) | xorpd Vpd,Wpd (66),(VEX)
-58: addps Vps,Wps (VEX) | addss Vss,Wss (F3),(VEX),(o128) | addpd Vpd,Wpd (66),(VEX) | addsd Vsd,Wsd (F2),(VEX),(o128)
-59: mulps Vps,Wps (VEX) | mulss Vss,Wss (F3),(VEX),(o128) | mulpd Vpd,Wpd (66),(VEX) | mulsd Vsd,Wsd (F2),(VEX),(o128)
-5a: cvtps2pd Vpd,Wps (VEX) | cvtss2sd Vsd,Wss (F3),(VEX),(o128) | cvtpd2ps Vps,Wpd (66),(VEX) | cvtsd2ss Vsd,Wsd (F2),(VEX),(o128)
-5b: cvtdq2ps Vps,Wdq (VEX) | cvtps2dq Vdq,Wps (66),(VEX) | cvttps2dq Vdq,Wps (F3),(VEX)
-5c: subps Vps,Wps (VEX) | subss Vss,Wss (F3),(VEX),(o128) | subpd Vpd,Wpd (66),(VEX) | subsd Vsd,Wsd (F2),(VEX),(o128)
-5d: minps Vps,Wps (VEX) | minss Vss,Wss (F3),(VEX),(o128) | minpd Vpd,Wpd (66),(VEX) | minsd Vsd,Wsd (F2),(VEX),(o128)
-5e: divps Vps,Wps (VEX) | divss Vss,Wss (F3),(VEX),(o128) | divpd Vpd,Wpd (66),(VEX) | divsd Vsd,Wsd (F2),(VEX),(o128)
-5f: maxps Vps,Wps (VEX) | maxss Vss,Wss (F3),(VEX),(o128) | maxpd Vpd,Wpd (66),(VEX) | maxsd Vsd,Wsd (F2),(VEX),(o128)
+50: vmovmskps Gy,Ups | vmovmskpd Gy,Upd (66)
+51: vsqrtps Vps,Wps | vsqrtpd Vpd,Wpd (66) | vsqrtss Vss,Hss,Wss (F3),(v1) | vsqrtsd Vsd,Hsd,Wsd (F2),(v1)
+52: vrsqrtps Vps,Wps | vrsqrtss Vss,Hss,Wss (F3),(v1)
+53: vrcpps Vps,Wps | vrcpss Vss,Hss,Wss (F3),(v1)
+54: vandps Vps,Hps,Wps | vandpd Vpd,Hpd,Wpd (66)
+55: vandnps Vps,Hps,Wps | vandnpd Vpd,Hpd,Wpd (66)
+56: vorps Vps,Hps,Wps | vorpd Vpd,Hpd,Wpd (66)
+57: vxorps Vps,Hps,Wps | vxorpd Vpd,Hpd,Wpd (66)
+58: vaddps Vps,Hps,Wps | vaddpd Vpd,Hpd,Wpd (66) | vaddss Vss,Hss,Wss (F3),(v1) | vaddsd Vsd,Hsd,Wsd (F2),(v1)
+59: vmulps Vps,Hps,Wps | vmulpd Vpd,Hpd,Wpd (66) | vmulss Vss,Hss,Wss (F3),(v1) | vmulsd Vsd,Hsd,Wsd (F2),(v1)
+5a: vcvtps2pd Vpd,Wps | vcvtpd2ps Vps,Wpd (66) | vcvtss2sd Vsd,Hx,Wss (F3),(v1) | vcvtsd2ss Vss,Hx,Wsd (F2),(v1)
+5b: vcvtdq2ps Vps,Wdq | vcvtps2dq Vdq,Wps (66) | vcvttps2dq Vdq,Wps (F3)
+5c: vsubps Vps,Hps,Wps | vsubpd Vpd,Hpd,Wpd (66) | vsubss Vss,Hss,Wss (F3),(v1) | vsubsd Vsd,Hsd,Wsd (F2),(v1)
+5d: vminps Vps,Hps,Wps | vminpd Vpd,Hpd,Wpd (66) | vminss Vss,Hss,Wss (F3),(v1) | vminsd Vsd,Hsd,Wsd (F2),(v1)
+5e: vdivps Vps,Hps,Wps | vdivpd Vpd,Hpd,Wpd (66) | vdivss Vss,Hss,Wss (F3),(v1) | vdivsd Vsd,Hsd,Wsd (F2),(v1)
+5f: vmaxps Vps,Hps,Wps | vmaxpd Vpd,Hpd,Wpd (66) | vmaxss Vss,Hss,Wss (F3),(v1) | vmaxsd Vsd,Hsd,Wsd (F2),(v1)
 # 0x0f 0x60-0x6f
-60: punpcklbw Pq,Qd | punpcklbw Vdq,Wdq (66),(VEX),(o128)
-61: punpcklwd Pq,Qd | punpcklwd Vdq,Wdq (66),(VEX),(o128)
-62: punpckldq Pq,Qd | punpckldq Vdq,Wdq (66),(VEX),(o128)
-63: packsswb Pq,Qq | packsswb Vdq,Wdq (66),(VEX),(o128)
-64: pcmpgtb Pq,Qq | pcmpgtb Vdq,Wdq (66),(VEX),(o128)
-65: pcmpgtw Pq,Qq | pcmpgtw Vdq,Wdq (66),(VEX),(o128)
-66: pcmpgtd Pq,Qq | pcmpgtd Vdq,Wdq (66),(VEX),(o128)
-67: packuswb Pq,Qq | packuswb Vdq,Wdq (66),(VEX),(o128)
-68: punpckhbw Pq,Qd | punpckhbw Vdq,Wdq (66),(VEX),(o128)
-69: punpckhwd Pq,Qd | punpckhwd Vdq,Wdq (66),(VEX),(o128)
-6a: punpckhdq Pq,Qd | punpckhdq Vdq,Wdq (66),(VEX),(o128)
-6b: packssdw Pq,Qd | packssdw Vdq,Wdq (66),(VEX),(o128)
-6c: punpcklqdq Vdq,Wdq (66),(VEX),(o128)
-6d: punpckhqdq Vdq,Wdq (66),(VEX),(o128)
-6e: movd/q/ Pd,Ed/q | movd/q Vdq,Ed/q (66),(VEX),(o128)
-6f: movq Pq,Qq | movdqa Vdq,Wdq (66),(VEX) | movdqu Vdq,Wdq (F3),(VEX)
+60: punpcklbw Pq,Qd | vpunpcklbw Vx,Hx,Wx (66),(v1)
+61: punpcklwd Pq,Qd | vpunpcklwd Vx,Hx,Wx (66),(v1)
+62: punpckldq Pq,Qd | vpunpckldq Vx,Hx,Wx (66),(v1)
+63: packsswb Pq,Qq | vpacksswb Vx,Hx,Wx (66),(v1)
+64: pcmpgtb Pq,Qq | vpcmpgtb Vx,Hx,Wx (66),(v1)
+65: pcmpgtw Pq,Qq | vpcmpgtw Vx,Hx,Wx (66),(v1)
+66: pcmpgtd Pq,Qq | vpcmpgtd Vx,Hx,Wx (66),(v1)
+67: packuswb Pq,Qq | vpackuswb Vx,Hx,Wx (66),(v1)
+68: punpckhbw Pq,Qd | vpunpckhbw Vx,Hx,Wx (66),(v1)
+69: punpckhwd Pq,Qd | vpunpckhwd Vx,Hx,Wx (66),(v1)
+6a: punpckhdq Pq,Qd | vpunpckhdq Vx,Hx,Wx (66),(v1)
+6b: packssdw Pq,Qd | vpackssdw Vx,Hx,Wx (66),(v1)
+6c: vpunpcklqdq Vx,Hx,Wx (66),(v1)
+6d: vpunpckhqdq Vx,Hx,Wx (66),(v1)
+6e: movd/q Pd,Ey | vmovd/q Vy,Ey (66),(v1)
+6f: movq Pq,Qq | vmovdqa Vx,Wx (66) | vmovdqu Vx,Wx (F3)
 # 0x0f 0x70-0x7f
-70: pshufw Pq,Qq,Ib | pshufd Vdq,Wdq,Ib (66),(VEX),(o128) | pshufhw Vdq,Wdq,Ib (F3),(VEX),(o128) | pshuflw VdqWdq,Ib (F2),(VEX),(o128)
+70: pshufw Pq,Qq,Ib | vpshufd Vx,Wx,Ib (66),(v1) | vpshufhw Vx,Wx,Ib (F3),(v1) | vpshuflw Vx,Wx,Ib (F2),(v1)
 71: Grp12 (1A)
 72: Grp13 (1A)
 73: Grp14 (1A)
-74: pcmpeqb Pq,Qq | pcmpeqb Vdq,Wdq (66),(VEX),(o128)
-75: pcmpeqw Pq,Qq | pcmpeqw Vdq,Wdq (66),(VEX),(o128)
-76: pcmpeqd Pq,Qq | pcmpeqd Vdq,Wdq (66),(VEX),(o128)
-77: emms/vzeroupper/vzeroall (VEX)
-78: VMREAD Ed/q,Gd/q
-79: VMWRITE Gd/q,Ed/q
+74: pcmpeqb Pq,Qq | vpcmpeqb Vx,Hx,Wx (66),(v1)
+75: pcmpeqw Pq,Qq | vpcmpeqw Vx,Hx,Wx (66),(v1)
+76: pcmpeqd Pq,Qq | vpcmpeqd Vx,Hx,Wx (66),(v1)
+# Note: Remove (v), because vzeroall and vzeroupper becomes emms without VEX.
+77: emms | vzeroupper | vzeroall
+78: VMREAD Ey,Gy
+79: VMWRITE Gy,Ey
 7a:
 7b:
-7c: haddps Vps,Wps (F2),(VEX) | haddpd Vpd,Wpd (66),(VEX)
-7d: hsubps Vps,Wps (F2),(VEX) | hsubpd Vpd,Wpd (66),(VEX)
-7e: movd/q Ed/q,Pd | movd/q Ed/q,Vdq (66),(VEX),(o128) | movq Vq,Wq (F3),(VEX),(o128)
-7f: movq Qq,Pq | movdqa Wdq,Vdq (66),(VEX) | movdqu Wdq,Vdq (F3),(VEX)
+7c: vhaddpd Vpd,Hpd,Wpd (66) | vhaddps Vps,Hps,Wps (F2)
+7d: vhsubpd Vpd,Hpd,Wpd (66) | vhsubps Vps,Hps,Wps (F2)
+7e: movd/q Ey,Pd | vmovd/q Ey,Vy (66),(v1) | vmovq Vq,Wq (F3),(v1)
+7f: movq Qq,Pq | vmovdqa Wx,Vx (66) | vmovdqu Wx,Vx (F3)
 # 0x0f 0x80-0x8f
 80: JO Jz (f64)
 81: JNO Jz (f64)
-82: JB/JNAE/JC Jz (f64)
-83: JNB/JAE/JNC Jz (f64)
-84: JZ/JE Jz (f64)
-85: JNZ/JNE Jz (f64)
+82: JB/JC/JNAE Jz (f64)
+83: JAE/JNB/JNC Jz (f64)
+84: JE/JZ Jz (f64)
+85: JNE/JNZ Jz (f64)
 86: JBE/JNA Jz (f64)
-87: JNBE/JA Jz (f64)
+87: JA/JNBE Jz (f64)
 88: JS Jz (f64)
 89: JNS Jz (f64)
 8a: JP/JPE Jz (f64)
@@ -502,18 +517,18 @@ b8: JMPE | POPCNT Gv,Ev (F3)
 b9: Grp10 (1A)
 ba: Grp8 Ev,Ib (1A)
 bb: BTC Ev,Gv
-bc: BSF Gv,Ev
-bd: BSR Gv,Ev
+bc: BSF Gv,Ev | TZCNT Gv,Ev (F3)
+bd: BSR Gv,Ev | LZCNT Gv,Ev (F3)
 be: MOVSX Gv,Eb
 bf: MOVSX Gv,Ew
 # 0x0f 0xc0-0xcf
 c0: XADD Eb,Gb
 c1: XADD Ev,Gv
-c2: cmpps Vps,Wps,Ib (VEX) | cmpss Vss,Wss,Ib (F3),(VEX),(o128) | cmppd Vpd,Wpd,Ib (66),(VEX) | cmpsd Vsd,Wsd,Ib (F2),(VEX)
-c3: movnti Md/q,Gd/q
-c4: pinsrw Pq,Rd/q/Mw,Ib | pinsrw Vdq,Rd/q/Mw,Ib (66),(VEX),(o128)
-c5: pextrw Gd,Nq,Ib | pextrw Gd,Udq,Ib (66),(VEX),(o128)
-c6: shufps Vps,Wps,Ib (VEX) | shufpd Vpd,Wpd,Ib (66),(VEX)
+c2: vcmpps Vps,Hps,Wps,Ib | vcmppd Vpd,Hpd,Wpd,Ib (66) | vcmpss Vss,Hss,Wss,Ib (F3),(v1) | vcmpsd Vsd,Hsd,Wsd,Ib (F2),(v1)
+c3: movnti My,Gy
+c4: pinsrw Pq,Ry/Mw,Ib | vpinsrw Vdq,Hdq,Ry/Mw,Ib (66),(v1)
+c5: pextrw Gd,Nq,Ib | vpextrw Gd,Udq,Ib (66),(v1)
+c6: vshufps Vps,Hps,Wps,Ib | vshufpd Vpd,Hpd,Wpd,Ib (66)
 c7: Grp9 (1A)
 c8: BSWAP RAX/EAX/R8/R8D
 c9: BSWAP RCX/ECX/R9/R9D
@@ -524,55 +539,55 @@ cd: BSWAP RBP/EBP/R13/R13D
 ce: BSWAP RSI/ESI/R14/R14D
 cf: BSWAP RDI/EDI/R15/R15D
 # 0x0f 0xd0-0xdf
-d0: addsubps Vps,Wps (F2),(VEX) | addsubpd Vpd,Wpd (66),(VEX)
-d1: psrlw Pq,Qq | psrlw Vdq,Wdq (66),(VEX),(o128)
-d2: psrld Pq,Qq | psrld Vdq,Wdq (66),(VEX),(o128)
-d3: psrlq Pq,Qq | psrlq Vdq,Wdq (66),(VEX),(o128)
-d4: paddq Pq,Qq | paddq Vdq,Wdq (66),(VEX),(o128)
-d5: pmullw Pq,Qq | pmullw Vdq,Wdq (66),(VEX),(o128)
-d6: movq Wq,Vq (66),(VEX),(o128) | movq2dq Vdq,Nq (F3) | movdq2q Pq,Uq (F2)
-d7: pmovmskb Gd,Nq | pmovmskb Gd,Udq (66),(VEX),(o128)
-d8: psubusb Pq,Qq | psubusb Vdq,Wdq (66),(VEX),(o128)
-d9: psubusw Pq,Qq | psubusw Vdq,Wdq (66),(VEX),(o128)
-da: pminub Pq,Qq | pminub Vdq,Wdq (66),(VEX),(o128)
-db: pand Pq,Qq | pand Vdq,Wdq (66),(VEX),(o128)
-dc: paddusb Pq,Qq | paddusb Vdq,Wdq (66),(VEX),(o128)
-dd: paddusw Pq,Qq | paddusw Vdq,Wdq (66),(VEX),(o128)
-de: pmaxub Pq,Qq | pmaxub Vdq,Wdq (66),(VEX),(o128)
-df: pandn Pq,Qq | pandn Vdq,Wdq (66),(VEX),(o128)
+d0: vaddsubpd Vpd,Hpd,Wpd (66) | vaddsubps Vps,Hps,Wps (F2)
+d1: psrlw Pq,Qq | vpsrlw Vx,Hx,Wx (66),(v1)
+d2: psrld Pq,Qq | vpsrld Vx,Hx,Wx (66),(v1)
+d3: psrlq Pq,Qq | vpsrlq Vx,Hx,Wx (66),(v1)
+d4: paddq Pq,Qq | vpaddq Vx,Hx,Wx (66),(v1)
+d5: pmullw Pq,Qq | vpmullw Vx,Hx,Wx (66),(v1)
+d6: vmovq Wq,Vq (66),(v1) | movq2dq Vdq,Nq (F3) | movdq2q Pq,Uq (F2)
+d7: pmovmskb Gd,Nq | vpmovmskb Gd,Ux (66),(v1)
+d8: psubusb Pq,Qq | vpsubusb Vx,Hx,Wx (66),(v1)
+d9: psubusw Pq,Qq | vpsubusw Vx,Hx,Wx (66),(v1)
+da: pminub Pq,Qq | vpminub Vx,Hx,Wx (66),(v1)
+db: pand Pq,Qq | vpand Vx,Hx,Wx (66),(v1)
+dc: paddusb Pq,Qq | vpaddusb Vx,Hx,Wx (66),(v1)
+dd: paddusw Pq,Qq | vpaddusw Vx,Hx,Wx (66),(v1)
+de: pmaxub Pq,Qq | vpmaxub Vx,Hx,Wx (66),(v1)
+df: pandn Pq,Qq | vpandn Vx,Hx,Wx (66),(v1)
 # 0x0f 0xe0-0xef
-e0: pavgb Pq,Qq | pavgb Vdq,Wdq (66),(VEX),(o128)
-e1: psraw Pq,Qq | psraw Vdq,Wdq (66),(VEX),(o128)
-e2: psrad Pq,Qq | psrad Vdq,Wdq (66),(VEX),(o128)
-e3: pavgw Pq,Qq | pavgw Vdq,Wdq (66),(VEX),(o128)
-e4: pmulhuw Pq,Qq | pmulhuw Vdq,Wdq (66),(VEX),(o128)
-e5: pmulhw Pq,Qq | pmulhw Vdq,Wdq (66),(VEX),(o128)
-e6: cvtpd2dq Vdq,Wpd (F2),(VEX) | cvttpd2dq Vdq,Wpd (66),(VEX) | cvtdq2pd Vpd,Wdq (F3),(VEX)
-e7: movntq Mq,Pq | movntdq Mdq,Vdq (66),(VEX)
-e8: psubsb Pq,Qq | psubsb Vdq,Wdq (66),(VEX),(o128)
-e9: psubsw Pq,Qq | psubsw Vdq,Wdq (66),(VEX),(o128)
-ea: pminsw Pq,Qq | pminsw Vdq,Wdq (66),(VEX),(o128)
-eb: por Pq,Qq | por Vdq,Wdq (66),(VEX),(o128)
-ec: paddsb Pq,Qq | paddsb Vdq,Wdq (66),(VEX),(o128)
-ed: paddsw Pq,Qq | paddsw Vdq,Wdq (66),(VEX),(o128)
-ee: pmaxsw Pq,Qq | pmaxsw Vdq,Wdq (66),(VEX),(o128)
-ef: pxor Pq,Qq | pxor Vdq,Wdq (66),(VEX),(o128)
+e0: pavgb Pq,Qq | vpavgb Vx,Hx,Wx (66),(v1)
+e1: psraw Pq,Qq | vpsraw Vx,Hx,Wx (66),(v1)
+e2: psrad Pq,Qq | vpsrad Vx,Hx,Wx (66),(v1)
+e3: pavgw Pq,Qq | vpavgw Vx,Hx,Wx (66),(v1)
+e4: pmulhuw Pq,Qq | vpmulhuw Vx,Hx,Wx (66),(v1)
+e5: pmulhw Pq,Qq | vpmulhw Vx,Hx,Wx (66),(v1)
+e6: vcvttpd2dq Vx,Wpd (66) | vcvtdq2pd Vx,Wdq (F3) | vcvtpd2dq Vx,Wpd (F2)
+e7: movntq Mq,Pq | vmovntdq Mx,Vx (66)
+e8: psubsb Pq,Qq | vpsubsb Vx,Hx,Wx (66),(v1)
+e9: psubsw Pq,Qq | vpsubsw Vx,Hx,Wx (66),(v1)
+ea: pminsw Pq,Qq | vpminsw Vx,Hx,Wx (66),(v1)
+eb: por Pq,Qq | vpor Vx,Hx,Wx (66),(v1)
+ec: paddsb Pq,Qq | vpaddsb Vx,Hx,Wx (66),(v1)
+ed: paddsw Pq,Qq | vpaddsw Vx,Hx,Wx (66),(v1)
+ee: pmaxsw Pq,Qq | vpmaxsw Vx,Hx,Wx (66),(v1)
+ef: pxor Pq,Qq | vpxor Vx,Hx,Wx (66),(v1)
 # 0x0f 0xf0-0xff
-f0: lddqu Vdq,Mdq (F2),(VEX)
-f1: psllw Pq,Qq | psllw Vdq,Wdq (66),(VEX),(o128)
-f2: pslld Pq,Qq | pslld Vdq,Wdq (66),(VEX),(o128)
-f3: psllq Pq,Qq | psllq Vdq,Wdq (66),(VEX),(o128)
-f4: pmuludq Pq,Qq | pmuludq Vdq,Wdq (66),(VEX),(o128)
-f5: pmaddwd Pq,Qq | pmaddwd Vdq,Wdq (66),(VEX),(o128)
-f6: psadbw Pq,Qq | psadbw Vdq,Wdq (66),(VEX),(o128)
-f7: maskmovq Pq,Nq | maskmovdqu Vdq,Udq (66),(VEX),(o128)
-f8: psubb Pq,Qq | psubb Vdq,Wdq (66),(VEX),(o128)
-f9: psubw Pq,Qq | psubw Vdq,Wdq (66),(VEX),(o128)
-fa: psubd Pq,Qq | psubd Vdq,Wdq (66),(VEX),(o128)
-fb: psubq Pq,Qq | psubq Vdq,Wdq (66),(VEX),(o128)
-fc: paddb Pq,Qq | paddb Vdq,Wdq (66),(VEX),(o128)
-fd: paddw Pq,Qq | paddw Vdq,Wdq (66),(VEX),(o128)
-fe: paddd Pq,Qq | paddd Vdq,Wdq (66),(VEX),(o128)
+f0: vlddqu Vx,Mx (F2)
+f1: psllw Pq,Qq | vpsllw Vx,Hx,Wx (66),(v1)
+f2: pslld Pq,Qq | vpslld Vx,Hx,Wx (66),(v1)
+f3: psllq Pq,Qq | vpsllq Vx,Hx,Wx (66),(v1)
+f4: pmuludq Pq,Qq | vpmuludq Vx,Hx,Wx (66),(v1)
+f5: pmaddwd Pq,Qq | vpmaddwd Vx,Hx,Wx (66),(v1)
+f6: psadbw Pq,Qq | vpsadbw Vx,Hx,Wx (66),(v1)
+f7: maskmovq Pq,Nq | vmaskmovdqu Vx,Ux (66),(v1)
+f8: psubb Pq,Qq | vpsubb Vx,Hx,Wx (66),(v1)
+f9: psubw Pq,Qq | vpsubw Vx,Hx,Wx (66),(v1)
+fa: psubd Pq,Qq | vpsubd Vx,Hx,Wx (66),(v1)
+fb: psubq Pq,Qq | vpsubq Vx,Hx,Wx (66),(v1)
+fc: paddb Pq,Qq | vpaddb Vx,Hx,Wx (66),(v1)
+fd: paddw Pq,Qq | vpaddw Vx,Hx,Wx (66),(v1)
+fe: paddd Pq,Qq | vpaddd Vx,Hx,Wx (66),(v1)
 ff:
 EndTable
 
@@ -580,155 +595,193 @@ Table: 3-byte opcode 1 (0x0f 0x38)
 Referrer: 3-byte escape 1
 AVXcode: 2
 # 0x0f 0x38 0x00-0x0f
-00: pshufb Pq,Qq | pshufb Vdq,Wdq (66),(VEX),(o128)
-01: phaddw Pq,Qq | phaddw Vdq,Wdq (66),(VEX),(o128)
-02: phaddd Pq,Qq | phaddd Vdq,Wdq (66),(VEX),(o128)
-03: phaddsw Pq,Qq | phaddsw Vdq,Wdq (66),(VEX),(o128)
-04: pmaddubsw Pq,Qq | pmaddubsw Vdq,Wdq (66),(VEX),(o128)
-05: phsubw Pq,Qq | phsubw Vdq,Wdq (66),(VEX),(o128)
-06: phsubd Pq,Qq | phsubd Vdq,Wdq (66),(VEX),(o128)
-07: phsubsw Pq,Qq | phsubsw Vdq,Wdq (66),(VEX),(o128)
-08: psignb Pq,Qq | psignb Vdq,Wdq (66),(VEX),(o128)
-09: psignw Pq,Qq | psignw Vdq,Wdq (66),(VEX),(o128)
-0a: psignd Pq,Qq | psignd Vdq,Wdq (66),(VEX),(o128)
-0b: pmulhrsw Pq,Qq | pmulhrsw Vdq,Wdq (66),(VEX),(o128)
-0c: Vpermilps /r (66),(oVEX)
-0d: Vpermilpd /r (66),(oVEX)
-0e: vtestps /r (66),(oVEX)
-0f: vtestpd /r (66),(oVEX)
+00: pshufb Pq,Qq | vpshufb Vx,Hx,Wx (66),(v1)
+01: phaddw Pq,Qq | vphaddw Vx,Hx,Wx (66),(v1)
+02: phaddd Pq,Qq | vphaddd Vx,Hx,Wx (66),(v1)
+03: phaddsw Pq,Qq | vphaddsw Vx,Hx,Wx (66),(v1)
+04: pmaddubsw Pq,Qq | vpmaddubsw Vx,Hx,Wx (66),(v1)
+05: phsubw Pq,Qq | vphsubw Vx,Hx,Wx (66),(v1)
+06: phsubd Pq,Qq | vphsubd Vx,Hx,Wx (66),(v1)
+07: phsubsw Pq,Qq | vphsubsw Vx,Hx,Wx (66),(v1)
+08: psignb Pq,Qq | vpsignb Vx,Hx,Wx (66),(v1)
+09: psignw Pq,Qq | vpsignw Vx,Hx,Wx (66),(v1)
+0a: psignd Pq,Qq | vpsignd Vx,Hx,Wx (66),(v1)
+0b: pmulhrsw Pq,Qq | vpmulhrsw Vx,Hx,Wx (66),(v1)
+0c: vpermilps Vx,Hx,Wx (66),(v)
+0d: vpermilpd Vx,Hx,Wx (66),(v)
+0e: vtestps Vx,Wx (66),(v)
+0f: vtestpd Vx,Wx (66),(v)
 # 0x0f 0x38 0x10-0x1f
 10: pblendvb Vdq,Wdq (66)
 11:
 12:
-13:
+13: vcvtph2ps Vx,Wx,Ib (66),(v)
 14: blendvps Vdq,Wdq (66)
 15: blendvpd Vdq,Wdq (66)
-16:
-17: ptest Vdq,Wdq (66),(VEX)
-18: vbroadcastss /r (66),(oVEX)
-19: vbroadcastsd /r (66),(oVEX),(o256)
-1a: vbroadcastf128 /r (66),(oVEX),(o256)
+16: vpermps Vqq,Hqq,Wqq (66),(v)
+17: vptest Vx,Wx (66)
+18: vbroadcastss Vx,Wd (66),(v)
+19: vbroadcastsd Vqq,Wq (66),(v)
+1a: vbroadcastf128 Vqq,Mdq (66),(v)
 1b:
-1c: pabsb Pq,Qq | pabsb Vdq,Wdq (66),(VEX),(o128)
-1d: pabsw Pq,Qq | pabsw Vdq,Wdq (66),(VEX),(o128)
-1e: pabsd Pq,Qq | pabsd Vdq,Wdq (66),(VEX),(o128)
+1c: pabsb Pq,Qq | vpabsb Vx,Wx (66),(v1)
+1d: pabsw Pq,Qq | vpabsw Vx,Wx (66),(v1)
+1e: pabsd Pq,Qq | vpabsd Vx,Wx (66),(v1)
 1f:
 # 0x0f 0x38 0x20-0x2f
-20: pmovsxbw Vdq,Udq/Mq (66),(VEX),(o128)
-21: pmovsxbd Vdq,Udq/Md (66),(VEX),(o128)
-22: pmovsxbq Vdq,Udq/Mw (66),(VEX),(o128)
-23: pmovsxwd Vdq,Udq/Mq (66),(VEX),(o128)
-24: pmovsxwq Vdq,Udq/Md (66),(VEX),(o128)
-25: pmovsxdq Vdq,Udq/Mq (66),(VEX),(o128)
+20: vpmovsxbw Vx,Ux/Mq (66),(v1)
+21: vpmovsxbd Vx,Ux/Md (66),(v1)
+22: vpmovsxbq Vx,Ux/Mw (66),(v1)
+23: vpmovsxwd Vx,Ux/Mq (66),(v1)
+24: vpmovsxwq Vx,Ux/Md (66),(v1)
+25: vpmovsxdq Vx,Ux/Mq (66),(v1)
 26:
 27:
-28: pmuldq Vdq,Wdq (66),(VEX),(o128)
-29: pcmpeqq Vdq,Wdq (66),(VEX),(o128)
-2a: movntdqa Vdq,Mdq (66),(VEX),(o128)
-2b: packusdw Vdq,Wdq (66),(VEX),(o128)
-2c: vmaskmovps(ld) /r (66),(oVEX)
-2d: vmaskmovpd(ld) /r (66),(oVEX)
-2e: vmaskmovps(st) /r (66),(oVEX)
-2f: vmaskmovpd(st) /r (66),(oVEX)
+28: vpmuldq Vx,Hx,Wx (66),(v1)
+29: vpcmpeqq Vx,Hx,Wx (66),(v1)
+2a: vmovntdqa Vx,Mx (66),(v1)
+2b: vpackusdw Vx,Hx,Wx (66),(v1)
+2c: vmaskmovps Vx,Hx,Mx (66),(v)
+2d: vmaskmovpd Vx,Hx,Mx (66),(v)
+2e: vmaskmovps Mx,Hx,Vx (66),(v)
+2f: vmaskmovpd Mx,Hx,Vx (66),(v)
 # 0x0f 0x38 0x30-0x3f
-30: pmovzxbw Vdq,Udq/Mq (66),(VEX),(o128)
-31: pmovzxbd Vdq,Udq/Md (66),(VEX),(o128)
-32: pmovzxbq Vdq,Udq/Mw (66),(VEX),(o128)
-33: pmovzxwd Vdq,Udq/Mq (66),(VEX),(o128)
-34: pmovzxwq Vdq,Udq/Md (66),(VEX),(o128)
-35: pmovzxdq Vdq,Udq/Mq (66),(VEX),(o128)
-36:
-37: pcmpgtq Vdq,Wdq (66),(VEX),(o128)
-38: pminsb Vdq,Wdq (66),(VEX),(o128)
-39: pminsd Vdq,Wdq (66),(VEX),(o128)
-3a: pminuw Vdq,Wdq (66),(VEX),(o128)
-3b: pminud Vdq,Wdq (66),(VEX),(o128)
-3c: pmaxsb Vdq,Wdq (66),(VEX),(o128)
-3d: pmaxsd Vdq,Wdq (66),(VEX),(o128)
-3e: pmaxuw Vdq,Wdq (66),(VEX),(o128)
-3f: pmaxud Vdq,Wdq (66),(VEX),(o128)
+30: vpmovzxbw Vx,Ux/Mq (66),(v1)
+31: vpmovzxbd Vx,Ux/Md (66),(v1)
+32: vpmovzxbq Vx,Ux/Mw (66),(v1)
+33: vpmovzxwd Vx,Ux/Mq (66),(v1)
+34: vpmovzxwq Vx,Ux/Md (66),(v1)
+35: vpmovzxdq Vx,Ux/Mq (66),(v1)
+36: vpermd Vqq,Hqq,Wqq (66),(v)
+37: vpcmpgtq Vx,Hx,Wx (66),(v1)
+38: vpminsb Vx,Hx,Wx (66),(v1)
+39: vpminsd Vx,Hx,Wx (66),(v1)
+3a: vpminuw Vx,Hx,Wx (66),(v1)
+3b: vpminud Vx,Hx,Wx (66),(v1)
+3c: vpmaxsb Vx,Hx,Wx (66),(v1)
+3d: vpmaxsd Vx,Hx,Wx (66),(v1)
+3e: vpmaxuw Vx,Hx,Wx (66),(v1)
+3f: vpmaxud Vx,Hx,Wx (66),(v1)
 # 0x0f 0x38 0x40-0x8f
-40: pmulld Vdq,Wdq (66),(VEX),(o128)
-41: phminposuw Vdq,Wdq (66),(VEX),(o128)
-80: INVEPT Gd/q,Mdq (66)
-81: INVPID Gd/q,Mdq (66)
+40: vpmulld Vx,Hx,Wx (66),(v1)
+41: vphminposuw Vdq,Wdq (66),(v1)
+42:
+43:
+44:
+45: vpsrlvd/q Vx,Hx,Wx (66),(v)
+46: vpsravd Vx,Hx,Wx (66),(v)
+47: vpsllvd/q Vx,Hx,Wx (66),(v)
+# Skip 0x48-0x57
+58: vpbroadcastd Vx,Wx (66),(v)
+59: vpbroadcastq Vx,Wx (66),(v)
+5a: vbroadcasti128 Vqq,Mdq (66),(v)
+# Skip 0x5b-0x77
+78: vpbroadcastb Vx,Wx (66),(v)
+79: vpbroadcastw Vx,Wx (66),(v)
+# Skip 0x7a-0x7f
+80: INVEPT Gy,Mdq (66)
+81: INVPID Gy,Mdq (66)
+82: INVPCID Gy,Mdq (66)
+8c: vpmaskmovd/q Vx,Hx,Mx (66),(v)
+8e: vpmaskmovd/q Mx,Vx,Hx (66),(v)
 # 0x0f 0x38 0x90-0xbf (FMA)
-96: vfmaddsub132pd/ps /r (66),(VEX)
-97: vfmsubadd132pd/ps /r (66),(VEX)
-98: vfmadd132pd/ps /r (66),(VEX)
-99: vfmadd132sd/ss /r (66),(VEX),(o128)
-9a: vfmsub132pd/ps /r (66),(VEX)
-9b: vfmsub132sd/ss /r (66),(VEX),(o128)
-9c: vfnmadd132pd/ps /r (66),(VEX)
-9d: vfnmadd132sd/ss /r (66),(VEX),(o128)
-9e: vfnmsub132pd/ps /r (66),(VEX)
-9f: vfnmsub132sd/ss /r (66),(VEX),(o128)
-a6: vfmaddsub213pd/ps /r (66),(VEX)
-a7: vfmsubadd213pd/ps /r (66),(VEX)
-a8: vfmadd213pd/ps /r (66),(VEX)
-a9: vfmadd213sd/ss /r (66),(VEX),(o128)
-aa: vfmsub213pd/ps /r (66),(VEX)
-ab: vfmsub213sd/ss /r (66),(VEX),(o128)
-ac: vfnmadd213pd/ps /r (66),(VEX)
-ad: vfnmadd213sd/ss /r (66),(VEX),(o128)
-ae: vfnmsub213pd/ps /r (66),(VEX)
-af: vfnmsub213sd/ss /r (66),(VEX),(o128)
-b6: vfmaddsub231pd/ps /r (66),(VEX)
-b7: vfmsubadd231pd/ps /r (66),(VEX)
-b8: vfmadd231pd/ps /r (66),(VEX)
-b9: vfmadd231sd/ss /r (66),(VEX),(o128)
-ba: vfmsub231pd/ps /r (66),(VEX)
-bb: vfmsub231sd/ss /r (66),(VEX),(o128)
-bc: vfnmadd231pd/ps /r (66),(VEX)
-bd: vfnmadd231sd/ss /r (66),(VEX),(o128)
-be: vfnmsub231pd/ps /r (66),(VEX)
-bf: vfnmsub231sd/ss /r (66),(VEX),(o128)
+90: vgatherdd/q Vx,Hx,Wx (66),(v)
+91: vgatherqd/q Vx,Hx,Wx (66),(v)
+92: vgatherdps/d Vx,Hx,Wx (66),(v)
+93: vgatherqps/d Vx,Hx,Wx (66),(v)
+94:
+95:
+96: vfmaddsub132ps/d Vx,Hx,Wx (66),(v)
+97: vfmsubadd132ps/d Vx,Hx,Wx (66),(v)
+98: vfmadd132ps/d Vx,Hx,Wx (66),(v)
+99: vfmadd132ss/d Vx,Hx,Wx (66),(v),(v1)
+9a: vfmsub132ps/d Vx,Hx,Wx (66),(v)
+9b: vfmsub132ss/d Vx,Hx,Wx (66),(v),(v1)
+9c: vfnmadd132ps/d Vx,Hx,Wx (66),(v)
+9d: vfnmadd132ss/d Vx,Hx,Wx (66),(v),(v1)
+9e: vfnmsub132ps/d Vx,Hx,Wx (66),(v)
+9f: vfnmsub132ss/d Vx,Hx,Wx (66),(v),(v1)
+a6: vfmaddsub213ps/d Vx,Hx,Wx (66),(v)
+a7: vfmsubadd213ps/d Vx,Hx,Wx (66),(v)
+a8: vfmadd213ps/d Vx,Hx,Wx (66),(v)
+a9: vfmadd213ss/d Vx,Hx,Wx (66),(v),(v1)
+aa: vfmsub213ps/d Vx,Hx,Wx (66),(v)
+ab: vfmsub213ss/d Vx,Hx,Wx (66),(v),(v1)
+ac: vfnmadd213ps/d Vx,Hx,Wx (66),(v)
+ad: vfnmadd213ss/d Vx,Hx,Wx (66),(v),(v1)
+ae: vfnmsub213ps/d Vx,Hx,Wx (66),(v)
+af: vfnmsub213ss/d Vx,Hx,Wx (66),(v),(v1)
+b6: vfmaddsub231ps/d Vx,Hx,Wx (66),(v)
+b7: vfmsubadd231ps/d Vx,Hx,Wx (66),(v)
+b8: vfmadd231ps/d Vx,Hx,Wx (66),(v)
+b9: vfmadd231ss/d Vx,Hx,Wx (66),(v),(v1)
+ba: vfmsub231ps/d Vx,Hx,Wx (66),(v)
+bb: vfmsub231ss/d Vx,Hx,Wx (66),(v),(v1)
+bc: vfnmadd231ps/d Vx,Hx,Wx (66),(v)
+bd: vfnmadd231ss/d Vx,Hx,Wx (66),(v),(v1)
+be: vfnmsub231ps/d Vx,Hx,Wx (66),(v)
+bf: vfnmsub231ss/d Vx,Hx,Wx (66),(v),(v1)
 # 0x0f 0x38 0xc0-0xff
-db: aesimc Vdq,Wdq (66),(VEX),(o128)
-dc: aesenc Vdq,Wdq (66),(VEX),(o128)
-dd: aesenclast Vdq,Wdq (66),(VEX),(o128)
-de: aesdec Vdq,Wdq (66),(VEX),(o128)
-df: aesdeclast Vdq,Wdq (66),(VEX),(o128)
-f0: MOVBE Gv,Mv | CRC32 Gd,Eb (F2)
-f1: MOVBE Mv,Gv | CRC32 Gd,Ev (F2)
+db: VAESIMC Vdq,Wdq (66),(v1)
+dc: VAESENC Vdq,Hdq,Wdq (66),(v1)
+dd: VAESENCLAST Vdq,Hdq,Wdq (66),(v1)
+de: VAESDEC Vdq,Hdq,Wdq (66),(v1)
+df: VAESDECLAST Vdq,Hdq,Wdq (66),(v1)
+f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2)
+f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2)
+f3: ANDN Gy,By,Ey (v)
+f4: Grp17 (1A)
+f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v)
+f6: MULX By,Gy,rDX,Ey (F2),(v)
+f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 EndTable
 
 Table: 3-byte opcode 2 (0x0f 0x3a)
 Referrer: 3-byte escape 2
 AVXcode: 3
 # 0x0f 0x3a 0x00-0xff
-04: vpermilps /r,Ib (66),(oVEX)
-05: vpermilpd /r,Ib (66),(oVEX)
-06: vperm2f128 /r,Ib (66),(oVEX),(o256)
-08: roundps Vdq,Wdq,Ib (66),(VEX)
-09: roundpd Vdq,Wdq,Ib (66),(VEX)
-0a: roundss Vss,Wss,Ib (66),(VEX),(o128)
-0b: roundsd Vsd,Wsd,Ib (66),(VEX),(o128)
-0c: blendps Vdq,Wdq,Ib (66),(VEX)
-0d: blendpd Vdq,Wdq,Ib (66),(VEX)
-0e: pblendw Vdq,Wdq,Ib (66),(VEX),(o128)
-0f: palignr Pq,Qq,Ib | palignr Vdq,Wdq,Ib (66),(VEX),(o128)
-14: pextrb Rd/Mb,Vdq,Ib (66),(VEX),(o128)
-15: pextrw Rd/Mw,Vdq,Ib (66),(VEX),(o128)
-16: pextrd/pextrq Ed/q,Vdq,Ib (66),(VEX),(o128)
-17: extractps Ed,Vdq,Ib (66),(VEX),(o128)
-18: vinsertf128 /r,Ib (66),(oVEX),(o256)
-19: vextractf128 /r,Ib (66),(oVEX),(o256)
-20: pinsrb Vdq,Rd/q/Mb,Ib (66),(VEX),(o128)
-21: insertps Vdq,Udq/Md,Ib (66),(VEX),(o128)
-22: pinsrd/pinsrq Vdq,Ed/q,Ib (66),(VEX),(o128)
-40: dpps Vdq,Wdq,Ib (66),(VEX)
-41: dppd Vdq,Wdq,Ib (66),(VEX),(o128)
-42: mpsadbw Vdq,Wdq,Ib (66),(VEX),(o128)
-44: pclmulq Vdq,Wdq,Ib (66),(VEX),(o128)
-4a: vblendvps /r,Ib (66),(oVEX)
-4b: vblendvpd /r,Ib (66),(oVEX)
-4c: vpblendvb /r,Ib (66),(oVEX),(o128)
-60: pcmpestrm Vdq,Wdq,Ib (66),(VEX),(o128)
-61: pcmpestri Vdq,Wdq,Ib (66),(VEX),(o128)
-62: pcmpistrm Vdq,Wdq,Ib (66),(VEX),(o128)
-63: pcmpistri Vdq,Wdq,Ib (66),(VEX),(o128)
-df: aeskeygenassist Vdq,Wdq,Ib (66),(VEX),(o128)
+00: vpermq Vqq,Wqq,Ib (66),(v)
+01: vpermpd Vqq,Wqq,Ib (66),(v)
+02: vpblendd Vx,Hx,Wx,Ib (66),(v)
+03:
+04: vpermilps Vx,Wx,Ib (66),(v)
+05: vpermilpd Vx,Wx,Ib (66),(v)
+06: vperm2f128 Vqq,Hqq,Wqq,Ib (66),(v)
+07:
+08: vroundps Vx,Wx,Ib (66)
+09: vroundpd Vx,Wx,Ib (66)
+0a: vroundss Vss,Wss,Ib (66),(v1)
+0b: vroundsd Vsd,Wsd,Ib (66),(v1)
+0c: vblendps Vx,Hx,Wx,Ib (66)
+0d: vblendpd Vx,Hx,Wx,Ib (66)
+0e: vpblendw Vx,Hx,Wx,Ib (66),(v1)
+0f: palignr Pq,Qq,Ib | vpalignr Vx,Hx,Wx,Ib (66),(v1)
+14: vpextrb Rd/Mb,Vdq,Ib (66),(v1)
+15: vpextrw Rd/Mw,Vdq,Ib (66),(v1)
+16: vpextrd/q Ey,Vdq,Ib (66),(v1)
+17: vextractps Ed,Vdq,Ib (66),(v1)
+18: vinsertf128 Vqq,Hqq,Wqq,Ib (66),(v)
+19: vextractf128 Wdq,Vqq,Ib (66),(v)
+1d: vcvtps2ph Wx,Vx,Ib (66),(v)
+20: vpinsrb Vdq,Hdq,Ry/Mb,Ib (66),(v1)
+21: vinsertps Vdq,Hdq,Udq/Md,Ib (66),(v1)
+22: vpinsrd/q Vdq,Hdq,Ey,Ib (66),(v1)
+38: vinserti128 Vqq,Hqq,Wqq,Ib (66),(v)
+39: vextracti128 Wdq,Vqq,Ib (66),(v)
+40: vdpps Vx,Hx,Wx,Ib (66)
+41: vdppd Vdq,Hdq,Wdq,Ib (66),(v1)
+42: vmpsadbw Vx,Hx,Wx,Ib (66),(v1)
+44: vpclmulqdq Vdq,Hdq,Wdq,Ib (66),(v1)
+46: vperm2i128 Vqq,Hqq,Wqq,Ib (66),(v)
+4a: vblendvps Vx,Hx,Wx,Lx (66),(v)
+4b: vblendvpd Vx,Hx,Wx,Lx (66),(v)
+4c: vpblendvb Vx,Hx,Wx,Lx (66),(v1)
+60: vpcmpestrm Vdq,Wdq,Ib (66),(v1)
+61: vpcmpestri Vdq,Wdq,Ib (66),(v1)
+62: vpcmpistrm Vdq,Wdq,Ib (66),(v1)
+63: vpcmpistri Vdq,Wdq,Ib (66),(v1)
+df: VAESKEYGEN Vdq,Wdq,Ib (66),(v1)
+f0: RORX Gy,Ey,Ib (F2),(v)
 EndTable
 
 GrpTable: Grp1
@@ -790,7 +843,7 @@ GrpTable: Grp5
 2: CALLN Ev (f64)
 3: CALLF Ep
 4: JMPN Ev (f64)
-5: JMPF Ep
+5: JMPF Mp
 6: PUSH Ev (d64)
 7:
 EndTable
@@ -807,7 +860,7 @@ EndTable
 GrpTable: Grp7
 0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B)
 1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001)
-2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B)
+2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
 5:
@@ -824,44 +877,45 @@ EndTable
 
 GrpTable: Grp9
 1: CMPXCHG8B/16B Mq/Mdq
-6: VMPTRLD Mq | VMCLEAR Mq (66) | VMXON Mq (F3)
-7: VMPTRST Mq
+6: VMPTRLD Mq | VMCLEAR Mq (66) | VMXON Mq (F3) | RDRAND Rv (11B)
+7: VMPTRST Mq | VMPTRST Mq (F3)
 EndTable
 
 GrpTable: Grp10
 EndTable
 
 GrpTable: Grp11
+# Note: the operands are given by group opcode
 0: MOV
 EndTable
 
 GrpTable: Grp12
-2: psrlw Nq,Ib (11B) | psrlw Udq,Ib (66),(11B),(VEX),(o128)
-4: psraw Nq,Ib (11B) | psraw Udq,Ib (66),(11B),(VEX),(o128)
-6: psllw Nq,Ib (11B) | psllw Udq,Ib (66),(11B),(VEX),(o128)
+2: psrlw Nq,Ib (11B) | vpsrlw Hx,Ux,Ib (66),(11B),(v1)
+4: psraw Nq,Ib (11B) | vpsraw Hx,Ux,Ib (66),(11B),(v1)
+6: psllw Nq,Ib (11B) | vpsllw Hx,Ux,Ib (66),(11B),(v1)
 EndTable
 
 GrpTable: Grp13
-2: psrld Nq,Ib (11B) | psrld Udq,Ib (66),(11B),(VEX),(o128)
-4: psrad Nq,Ib (11B) | psrad Udq,Ib (66),(11B),(VEX),(o128)
-6: pslld Nq,Ib (11B) | pslld Udq,Ib (66),(11B),(VEX),(o128)
+2: psrld Nq,Ib (11B) | vpsrld Hx,Ux,Ib (66),(11B),(v1)
+4: psrad Nq,Ib (11B) | vpsrad Hx,Ux,Ib (66),(11B),(v1)
+6: pslld Nq,Ib (11B) | vpslld Hx,Ux,Ib (66),(11B),(v1)
 EndTable
 
 GrpTable: Grp14
-2: psrlq Nq,Ib (11B) | psrlq Udq,Ib (66),(11B),(VEX),(o128)
-3: psrldq Udq,Ib (66),(11B),(VEX),(o128)
-6: psllq Nq,Ib (11B) | psllq Udq,Ib (66),(11B),(VEX),(o128)
-7: pslldq Udq,Ib (66),(11B),(VEX),(o128)
+2: psrlq Nq,Ib (11B) | vpsrlq Hx,Ux,Ib (66),(11B),(v1)
+3: vpsrldq Hx,Ux,Ib (66),(11B),(v1)
+6: psllq Nq,Ib (11B) | vpsllq Hx,Ux,Ib (66),(11B),(v1)
+7: vpslldq Hx,Ux,Ib (66),(11B),(v1)
 EndTable
 
 GrpTable: Grp15
-0: fxsave
-1: fxstor
-2: ldmxcsr (VEX)
-3: stmxcsr (VEX)
+0: fxsave | RDFSBASE Ry (F3),(11B)
+1: fxstor | RDGSBASE Ry (F3),(11B)
+2: vldmxcsr Md (v1) | WRFSBASE Ry (F3),(11B)
+3: vstmxcsr Md (v1) | WRGSBASE Ry (F3),(11B)
 4: XSAVE
 5: XRSTOR | lfence (11B)
-6: mfence (11B)
+6: XSAVEOPT | mfence (11B)
 7: clflush | sfence (11B)
 EndTable
 
@@ -872,6 +926,12 @@ GrpTable: Grp16
 3: prefetch T2
 EndTable
 
+GrpTable: Grp17
+1: BLSR By,Ey (v)
+2: BLSMSK By,Ey (v)
+3: BLSI By,Ey (v)
+EndTable
+
 # AMD's Prefetch Group
 GrpTable: GrpP
 0: PREFETCH
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index eaf11f5..5f6a5b6 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -47,7 +47,7 @@ BEGIN {
 	sep_expr = "^\\|$"
 	group_expr = "^Grp[0-9A-Za-z]+"
 
-	imm_expr = "^[IJAO][a-z]"
+	imm_expr = "^[IJAOL][a-z]"
 	imm_flag["Ib"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Jb"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Iw"] = "INAT_MAKE_IMM(INAT_IMM_WORD)"
@@ -59,6 +59,7 @@ BEGIN {
 	imm_flag["Iv"] = "INAT_MAKE_IMM(INAT_IMM_VWORD)"
 	imm_flag["Ob"] = "INAT_MOFFSET"
 	imm_flag["Ov"] = "INAT_MOFFSET"
+	imm_flag["Lx"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 
 	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
 	force64_expr = "\\([df]64\\)"
@@ -70,8 +71,12 @@ BEGIN {
 	lprefix3_expr = "\\(F2\\)"
 	max_lprefix = 4
 
-	vexok_expr = "\\(VEX\\)"
-	vexonly_expr = "\\(oVEX\\)"
+	# All opcodes starting with lower-case 'v' or with (v1) superscript
+	# accepts VEX prefix
+	vexok_opcode_expr = "^v.*"
+	vexok_expr = "\\(v1\\)"
+	# All opcodes with (v) superscript supports *only* VEX prefix
+	vexonly_expr = "\\(v\\)"
 
 	prefix_expr = "\\(Prefix\\)"
 	prefix_num["Operand-Size"] = "INAT_PFX_OPNDSZ"
@@ -85,8 +90,8 @@ BEGIN {
 	prefix_num["SEG=GS"] = "INAT_PFX_GS"
 	prefix_num["SEG=SS"] = "INAT_PFX_SS"
 	prefix_num["Address-Size"] = "INAT_PFX_ADDRSZ"
-	prefix_num["2bytes-VEX"] = "INAT_PFX_VEX2"
-	prefix_num["3bytes-VEX"] = "INAT_PFX_VEX3"
+	prefix_num["VEX+1byte"] = "INAT_PFX_VEX2"
+	prefix_num["VEX+2byte"] = "INAT_PFX_VEX3"
 
 	clear_vars()
 }
@@ -310,12 +315,10 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 		if (match(opcode, fpu_expr))
 			flags = add_flags(flags, "INAT_MODRM")
 
-		# check VEX only code
+		# check VEX codes
 		if (match(ext, vexonly_expr))
 			flags = add_flags(flags, "INAT_VEXOK | INAT_VEXONLY")
-
-		# check VEX only code
-		if (match(ext, vexok_expr))
+		else if (match(ext, vexok_expr) || match(opcode, vexok_opcode_expr))
 			flags = add_flags(flags, "INAT_VEXOK")
 
 		# check prefixes

