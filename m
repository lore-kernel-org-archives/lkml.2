Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0J3JEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:04:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37337 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0J3JEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=StJVmUSxsrVFZmInZ30h9Z/NT1JFyVPNnwq0TKVclqNLLUHhblu/QYSmQFDxrB/J09
         sS+UG8OfznMLcq0nuLTXOFkxwc6ylQsEr/3yozwe7L1jh3CWWoHEHNubd9XekGiOwJmT
         igxGCfL7UqnLfKJFGxn7MiXDBUGHu639NdpP8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: kvm: fix information leak to userland
Date: Sat, 30 Oct 2010 13:04:24 +0400
Message-Id: <1288429464-21763-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure kvm_ppc_pvinfo is copied to userland with flags and
pad fields unitialized.  It leads to leaking of contents of
kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested at all.

 arch/powerpc/kvm/powerpc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2f87a16..38f756f 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -617,6 +617,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_PPC_GET_PVINFO: {
 		struct kvm_ppc_pvinfo pvinfo;
+		memset(&pvinfo, 0, sizeof(pvinfo));
 		r = kvm_vm_ioctl_get_pvinfo(&pvinfo);
 		if (copy_to_user(argp, &pvinfo, sizeof(pvinfo))) {
 			r = -EFAULT;
-- 
1.7.0.4

