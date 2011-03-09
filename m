Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1CISbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:31:40 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:55608 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752856Ab1CISbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:31:39 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Mar 2011 13:31:39 EST
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH v2 2/2] n_gsm: fix UIH control byte : P bit should be 0
Date: Wed,  9 Mar 2011 19:24:49 +0100
Message-Id: <1299695089-2994-2-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299695089-2994-1-git-send-email-eric@eukrea.com>
References: <1299695089-2994-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14265151821570026777
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* the GSM 07.10 specification says in 5.4.3.1 that
'both stations shall set the P bit to 0'
  thanks to Alan Cox for finding this explanation in the spec

* without this fix, on Telit & Sim.com modems, opening a new DLC
randomly fails. Not setting PF bit of the control byte gives a
reliable behaviour on these modems.

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
v2 : updated patch and comment following Alan's review

 drivers/tty/n_gsm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index aa2e5d3..6613918 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1250,8 +1250,7 @@ static void gsm_control_response(struct gsm_mux *gsm, unsigned int command,
 
 static void gsm_control_transmit(struct gsm_mux *gsm, struct gsm_control *ctrl)
 {
-	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 1,
-							gsm->ftype|PF);
+	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 1, gsm->ftype);
 	if (msg == NULL)
 		return;
 	msg->data[0] = (ctrl->cmd << 1) | 2 | EA;	/* command */
-- 
1.7.4

