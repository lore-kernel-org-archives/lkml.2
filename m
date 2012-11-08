Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2KHK7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:59:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55605 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2KHK66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:58:58 -0500
X-IronPort-AV: E=Sophos;i="4.80,737,1344182400"; 
   d="scan'208";a="6161801"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [Patch v4 0/7] acpi,memory-hotplug : implement framework for hot removing memory
Date: Thu, 8 Nov 2012 19:04:46 +0800
Message-Id: <1352372693-32411-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 18:58:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 18:59:00,
	Serialize complete at 2012/11/08 18:59:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory device can be removed by 2 ways:
1. send eject request by SCI
2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject

In the 1st case, acpi_memory_disable_device() will be called.
In the 2nd case, acpi_memory_device_remove() will be called.
acpi_memory_device_remove() will also be called when we unbind the
memory device from the driver acpi_memhotplug or a driver initialization
fails.

acpi_memory_disable_device() has already implemented a code which
offlines memory and releases acpi_memory_info struct . But
acpi_memory_device_remove() has not implemented it yet.

So the patch prepares the framework for hot removing memory and
adds the framework into acpi_memory_device_remove().

The last version of this patchset is here:
https://lkml.org/lkml/2012/10/26/175

Note: patch1-2 are in pm tree now. And there is a bug in patch1, so I resend
them. The commit in pm tree is:
patch1: 85fcb3758c10e063a2a30dfad75017097999deed
patch2: d0fbb400b6f3a6191bdc5024f8733b2e2b86338f

Changes from v3 to v4:
1. patch1: unlock list_lock when removing memory fails.
2. patch2: just rebase them
3. patch3-7: these patches are in -mm tree, and they conflict with this
   patchset, so Adrew Morton drop them from -mm tree. I rebase and merge
   them into this patchset.

Wen Congyang (6):
  acpi,memory-hotplug: introduce a mutex lock to protect the list in
    acpi_memory_device
  acpi_memhotplug.c: fix memory leak when memory device is unbound from
    the module acpi_memhotplug
  acpi_memhotplug.c: free memory device if acpi_memory_enable_device()
    failed
  acpi_memhotplug.c: don't allow to eject the memory device if it is
    being used
  acpi_memhotplug.c: bind the memory device when the driver is being
    loaded
  acpi_memhotplug.c: auto bind the memory device which is hotplugged
    before the driver is loaded

Yasuaki Ishimatsu (1):
  acpi,memory-hotplug : add memory offline code to
    acpi_memory_device_remove()

 drivers/acpi/acpi_memhotplug.c | 168 ++++++++++++++++++++++++++++++++---------
 1 file changed, 133 insertions(+), 35 deletions(-)

-- 
1.8.0

