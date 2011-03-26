Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab1CZAMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:12:06 -0400
Received: from kroah.org ([198.145.64.141]:35868 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab1CZAG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:57 2011
Message-Id: <20110326000457.402478620@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [15/35] PCI: return correct value when writing to the "reset" attribute
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

commit 447c5dd7338638f526e9bcf7dcf69b4da5835c7d upstream.

A successful write() to the "reset" sysfs attribute should return the
number of bytes written, not 0. Otherwise userspace (bash) retries the
write over and over again.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-sysfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -966,7 +966,12 @@ static ssize_t reset_store(struct device
 
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


