Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2JBHt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:49:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49023 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2JBHt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:49:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org, hbabu@us.ibm.com,
        mingo@redhat.com, vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com,
        hpa@zytor.com, bhelgaas@google.com, tglx@linutronix.de,
        Takao Indoh <indou.takao@jp.fujitsu.com>
Message-Id: <20121002074434.204.47750.sendpatchset@indoh>
Subject: [PATCH v2 0/2] Reset PCIe devices to address DMA problem on kdump with iommu
Date: Tue,  2 Oct 2012 16:49:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches reset PCIe devices at boot time to address DMA problem on
kdump with iommu. When "reset_devices" is specified, a hot reset is
triggered on each PCIe root port and downstream port to reset its
downstream endpoint.

Background:
A kdump problem about DMA has been discussed for a long time. That is,
when a kernel is switched to the kdump kernel DMA derived from first
kernel affects second kernel. Recently this problem surfaces when iommu
is used for PCI passthrough on KVM guest. In the case of the machine I
use, when intel_iommu=on is specified, DMAR error is detected in kdump
kernel and PCI SERR is also detected. Finally kdump fails because some
devices does not work correctly.

The root cause is that ongoing DMA from first kernel causes DMAR fault
because page table of DMAR is initialized while kdump kernel is booting
up. Therefore to address this problem DMA needs to be stopped before
DMAR is initialized at kdump kernel boot time. By these patches, PCIe
devices are reset by hot reset and its DMA is stopped when reset_devices
is specified. One problem of this solution is that the monitor blacks
out when VGA controller is reset. So this patch does not reset the port
whose child endpoint is VGA device.

v2:
Reset devices in setup_arch() because reset need to be done before
interrupt remapping is initialized.

v1:
https://lkml.org/lkml/2012/8/3/160

Thanks,
Takao Indoh

