Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2AEAsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:48:36 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59503 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab2AEAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:48:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] Support Function Level Reset (FLR) in the xen-pciback module (v1) and some fixes.
Date: Wed,  4 Jan 2012 19:46:38 -0500
Message-Id: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F04F353.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patches allow the pciback module to perform a reset whenever
a PCI device is:
 - attached to the pciback module, as so:
  echo "0000:01.07.0" > /sys/bus/pci/devices/pciback/bind
 - detached from the pciback module, as so:
  echo "0000:01.07.0" > /sys/bus/pci/devices/pciback/unbind
 - and when the guest is done with (internally when the guest is not using
   the PCI device anymore).

I ran in one issue which is that I could not do pci_reset_function call when "bind"
or "unbind" were done as the device_lock was held (and pci_reset_function tried to
acquire the mutex). The solution was to introduce a new "pci_reset_function":

[PATCH 1/5] pci: Introduce __pci_reset_function_locked to be used
and then piggyback on that in
[PATCH 2/5] xen/pciback: Support pci_reset_function, aka FLR or D3

Also there are two fixes included in this - one where the PCI_DEV_FLAG_ASSIGNED
was in the wrong location and the "device has been assigned to other domain"
warning that always appeared. More details are in the patches themselves.


 drivers/pci/pci.c                  |   25 ++++++++++++++++++++
 drivers/xen/xen-pciback/pci_stub.c |   45 +++++++++++++++++++++++++++++++++--
 drivers/xen/xen-pciback/pciback.h  |    1 +
 drivers/xen/xen-pciback/xenbus.c   |    8 +++---
 include/linux/pci.h                |    1 +
 5 files changed, 73 insertions(+), 7 deletions(-)
