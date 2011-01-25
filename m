Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1AYSk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:40:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43721 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1AYSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:40:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=F6kmVuiIDOhpKQxUqLlhep0a6D2ulCGS2iWEi/lCC0btGhBDLJXTCoOdGZsBPDD+PQ
         GY3BC0VY6U6HeQHBI6PTwh3HzMMfcPlhTi7e0jip6/VWj+gW0g/z8YhT0wf3qU9MCW62
         U8z6wUgeXez/OlkYqstRoQ94jKYKZHD8g9PUA=
Subject: [PATCH] perf: fix alloc_callchain_buffers()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Miller <davem@davemloft.net>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 19:40:51 +0100
Message-ID: <1295980851.3588.351.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 927c7a9e92c4 ( perf: Fix race in callchains ) introduced a
mismatch in the sizing of struct callchain_cpus_entries.

nr_cpu_ids must be used instead of num_possible_cpus(), or we might get
out of bound memory accesses on some machines.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: David Miller <davem@davemloft.net>
CC: Stephane Eranian <eranian@google.com>
CC: stable@kernel.org
---
 kernel/perf_event.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 126a302..852ae8c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1999,8 +1999,7 @@ static int alloc_callchain_buffers(void)
 	 * accessed from NMI. Use a temporary manual per cpu allocation
 	 * until that gets sorted out.
 	 */
-	size = sizeof(*entries) + sizeof(struct perf_callchain_entry *) *
-		num_possible_cpus();
+	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
 
 	entries = kzalloc(size, GFP_KERNEL);
 	if (!entries)


