Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab1D2TGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:06:40 -0400
Received: from kroah.org ([198.145.64.141]:50262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933034Ab1D2S6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185654.515303419@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [20/55] tty/n_gsm: fix bug in CRC calculation for gsm1 mode
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

commit 9db4e4381a8e881ff65a5d3400bfa471f84217e7 upstream.

Problem description:
  gsm_queue() calculate a CRC for arrived frames. As a last step of
  CRC calculation it call

    gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);

  This work perfectly for the case of GSM0 mode as gsm->received_fcs
  contain the last piece of data required to generate final CRC.

  gsm->received_fcs is not used for GSM1 mode. Thus we put an
  additional byte to CRC calculation. As result we get a wrong CRC
  and reject incoming frame.

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/n_gsm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1659,8 +1659,12 @@ static void gsm_queue(struct gsm_mux *gs
 
 	if ((gsm->control & ~PF) == UI)
 		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
-	/* generate final CRC with received FCS */
-	gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
+	if (gsm->encoding == 0){
+		/* WARNING: gsm->received_fcs is used for gsm->encoding = 0 only.
+		            In this case it contain the last piece of data
+		            required to generate final CRC */
+		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
+	}
 	if (gsm->fcs != GOOD_FCS) {
 		gsm->bad_fcs++;
 		if (debug & 4)


