Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0CRJaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:30:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:56827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0CRJah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:30:37 -0400
Message-ID: <4BA1F2BA.30604@kernel.org>
Date: Thu, 18 Mar 2010 18:30:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Sparc <sparclinux@vger.kernel.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] percpu misaligned allocation
References: <20100318044930.GC5045@nowhere>
In-Reply-To: <20100318044930.GC5045@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 09:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/18/2010 01:49 PM, Frederic Weisbecker wrote:
> Hi,
> 
> While using the lock events through perf in a sparc box, I can see
> the following message repeated many times:
> 
> 	Kernel unaligned access at TPC[49357c] perf_trace_lock_acquire+0xb4/0x180
> 
> It actually hangs the box as the messages are sent to a serial console.
> 
> When used with perf, the trace events use a per cpu buffer allocated
> in kernel/trace/trace_event_perf.c, and the allocation appears to return
> a misaligned percpu pointer. It is aligned to 4 while it seems it
> requires to be aligned to 8.

Does this fix the problem?

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index c1cc3ab..d3f7d1b 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -27,13 +27,15 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 		return 0;
 
 	if (!total_profile_count) {
-		buf = (char *)alloc_percpu(perf_trace_t);
+		buf = (char *)__alloc_percpu(sizeof(perf_trace_t),
+					     __alignof__(unsigned long));
 		if (!buf)
 			goto fail_buf;
 
 		rcu_assign_pointer(perf_trace_buf, buf);
 
-		buf = (char *)alloc_percpu(perf_trace_t);
+		buf = (char *)__alloc_percpu(sizeof(perf_trace_t),
+					     __alignof__(unsigned long));
 		if (!buf)
 			goto fail_buf_nmi;
 


-- 
tejun
