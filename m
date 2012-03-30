Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965219Ab2C3WUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:20:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52476 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935690Ab2C3VMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:12:36 -0400
Message-Id: <20120330194848.839914270@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark D Rustad <mark.d.rustad@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Robert Love <robert.w.love@intel.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 068/149] tcm_fc: Fix fc_exch memory leak in ft_send_resp_status
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 031ed4d565b31880a4136bb7366bc89f5b1dba7d upstream.

This patch fixes a bug in tcm_fc where fc_exch memory from fc_exch_mgr->ep_pool
is currently being leaked by ft_send_resp_status() usage.  Following current
code in ft_queue_status() response path, using lport->tt.seq_send() needs to be
followed by a lport->tt.exch_done() in order to release fc_exch memory back into
libfc_em kmem_cache.

ft_send_resp_status() code is currently used in pre submit se_cmd ft_send_work()
error exceptions, TM request setup exceptions, and main TM response callback
path in ft_queue_tm_resp().  This bugfix addresses the leak in these cases.

Cc: Mark D Rustad <mark.d.rustad@intel.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_cmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -329,10 +329,12 @@ static void ft_send_resp_status(struct f
 
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_DD_CMD_STATUS, 0);
 	sp = fr_seq(fp);
-	if (sp)
+	if (sp) {
 		lport->tt.seq_send(lport, sp, fp);
-	else
+		lport->tt.exch_done(sp);
+	} else {
 		lport->tt.frame_send(lport, fp);
+	}
 }
 
 /*


