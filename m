Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2JNPRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:17:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757Ab2JNOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:35 -0400
Message-Id: <20121014143534.740486772@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        xiaojin <jin.xiao@intel.com>, "Yin, Fengwei" <fengwei.yin@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 007/147] n_gsm.c: Implement 3GPP27.010 DLC start-up procedure in MUX
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xiaojin <jin.xiao@intel.com>

commit 7e8ac7b23b67416700dfb8b4136a4e81ce675b48 upstream.

In 3GPP27.010 5.8.1, it defined:
The TE multiplexer initiates the establishment of the multiplexer control channel by sending a SABM frame on DLCI 0 using the procedures of clause 5.4.1.
Once the multiplexer channel is established other DLCs may be established using the procedures of clause 5.4.1.
This patch implement 5.8.1 in MUX level, it make sure DLC0 is the first channel to be setup.

[or for those not familiar with the specification: it was possible to try
 and open a data connection while the control channel was not yet fully
 open, which is a spec violation and confuses some modems]

Signed-off-by: xiaojin <jin.xiao@intel.com>
Tested-by: Yin, Fengwei <fengwei.yin@intel.com>
[tweaked the order we check things and error code]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2889,6 +2889,10 @@ static int gsmtty_open(struct tty_struct
 	gsm = gsm_mux[mux];
 	if (gsm->dead)
 		return -EL2HLT;
+	/* If DLCI 0 is not yet fully open return an error. This is ok from a locking
+	   perspective as we don't have to worry about this if DLCI0 is lost */
+	if (gsm->dlci[0] && gsm->dlci[0]->state != DLCI_OPEN) 
+		return -EL2NSYNC;
 	dlci = gsm->dlci[line];
 	if (dlci == NULL)
 		dlci = gsm_dlci_alloc(gsm, line);


