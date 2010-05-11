Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab0EKJpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab0EKJpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:45:07 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH] PCI: return correct value when writing to the "reset"
	attribute
To: linux-pci@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Date: Tue, 11 May 2010 11:44:54 +0200
Message-ID: <20100511094453.12485.43792.stgit@leela.lan>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A successful write() to the "reset" sysfs attribute should return the
number of bytes written, not 0. Otherwise userspace (bash) retries the
write over and over again.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

 drivers/pci/pci-sysfs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fad9398..ba88a2f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -960,7 +960,12 @@ static ssize_t reset_store(struct device *dev,
 
 	if (val != 1)
 		return -EINVAL;
-	return pci_reset_function(pdev);
+
+	result = pci_reset_function(pdev);
+	if (result < 0)
+		return result;
+
+	return count;
 }
 
 static struct device_attribute reset_attr = __ATTR(reset, 0200, NULL, reset_store);

