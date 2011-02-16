Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1BPAi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:38:58 -0500
Received: from kroah.org ([198.145.64.141]:49528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab1BPAXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.555901477@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Miller <davem@davemloft.net>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [204/272] perf: Fix alloc_callchain_buffers()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 88d4f0db7fa8785859c1d637f9aac210932b6216 upstream.

Commit 927c7a9e92c4 ("perf: Fix race in callchains") introduced
a mismatch in the sizing of struct callchain_cpus_entries.

nr_cpu_ids must be used instead of num_possible_cpus(), or we
might get out of bound memory accesses on some machines.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1295980851.3588.351.camel@edumazet-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1872,8 +1872,7 @@ static int alloc_callchain_buffers(void)
 	 * accessed from NMI. Use a temporary manual per cpu allocation
 	 * until that gets sorted out.
 	 */
-	size = sizeof(*entries) + sizeof(struct perf_callchain_entry *) *
-		num_possible_cpus();
+	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
 
 	entries = kzalloc(size, GFP_KERNEL);
 	if (!entries)


