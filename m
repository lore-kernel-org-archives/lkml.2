Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2HTEB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:01:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab2HTEBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [ 43/46] KVM: x86 emulator: fix byte-sized MOVZX/MOVSX
Date: Sun, 19 Aug 2012 20:59:19 -0700
Message-Id: <20120820035838.239345023@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 361cad2b50a2c92b91b6f568db860fabad3bf149)

Commit 2adb5ad9fe1 removed ByteOp from MOVZX/MOVSX, replacing them by
SrcMem8, but neglected to fix the dependency in the emulation code
on ByteOp.  This caused the instruction not to have any effect in
some circumstances.

Fix by replacing the check for ByteOp with the equivalent src.op_bytes == 1.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4426,12 +4426,12 @@ twobyte_insn:
 		break;
 	case 0xb6 ... 0xb7:	/* movzx */
 		ctxt->dst.bytes = ctxt->op_bytes;
-		ctxt->dst.val = (ctxt->d & ByteOp) ? (u8) ctxt->src.val
+		ctxt->dst.val = (ctxt->src.bytes == 1) ? (u8) ctxt->src.val
 						       : (u16) ctxt->src.val;
 		break;
 	case 0xbe ... 0xbf:	/* movsx */
 		ctxt->dst.bytes = ctxt->op_bytes;
-		ctxt->dst.val = (ctxt->d & ByteOp) ? (s8) ctxt->src.val :
+		ctxt->dst.val = (ctxt->src.bytes == 1) ? (s8) ctxt->src.val :
 							(s16) ctxt->src.val;
 		break;
 	case 0xc0 ... 0xc1:	/* xadd */


