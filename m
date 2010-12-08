Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0LHCMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:12:20 -0500
Received: from kroah.org ([198.145.64.141]:46079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab0LHArJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:09 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.803615773@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Vasiliy Kulikov <segooon@gmail.com>
Subject: [045/127] KVM: x86: fix information leak to userland
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Vasiliy Kulikov <segooon@gmail.com>

commit 97e69aa62f8b5d338d6cff49be09e37cc1262838 upstream.

Structures kvm_vcpu_events, kvm_debugregs, kvm_pit_state2 and
kvm_clock_data are copied to userland with some padding and reserved
fields unitialized.  It leads to leaking of contents of kernel stack
memory.  We have to initialize them to zero.

In patch v1 Jan Kiszka suggested to fill reserved fields with zeros
instead of memset'ting the whole struct.  It makes sense as these
fields are explicitly marked as padding.  No more fields need zeroing.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2102,6 +2102,7 @@ static int kvm_vm_ioctl_get_pit2(struct
 		sizeof(ps->channels));
 	ps->flags = kvm->arch.vpit->pit_state.flags;
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	memset(&ps->reserved, 0, sizeof(ps->reserved));
 	return r;
 }
 
@@ -2439,6 +2440,7 @@ long kvm_arch_vm_ioctl(struct file *filp
 		now_ns = timespec_to_ns(&now);
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		user_ns.flags = 0;
+		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))


