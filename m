Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0JVTEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:04:04 -0400
Received: from kroah.org ([198.145.64.141]:34374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759480Ab0JVS46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.532678913@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        mtosatti@redhat.com, avi@redhat.com
Subject: [080/103] KVM: Fix reboot on Intel hosts
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit ca242ac9960dc61530e25a2c190e4e13fd5f1ecb upstream.

When we reboot, we disable vmx extensions or otherwise INIT gets blocked.
If a task on another cpu hits a vmx instruction, it will fault if vmx is
disabled.  We trap that to avoid a nasty oops and spin until the reboot
completes.

Problem is, we sleep with interrupts disabled.  This blocks smp_send_stop()
from running, and the reboot process halts.

Fix by enabling interrupts before spinning.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/kvm_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1942,10 +1942,12 @@ static int kvm_cpu_hotplug(struct notifi
 
 asmlinkage void kvm_handle_fault_on_reboot(void)
 {
-	if (kvm_rebooting)
+	if (kvm_rebooting) {
 		/* spin while reset goes on */
+		local_irq_enable();
 		while (true)
 			;
+	}
 	/* Fault while not rebooting.  We want the trace. */
 	BUG();
 }


