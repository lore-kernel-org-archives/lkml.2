Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2IMAhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:37:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2ILXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Yi Zou <yi.zou@intel.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Open-FCoE.org" <devel@open-fcoe.org>
Subject: [ 028/108] target: fix NULL pointer dereference bug alloc_page() fails to get memory
Date: Wed, 12 Sep 2012 16:28:26 -0700
Message-Id: <20120912232453.494266544@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit d0e27c88d795fb9647153063ec48051fd84e1731 upstream.

I am hitting this bug when the target is low in memory that fails the
alloc_page() for the newly submitted command. This is a sort of off-by-one
bug causing NULL pointer dereference in __free_page() since 'i' here is
really the counter of total pages that have been successfully allocated here.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Open-FCoE.org <devel@open-fcoe.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3477,9 +3477,9 @@ transport_generic_get_mem(struct se_cmd
 	return 0;
 
 out:
-	while (i >= 0) {
-		__free_page(sg_page(&cmd->t_data_sg[i]));
+	while (i > 0) {
 		i--;
+		__free_page(sg_page(&cmd->t_data_sg[i]));
 	}
 	kfree(cmd->t_data_sg);
 	cmd->t_data_sg = NULL;


