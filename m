Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab1L2C23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 21:28:29 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:50572 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1L2C21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 21:28:27 -0500
X-Greylist: delayed 1652 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Dec 2011 21:28:27 EST
Message-ID: <4EFBC973.1040905@tu-ilmenau.de>
Date: Thu, 29 Dec 2011 02:59:15 +0100
From: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
Reply-To: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= 
	  <stephan.baerwolf@tu-ilmenau.de>
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111201 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: KVM guest-kernel panics double fault
X-Enigmail-Version: 1.3.3
Content-Type: multipart/mixed;
 boundary="------------050105010703020204030609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050105010703020204030609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hello guys,

I am sorry to disturb you this short before New Year, but I think this
shouldn't wait until next year.

After experiencing crashes in virtual maschines and considering kernel /
qemu / kvm / cpu -bugs, I discovered the following (see patch) issue.
Because unpriviledged users can crash VMs, I think it is a serious one
and needs short-term attention.

The patch I wrote is against 3.2-rc7 but I always tested with linux 3.1.6.
Hopfully it solve the problems to your satisfaction.

regards and a happy new year,
    Stephan Bärwolf




Subject: [PATCH] KVM: fix missing "illegal instruction"-trap in guests
within non-64bit protected modes

On hosts without this patch, 32bit guests will crash for
example by simply executing following nasm-demo-application:

        [bits 32]
        global _start
        SECTION .text
        _start: syscall

(I am not sure if this can be exploited in more worse ways,
like breaking out of VMs in more complex szenarios?
But I tested it with win32 and linux - both always crashed)

        Disassembly of section .text:

        00000000 <_start>:
           0:   0f 05                   syscall

The reason seems a missing "invalid opcode"-trap (int6) for the
syscall opcode "0f05", which is not available on 32bit cpus.
Intel's "Intel 64 and IA-32 Architecture Software Developers
Manual" (http://www.intel.com/content/dam/doc/manual/
64-ia-32-architectures-software-developer-manual-325462.pdf)
documents on page 1804 (4-586) "syscall" is only available
in 64bit longmode. So "syscall" must trap in real- and
virtual 8086 -mode, as also in all non-64bit protected-modes.

The last ones (16 & 32bit protected mode) are not beeing checked
by kvm and so causing a missing trap as an double-fault-panic
on 32bit guests.

Also an initially not observed problem can be explained
with this bug:
On 64bit guests (x86_64) 32bit compat-programs are able to
syscall their kernel via "0f05" correctly, althought native
(not virtualized) systems would also trap!

This patch solves the described problem by extending the
checking of cpu's operational mode.

Screenshots of a i686 testing VM  before and after applying
this patch are available under:

http://matrixstorm.com/software/linux/kvm/20111229/before.jpg
http://matrixstorm.com/software/linux/kvm/20111229/after.jpg



--------------050105010703020204030609
Content-Type: text/x-patch;
 name="0001-KVM-fix-missing-illegal-instruction-trap-in-guests-w.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-KVM-fix-missing-illegal-instruction-trap-in-guests-w.pa";
 filename*1="tch"

>From 4de09b4bdba4927b8e248daa1bbfacaf3752fb6e Mon Sep 17 00:00:00 2001
From: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Date: Thu, 29 Dec 2011 00:50:46 +0000
Subject: [PATCH] KVM: fix missing "illegal instruction"-trap in guests within non-64bit protected modes

On hosts without this patch, 32bit guests will crash for
example by simply executing following nasm-demo-application:

	[bits 32]
	global _start
	SECTION .text
	_start: syscall

(I am not sure if this can be exploited in more worse ways,
like breaking out of VMs in more complex szenarios?
But I tested it with win32 and linux - both always crashed)

	Disassembly of section .text:

	00000000 <_start>:
	   0:   0f 05                   syscall

The reason seems a missing "invalid opcode"-trap (int6) for the
syscall opcode "0f05", which is not available on 32bit cpus.
Intel's "Intel 64 and IA-32 Architecture Software Developers
Manual" (http://www.intel.com/content/dam/doc/manual/
64-ia-32-architectures-software-developer-manual-325462.pdf)
documents on page 1804 (4-586) "syscall" is only available
in 64bit longmode. So "syscall" must trap in real- and
virtual 8086 -mode, as also in all non-64bit protected-modes.

The last ones (16 & 32bit protected mode) are not beeing checked
by kvm and so causing a missing trap as an double-fault-panic
on 32bit guests.

Also an initially not observed problem can be explained
with this bug:
On 64bit guests (x86_64) 32bit compat-programs are able to
syscall their kernel via "0f05" correctly, althought native
(not virtualized) systems would also trap!

This patch solves the described problem by extending the
checking of cpu's operational mode.

Screenshots of a i686 testing VM  before and after applying
this patch are available under:

http://matrixstorm.com/software/linux/kvm/20111229/before.jpg
http://matrixstorm.com/software/linux/kvm/20111229/after.jpg

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
---
 arch/x86/kvm/emulate.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f1e3be1..60f6ffc 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1886,7 +1886,15 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
 	u64 efer = 0;
 
 	/* syscall is not available in real mode */
+	/* 
+	   "0f05" is also not available in
+	   all non-64-bit protected modes (16&
+	   32bit) or virtual 8086 mode		 
+	   Only 64bit longmode supports this opcode
+	*/
 	if (ctxt->mode == X86EMUL_MODE_REAL ||
+	    ctxt->mode == X86EMUL_MODE_PROT16 ||
+	    ctxt->mode == X86EMUL_MODE_PROT32 ||
 	    ctxt->mode == X86EMUL_MODE_VM86)
 		return emulate_ud(ctxt);
 
-- 
1.7.3.4


--------------050105010703020204030609--
