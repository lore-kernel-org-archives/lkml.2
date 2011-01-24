Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1AXP0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:26:22 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44578 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1AXP0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:19 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: [PATCH 2/7] x86, microcode: Correct sysdev_add error path
Date: Mon, 24 Jan 2011 16:28:58 +0100
Message-Id: <1295882943-11184-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295882943-11184-1-git-send-email-bp@amd64.org>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When we encounter an error while initting the microcode driver on a CPU,
we must undo the previously added sysfs group.

Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/microcode_core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 1cca374..87af68e 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -417,8 +417,10 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR)
-		err = -EINVAL;
+	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		return -EINVAL;
+	}
 
 	return err;
 }
-- 
1.7.4.rc2

