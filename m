Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab1CWMVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1CWMVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:21:52 -0400
Date: Wed, 23 Mar 2011 14:21:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: stable@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Michal Schmidt <mschmidt@redhat.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH stable] PCI: return correct value when writing to the "reset"
 attribute
Message-ID: <20110323122103.GA24976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 447c5dd7338638f526e9bcf7dcf69b4da5835c7d
Author: Michal Schmidt <mschmidt@redhat.com>
Date:   Tue May 11 11:44:54 2010 +0200

A successful write() to the "reset" sysfs attribute should return the
number of bytes written, not 0. Otherwise userspace (bash) retries the
write over and over again.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Applies without changes to all of 2.6.32,2.6.33,2.6.34

This bug is starting to bite userspace, it seems that the right thing to
do is to fix the bug in stable kernels.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---
 drivers/pci/pci-sysfs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 3a3b911..e44682c 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -939,7 +939,12 @@ static ssize_t reset_store(struct device *dev,
 
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
-- 
1.7.3.2.91.g446ac
