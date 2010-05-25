Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab0EYP2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:28:08 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:29182 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab0EYP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:28:06 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L2ZEYG-02-KOP-02
X-M-MSG: 
Date: Tue, 25 May 2010 17:28:58 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [PATCH] powernow-k8: Fix section mismatch
Message-ID: <20100525152858.GA24836@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:

"WARNING: arch/x86/kernel/built-in.o(.exit.text+0x72):
Section mismatch in reference from the function powernowk8_exit() to the variable .cpuinit.data:cpb_nb

The function __exit powernowk8_exit() references a variable
__cpuinitdata cpb_nb. This is often seen when error handling in the exit
function uses functionality in the init path. The fix is often to remove
the __cpuinitdata annotation of cpb_nb so it may be used outside an init
section."

Cc: <stable@kernel.org>
Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6f3dc8f..7ec2123 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1497,8 +1497,8 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
  * simply keep the boost-disable flag in sync with the current global
  * state.
  */
-static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
-				void *hcpu)
+static int cpb_notify(struct notifier_block *nb, unsigned long action,
+		      void *hcpu)
 {
 	unsigned cpu = (long)hcpu;
 	u32 lo, hi;
@@ -1528,7 +1528,7 @@ static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpb_nb = {
+static struct notifier_block cpb_nb = {
 	.notifier_call		= cpb_notify,
 };
 
-- 
1.7.0


-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

