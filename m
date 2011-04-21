Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1DUTVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:21:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab1DUTVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:21:23 -0400
Date: Thu, 21 Apr 2011 15:21:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421192117.GA14249@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.6.0 enables a new warning by default, which spews ~3000 lines
of extra warnings to my build. The warning looks like ..

arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function ‘pending_bit_stuck’:
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:108:10: warning: variable ‘hi’ set but not used [-Wunused-but-set-variable]
arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function ‘core_voltage_pre_transition’:
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:340:14: warning: variable ‘lo’ set but not used [-Wunused-but-set-variable]

In those cases, there's no bug there, the code just doesn't use all the arguments
that get passed to rdmsr...   For eg,

static int pending_bit_stuck(void)
{
        u32 lo, hi;

        if (cpu_family == CPU_HW_PSTATE)
                return 0;

        rdmsr(MSR_FIDVID_STATUS, lo, hi); 
        return lo & MSR_S_LO_CHANGE_PENDING ? 1 : 0; 
}


gcc's manpage says to dismiss this warning with attribute(unused), but sprinkling thousands
of those through the source seems pretty ugly.  As does rewriting functions
like rdmsr to handle NULL as an argument.

There might be some valid bugs found (I think DaveM found a few already) from this new
warning, but it seems like everything I've looked at so far is just noise.

Any thoughts ?

	Dave

