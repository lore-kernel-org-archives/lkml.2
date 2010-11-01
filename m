Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab0KAI7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:59:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab0KAI7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:59:21 -0400
Message-ID: <4CCE8270.5020300@cn.fujitsu.com>
Date: Mon, 01 Nov 2010 17:03:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [RFC PATCH v2 6/7] KVM: fix the race while wakeup all pv guest
References: <4CCE8143.3090105@cn.fujitsu.com>
In-Reply-To: <4CCE8143.3090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kvm_async_pf_wakeup_all(), we add a dummy apf to vcpu->async_pf.done
without holding vcpu->async_pf.lock, it will break if we are handling apfs
at this time.

Also use 'list_empty_careful()' instead of 'list_empty()'

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 virt/kvm/async_pf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index d57ec92..6ef3373 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -200,7 +200,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
-	if (!list_empty(&vcpu->async_pf.done))
+	if (!list_empty_careful(&vcpu->async_pf.done))
 		return 0;
 
 	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
@@ -211,7 +211,10 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	get_page(bad_page);
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
+	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&work->link, &vcpu->async_pf.done);
+	spin_unlock(&vcpu->async_pf.lock);
+
 	vcpu->async_pf.queued++;
 	return 0;
 }
-- 
1.7.0.4

