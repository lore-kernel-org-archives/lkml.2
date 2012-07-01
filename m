Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2GAX4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 19:56:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2GAXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 19:55:23 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf: Don't assume host's module path for default guest machine
Date: Sun,  1 Jul 2012 17:55:04 -0600
Message-Id: <1341186904-66077-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the default guest modules option (--guestmodules) for perf-kvm
the host's module path is prepended to the modules. e.g,

... PERF_RECORD_MMAP 0/0: [0xffffffffa0005000(0x4fff) @ 0]:
    /lib/modules/3.4.0+/kernel/drivers/virtio/virtio.ko

which is wrong so don't do it. With this patch MMAP events for default guest
kernel modules become:

... PERF_RECORD_MMAP 0/0: [0xffffffffa0005000(0x4fff) @ 0]: [virtio]

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/symbol.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 50958bb..90f6951 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2077,6 +2077,9 @@ static int machine__create_modules(struct machine *machine)
 	free(line);
 	fclose(file);
 
+	if (machine->pid == DEFAULT_GUEST_KERNEL_ID)
+		return 0;
+
 	return machine__set_modules_path(machine);
 
 out_delete_line:
-- 
1.7.10.1

