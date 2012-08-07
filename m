Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2HGXUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:20:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854Ab2HGWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:36:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 007/109] powerpc/eeh: Check handle_eeh_events() return value
Date: Tue,  7 Aug 2012 15:34:26 -0700
Message-Id: <20120807222043.718604773@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

commit 10db8d212864cb6741df7d7fafda5ab6661f6f88 upstream.

Function eeh_event_handler() dereferences the pointer returned by
handle_eeh_events() without checking, causing a crash if NULL was
returned, which is expected in some situations.

This patch fixes this bug by checking for the value returned by
handle_eeh_events() before dereferencing it.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/eeh_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/eeh_event.c
+++ b/arch/powerpc/platforms/pseries/eeh_event.c
@@ -85,8 +85,10 @@ static int eeh_event_handler(void * dumm
 	set_current_state(TASK_INTERRUPTIBLE);	/* Don't add to load average */
 	edev = handle_eeh_events(event);
 
-	eeh_clear_slot(eeh_dev_to_of_node(edev), EEH_MODE_RECOVERING);
-	pci_dev_put(edev->pdev);
+	if (edev) {
+		eeh_clear_slot(eeh_dev_to_of_node(edev), EEH_MODE_RECOVERING);
+		pci_dev_put(edev->pdev);
+	}
 
 	kfree(event);
 	mutex_unlock(&eeh_event_mutex);


