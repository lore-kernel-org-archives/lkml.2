Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0KBBss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:48:48 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42582 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0KBBso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:48:44 -0400
Date: Tue, 2 Nov 2010 10:49:34 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Jesper Juhl <jj@chaosbits.net>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM x86: remove memset, use vzalloc and don't assign
 the same value to a variable twice
Message-Id: <20101102104934.ecd779dd.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <alpine.LNX.2.00.1011011924440.9616@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net>
	<4CCE0EB2.9070302@oss.ntt.co.jp>
	<alpine.LNX.2.00.1011011924440.9616@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper, (dropped some addresses from Cc)

> > Jesper Juhl wrote:
> There's definately a positive size impact for the generated object code 
> and we save having to do the call to memset() and the cost of a vzalloc() 
> call looks more or less the same as a call to vmalloc() to me.

> > This patch is not based on kvm.git, I guess.
> > 
> Nope. It was generated against mainline git as of a couple of days ago. I 
> can generate a version against kvm.git if you prefer.

Sorry, I should have said more clearly.

kvm_vm_ioctl_get_dirty_log() has been changed since latest mainline kernel was released.
Furthermore, vmalloc() in it is to be removed soon, currently in kvm's next.

I have checked all vmalloc() + memset() in kvm, and there are three remaining.
See the patch below.
  - I have tested on x86.
  - I can test ppc later if needed, but this is so trivial that Alex will see
    no problem about this, probably.

So please write your Signed-off-by and ask Avi and Marcelo to apply.

Thanks,
  Takuya

===
Subject: [PATCH] KVM: replace vmalloc and memset with vzalloc

Let's use newly introduced vzalloc().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Jesper Juhl <jj@chaosbits.net>
---
 arch/powerpc/kvm/book3s.c |    4 +---
 virt/kvm/kvm_main.c       |    9 ++-------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index e316847..badc983 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1307,12 +1307,10 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
 	int err = -ENOMEM;
 	unsigned long p;
 
-	vcpu_book3s = vmalloc(sizeof(struct kvmppc_vcpu_book3s));
+	vcpu_book3s = vzalloc(sizeof(struct kvmppc_vcpu_book3s));
 	if (!vcpu_book3s)
 		goto out;
 
-	memset(vcpu_book3s, 0, sizeof(struct kvmppc_vcpu_book3s));
-
 	vcpu_book3s->shadow_vcpu = (struct kvmppc_book3s_shadow_vcpu *)
 		kzalloc(sizeof(*vcpu_book3s->shadow_vcpu), GFP_KERNEL);
 	if (!vcpu_book3s->shadow_vcpu)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dbe1d6a..bd44a81 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -606,13 +606,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate if a slot is being created */
 #ifndef CONFIG_S390
 	if (npages && !new.rmap) {
-		new.rmap = vmalloc(npages * sizeof(*new.rmap));
+		new.rmap = vzalloc(npages * sizeof(*new.rmap));
 
 		if (!new.rmap)
 			goto out_free;
 
-		memset(new.rmap, 0, npages * sizeof(*new.rmap));
-
 		new.user_alloc = user_alloc;
 		new.userspace_addr = mem->userspace_addr;
 	}
@@ -635,14 +633,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			     >> KVM_HPAGE_GFN_SHIFT(level));
 		lpages -= base_gfn >> KVM_HPAGE_GFN_SHIFT(level);
 
-		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
+		new.lpage_info[i] = vzalloc(lpages * sizeof(*new.lpage_info[i]));
 
 		if (!new.lpage_info[i])
 			goto out_free;
 
-		memset(new.lpage_info[i], 0,
-		       lpages * sizeof(*new.lpage_info[i]));
-
 		if (base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
 			new.lpage_info[i][0].write_count = 1;
 		if ((base_gfn+npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
-- 
1.7.0.4

