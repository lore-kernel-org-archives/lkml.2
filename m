Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0IJIwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:52:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0IJIwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nGKnbEZyMzEJ8YXNxtd7wOYZjTjyfkms4FnEdh89ri8VtKpxAYppFRyq7AbXwexxGE
         qlc5hJZ+dfqiV2ZVgFnl2/FWp1sClU74gubQVr35oQTKa7eliMzd8hWWhlH6qwgo9QiS
         t9wamnTyCcRFahXJKeiCJ0KquzbmlQpQrGU6Y=
Message-ID: <4C89F1CE.4050302@gmail.com>
Date: Fri, 10 Sep 2010 10:52:30 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
Subject: [PATCH percpu#for-next] percpu: clear memory allocated with the km
 allocator
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>	 <1284040322.2589.174.camel@edumazet-laptop>	 <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com> <1284106566.402.26.camel@laptop> <4C89EF37.5080803@kernel.org>
In-Reply-To: <4C89EF37.5080803@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu allocator should clear memory before returning it but the km
allocator forgot to do it.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Spotted-by: Peter Zijlstra <peterz@infradead.org>
---
 mm/percpu-km.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 7037bc7..89633fe 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -35,7 +35,11 @@

 static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 {
-	/* noop */
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
+
 	return 0;
 }

-- 
1.7.1

