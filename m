Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2IUMEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:04:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53512 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IUMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:04:03 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Fri, 21 Sep 2012 17:30:20 +0530
Message-Id: <20120921120019.27611.66093.sendpatchset@codeblue>
In-Reply-To: <20120921115942.27611.67488.sendpatchset@codeblue>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
Subject: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted scenario in PLE handler
x-cbid: 12092112-1618-0000-0000-000002855BB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

When PLE handler fails to find a better candidate to yield_to, it
goes back and does spin again. This is acceptable when we do not
have overcommit.
But in overcommitted scenarios (especially when we have large
number of small guests), it is better to yield.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8323685..713b677 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1660,6 +1660,10 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 			}
 		}
 	}
+	/* In overcommitted cases, yield instead of spinning */
+	if (!yielded && rq_nr_running() > 1)
+		schedule();
+
 	kvm_vcpu_set_in_spin_loop(me, false);
 
 	/* Ensure vcpu is not eligible during next spinloop */

