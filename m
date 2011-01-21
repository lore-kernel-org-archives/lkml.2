Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1AUPHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:07:22 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58419 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1AUPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:07:20 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCHSET 0/12] RAS daemon v4
Date: Fri, 21 Jan 2011 16:09:23 +0100
Message-Id: <1295622575-18607-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

here's another round of the RAS daemon patchset. This time I'd like to
get some ACKs/NACKs on the perf bits and whether this is agreeable to
do. To some of the patches:

* 0001-perf-Start-the-massive-restructuring.patch:

This renames perf_event.c into events/core.c, as talked about earlier.
This is only a first step though, the rest should come from perf people
I guess...

* 0002-perf-Add-persistent-event-facilities.patch

... and this one puts the persistent bits in persistent.c

* 0004-perf-Add-Makefile.lib.patch
* 0005-perf-Export-trace-event-utils.patch

I'm adding a toplevel tools/Makefile here which we could use for the
other tools in there since we keep growing even more tools with each
kernel release.

* 0007-perf-Export-debugfs-utilities.patch

This one is needed only temporary, as we're moving the perf events to
/sysfs. After that work is done, the persistent fd will be read from
there.

For more details, check the individual patches.

Btw, the patches are ontop of tip/master from ~two weeks ago, i.e.:
cf1f6cd677a9ce8c80e5de61724a25074ad9a8cf.

In order to run this patchset, you need only this hunk:

---
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index c018109..7bffbc6 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <trace/events/mce.h>
 
 #include "mce_amd.h"
 
@@ -598,6 +599,8 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 
 	amd_decode_err_code(m->status & 0xffff);
 
+	trace_mce_record(m);
+
 	return NOTIFY_STOP;
 }
 EXPORT_SYMBOL_GPL(amd_decode_mce);
---

so that you can inject some MCEs like so:

$ cd tools/
$ make -j ras
$ ./ras/rasd
$ modprobe mce_amd_inj (built by CONFIG_EDAC_MCE_INJ)
$ echo 0x9c00410000010016 > /sys/devices/system/edac/mce/status
$ echo 0 > /sys/devices/system/edac/mce/bank

And after 30 sec the latest, /var/log/ras.log will contain:

Got MCE, cpu: 0, status: 0x9c00410000010016, addr: 0x0000000000000000

This is still undecoded yet but I'm working on it.

Anyway, please take a look and send me all comments you'd have.

Thanks.
