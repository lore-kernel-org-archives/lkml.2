Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab1EFA1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:27:14 -0400
Received: from kroah.org ([198.145.64.141]:37438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab1EFA0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:19 2011
Message-Id: <20110506002219.304213396@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [143/143] KVM: x86: Fix kvmclock bug
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zamsden@redhat.com>

(backported from commit 28e4639adf0c9f26f6bb56149b7ab547bf33bb95)

If preempted after kvmclock values are updated, but before hardware
virtualization is entered, the last tsc time as read by the guest is
never set.  It underflows the next time kvmclock is updated if there
has not yet been a successful entry / exit into hardware virt.

Fix this by simply setting last_tsc to the newly read tsc value so
that any computed nsec advance of kvmclock is nulled.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

BugLink: http://bugs.launchpad.net/bugs/714335

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -694,6 +694,7 @@ static void kvm_write_guest_time(struct
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_kernel_ns = kernel_ns;
+	vcpu->last_guest_tsc = tsc_timestamp;
 
 	/*
 	 * The interface expects us to write an even number signaling that the


