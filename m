Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2GWBxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:53:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54328 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab2GWBnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:17 -0400
Message-Id: <20120723010700.069605757@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Rustad <mark.d.rustad@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 057/108] tcm_fc: Fix crash seen with aborts and large reads
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit 3cc5d2a6b9a2fd1bf024aa5e52dd22961eecaf13 upstream.

This patch fixes a crash seen when large reads have their exchange
aborted by either timing out or being reset. Because the exchange
abort results in the seq pointer being set to NULL, because the
sequence is no longer valid, it must not be dereferenced. This
patch changes the function ft_get_task_tag to return ~0 if it is
unable to get the tag for this reason. Because the get_task_tag
interface provides no means of returning an error, this seems
like the best way to fix this issue at the moment.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/tcm_fc/tfc_cmd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index f03fb97..5b65f33 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -230,6 +230,8 @@ u32 ft_get_task_tag(struct se_cmd *se_cmd)
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
+	if (cmd->aborted)
+		return ~0;
 	return fc_seq_exch(cmd->seq)->rxid;
 }
 


