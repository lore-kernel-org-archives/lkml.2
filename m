Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1LTDTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:19:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab1LTDTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:19:44 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] kvm: Lock down device assignment
To: avi@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 19 Dec 2011 20:19:41 -0700
Message-ID: <20111220030826.11829.9141.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches to try to better secure the device assignment ioctl.
This firt patch makes KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory
option when assigning a device.  I don't believe we have any
users of this option, so I think we can skip any deprecation
period, especially since it's existence is rather dangerous.

The second patch introduces some file permission checking that Avi
suggested.  If a user has been granted read/write permission to
the PCI sysfs BAR resource files, this is a good indication that
they have access to the device.  We can't call sys_faccessat
directly (not exported), but the important bits are self contained
enough to include directly.  This still works with sudo and libvirt
usage, the latter already grants qemu permission to these files.
Thanks,

Alex

---

Alex Williamson (2):
      kvm: Device assignment permission checks
      kvm: Remove ability to assign a device without iommu support


 virt/kvm/assigned-dev.c |   73 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 63 insertions(+), 10 deletions(-)
