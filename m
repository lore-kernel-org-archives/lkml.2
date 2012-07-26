Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2GZUwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:52:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48111 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2GZUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:52:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [RFC PATCH] Xen-SWIOTLB fixes (v1) for 3.7
Date: Thu, 26 Jul 2012 16:43:25 -0400
Message-Id: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patch for 3.7.

I thought I had addressed this in the past but I can't seem to find
the patches. There is one bug - if one boots a PV 64-bit guests
with more than 4GB, the SWIOTLB gets turned on - and 64MB of precious
low-memory gets used. If you launch more than 10 of them on a 32GB
machines you are going to run in-to trouble as the lowmem gets
exhausted.

On the other hand, the user might want to have 10 guests with 4GB
and each with a PCI device!

So to fix this, we are going to figure out whether the user had
provided the e820_hole=1 parameter in the guest config. The effect
of that parameter is that a massaged host's E820 is used in the guest
 - and we check if it has E820_ACPI or E820_NVS. If so, the user
really wanted to pass in PCI devices to the guest.

Since we now have a routine to check for the e820_hole we can optimize and
see if the user forgot the "iommu=soft" and automatically turn that
on.

The patches are RFC b/c it looks like something has gone bit-rotten the
last time I used this (when Fedora Core 16 was released) b/c I can't
get a guest to boot with e820_hole :-(. But they [the patches] look
sound to me and they do fix the bug of allocating SWIOTLB for normal
PV guests..

