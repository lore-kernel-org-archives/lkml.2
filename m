Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0ENQ4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0ENQ4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:56:53 -0400
Message-ID: <4BED80C5.7030503@redhat.com>
Date: Fri, 14 May 2010 18:56:37 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@osdl.org>
CC: minyard@acm.org, mjg@redhat.com, openipmi-developer@lists.sourceforge.net
Subject: [PATCH] ipm: fix mutex use
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like there is an unbalance with the mutexes after the latest 
IPMI patchset applied. For example in 
"static __devinit int init_ipmi_si(void)"
....
	list_for_each_entry(e, &smi_infos, link) {
		if (!e->irq && (!type || e->addr_source == type)) {
			if (!try_smi_init(e)) {
				type = e->addr_source;
			}
		}
	}
	mutex_unlock(&smi_infos_lock);

we are calling mutex_unlock twice, because the mutex_unlock(&smi_infos_lock)
is also called from try_smi_init.

If the lock in try_smi_init is not needed this can be then solved
by removing the mutex_unlock(&smi_infos_lock) from try_smi_init.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

---
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 8d7b879..c6af8e0 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3060,8 +3060,6 @@ static int try_smi_init(struct smi_info *new_smi)
 		goto out_err_stop_timer;
 	}
 
-	mutex_unlock(&smi_infos_lock);
-
 	printk(KERN_INFO "IPMI %s interface initialized\n",
 	       si_to_str[new_smi->si_type]);
 
@@ -3111,8 +3109,6 @@ static int try_smi_init(struct smi_info *new_smi)
 		new_smi->dev_registered = 0;
 	}
 
-	mutex_unlock(&smi_infos_lock);
-
 	return rv;
 }
 


