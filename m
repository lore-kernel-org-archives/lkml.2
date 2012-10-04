Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946189Ab2JDVmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:42:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934229Ab2JDVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:25:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        xiaojin <jin.xiao@intel.com>, "Yin, Fengwei" <fengwei.yin@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 35/52] n_gsm.c: Implement 3GPP27.010 DLC start-up procedure in MUX
Date: Thu,  4 Oct 2012 14:21:26 -0700
Message-Id: <20121004210639.741523886@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


