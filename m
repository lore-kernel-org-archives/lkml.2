Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab1IPWQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:16:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11970 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1IPWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:16:17 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>, Sameer Nanda <snanda@chromium.org>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC] PM / Runtime: decrease verbosity in kernel log
Date: Fri, 16 Sep 2011 15:15:53 -0700
Message-Id: <1316211355-2888-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When activating the PCI runtime PM on a laptop, my kernel log is filled with
messages such as the following ones and can be hardly read to find interesting
information:
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PME# enabled
ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0x92205000-0x922053ff] (PCI address [0x92205000-0x922053ff])
ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10b)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PME# enabled
ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0x92205000-0x922053ff]

All those messages are triggered by the following cause, the laptop has a USB
3G modem with USB autosuspend activated. The USB device will wake up about
every 30s to do some network related activities. Every time, the modem wakes
up this triggers the wake up of the attached EHCI/PCI USB host controller
which reconfigures its PCI interface, then everything go back to a suspended mode.

Having the same 10 lines of log repeated is not really useful, but I probably
cannot totally remove them since there are somewhat useful for PCI hotplug
users and other PCI debugging.
So, my proposal is to create a new dev_printk macro : "dev_printk_norpm" which
outputs traces only when the device has not the runtime PM activated,
and guard those traces with it.
(cf the 2 patches in this thread as a PoC)

--
Vincent

