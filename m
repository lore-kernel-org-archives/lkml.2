Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1ANVXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:23:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40894 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1ANVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:23:18 -0500
Message-ID: <4D30BE98.7060809@kernel.org>
Date: Fri, 14 Jan 2011 13:22:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux.com>, Greg KH <greg@kroah.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH] x86: set percpu cpu0 lpj to default
References: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com> <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com> <4D2F9948.8000804@kernel.org> <20110114004428.GA26847@kroah.com> <4D2FA305.2030808@kernel.org> <alpine.DEB.2.00.1101140846560.2423@router.home>
In-Reply-To: <alpine.DEB.2.00.1101140846560.2423@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to use udelay() in early stage.

For x86, normally udelay need to use percpu.loops_per_jiffy
will need to wait per_cpu(cpu_info) is allocated and copied
from boot_cpu_data, after it is in smp_prepare_cpus()
boot_cpu_data.loops_per_jiffy get set in identify_boot_cpu from check_bugs.

But cpu_data(0) can be referred early, that is in per cpu load data.

Try to set it with default vaule instead leave it as zero.

BTW: it it is some small...only 4096

Now: only user for udelay is ehci dgp early console.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -734,6 +734,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_trap_init();
 	early_cpu_init();
+	cpu_data(0).loops_per_jiffy = loops_per_jiffy;
 	early_ioremap_init();
 
 	setup_olpc_ofw_pgd();
