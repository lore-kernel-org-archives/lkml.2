Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2HTO0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:26:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53573 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2HTO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:26:15 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] kvm: Fix nonsense handling of compat ioctl
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Aug 2012 15:43:43 +0100
Message-ID: <20120820144330.6218.27112.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

KVM_SET_SIGNAL_MASK passed a NULL argument leaves the on stack signal
sets uninitialized. It then passes them through to
kvm_vcpu_ioctl_set_sigmask.

We should be passing a NULL in this case not translated garbage.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 virt/kvm/kvm_main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2e85af..e47a7ca 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1975,9 +1975,10 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 			if (copy_from_user(&csigset, sigmask_arg->sigset,
 					   sizeof csigset))
 				goto out;
-		}
-		sigset_from_compat(&sigset, &csigset);
-		r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
+			sigset_from_compat(&sigset, &csigset);
+			r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
+		} else
+			kvm_vcpu_ioctl_set_sigmask(vcpu, NULL);
 		break;
 	}
 	default:

