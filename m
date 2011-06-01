Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab1FATP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:15:59 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:55123 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1FATP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:15:58 -0400
Date: Wed, 1 Jun 2011 15:15:36 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com
Subject: [patch] perf_events: fix perf buffer watermark setting
Message-ID: <alpine.DEB.2.00.1106011506390.5384@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since 2.6.36 (specifically commit d57e34fdd60be7ffd0b1d86bfa1a553df86b7172)
the perf_buffer_init_code() has been mis-setting the buffer watermark if
perf_event_attr.wakeup_events has a non-zero value.

This is because perf_event_attr.wakeup_events is a union with 
perf_event_attr.wakeup_watermark.

This commit re-enables the check for perf_event_attr.watermark being
set before continuing with setting a non-default watermark.

This bug is most noticable when you are trying to use PERF_IOC_REFRESH
with a value larger than one and perf_event_attr.wakeup_events is set to 
one.  In this case the buffer watermark will be set to 1 and you will
get extraneous POLL_IN overflows rather than POLL_HUP as expected.

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>


diff --git a/kernel/events/core.c b/kernel/events/core.c
index d863b3c..b949661 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3787,7 +3787,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE)
 		flags |= PERF_BUFFER_WRITABLE;
 
-	buffer = perf_buffer_alloc(nr_pages, event->attr.wakeup_watermark,
+	buffer = perf_buffer_alloc(nr_pages, 
+				   event->attr.watermark?event->attr.wakeup_watermark:0,
 				   event->cpu, flags);
 	if (!buffer) {
 		ret = -ENOMEM;
