Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab0KXCb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:31:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab0KXCb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:31:56 -0500
Date: Tue, 23 Nov 2010 21:31:24 -0500
From: Dave Jones <davej@redhat.com>
To: Neil Brown <neilb@suse.de>, x86@kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Missing "unregister_cpu_notifier" in powernow-k8.c
Message-ID: <20101124023124.GD1987@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Neil Brown <neilb@suse.de>,
	x86@kernel.org, cpufreq@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20101124112801.78830fba@notabene.brown>
 <20101124021938.GB1987@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101124021938.GB1987@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 09:19:38PM -0500, Dave Jones wrote:
 >  The following might be a partial fix, but I suspect there is probably other
 >  clean-up that is needed.

Indeed, looks like another possible leak in the unlikely event that the
percpu msr struct can't be allocated..
Instead of adding an unregister on fail, I think we can just move the registration later.

	Dave

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 812778c..f0a80f1 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1556,14 +1556,14 @@ static int __cpuinit powernowk8_init(void)
 
                cpb_capable = true;
 
-               register_cpu_notifier(&cpb_nb);
-
                msrs = msrs_alloc();
                if (!msrs) {
                        printk(KERN_ERR "%s: Error allocating msrs!\n", __func__);
                        return -ENOMEM;
                }
 
+               register_cpu_notifier(&cpb_nb);
+
                rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
 
                for_each_cpu(cpu, cpu_online_mask) {

