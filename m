Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab1I3Lus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:50:48 -0400
Received: from goliath.siemens.de ([192.35.17.28]:29867 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab1I3Luo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:50:44 -0400
Message-ID: <4E85ACFC.1090509@siemens.com>
Date: Fri, 30 Sep 2011 13:50:20 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu >> \"Liu, Jinsong\"" <jinsong.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: [PATCH] KVM: x86: Use do_div for tsc deadline calculation
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au> <4E84CC00.8090702@xenotime.net> <20110930085810.11bc8e2e38e1400a8b0b4cec@canb.auug.org.au>
In-Reply-To: <20110930085810.11bc8e2e38e1400a8b0b4cec@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required on i386 hosts.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kvm/lapic.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f9385ec..92390dc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -740,9 +740,10 @@ static void start_apic_timer(struct kvm_lapic *apic)
 
 		now = apic->lapic_timer.timer.base->get_time();
 		guest_tsc = kvm_x86_ops->read_l1_tsc(vcpu);
-		if (likely(tscdeadline > guest_tsc))
-			ns = (tscdeadline - guest_tsc)
-				* 1000000L / this_tsc_khz;
+		if (likely(tscdeadline > guest_tsc)) {
+			ns = (tscdeadline - guest_tsc) * 1000000ULL;
+			do_div(ns, this_tsc_khz);
+		}
 		hrtimer_start(&apic->lapic_timer.timer,
 			ktime_add_ns(now, ns), HRTIMER_MODE_ABS);
 
-- 
1.7.3.4
