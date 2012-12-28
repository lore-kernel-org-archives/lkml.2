Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2L1TaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:30:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55582 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932389Ab2L1TTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:31 -0500
Message-Id: <20121228190341.201180702@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Binderman <dcb314@hotmail.com>
Subject: [ 053/173] xhci: Fix conditional check in bandwidth calculation.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 392a07ae3316f2b90b39ce41e66d6f6b5c95de90 upstream.

David reports that at drivers/usb/host/xhci.c:2257:

static bool xhci_is_sync_in_ep(unsigned int ep_type)
{
    return (ep_type == ISOC_IN_EP || ep_type != INT_IN_EP);
}

The static analyser cppcheck says

[linux-3.7-rc2/drivers/usb/host/xhci.c:2257]: (style) Redundant condition: If ep_type == 5, the comparison ep_type != 7 is always true.

Maybe the original programmer intention was something like

static bool xhci_is_sync_in_ep(unsigned int ep_type)
{
    return (ep_type == ISOC_IN_EP || ep_type == INT_IN_EP);
}

Fix this.

This patch should be backported to stable kernels as old as 3.2, that
contain the commit 2b69899934c63b7b9432568584fb4c4a2924f40c "xhci: USB
3.0 BW checking."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 1ca0f3a..2e29f2f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2255,7 +2255,7 @@ static bool xhci_is_async_ep(unsigned int ep_type)
 
 static bool xhci_is_sync_in_ep(unsigned int ep_type)
 {
-	return (ep_type == ISOC_IN_EP || ep_type != INT_IN_EP);
+	return (ep_type == ISOC_IN_EP || ep_type == INT_IN_EP);
 }
 
 static unsigned int xhci_get_ss_bw_consumed(struct xhci_bw_info *ep_bw)


