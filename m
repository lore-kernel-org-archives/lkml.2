Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab0GAV1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:27:48 -0400
Received: from kroah.org ([198.145.64.141]:33277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab0GAVPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:37 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.895625064@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [194/200] KVM: Fix wallclock version writing race
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

Wallclock writing uses an unprotected global variable to hold the version;
this can cause one guest to interfere with another if both write their
wallclock at the same time.

Acked-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 9ed3c444ab8987c7b219173a2f7807e3f71e234e)
---
 arch/x86/kvm/x86.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -695,14 +695,22 @@ static int do_set_msr(struct kvm_vcpu *v
 
 static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 {
-	static int version;
+	int version;
+	int r;
 	struct pvclock_wall_clock wc;
 	struct timespec boot;
 
 	if (!wall_clock)
 		return;
 
-	version++;
+	r = kvm_read_guest(kvm, wall_clock, &version, sizeof(version));
+	if (r)
+		return;
+
+	if (version & 1)
+		++version;  /* first time write, random junk */
+
+	++version;
 
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 


