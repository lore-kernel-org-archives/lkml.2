Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2EBGmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:42:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62223 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2EBGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:42:14 -0400
Date: Tue, 1 May 2012 22:00:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 02/19] PCI: introduce recursive rwsem to serialize PCI
 hotplug operations
Message-ID: <20120502050025.GA23579@kroah.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
 <1335539820-11232-3-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335539820-11232-3-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:16:43PM +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> There are multiple ways to trigger PCI hotplug requests concurrently,
> such as:
> 1. Sysfs interfaces exported by the PCI core subsystem
> 2. Sysfs interfaces exported by the PCI hotplug subsystem
> 3. PCI hotplug events triggered by PCI Hotplug Controllers
> 4. ACPI hotplug events for PCI host bridges
> 5. Driver binding/unbinding events
> 
> The PCI core subsystem doesn't support concurrent hotplug operations yet,
> so all PCI hotplug requests should be globally serialized. This patch
> introduces several new interfaces to serialize PCI hotplug operations.
> 
> pci_hotplug_try_enter(): try to acquire write lock

Ick, no, why would you ever want to do that?

> pci_hotplug_enter(): acquire write lock
> pci_hotplug_exit(): release write lock
> pci_hotplug_disable(): acquire read lock
> pci_hotplug_enable(): release read lock

No, the pci hotplug core should not need a rwsem, just a simple lock, if
that:
	pci_hotplug_lock()
	pci_hotplug_unlock()
and that's it.

Really you should not need these functions, the pci hotplug core should
handle it for you, and the drivers should not care at all.  That's the
"proper" way to fix this up, serialize stuff within the pci core, not
the individual drivers.

> Today we have reproduced the issue on a real platform by using
> acpiphp driver. It's an IA64 platform running Suse 11SP1 (official
> 2.6.32.12 kernel). The test script is:
> 
> This issue could be reproduced on an IA64 platform with Suse 11SP1
> (official 2.6.32.12 kernel) and acpiphp driver.

You do realize just how old that kernel is right?  Please don't assume
that this kernel version is relevant to us all these years later.

> +/*
> + * trylock for writing -- returns 1 if successful, 0 if contention
> + */
> +int pci_hotplug_try_enter(void)
> +{
> +	if (current != pci_hotplug_mutex_owner) {
> +		if (down_write_trylock(&pci_hotplug_rwsem) == 0)
> +			return 0;
> +		pci_hotplug_mutex_owner = current;
> +	}
> +	pci_hotplug_mutex_recursive++;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(pci_hotplug_try_enter);

Don't try to invent new lock types like this, you are bound to get it
wrong.  And don't create recursive locks, fix the code up to never need
it.

thanks,

greg k-h
