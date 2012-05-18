Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946774Ab2ERXHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:07:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946720Ab2ERXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:07:11 -0400
Message-Id: <20120518212651.678362622@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bernhard Kohl <bernhard.kohl@gmx.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 27/47] target: Fix SPC-2 RELEASE bug for multi-session iSCSI client setups
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernhard Kohl <Riedel-und-Kohl@t-online.de>

commit edc318d9fea6854df752ec8c645b960b0d5a1d23 upstream.

This patch addresses a bug in a special case for target core SPC-2 RELEASE
logic where the same physical client (eg: iSCSI InitiatorName) with
differing iSCSI session identifiers (ISID) is allowed to incorrectly release
the same client's SPC-2 reservation from the non reservation holding path.

Note this bug is specific to iscsi-target w/ SPC-2 reservations, and
with the default enforce_pr_isids=1 device attr setting in target-core
controls if a InitiatorName + different ISID reservations are handled
the same as a single iSCSI client entity.

Signed-off-by: Bernhard Kohl <bernhard.kohl@gmx.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -220,6 +220,9 @@ int target_scsi2_reservation_release(str
 	if (dev->dev_reserved_node_acl != sess->se_node_acl)
 		goto out_unlock;
 
+	if (dev->dev_res_bin_isid != sess->sess_bin_isid)
+		goto out_unlock;
+
 	dev->dev_reserved_node_acl = NULL;
 	dev->dev_flags &= ~DF_SPC2_RESERVATIONS;
 	if (dev->dev_flags & DF_SPC2_RESERVATIONS_WITH_ISID) {


