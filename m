Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668Ab2C3VLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:11:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64808 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935685Ab2C3VLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:11:42 -0400
Message-Id: <20120330194846.269072555@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Simon Horman <horms@verge.net.au>
Subject: [ 057/149] PM / Domains: Fix handling of wakeup devices during system resume
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit cc85b20780562d404e18a47b9b55b4a5102ae53e upstream.

During system suspend pm_genpd_suspend_noirq() checks if the given
device is in a wakeup path (i.e. it appears to be needed for one or
more wakeup devices to work or is a wakeup device itself) and if it
needs to be "active" for wakeup to work.  If that is the case, the
function returns 0 without incrementing the device domain's counter
of suspended devices and without executing genpd_stop_dev() for the
device.  In consequence, the device is not stopped (e.g. its clock
isn't disabled) and power is always supplied to its domain in the
resulting system sleep state.

However, pm_genpd_resume_noirq() doesn't repeat that check and it
runs genpd_start_dev() and decrements the domain's counter of
suspended devices even for the wakeup device that weren't stopped by
pm_genpd_suspend_noirq().  As a result, the start callback may be run
unnecessarily for them and their domains' counters of suspended
devices may become negative.  Both outcomes aren't desirable, so fix
pm_genpd_resume_noirq() to look for wakeup devices that might not be
stopped by during system suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/domain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -751,7 +751,8 @@ static int pm_genpd_resume_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off)
+	if (genpd->suspend_power_off
+	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
 		return 0;
 
 	/*


