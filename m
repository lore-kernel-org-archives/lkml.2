Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2IYB6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:58:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:7141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2IYB6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,478,1344236400"; 
   d="scan'208";a="226011230"
Message-ID: <1348538339.10877.193.camel@rui.sh.intel.com>
Subject: Re: [PATCH] Thermal: Fix bug on generic thermal framework.
From: Zhang Rui <rui.zhang@intel.com>
To: jonghwa3.lee@samsung.com
Cc: "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>
Date: Tue, 25 Sep 2012 09:58:59 +0800
In-Reply-To: <50610504.7050706@samsung.com>
References: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
	 <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
	 <1348477068.10877.180.camel@rui.sh.intel.com>
	 <50610504.7050706@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 二, 2012-09-25 at 10:12 +0900, jonghwa3.lee@samsung.com wrote:
> On 2012년 09월 24일 17:57, Zhang Rui wrote:
> > On 一, 2012-09-24 at 02:08 -0600, R, Durgadoss wrote:
> >> Hi,
> >>
> >> Patch is fine, but I think you have to re-base on top of
> >> Rui's -next branch here:
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
> >>
> >> Also, adding Rui to this mail, not sure whether he is in LKML/pm.
> >>
> >> Thanks,
> >> Durga
> >>
> >>> -----Original Message-----
> >>> From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
> >>> Sent: Monday, September 24, 2012 7:36 AM
> >>> To: linux-pml@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org; Brown, Len; Rafael J. Wysocki; Andrew
> >>> Morton; Amit Kachhap; R, Durgadoss; Jonghwa Lee
> >>> Subject: [PATCH] Thermal: Fix bug on generic thermal framework.
> >>>
> >>> When system fails to bind cooling devices to thermal zone device during
> >>> registering thermal zone device, it leaves registering without canceling
> >>> delayed work. It probably makes panic if polling rate is not enough to release
> >>> that work from workqueue. So it is better to ignore initialization of polling
> >>> work to prevent that unexpected state.
> >>>
> > Hi, Jonghwa,
> >
> > I still do not understand what the problem is.
> > Say if a cooling device fails to bind, the thermal zone device would
> > still work properly, just like the failure cooling device is not
> > referenced in this thermal zone.
> >
> > thanks,
> > rui
> Hi rui,
> No, it doesn't work properly. If it fails to bind some cool dev to
> thermal zone device, it frees thermal zone
> device without canceling delayed work. After freeing thermal zone
> device, system may call work function
> pointed NULL as the timer expired. Thus it requires skipping the
> initialization of polling work or canceling before
> the unregister.


hah, I see what the problem is.
ideally, if we fail to bind one cooling device, we should just ignore it
and continue to bind other, what do you think?

does the patch below fix your problem?
If yes, I'll try to rebase it on top of my next tree.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_sys.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 2ab31e4..c5e2c28 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1343,20 +1343,17 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 
 	mutex_lock(&thermal_list_lock);
 	list_add_tail(&tz->node, &thermal_tz_list);
-	if (ops->bind)
-		list_for_each_entry(pos, &thermal_cdev_list, node) {
-		result = ops->bind(tz, pos);
-		if (result)
-			break;
-		}
+	if (ops->bind) {
+		list_for_each_entry(pos, &thermal_cdev_list, node)
+			ops->bind(tz, pos);
+	}
 	mutex_unlock(&thermal_list_lock);
 
 	INIT_DELAYED_WORK(&(tz->poll_queue), thermal_zone_device_check);
 
 	thermal_zone_device_update(tz);
 
-	if (!result)
-		return tz;
+	return tz;
 
 unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
-- 
1.7.7.6



