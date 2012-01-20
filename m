Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2ATJIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:08:30 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39804 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2ATJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:08:26 -0500
Message-ID: <4F192F01.1030502@linux.vnet.ibm.com>
Date: Fri, 20 Jan 2012 14:38:17 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trinabh Gupta <g.trinabh@gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
References: <20120120182117.01a6eb5d3cfb3f2bdfb32ae4@canb.auug.org.au>
In-Reply-To: <20120120182117.01a6eb5d3cfb3f2bdfb32ae4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011922-9264-0000-0000-000000AB2447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 12:51 PM, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allmodconfig) failed like this:
> 
> arch/powerpc/platforms/pseries/processor_idle.c:35:6: error: redefinition of 'update_smt_snooze_delay'
> arch/powerpc/include/asm/system.h:230:20: note: previous definition of 'update_smt_snooze_delay' was here
> arch/powerpc/platforms/pseries/processor_idle.c:175:5: error: redefinition of 'pseries_notify_cpuidle_add_cpu'
> arch/powerpc/include/asm/system.h:231:19: note: previous definition of 'pseries_notify_cpuidle_add_cpu' was here
> 
> Caused by commit 707827f3387d ("powerpc/cpuidle: cpuidle driver for
> pSeries").  For this build, CONFIG_PSERIES_IDLE is "m".
> 
> 
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev




Hi Stephen,

We had a discussion on this particular problem on ppcdev list a few
days back and concluded that it is best not have pseries_idle
as a module.

http://old.nabble.com/-PATCH--cpuidle%3A-Default-y-for-pseries-to33118294.html#a33127587

The following patch disables pseries cpuidle driver to be loaded as a
module as there are build problems reported when one is trying to do so.

arch/powerpc/platforms/pseries/processor_idle.c:35:6: error:
redefinition of 'update_smt_snooze_delay'
arch/powerpc/include/asm/system.h:230:20: note:
previous definition of 'update_smt_snooze_delay' was here
arch/powerpc/platforms/pseries/processor_idle.c:175:5:
error: redefinition of 'pseries_notify_cpuidle_add_cpu'
arch/powerpc/include/asm/system.h:231:19: note:
previous definition of 'pseries_notify_cpuidle_add_cpu' was here

Since the above two functions
are used in core power architecture functions (store_smt_snooze_delay
at kernel/sysfs.c and smp_xics_setup_cpu at platforms/pseries/smp.c),
this requires some rework in these interactions. For now please
disable PSERIES_IDLE to be built as a module for now.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/Kconfig
b/arch/powerpc/platforms/pseries/Kconfig
index ae7b6d4..31f22c1 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -122,7 +122,7 @@ config DTL
 	  Say N if you are unsure.

 config PSERIES_IDLE
-	tristate "Cpuidle driver for pSeries platforms"
+	bool "Cpuidle driver for pSeries platforms"
 	depends on CPU_IDLE
 	depends on PPC_PSERIES
 	default y

Regards,
Deepthi

