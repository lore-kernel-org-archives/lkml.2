Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2GZVYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:24:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2GZVU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:20:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Rustad <mark.d.rustad@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 08/23] tcm_fc: Fix crash seen with aborts and large reads
Date: Thu, 26 Jul 2012 14:19:47 -0700
Message-Id: <20120726211406.606538356@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_cmd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -240,6 +240,8 @@ u32 ft_get_task_tag(struct se_cmd *se_cm
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
+	if (cmd->aborted)
+		return ~0;
 	return fc_seq_exch(cmd->seq)->rxid;
 }
 


