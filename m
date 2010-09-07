Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0IGDtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:49:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:48041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab0IGDtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,327,1280732400"; 
   d="scan'208";a="604432815"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Zachary Amsden <zamsden@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dong, Eddie" <eddie.dong@intel.com>
Date: Tue, 7 Sep 2010 11:44:01 +0800
Subject: RE: [KVM timekeeping 26/35] Catchup slower TSC to guest rate
Thread-Topic: [KVM timekeeping 26/35] Catchup slower TSC to guest rate
Thread-Index: ActAP9mW0WIJCTe9Q36EYxd+qnlo/AN/nY/A
Message-ID: <1A42CE6F5F474C41B63392A5F80372B22A8253C5@shsmsx501.ccr.corp.intel.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-27-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-27-git-send-email-zamsden@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o873nSnD004788

Zachary:
	Will you extend the logic to cover the situation when the guest runs at higher than the guest rate but the PCPU is over committed. In that case, likely we can use the time spent when the VCPU is scheduled out to catch up as well. Of course if the VCPU scheduled out time is not enough to compensate the cycles caused by fast host TSC (exceeding a threahold), we will eventually have to fall back to trap and emulation mode.

Thx, Eddie

-----Original Message-----
From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Zachary Amsden
Sent: 2010Äê8ÔÂ20ÈÕ 16:08
To: kvm@vger.kernel.org
Cc: Zachary Amsden; Avi Kivity; Marcelo Tosatti; Glauber Costa; Thomas Gleixner; John Stultz; linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 26/35] Catchup slower TSC to guest rate

Use the catchup code to continue adjusting the TSC when
running at lower than the guest rate

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4215d7..086d56a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1013,8 +1013,11 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
 	}
 	local_irq_restore(flags);
-	if (catchup)
+	if (catchup) {
+		if (this_tsc_khz < v->kvm->arch.virtual_tsc_khz)
+			vcpu->tsc_rebase = 1;
 		return 0;
+	}
 
 	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
@@ -5022,6 +5025,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_guest_exit();
 
+	/* Running on slower TSC without kvmclock, we must bump TSC */
+	if (vcpu->arch.tsc_rebase)
+		kvm_request_clock_update(vcpu);
+
 	preempt_enable();
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
