Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab1CXT6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:58:31 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:55052
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933797Ab1CXT63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:58:29 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK936eK1432N98dN4015Lzz1202hzz8275bh8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIKVGG-02-C74-02
X-M-MSG: 
Date: Thu, 24 Mar 2011 20:57:49 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT PULL] oprofile updates for v2.6.39
Message-ID: <20110324195749.GS31407@erda.amd.com>
References: <20110317120136.GB31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110317120136.GB31407@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 17.03.11 13:01:36, Robert Richter wrote:
> please pull oprofile updates for v2.6.39 (tip/perf/core):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

please consider to pull one more late patch from oprofile/core. We
would like to see it in v2.6.39. It's a small change unlikely to break
anything and it completes the Sandy Bridge support in oprofile.

Thanks,

-Robert



The following changes since commit ec6b426c4dbb9eef40375c389746cab7e931a584:

  oprofile, s390: Cleanups (2011-03-16 14:30:40 +0100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Andi Kleen (1):
      oprofile, x86: Allow setting EDGE/INV/CMASK for counter events

 arch/x86/oprofile/nmi_int.c    |    5 +++++
 arch/x86/oprofile/op_counter.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)




>From 914a76ca5eedc9f286a36f61c4eaa95b451ba3e6 Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Wed, 16 Mar 2011 15:44:33 -0400
Subject: [PATCH] oprofile, x86: Allow setting EDGE/INV/CMASK for counter events

For some performance events it's useful to set the EDGE and INV
bits and the CMASK mask in the counter control register. The list
of predefined events Intel releases for each CPU has some events which
require these settings to get more "natural" to use higher level events.

oprofile currently doesn't allow this.

This patch adds new extra configuration fields for them, so that
they can be specified in oprofilefs.

An updated oprofile daemon can then make use of this to set them.

v2: Write back masked extra value to variable.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c    |    5 +++++
 arch/x86/oprofile/op_counter.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index e2b7b0c..ee165f1 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -49,6 +49,10 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 	val |= counter_config->user ? ARCH_PERFMON_EVENTSEL_USR : 0;
 	val |= counter_config->kernel ? ARCH_PERFMON_EVENTSEL_OS : 0;
 	val |= (counter_config->unit_mask & 0xFF) << 8;
+	counter_config->extra &= (ARCH_PERFMON_EVENTSEL_INV |
+				  ARCH_PERFMON_EVENTSEL_EDGE |
+				  ARCH_PERFMON_EVENTSEL_CMASK);
+	val |= counter_config->extra;
 	event &= model->event_mask ? model->event_mask : 0xFF;
 	val |= event & 0xFF;
 	val |= (event & 0x0F00) << 24;
@@ -440,6 +444,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
 		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
 		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
+		oprofilefs_create_ulong(sb, dir, "extra", &counter_config[i].extra);
 	}
 
 	return 0;
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index e28398d..0b7b7b1 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -22,6 +22,7 @@ struct op_counter_config {
 	unsigned long kernel;
 	unsigned long user;
 	unsigned long unit_mask;
+	unsigned long extra;
 };
 
 extern struct op_counter_config counter_config[];
-- 
1.7.3.4




-- 
Advanced Micro Devices, Inc.
Operating System Research Center

