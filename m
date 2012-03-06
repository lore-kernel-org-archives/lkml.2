Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2CFQQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:16:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2CFQQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:16:01 -0500
Date: Tue, 6 Mar 2012 08:12:22 -0800
From: tip-bot for Mika Westerberg <mika.westerberg@linux.intel.com>
Message-ID: <tip-85zdo06yve1o27jpwc74gzng@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, durgadoss.r@intel.com,
        alan@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        durgadoss.r@intel.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/mid/thermal: Turn off thermistor
Git-Commit-ID: 1b7ccabcc372152d1492241610e52b8ea14b0968
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:12:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b7ccabcc372152d1492241610e52b8ea14b0968
Gitweb:     http://git.kernel.org/tip/1b7ccabcc372152d1492241610e52b8ea14b0968
Author:     Mika Westerberg <mika.westerberg@linux.intel.com>
AuthorDate: Mon, 5 Mar 2012 15:01:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:01:26 +0100

x86/mid/thermal: Turn off thermistor

Instead of complaining that the voltage is on, we can just ask
the MSIC to turn the voltage off. This should save some power.

Voltage for thermistors is turned on when ADC conversion is
initiated.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-85zdo06yve1o27jpwc74gzng@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/intel_mid_thermal.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index 5917b3c..2ee9766 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -360,8 +360,10 @@ static int mid_initialize_adc(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (data & MSIC_ADCTHERM_MASK)
-		dev_warn(dev, "ADCTHERM already set");
+	data &= ~MSIC_ADCTHERM_MASK;
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, data);
+	if (ret)
+		return ret;
 
 	/* Index of the first channel in which the stop bit is set */
 	channel_index = find_free_channel();
