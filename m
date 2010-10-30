Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0J3Szb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:55:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48059 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab0J3Sz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i80LxFFw2jIYGz5lVJpPROKBzCRbOP3oXz7bo28hQ92GxvBwbx/Q+uhzR88NmnxlCD
         YTWUrqJOv5llTYtf+KtewosF9MntltiQ528EFRTPpWvpGQ85uhLmF/RFkQXX+3GxzKzV
         Q8oWphoYUGu2o0f/nSygnSHpRoFg5e/m+UMKI=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] powerpc: kvm: powerpc: fix information leak to userland
Date: Sat, 30 Oct 2010 22:55:22 +0400
Message-Id: <1288464922-8812-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure kvm_ppc_pvinfo is copied to userland with "flags" and "pad"
fields unitialized.  It leads to leaking of contents of kernel stack
memory.  We have to initialize them to zero.

In patch v1 Jan Kiszka suggested to fill reserved fields with zeros
instead of memset'ting the whole struct.  It makes sense as these
fields are explicitly marked as padding.  No more fields need zeroing.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 arch/powerpc/kvm/powerpc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2f87a16..5962336 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -604,6 +604,8 @@ static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
 	pvinfo->hcall[1] = inst_ori | (KVM_SC_MAGIC_R0 & inst_imm_mask);
 	pvinfo->hcall[2] = inst_sc;
 	pvinfo->hcall[3] = inst_nop;
+	pvinfo->flags = 0;
+	memset(&pvinfo->pad, 0, sizeof(pvinfo->pad));
 
 	return 0;
 }
-- 
1.7.0.4

