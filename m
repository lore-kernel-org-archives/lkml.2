Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2EWCqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:46:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49754 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2EWCqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:46:09 -0400
MIME-Version: 1.0
Date: Wed, 23 May 2012 10:46:09 +0800
Message-ID: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com>
Subject: ACPI and NUMA guys, please help to check if this patch is OK
From: ethan zhao <ethan.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kurt Garloff <kurt@garloff.de>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] drivers/acpi/numa.c: Add localities checking code against
proximity domains to slit_valid()

 Some buggy BIOS/ACPI will set different number to SLIT localities and
SRAT proximity domains,
 That will make NUMA configuration invalid and kernel will output
information like following

NUMA:Warning:invalid distance parameter, from=-1 to=-1 distance=83

This patch adds some checking code to slit_valid() function in order
to check theSLIT localities
count against SRAT proximity domains number and give clear information
about ACPI bug.

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/acpi/numa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index e56f3be..55c8a8e 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -161,6 +161,13 @@ static __init int slit_valid(struct acpi_table_slit *slit)
 {
        int i, j;
        int d = slit->locality_count;
+       int pxd = nodes_weight(nodes_found_map);
+       if (pxd != d) {
+               printk(KERN_INFO "ACPI: BIOS bug! SLIT localities
count %d doesn't equal SRAT proximity domains number %d\n",
+                       d , pxd);
+               return 0;
+       }
+
        for (i = 0; i < d; i++) {
                for (j = 0; j < d; j++)  {
                        u8 val = slit->entry[d*i + j];
--
1.7.1
