Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab3AIUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:42757 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314Ab3AIUj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Binderman <dcb314@hotmail.com>
Subject: [ 064/123] xhci: Fix conditional check in bandwidth calculation.
Date: Wed,  9 Jan 2013 12:35:03 -0800
Message-Id: <20130109201506.827253029@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2254,7 +2254,7 @@ static bool xhci_is_async_ep(unsigned in
 
 static bool xhci_is_sync_in_ep(unsigned int ep_type)
 {
-	return (ep_type == ISOC_IN_EP || ep_type != INT_IN_EP);
+	return (ep_type == ISOC_IN_EP || ep_type == INT_IN_EP);
 }
 
 static unsigned int xhci_get_ss_bw_consumed(struct xhci_bw_info *ep_bw)


