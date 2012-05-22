Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2EVWcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:32:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:12847 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2EVWcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:32:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155863319"
Date: Wed, 23 May 2012 00:42:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120522224214.GG10210@sortiz-mobl>
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
 <4FB9F818.4030801@linaro.org>
 <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
 <4FBA0460.1070300@linaro.org>
 <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au>
 <4FBA08A4.6030706@linaro.org>
 <20120521095427.GA30045@sirena.org.uk>
 <4FBA18C7.4030800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA18C7.4030800@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, May 21, 2012 at 11:28:23AM +0100, Lee Jones wrote:
> When CONFIG_AB8500_CORE is set, building ab8500-core.c and
> !(CONFIG_UX500_SOC_DB8500 | CONFIG_MFD_DB8500_PRCMU), both
> db8500-prcmu.h and dbx500-prcmu.h take it upon themselves to _both_
> create 'return 0' inline functions for the following:
> 
> prcmu_abb_read()
> prcmu_abb_write()
> prcmu_config_clkout()
> prcmu_ac_wake_req()
> prcmu_ac_sleep_req()
> 
> I think we need a Kconfig rule to prevent this from happening, but
> I'm not sure what the correct logic would be. 
Do you want the above routines to be NOOPs when !CONFIG_MFD_DB8500_PRCMU or
when !CONFIG_UX500_SOC_DB8500 ? It would make more sense to define them as
NOOP when !CONFIG_MFD_DB8500_PRCMU and remove all those definitions from
dbx500-prmcu.h
But I may be missing some of your architecture dependencies.

Something like that:

diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index d7674eb..8515547 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -366,12 +366,8 @@ static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
 		db8500_prcmu_get_abb_event_buffer(buf);
 }
 
-int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
-int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size);
 
-int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
-
 static inline int prcmu_request_clock(u8 clock, bool enable)
 {
 	if (cpu_is_u5500())
@@ -447,8 +443,6 @@ static inline u16 prcmu_get_reset_code(void)
 		return db8500_prcmu_get_reset_code();
 }
 
-void prcmu_ac_wake_req(void);
-void prcmu_ac_sleep_req(void);
 static inline void prcmu_modem_reset(void)
 {
 	if (cpu_is_u5500())
@@ -611,27 +605,12 @@ static inline void prcmu_enable_wakeups(u32 wakeups) {}
 
 static inline void prcmu_disable_wakeups(void) {}
 
-static inline int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
 static inline int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
 	u8 size)
 {
 	return -ENOSYS;
 }
 
-static inline int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
-{
-	return 0;
-}
-
 static inline int prcmu_request_clock(u8 clock, bool enable)
 {
 	return 0;
@@ -689,10 +668,6 @@ static inline u16 prcmu_get_reset_code(void)
 	return 0;
 }
 
-static inline void prcmu_ac_wake_req(void) {}
-
-static inline void prcmu_ac_sleep_req(void) {}
-
 static inline void prcmu_modem_reset(void) {}
 
 static inline bool prcmu_is_ac_wake_requested(void)

I would appreciate if we could have a fix for this one sooner than later as
I'm planning to send my pull request by the end of this week.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
