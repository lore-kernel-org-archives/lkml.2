Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0JCTAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:00:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0JCTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:00:16 -0400
Date: Sun, 3 Oct 2010 21:00:12 +0200
From: Heinz Diehl <htd@fritha.org>
To: linux-kernel@vger.kernel.org
Cc: trenn@suse.de
Subject: [cpufreq] ondemand: Intel i5-450M gets stuck in lowest state
Message-ID: <20101003190012.GA29952@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V02:K0:JJplhh08pJDVsRM1Hfacq44acMetG2AGEBWCVC6JQ+l
 wvJfJG4dytYae/EDB5dCMhnhSaNnIdiqGVfmOOW6Jm4DQtyQcS
 /7cSZZnarHipDw5/Krh+dRzfN9HYgeWONqAensmdaE6XVE0sbf
 J1HHdUa5LBcmK9e3+eXFnok+RB+WxchD1iEu/6X6rGfEN5GDI8
 yKZh01lOsHj0v3DXSGO4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I own a brand new ASUS U45JC laptop with an Intel i5-450M CPU built in.
During the first compile on it, I noticed that the CPU reached max. 1.33 GHz
using governor "ondemand". Kicking the CPU with a kernel compile using
"make -j4" didn't help either, max. frequency was nailed at 1.33 GHz.
Both the latest stable 2.6.35.7 and release candidate 2.6.36-rc6-git2 are
affected.

After 2 days investigating (I'm not primarily a kernel programmer/developer), 
I came across the solution, and there was already a patch available from
Thomas Renninger @suse, which I have included in this mail. I blindly
guess now that a lot of people own a notebook with an Intel i5 inside, and
maybe (could) have the same problem.

Any chance to get this included in the kernel, or is it just me who
encounters this problem? The patch applies cleanly against the latest rc,
and I can confirm that it also fixes the above mentioned problem in
2.6.35.7 (I backported it and did try).

Thanks,
Heinz.


---
 drivers/cpufreq/cpufreq_ondemand.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -35,6 +35,7 @@
 #define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
 #define MAX_FREQUENCY_UP_THRESHOLD		(100)
+#define MAX_DEFAULT_SAMPLING_RATE		(300 * 1000U)
 
 /*
  * The polling frequency of this governor depends on the capability of
@@ -736,6 +737,29 @@ static int cpufreq_governor_dbs(struct c
 			dbs_tuners_ins.sampling_rate =
 				max(min_sampling_rate,
 				    latency * LATENCY_MULTIPLIER);
+			/*
+			 * Cut def_sampling rate to 300ms if it was above,
+			 * still consider to not set it above latency
+			 * transition * 100
+			 */
+			if (dbs_tuners_ins.sampling_rate > MAX_DEFAULT_SAMPLING_RATE) {
+				dbs_tuners_ins.sampling_rate =
+					max(min_sampling_rate, MAX_DEFAULT_SAMPLING_RATE);
+				printk(KERN_INFO "CPUFREQ: ondemand sampling "
+				       "rate set to %d ms\n",
+				       dbs_tuners_ins.sampling_rate / 1000);
+			}
+			/*
+			 * Be conservative in respect to performance.
+			 * If an application calculates using two threads
+			 * depending on each other, they will be run on several
+			 * CPU cores resulting on 50% load on both.
+			 * SLED might still want to prefer 80% up_threshold
+			 * by default, but we cannot differ that here.
+			 */
+			if (num_online_cpus() > 1)
+				dbs_tuners_ins.up_threshold =
+					DEF_FREQUENCY_UP_THRESHOLD / 2;
 			dbs_tuners_ins.io_is_busy = should_io_be_busy();
 		}
 		mutex_unlock(&dbs_mutex);
