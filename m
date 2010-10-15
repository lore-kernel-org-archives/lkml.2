Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0JOO6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:58:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:55062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0JOO6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:58:30 -0400
Message-ID: <4CB86C0D.60603@kernel.org>
Date: Fri, 15 Oct 2010 16:58:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH v2.6.36-rc7] pcmcia: don't call flush_scheduled_work() spuriously
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 14:58:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au100_generic and soc_common call flush_scheduled_work() spuriously.
Remove them.

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Am I missing something?  The only pcmcia driver which uses the system
workqueue is vrc4173 which doesn't seem to depend on any of the above
and doesn't seem to implement removal properly anyway.

Thank you.

 drivers/pcmcia/au1000_generic.c |    3 ---
 drivers/pcmcia/soc_common.c     |    4 ----
 2 files changed, 7 deletions(-)

Index: work/drivers/pcmcia/au1000_generic.c
===================================================================
--- work.orig/drivers/pcmcia/au1000_generic.c
+++ work/drivers/pcmcia/au1000_generic.c
@@ -441,14 +441,12 @@ int au1x00_pcmcia_socket_probe(struct de


 out_err:
-	flush_scheduled_work();
 	ops->hw_shutdown(skt);
 	while (i-- > 0) {
 		skt = PCMCIA_SOCKET(i);

 		del_timer_sync(&skt->poll_timer);
 		pcmcia_unregister_socket(&skt->socket);
-		flush_scheduled_work();
 		if (i == 0) {
 			iounmap(skt->virt_io + (u32)mips_io_port_base);
 			skt->virt_io = NULL;
@@ -480,7 +478,6 @@ int au1x00_drv_pcmcia_remove(struct plat

 		del_timer_sync(&skt->poll_timer);
 		pcmcia_unregister_socket(&skt->socket);
-		flush_scheduled_work();
 		skt->ops->hw_shutdown(skt);
 		au1x00_pcmcia_config_skt(skt, &dead_socket);
 		iounmap(skt->virt_io + (u32)mips_io_port_base);
Index: work/drivers/pcmcia/soc_common.c
===================================================================
--- work.orig/drivers/pcmcia/soc_common.c
+++ work/drivers/pcmcia/soc_common.c
@@ -627,8 +627,6 @@ void soc_pcmcia_remove_one(struct soc_pc

 	pcmcia_unregister_socket(&skt->socket);

-	flush_scheduled_work();
-
 	skt->ops->hw_shutdown(skt);

 	soc_common_pcmcia_config_skt(skt, &dead_socket);
@@ -720,8 +718,6 @@ int soc_pcmcia_add_one(struct soc_pcmcia
 	pcmcia_unregister_socket(&skt->socket);

  out_err_7:
-	flush_scheduled_work();
-
 	skt->ops->hw_shutdown(skt);
  out_err_6:
 	list_del(&skt->node);
