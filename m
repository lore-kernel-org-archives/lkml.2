Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2AUKJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:09:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16517 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2AUKI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:08:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/21] PCI: Try to assign required+option size at first
Date: Sat, 21 Jan 2012 02:08:20 -0800
Message-Id: <1327140517-14811-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F1A8EB5.0081,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found reassign can not find right range for one resource. even total range is enough.

bridge b1:02.0 will need 2M+3M
bridge b1:03.0 will need 2M+3M

so bridge b0:00.0 will get assigned: 4M : [f8000000-f83fffff]
   later is reassigned to 10M : [f8000000-f9ffffff]

b1:02.0 is assigned to 2M : [f8000000-f81fffff]
b1:03.0 is assigned to 2M : [f8200000-f83fffff]

after that b1:03.0 get chance to be reassigned to [f8200000-f86fffff]
but b1:02.0 will not have chance to expand, because b1:03.0 is using in middle one.

[  187.911401] pci 0000:b1:02.0: bridge window [mem 0x00100000-0x002fffff] to [bus b2-b2] add_size 300000
[  187.920764] pci 0000:b1:03.0: bridge window [mem 0x00100000-0x002fffff] to [bus b3-b3] add_size 300000
[  187.930129] pci 0000:b1:02.0: [mem 0x00100000-0x002fffff] get_res_add_size  add_size 300000
[  187.938500] pci 0000:b1:03.0: [mem 0x00100000-0x002fffff] get_res_add_size  add_size 300000
[  187.946857] pci 0000:b0:00.0: bridge window [mem 0x00100000-0x004fffff] to [bus b1-b3] add_size 600000
[  187.956206] pci 0000:b0:00.0: BAR 14: assigned [mem 0xf8000000-0xf83fffff]
[  187.963102] pci 0000:b0:00.0: BAR 15: assigned [mem 0xf5000000-0xf51fffff pref]
[  187.970434] pci 0000:b0:00.0: BAR 14: reassigned [mem 0xf8000000-0xf89fffff]
[  187.977497] pci 0000:b1:02.0: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[  187.984383] pci 0000:b1:02.0: BAR 15: assigned [mem 0xf5000000-0xf50fffff pref]
[  187.991695] pci 0000:b1:03.0: BAR 14: assigned [mem 0xf8200000-0xf83fffff]
[  187.998576] pci 0000:b1:03.0: BAR 15: assigned [mem 0xf5100000-0xf51fffff pref]
[  188.005888] pci 0000:b1:03.0: BAR 14: reassigned [mem 0xf8200000-0xf86fffff]
[  188.012939] pci 0000:b1:02.0: BAR 14: can't assign mem (size 0x200000)
[  188.019471] pci 0000:b1:02.0: failed to add 300000 to res=[mem 0xf8000000-0xf81fffff]
[  188.027326] pci 0000:b2:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
[  188.034071] pci 0000:b2:00.0: reg 18c: [mem 0x00000000-0x000fffff 64bit]
[  188.040795] pci 0000:b2:00.0: BAR 2: assigned [mem 0xf8000000-0xf80fffff 64bit]
[  188.048119] pci 0000:b2:00.0: BAR 2: set to [mem 0xf8000000-0xf80fffff 64bit] (PCI address [0xf8000000-0xf80fffff])
[  188.058550] pci 0000:b2:00.0: BAR 6: assigned [mem 0xf5000000-0xf50fffff pref]
[  188.065802] pci 0000:b2:00.0: BAR 0: assigned [mem 0xf8100000-0xf8103fff 64bit]
[  188.073125] pci 0000:b2:00.0: BAR 0: set to [mem 0xf8100000-0xf8103fff 64bit] (PCI address [0xf8100000-0xf8103fff])
[  188.083596] pci 0000:b2:00.0: reg 18c: [mem 0x00000000-0x000fffff 64bit]
[  188.090310] pci 0000:b2:00.0: BAR 9: can't assign mem (size 0x300000)
[  188.096773] pci 0000:b2:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
[  188.103479] pci 0000:b2:00.0: BAR 7: assigned [mem 0xf8104000-0xf810ffff 64bit]
[  188.110801] pci 0000:b2:00.0: BAR 7: set to [mem 0xf8104000-0xf810ffff 64bit] (PCI address [0xf8104000-0xf810ffff])
[  188.121256] pci 0000:b1:02.0: PCI bridge to [bus b2-b2]
[  188.126512] pci 0000:b1:02.0:   bridge window [mem 0xf8000000-0xf81fffff]
[  188.133328] pci 0000:b1:02.0:   bridge window [mem 0xf5000000-0xf50fffff pref]
[  188.140608] pci 0000:b3:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
[  188.147341] pci 0000:b3:00.0: reg 18c: [mem 0x00000000-0x000fffff 64bit]
[  188.154076] pci 0000:b3:00.0: BAR 2: assigned [mem 0xf8200000-0xf82fffff 64bit]
[  188.161417] pci 0000:b3:00.0: BAR 2: set to [mem 0xf8200000-0xf82fffff 64bit] (PCI address [0xf8200000-0xf82fffff])
[  188.171865] pci 0000:b3:00.0: BAR 6: assigned [mem 0xf5100000-0xf51fffff pref]
[  188.179090] pci 0000:b3:00.0: BAR 0: assigned [mem 0xf8300000-0xf8303fff 64bit]
[  188.186431] pci 0000:b3:00.0: BAR 0: set to [mem 0xf8300000-0xf8303fff 64bit] (PCI address [0xf8300000-0xf8303fff])
[  188.196884] pci 0000:b3:00.0: reg 18c: [mem 0x00000000-0x000fffff 64bit]
[  188.203591] pci 0000:b3:00.0: BAR 9: assigned [mem 0xf8400000-0xf86fffff 64bit]
[  188.210909] pci 0000:b3:00.0: BAR 9: set to [mem 0xf8400000-0xf86fffff 64bit] (PCI address [0xf8400000-0xf86fffff])
[  188.221379] pci 0000:b3:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
[  188.228089] pci 0000:b3:00.0: BAR 7: assigned [mem 0xf8304000-0xf830ffff 64bit]
[  188.235407] pci 0000:b3:00.0: BAR 7: set to [mem 0xf8304000-0xf830ffff 64bit] (PCI address [0xf8304000-0xf830ffff])
[  188.245843] pci 0000:b1:03.0: PCI bridge to [bus b3-b3]
[  188.251107] pci 0000:b1:03.0:   bridge window [mem 0xf8200000-0xf86fffff]
[  188.257922] pci 0000:b1:03.0:   bridge window [mem 0xf5100000-0xf51fffff pref]
[  188.265180] pci 0000:b0:00.0: PCI bridge to [bus b1-b3]
[  188.270443] pci 0000:b0:00.0:   bridge window [mem 0xf8000000-0xf89fffff]
[  188.277250] pci 0000:b0:00.0:   bridge window [mem 0xf5000000-0xf51fffff pref]
[  188.284512] pcieport 0000:80:02.2: PCI bridge to [bus b0-bf]
[  188.290184] pcieport 0000:80:02.2:   bridge window [io  0xa000-0xbfff]
[  188.296735] pcieport 0000:80:02.2:   bridge window [mem 0xf8000000-0xf8ffffff]
[  188.303963] pcieport 0000:80:02.2:   bridge window [mem 0xf5000000-0xf5ffffff 64bit pref]

b2:00.0 BAR 9 has not get assigned...

root cause:
b1:02.0 can not be added more range, because b1:03.0 is just after it.
not space between required ranges.

Solution:
Try to assign required + optional all together at first, and if it fails, go with required then reassign path.

-v2: seperate add_to_list change() to another patch according to Jesse.
     seperate get_res_add_size() moving to another patch according to Jesse.
     add !realloc_head->next check if the list is empty to bail early according to Jesse.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 75d43eb..7757c00 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -99,6 +99,24 @@ static void add_to_failed_list(struct resource_list_x *head,
 			0 /* dont care */);
 }
 
+static void remove_from_list(struct resource_list_x *realloc_head,
+				 struct resource *res)
+{
+	struct resource_list_x *prev, *tmp, *list;
+
+	prev = realloc_head;
+	for (list = realloc_head->next; list;) {
+		if (list->res != res) {
+			prev = list;
+			list = list->next;
+			continue;
+		}
+		tmp = list;
+		prev->next = list = list->next;
+		kfree(tmp);
+	}
+}
+
 static resource_size_t get_res_add_size(struct resource_list_x *realloc_head,
 					struct resource *res)
 {
@@ -108,8 +126,13 @@ static resource_size_t get_res_add_size(struct resource_list_x *realloc_head,
 	for (list = realloc_head->next; list && list->res != res;
 			list = list->next)
 		;
-	if (list)
+
+	if (list) {
+		dev_printk(KERN_DEBUG, &list->dev->dev,
+			 "%pR get_res_add_size  add_size %llx\n",
+			 list->res, (unsigned long long)list->add_size);
 		return list->add_size;
+	}
 
 	return 0;
 }
@@ -238,6 +261,64 @@ static void __assign_resources_sorted(struct resource_list *head,
 				 struct resource_list_x *realloc_head,
 				 struct resource_list_x *fail_head)
 {
+	/*
+	 * Should not assign requested resources at first.
+	 *   they could be adjacent, so later reassign can not reallocate
+	 *   them one by one in parent resource window.
+	 * Try to assign requested + add_size at begining
+	 *  if could do that, could get out early.
+	 *  if could not do that, we still try to assign requested at first,
+	 *    then try to reassign add_size for some resources.
+	 */
+	struct resource_list_x save_head, local_fail_head, *list;
+	struct resource_list *l;
+
+	/* Check if optional add_size is there */
+	if (!realloc_head || !realloc_head->next)
+		goto requested_and_reassign;
+
+	/* Save original start, end, flags etc at first */
+	save_head.next = NULL;
+	for (l = head->next; l; l = l->next)
+		if (add_to_list(&save_head, l->dev, l->res, 0, 0)) {
+			free_list(resource_list_x, &save_head);
+			goto requested_and_reassign;
+		}
+
+	/* Update res in head list with add_size in realloc_head list */
+	for (l = head->next; l; l = l->next)
+		l->res->end += get_res_add_size(realloc_head, l->res);
+
+	/* Try updated head list with add_size added */
+	local_fail_head.next = NULL;
+	assign_requested_resources_sorted(head, &local_fail_head);
+
+	/* all assigned with add_size ? */
+	if (!local_fail_head.next) {
+		/* Remove head list from realloc_head list */
+		for (l = head->next; l; l = l->next)
+			remove_from_list(realloc_head, l->res);
+		free_list(resource_list_x, &save_head);
+		free_list(resource_list, head);
+		return;
+	}
+
+	free_list(resource_list_x, &local_fail_head);
+	/* Release assigned resource */
+	for (l = head->next; l; l = l->next)
+		if (l->res->parent)
+			release_resource(l->res);
+	/* Restore start/end/flags from saved list */
+	for (list = save_head.next; list; list = list->next) {
+		struct resource *res = list->res;
+
+		res->start = list->start;
+		res->end = list->end;
+		res->flags = list->flags;
+	}
+	free_list(resource_list_x, &save_head);
+
+requested_and_reassign:
 	/* Satisfy the must-have resource requests */
 	assign_requested_resources_sorted(head, fail_head);
 
-- 
1.7.7

