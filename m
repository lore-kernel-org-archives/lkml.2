Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab1GKWIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:08:36 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.206]:60329 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab1GKWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:08:35 -0400
Message-ID: <4E1B745A.5000802@interia.pl>
Date: Mon, 11 Jul 2011 23:08:26 +0100
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628
	Thunderbird/5.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: [PATCH] e_powersaver: Add sanity checks to code provided by VIA
References: <1310114243.2940.3.camel@phoenix>
In-Reply-To: <1310114243.2940.3.camel@phoenix>
X-Interia-Antivirus: OK
X-EMID: 81d40958
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch from VIA is forcing "e_powersaver" to accept any processor >=A, 
but code supports only A and D.
Patch from VIA is forcing "e_powersaver" to support new brand, but code 
was intended for 2 bits only.
Looks like model D is using 8 bits for brand. Compensate.

Thanks to Axel Lin for pointing it out!

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>

---
  drivers/cpufreq/e_powersaver.c |   15 ++++++++++++---
  1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 35a257d..7883ffa 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -179,9 +179,13 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
          break;
      case 13:
          rdmsr(0x1154, lo, hi);
-        brand = (((lo >> 4) ^ (lo >> 2))) & 0x000000ff;
+        brand = (((lo >> 4) ^ (lo >> 2))) & 0xff;
          printk(KERN_CONT "Model D ");
          break;
+    default:
+        printk(KERN_CONT "unknown processor\n");
+        return -ENODEV;
+        break;
      }

      switch (brand) {
@@ -194,14 +198,19 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
      case EPS_BRAND_EDEN:
          printk(KERN_CONT "Eden\n");
          break;
+    case EPS_BRAND_C3:
+        printk(KERN_CONT "C3\n");
+        return -ENODEV;
+        break;
      case EPS_BRAND_C7D:
          printk(KERN_CONT "C7-D\n");
          break;
-    case EPS_BRAND_C3:
-        printk(KERN_CONT "C3\n");
+    default:
+        printk(KERN_CONT "unsupported brand\n");
          return -ENODEV;
          break;
      }
+
      /* Enable Enhanced PowerSaver */
      rdmsrl(MSR_IA32_MISC_ENABLE, val);
      if (!(val & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
-- 
1.7.6



----------------------------------------------------------------
Znajdz samochod idealny dla siebie!
Szukaj >> http://linkint.pl/f29e2
