Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2KLVIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:08:55 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33934 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KLVIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:08:53 -0500
Message-ID: <1352754038.12509.16.camel@misato.fc.hp.com>
Subject: Re: [Patch v4 1/7] acpi,memory-hotplug: introduce a mutex lock to
 protect the list in acpi_memory_device
From: Toshi Kani <toshi.kani@hp.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>
Date: Mon, 12 Nov 2012 14:00:38 -0700
In-Reply-To: <1352372693-32411-2-git-send-email-wency@cn.fujitsu.com>
References: <1352372693-32411-1-git-send-email-wency@cn.fujitsu.com>
	 <1352372693-32411-2-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 19:04 +0800, Wen Congyang wrote:
> The memory device can be removed by 2 ways:
> 1. send eject request by SCI
> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> 
> This 2 events may happen at the same time, so we may touch
> acpi_memory_device.res_list at the same time. This patch
> introduce a lock to protect this list.

Hi Wen,

This race condition is not unique in memory hot-remove as the sysfs
eject interface is created for all objects with _EJ0.  For CPU
hot-remove, I addressed this race condition by making the notify handler
to run the hot-remove operation on kacpi_hotplug_wq by calling
acpi_os_hotplug_execute().  This serializes the hot-remove operations
among the two events since the sysfs eject also runs on
kacpi_hotplug_wq.  This way is much simpler and is easy to maintain,
although it does not allow both operations to run simultaneously (which
I do not think we need).  Can it be used for memory hot-remove as well?

Thanks,
-Toshi

