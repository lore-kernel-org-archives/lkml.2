Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740Ab2EWRxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:53:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35160 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2EWRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:53:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH 3/4] xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for correctness.
Date: Wed, 23 May 2012 13:47:01 -0400
Message-Id: <1337795222-29946-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure that those parameters are setup to be correct.
As such the value of 0 is deemed invalid and we find that we
bail out. The hypervisor sets by default all of them to be zero
and when the hypercall is done does a simple:

 a.value = d->arch.hvm_domain.params[a.index];

Which means that if the Xen toolstack forgot to setup the proper
HVM_PARAM_CONSOLE_EVTCHN, we would get the default value of 0
and use that.

CC: stable@kernel.org
Fixes-Oracle-Bug: 14091238
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 3277f0e..5fb1cb9 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -216,12 +216,12 @@ static int xen_hvm_console_init(void)
 		return 0;
 
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
-	if (r < 0)
+	if (r < 0 || v == 0)
 		goto err;
 	info->evtchn = v;
 	v = 0;
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
-	if (r < 0)
+	if (r < 0 || v == 0)
 		goto err;
 	mfn = v;
 	info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
-- 
1.7.7.5

