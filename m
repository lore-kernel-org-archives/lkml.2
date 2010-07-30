Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0G3SDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:03:51 -0400
Received: from kroah.org ([198.145.64.141]:59315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab0G3R6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175152.154247953@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Chiang <achiang@canonical.com>, Len Brown <len.brown@intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [201/205] ACPI: processor: fix processor_physically_present on UP
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Chiang <achiang@canonical.com>

commit 856b185dd23da39e562983fbf28860f54e661b41 upstream.

The commit 5d554a7bb06 (ACPI: processor: add internal
processor_physically_present()) is broken on uniprocessor (UP)
configurations, as acpi_get_cpuid() will always return -1.

We use the value of num_possible_cpus() to tell us whether we got
an invalid cpuid from acpi_get_cpuid() in the SMP case, or if
instead, we are UP, in which case num_possible_cpus() is #defined
as 1.

We use num_possible_cpus() instead of num_online_cpus() to
protect ourselves against the scenario of CPU hotplug, and we've
taken down all the CPUs except one.

Thanks to Jan Pogadl for initial report and analysis and Chen
Gong for review.

https://bugzilla.kernel.org/show_bug.cgi?id=16357

Reported-by: Jan Pogadl <pogadl.jan@googlemail.com>:
Reviewed-by: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Alex Chiang <achiang@canonical.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -223,7 +223,7 @@ static bool processor_physically_present
 	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
 	cpuid = acpi_get_cpuid(handle, type, acpi_id);
 
-	if (cpuid == -1)
+	if ((cpuid == -1) && (num_possible_cpus() > 1))
 		return false;
 
 	return true;


