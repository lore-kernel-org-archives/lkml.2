Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0DSMIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:08:50 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:36804 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0DSMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:08:49 -0400
Message-ID: <4BCC47CF.8060107@de.ibm.com>
Date: Mon, 19 Apr 2010 14:08:47 +0200
From: Thomas Klein <osstklei@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>
Subject: [PATCH 2/2] ehea: fix possible DLPAR/mem deadlock
References: <1221140080-9853-1-git-send-email-sebastien.dugue@bull.net>	<1221140080-9853-3-git-send-email-sebastien.dugue@bull.net>	<48CE7CC3.8040902@de.ibm.com> <20080916085746.194c1510@bull.net>
In-Reply-To: <20080916085746.194c1510@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force serialization of userspace-triggered DLPAR/mem operations

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
---

Patch created against 2.6.34-rc4

diff -Nurp linux-2.6.34-rc4.orig//drivers/net/ehea/ehea.h linux-2.6.34-rc4//drivers/net/ehea/ehea.h
--- linux-2.6.34-rc4.orig//drivers/net/ehea/ehea.h	2010-04-19 11:54:07.000000000 +0200
+++ linux-2.6.34-rc4//drivers/net/ehea/ehea.h	2010-04-19 12:00:14.000000000 +0200
@@ -40,7 +40,7 @@
  #include <asm/io.h>

  #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0102"
+#define DRV_VERSION	"EHEA_0103"

  /* eHEA capability flags */
  #define DLPAR_PORT_ADD_REM 1
diff -Nurp linux-2.6.34-rc4.orig//drivers/net/ehea/ehea_main.c linux-2.6.34-rc4//drivers/net/ehea/ehea_main.c
--- linux-2.6.34-rc4.orig//drivers/net/ehea/ehea_main.c	2010-04-19 11:59:11.000000000 +0200
+++ linux-2.6.34-rc4//drivers/net/ehea/ehea_main.c	2010-04-19 11:59:50.000000000 +0200
@@ -2889,7 +2889,6 @@ static void ehea_rereg_mrs(struct work_s
  	int ret, i;
  	struct ehea_adapter *adapter;

-	mutex_lock(&dlpar_mem_lock);
  	ehea_info("LPAR memory changed - re-initializing driver");

  	list_for_each_entry(adapter, &adapter_list, list)
@@ -2959,7 +2958,6 @@ static void ehea_rereg_mrs(struct work_s
  		}
  	ehea_info("re-initializing driver complete");
  out:
-	mutex_unlock(&dlpar_mem_lock);
  	return;
  }

@@ -3542,7 +3540,14 @@ void ehea_crash_handler(void)
  static int ehea_mem_notifier(struct notifier_block *nb,
                               unsigned long action, void *data)
  {
+	int ret = NOTIFY_BAD;
  	struct memory_notify *arg = data;
+
+	if (!mutex_trylock(&dlpar_mem_lock)) {
+		ehea_info("ehea_mem_notifier must not be called parallelized");
+		goto out;
+	}
+
  	switch (action) {
  	case MEM_CANCEL_OFFLINE:
  		ehea_info("memory offlining canceled");
@@ -3551,14 +3556,14 @@ static int ehea_mem_notifier(struct noti
  		ehea_info("memory is going online");
  		set_bit(__EHEA_STOP_XFER, &ehea_driver_flags);
  		if (ehea_add_sect_bmap(arg->start_pfn, arg->nr_pages))
-			return NOTIFY_BAD;
+			goto out_unlock;
  		ehea_rereg_mrs(NULL);
  		break;
  	case MEM_GOING_OFFLINE:
  		ehea_info("memory is going offline");
  		set_bit(__EHEA_STOP_XFER, &ehea_driver_flags);
  		if (ehea_rem_sect_bmap(arg->start_pfn, arg->nr_pages))
-			return NOTIFY_BAD;
+			goto out_unlock;
  		ehea_rereg_mrs(NULL);
  		break;
  	default:
@@ -3566,8 +3571,12 @@ static int ehea_mem_notifier(struct noti
  	}

  	ehea_update_firmware_handles();
+	ret = NOTIFY_OK;

-	return NOTIFY_OK;
+out_unlock:
+	mutex_unlock(&dlpar_mem_lock);
+out:
+	return ret;
  }

  static struct notifier_block ehea_mem_nb = {
