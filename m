Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2HTECM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:02:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab2HTECD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:02:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Zachary Amsden <zamsden@gmail.com>, Bruce Rogers <brogers@suse.com>
Subject: [ 41/46] KVM: x86: apply kvmclock offset to guest wall clock time
Date: Sun, 19 Aug 2012 20:59:17 -0700
Message-Id: <20120820035837.972658704@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruce Rogers <brogers@suse.com>

(cherry picked from commit 4b6486659a7defef82ea51b276024b3aa357fefc)

When a guest migrates to a new host, the system time difference from the
previous host is used in the updates to the kvmclock system time visible
to the guest, resulting in a continuation of correct kvmclock based guest
timekeeping.

The wall clock component of the kvmclock provided time is currently not
updated with this same time offset. Since the Linux guest caches the
wall clock based time, this discrepency is not noticed until the guest is
rebooted. After reboot the guest's time calculations are off.

This patch adjusts the wall clock by the kvmclock_offset, resulting in
correct guest time after a reboot.

Cc: Zachary Amsden <zamsden@gmail.com>
Signed-off-by: Bruce Rogers <brogers@suse.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -907,6 +907,10 @@ static void kvm_write_wall_clock(struct
 	 */
 	getboottime(&boot);
 
+	if (kvm->arch.kvmclock_offset) {
+		struct timespec ts = ns_to_timespec(kvm->arch.kvmclock_offset);
+		boot = timespec_sub(boot, ts);
+	}
 	wc.sec = boot.tv_sec;
 	wc.nsec = boot.tv_nsec;
 	wc.version = version;


