Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2GWOGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:06:30 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48623 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2GWOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:06:29 -0400
Message-ID: <500D5A5D.8080703@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 22:06:21 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: use kvm_release_page_clean to guest page
References: <500D59A7.9060503@linux.vnet.ibm.com> <500D5A1E.6000704@linux.vnet.ibm.com>
In-Reply-To: <500D5A1E.6000704@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072314-4790-0000-0000-000003D11476
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kvm_async_pf_wakeup_all, it uses bad_page to generate broadcast wakeup,
and use put_page to release the page, the work depends on bad_page is the
normal page. But we will use the error code instead of bad_page, so use
kvm_release_page_clean to release the page which will release the error
code probably

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/async_pf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 74268b4..ebae24b 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -112,7 +112,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), link);
 		list_del(&work->link);
 		if (work->page)
-			put_page(work->page);
+			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
 	spin_unlock(&vcpu->async_pf.lock);
@@ -139,7 +139,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
 		if (work->page)
-			put_page(work->page);
+			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
 }
-- 
1.7.7.6

