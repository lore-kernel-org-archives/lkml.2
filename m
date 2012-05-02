Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2EBVqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:46:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61169 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2EBVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:46:12 -0400
Date: Wed, 2 May 2012 14:46:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 02/19] PCI: introduce recursive rwsem to serialize PCI
 hotplug operations
Message-ID: <20120502214608.GB27281@kroah.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
 <1335539820-11232-3-git-send-email-jiang.liu@huawei.com>
 <20120502050025.GA23579@kroah.com>
 <4FA0E161.9060307@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0E161.9060307@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:25:21PM +0800, Jiang Liu wrote:
> On 2012-5-2 13:00, Greg KH wrote:
> >On Fri, Apr 27, 2012 at 11:16:43PM +0800, Jiang Liu wrote:
> >>From: Jiang Liu<jiang.liu@huawei.com>
> >>
> >>There are multiple ways to trigger PCI hotplug requests concurrently,
> >>such as:
> >>1. Sysfs interfaces exported by the PCI core subsystem
> >>2. Sysfs interfaces exported by the PCI hotplug subsystem
> >>3. PCI hotplug events triggered by PCI Hotplug Controllers
> >>4. ACPI hotplug events for PCI host bridges
> >>5. Driver binding/unbinding events
> >>
> >>The PCI core subsystem doesn't support concurrent hotplug operations yet,
> >>so all PCI hotplug requests should be globally serialized. This patch
> >>introduces several new interfaces to serialize PCI hotplug operations.
> >>
> >>pci_hotplug_try_enter(): try to acquire write lock
> >
> >Ick, no, why would you ever want to do that?
> >
> >>pci_hotplug_enter(): acquire write lock
> >>pci_hotplug_exit(): release write lock
> >>pci_hotplug_disable(): acquire read lock
> >>pci_hotplug_enable(): release read lock
> >
> >No, the pci hotplug core should not need a rwsem, just a simple lock, if
> >that:
> >	pci_hotplug_lock()
> >	pci_hotplug_unlock()
> >and that's it.
> >
> >Really you should not need these functions, the pci hotplug core should
> >handle it for you, and the drivers should not care at all.  That's the
> >"proper" way to fix this up, serialize stuff within the pci core, not
> >the individual drivers.
> >
> >>Today we have reproduced the issue on a real platform by using
> >>acpiphp driver. It's an IA64 platform running Suse 11SP1 (official
> >>2.6.32.12 kernel). The test script is:
> >>
> >>This issue could be reproduced on an IA64 platform with Suse 11SP1
> >>(official 2.6.32.12 kernel) and acpiphp driver.
> >
> >You do realize just how old that kernel is right?  Please don't assume
> >that this kernel version is relevant to us all these years later.
> This could be reproduced with latest kernel too, such as 3.3. We
> use 2.6.32.12 because the all 3.x series kernels can't boot on
> our IA64 platform due to an issue in scheduler. We have reproduced
> similar issue on x86 platforms with 3.x kernels.

That's wonderful, and is relevant, unlike what you originally wrote.

Please always write relevant changelog comments, otherwise they are...

greg k-h
