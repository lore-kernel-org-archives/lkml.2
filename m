Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab2EEEbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:31:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41267 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2EEEbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:31:12 -0400
Date: Fri, 4 May 2012 21:29:48 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: broken nouveau dependency on power supply
Message-ID: <20120505042947.GC3285@lizard>
References: <1333328762.30734.24.camel@pasglop>
 <1333338803.30734.37.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333338803.30734.37.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Benjamin,

Sorry, it took me some time to get to it.

On Mon, Apr 02, 2012 at 01:53:23PM +1000, Benjamin Herrenschmidt wrote:
[...]
> > With CONFIG_POWER_SUPPLY=m & nouveau built-in we get a build failure:
> > 
> > drivers/built-in.o: In function `.nouveau_pm_trigger':
> > (.text+0xa56e8): undefined reference to `.power_supply_is_system_supplied'
> > 
> > nouveau probably needs to depends on CONFIG_POWER_SUPPLY to force a module
> > build with the latter is =m
> 
> Ok, not that trivial...
> 
> The problem is more like POWER_SUPPLY should be a bool, not a tristate.

I see that nouveau already selects POWER_SUPPLY, but your points are
still valid. Let's make the power supply thing simple. I've applied
the following patch:

- - - -
[PATCH] power_supply: Make the core a boolean instead of a tristate

On Mon, Apr 02, 2012 at 01:53:23PM +1000, Benjamin Herrenschmidt wrote:
> > drivers/built-in.o: In function `.nouveau_pm_trigger':
> > (.text+0xa56e8): undefined reference to `.power_supply_is_system_supplied'
> >
> > nouveau probably needs to depends on CONFIG_POWER_SUPPLY to force a module
> > build with the latter is =m
>
> Ok, not that trivial...
>
> The problem is more like POWER_SUPPLY should be a bool, not a tristate.
>
> If you think about it: you don't want things like nouveau to depend on a
> random subsystem like that, people will never get it. In fact,
> POWER_SUPPLY provides empty inline stubs when not enabled, so that's
> really designed to not have depends...
>
> However that -cannot- work if POWER_SUPPLY is modular and the drivers
> who use it are not.
>
> The only fixes here that make sense I can think of
> that don't also involve Kconfig horrors are:
>
>  - Ugly: in power_supply.h, use the extern variant if
>
>       defined(CONFIG_POWER_SUPPLY) ||
>        (defined(CONFIG_POWER_SUPPLY_MODULE) && defined(MODULE))
>
> IE. use the stub if power supply is a module and what is being built is
> built-in. Of course that's not only ugly, it somewhat sucks from a user
> perspective as the subsystem now exists but can't be used by some
> drivers...
>
>  - Better: Just make the bloody thing a bool :-) The power supply
> framework itself is small enough, just make it a boolean option and
> avoid the problem entirely. The actual power supply sub drivers can
> remain modular of course.

Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/Kconfig        |    2 +-
 include/linux/power_supply.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 99dc29f..0c52a40 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -1,5 +1,5 @@
 menuconfig POWER_SUPPLY
-	tristate "Power supply class support"
+	bool "Power supply class support"
 	help
 	  Say Y here to enable power supply class support. This allows
 	  power supply (batteries, AC, USB) monitoring by userspace
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index fd17ae0..3b912be 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -212,7 +212,7 @@ extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
 
-#if defined(CONFIG_POWER_SUPPLY) || defined(CONFIG_POWER_SUPPLY_MODULE)
+#ifdef CONFIG_POWER_SUPPLY
 extern int power_supply_is_system_supplied(void);
 #else
 static inline int power_supply_is_system_supplied(void) { return -ENOSYS; }
-- 
1.7.9.2

