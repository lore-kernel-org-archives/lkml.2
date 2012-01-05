Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab2AEPZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:25:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61045 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab2AEPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:25:42 -0500
Date: Thu, 5 Jan 2012 19:25:36 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the battery tree
Message-ID: <20120105152536.GB28629@oksana.dev.rtsoft.ru>
References: <20120105144042.4e03850089cce56a7e9312e4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120105144042.4e03850089cce56a7e9312e4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 02:40:42PM +1100, Stephen Rothwell wrote:
> Hi Anton,
> 
> After merging the battery tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "sysfs_create_link_nowarn" [drivers/power/power_supply.ko] undefined!
> 
> Caused by commit 8351665195ce ("power_supply: allow a power supply to
> explicitly point to powered device").  That symbol is not exported to
> modules.
> 
> I have used the battery tree from next-20120104 for today.

Thanks for catching this, Stephen!

I wonder why do we need to use _nowarn variant?..

Something tells me that we actually want a warning.

Jeremy, are you OK with the patch down below?

- - - -
From: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: power_supply: Drop usage of nowarn variant of sysfs_create_link()

The function is not exported to modules, plus we do want to catch anyone
who tries to create complex hierarchy (in that case we'd need to change
'powers' symlink to a directory, probably under a different name to not
break ABI).

This patch fixes the following build error:

 ERROR: "sysfs_create_link_nowarn" [drivers/power/power_supply.ko] undefined!

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/power_supply_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index b10c121..47f4e11 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
-	return sysfs_create_link_nowarn(&psy->dev->kobj, &dev->kobj, "powers");
+	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
 }
 EXPORT_SYMBOL_GPL(power_supply_powers);
 
-- 
1.7.7.3

