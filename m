Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2JNOl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46142 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab2JNOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:53 -0400
Message-Id: <20121014143553.104568198@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 143/147] e1000: fix lockdep splat in shutdown handler
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 3a3847e007aae732d64d8fd1374126393e9879a3 upstream.

As reported by Steven Rostedt, e1000 has a lockdep splat added
during the recent merge window.  The issue is that
cancel_delayed_work is called while holding our private mutex.

There is no reason that I can see to hold the mutex during pci
shutdown, it was more just paranoia that I put the mutex_lock
around the call to e1000_down.

In a quick survey lots of drivers handle locking differently when
being called by the pci layer.  The assumption here is that we
don't need the mutexes' protection in this function because
the driver could not be unloaded while in the shutdown handler
which is only called at reboot or poweroff.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 985d589..934d5aa 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4724,8 +4724,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	netif_device_detach(netdev);
 
-	mutex_lock(&adapter->mutex);
-
 	if (netif_running(netdev)) {
 		WARN_ON(test_bit(__E1000_RESETTING, &adapter->flags));
 		e1000_down(adapter);
@@ -4733,10 +4731,8 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 #ifdef CONFIG_PM
 	retval = pci_save_state(pdev);
-	if (retval) {
-		mutex_unlock(&adapter->mutex);
+	if (retval)
 		return retval;
-	}
 #endif
 
 	status = er32(STATUS);
@@ -4791,8 +4787,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	if (netif_running(netdev))
 		e1000_free_irq(adapter);
 
-	mutex_unlock(&adapter->mutex);
-
 	pci_disable_device(pdev);
 
 	return 0;


