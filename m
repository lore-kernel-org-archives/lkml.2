Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1GZRFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:05:16 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40487 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1GZRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:05:07 -0400
Date: Tue, 26 Jul 2011 19:04:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>, Frank Arnold <Frank.Arnold@amd.com>
Subject: Re: [patch 3/3] x86: cache_info: Kill the atomic allocation in
 amd_init_l3_cache()
Message-ID: <20110726170449.GB32536@aftab>
References: <20110723212603.517924252@linutronix.de>
 <20110723212626.688229918@linutronix.de>
 <20110724102734.GA17099@liondog.tnic>
 <alpine.LFD.2.02.1107241812590.3136@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107241812590.3136@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 12:13:38PM -0400, Thomas Gleixner wrote:
> > Let me test the patchset on Monday to verify there are no other subtle
> > interactions I haven't thought of right now.

Yep, patches look good and boot as a xen guest too.

While you're at it, can you please also apply the following one which
updates L3 size calculation on F15h?

Thanks.

--
From: Frank Arnold <frank.arnold@amd.com>
Date: Wed, 18 May 2011 11:32:10 +0200
Subject: [PATCH] x86, AMD, cacheinfo: Update calculation of L3 cache indices

L3 subcaches 0 and 1 of AMD Family 15h CPUs can have a size of 2MB.
Update the calculation routine for the number of L3 indices to reflect
that.

Signed-off-by: Frank Arnold <frank.arnold@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 951820f..a3b0811 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -314,6 +314,12 @@ static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 	/* calculate subcache sizes */
 	l3->subcaches[0] = sc0 = !(val & BIT(0));
 	l3->subcaches[1] = sc1 = !(val & BIT(4));
+
+	if (boot_cpu_data.x86 == 0x15) {
+		l3->subcaches[0] = sc0 += !(val & BIT(1));
+		l3->subcaches[1] = sc1 += !(val & BIT(5));
+	}
+
 	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
-- 
1.7.6.134.gcf13f6


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
