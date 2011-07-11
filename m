Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1GKKWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:22:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64543 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1GKKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:22:31 -0400
Subject: [PATCH] hp-wmi: fix use after free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 12:22:21 +0200
Message-ID: <1310379741.6975.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  191.310008] WARNING: kmemcheck: Caught 32-bit read from freed memory (f0d25f14)
[  191.310011] c056d2f088000000105fd2f00000000050415353040000000000000000000000
[  191.310020]  i i i i f f f f f f f f f f f f f f f f f f f f f f f f f f f f
[  191.310027]                                          ^
[  191.310029] 
[  191.310032] Pid: 737, comm: modprobe Not tainted 3.0.0-rc5+ #268 Hewlett-Packard HP Compaq 6005 Pro SFF PC/3047h
[  191.310036] EIP: 0060:[<f80b3104>] EFLAGS: 00010286 CPU: 0
[  191.310039] EIP is at hp_wmi_perform_query+0x104/0x150 [hp_wmi]
[  191.310041] EAX: f0d25601 EBX: f0d25f00 ECX: 000121cf EDX: 000121ce
[  191.310043] ESI: f0d25f10 EDI: f0f97ea8 EBP: f0f97ec4 ESP: c173f34c
[  191.310045]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  191.310046] CR0: 8005003b CR2: f540c000 CR3: 30f30000 CR4: 000006d0
[  191.310048] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  191.310050] DR6: ffff4ff0 DR7: 00000400
[  191.310051]  [<f80b317b>] hp_wmi_dock_state+0x2b/0x40 [hp_wmi]
[  191.310054]  [<f80b6093>] hp_wmi_init+0x93/0x1a8 [hp_wmi]
[  191.310057]  [<c10011f0>] do_one_initcall+0x30/0x170
[  191.310061]  [<c107ab9f>] sys_init_module+0xef/0x1a60
[  191.310064]  [<c149f998>] sysenter_do_call+0x12/0x28
[  191.310067]  [<ffffffff>] 0xffffffff

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/platform/x86/hp-wmi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index f94017b..f8f43ff 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -207,6 +207,7 @@ static int hp_wmi_perform_query(int query, int write, void *buffer,
 	};
 	struct acpi_buffer input = { sizeof(struct bios_args), &args };
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	u32 rc;
 
 	if (WARN_ON(insize > sizeof(args.data)))
 		return -EINVAL;
@@ -224,13 +225,13 @@ static int hp_wmi_perform_query(int query, int write, void *buffer,
 	}
 
 	bios_return = (struct bios_return *)obj->buffer.pointer;
+	rc = bios_return->return_code;
 
-	if (bios_return->return_code) {
-		if (bios_return->return_code != HPWMI_RET_UNKNOWN_CMDTYPE)
-			pr_warn("query 0x%x returned error 0x%x\n",
-				query, bios_return->return_code);
+	if (rc) {
+		if (rc != HPWMI_RET_UNKNOWN_CMDTYPE)
+			pr_warn("query 0x%x returned error 0x%x\n", query, rc);
 		kfree(obj);
-		return bios_return->return_code;
+		return rc;
 	}
 
 	if (!outsize) {


