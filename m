Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0FNPRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:17:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab0FNPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=jtXxQqlw7N/skIcr74UofV81JF7zbQBSlsOslb2PKoenUpM8MZotgn/tkf7n5UHKkV
         9U4y8H/2aU+22Yaq5+lrr4E13Cmw7eQKVgsx8Tb+lBb0B1rVXlEzI+KzQkYFG2Qgpz3m
         hYCX3FF+p6IDW1h34NfzDQWI9a9YJ7uR29Bbs=
Message-ID: <4C16480C.40808@gmail.com>
Date: Mon, 14 Jun 2010 17:17:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Intel IOMMU double lock
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found the following double lock.

In get_domain_for_dev:
  spin_lock_irqsave(&device_domain_lock, flags);
  domain_exit(domain);
    domain_remove_dev_info(domain);
      spin_lock_irqsave(&device_domain_lock, flags);
      spin_unlock_irqrestore(&device_domain_lock, flags);
  spin_unlock_irqrestore(&device_domain_lock, flags);

I don't know how to solve this properly. Is this OK:
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 796828f..e6ac8e7 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1874,14 +1874,15 @@ static struct dmar_domain
*get_domain_for_dev(struct pci_dev *pdev, int gaw)
                        }
                }
                if (found) {
+                       spin_unlock_irqrestore(&device_domain_lock, flags);
                        free_devinfo_mem(info);
                        domain_exit(domain);
                        domain = found;
                } else {
                        list_add(&info->link, &domain->devices);
                        list_add(&info->global, &device_domain_list);
+                       spin_unlock_irqrestore(&device_domain_lock, flags);
                }
-               spin_unlock_irqrestore(&device_domain_lock, flags);
        }

 found_domain:

thanks,
-- 
js
