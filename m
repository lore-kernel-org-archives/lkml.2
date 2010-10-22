Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab0JVS5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:57:04 -0400
Received: from kroah.org ([198.145.64.141]:34365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439Ab0JVS45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.445064901@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Gregory Haskins <ghaskins@novell.com>
Subject: [079/103] KVM: fix irqfd assign/deassign race
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 6bbfb2653177a00f70e57e53625502d43804fed0 upstream.

I think I see the following (theoretical) race:

During irqfd assign, we drop irqfds lock before we
schedule inject work. Therefore, deassign running
on another CPU could cause shutdown and flush to run
before inject, causing user after free in inject.

A simple fix it to schedule inject under the lock.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/eventfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -217,7 +217,6 @@ kvm_irqfd_assign(struct kvm *kvm, int fd
 	events = file->f_op->poll(file, &irqfd->pt);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
-	spin_unlock_irq(&kvm->irqfds.lock);
 
 	/*
 	 * Check if there was an event already pending on the eventfd
@@ -226,6 +225,8 @@ kvm_irqfd_assign(struct kvm *kvm, int fd
 	if (events & POLLIN)
 		schedule_work(&irqfd->inject);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
 	/*
 	 * do not drop the file until the irqfd is fully initialized, otherwise
 	 * we might race against the POLLHUP


