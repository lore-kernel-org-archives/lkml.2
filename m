Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0K3TMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:12:37 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:22272 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751175Ab0K3TIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nHz6ArEVM1l8hY0fn0pW4TSuKTV5fel33.UcJ0rmeqsb3kL
 1oVHdDO0KnLrbOOm8Z4jhHiGm2cYUmXS1eklsJJ7JjN7cY5hiZvGbX3S3fTd
 wube6fKzDLPPbFH5xC1XahYcFVzDEPJ8Ek8uPJY7otUe3uVuQ92nkIg9wj1N
 kOBKC1Xv..NEzYTjr8izSRQXMGKGx_9b6WTAwNc7u8O4gKTuJX1sxA0JVYsk
 rNjeRbTrcS_6CCPd8qF0MdAkXwmjYcOQOnpnm26DzrR.Hq1nUMHaQ
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190841.646069646@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:08 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 01/18] percpucounter: Optimize __percpu_counter_add a bit through the use of this_cpu() options.
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=percpu_fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The this_cpu_* options can be used to optimize __percpu_counter_add a bit. Avoids
some address arithmetic and saves 12 bytes.

Before:


00000000000001d3 <__percpu_counter_add>:
 1d3:	55                   	push   %rbp
 1d4:	48 89 e5             	mov    %rsp,%rbp
 1d7:	41 55                	push   %r13
 1d9:	41 54                	push   %r12
 1db:	53                   	push   %rbx
 1dc:	48 89 fb             	mov    %rdi,%rbx
 1df:	48 83 ec 08          	sub    $0x8,%rsp
 1e3:	4c 8b 67 30          	mov    0x30(%rdi),%r12
 1e7:	65 4c 03 24 25 00 00 	add    %gs:0x0,%r12
 1ee:	00 00 
 1f0:	4d 63 2c 24          	movslq (%r12),%r13
 1f4:	48 63 c2             	movslq %edx,%rax
 1f7:	49 01 f5             	add    %rsi,%r13
 1fa:	49 39 c5             	cmp    %rax,%r13
 1fd:	7d 0a                	jge    209 <__percpu_counter_add+0x36>
 1ff:	f7 da                	neg    %edx
 201:	48 63 d2             	movslq %edx,%rdx
 204:	49 39 d5             	cmp    %rdx,%r13
 207:	7f 1e                	jg     227 <__percpu_counter_add+0x54>
 209:	48 89 df             	mov    %rbx,%rdi
 20c:	e8 00 00 00 00       	callq  211 <__percpu_counter_add+0x3e>
 211:	4c 01 6b 18          	add    %r13,0x18(%rbx)
 215:	48 89 df             	mov    %rbx,%rdi
 218:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
 21f:	00 
 220:	e8 00 00 00 00       	callq  225 <__percpu_counter_add+0x52>
 225:	eb 04                	jmp    22b <__percpu_counter_add+0x58>
 227:	45 89 2c 24          	mov    %r13d,(%r12)
 22b:	5b                   	pop    %rbx
 22c:	5b                   	pop    %rbx
 22d:	41 5c                	pop    %r12
 22f:	41 5d                	pop    %r13
 231:	c9                   	leaveq 
 232:	c3                   	retq   


After:

00000000000001d3 <__percpu_counter_add>:
 1d3:	55                   	push   %rbp
 1d4:	48 63 ca             	movslq %edx,%rcx
 1d7:	48 89 e5             	mov    %rsp,%rbp
 1da:	41 54                	push   %r12
 1dc:	53                   	push   %rbx
 1dd:	48 89 fb             	mov    %rdi,%rbx
 1e0:	48 8b 47 30          	mov    0x30(%rdi),%rax
 1e4:	65 44 8b 20          	mov    %gs:(%rax),%r12d
 1e8:	4d 63 e4             	movslq %r12d,%r12
 1eb:	49 01 f4             	add    %rsi,%r12
 1ee:	49 39 cc             	cmp    %rcx,%r12
 1f1:	7d 0a                	jge    1fd <__percpu_counter_add+0x2a>
 1f3:	f7 da                	neg    %edx
 1f5:	48 63 d2             	movslq %edx,%rdx
 1f8:	49 39 d4             	cmp    %rdx,%r12
 1fb:	7f 21                	jg     21e <__percpu_counter_add+0x4b>
 1fd:	48 89 df             	mov    %rbx,%rdi
 200:	e8 00 00 00 00       	callq  205 <__percpu_counter_add+0x32>
 205:	4c 01 63 18          	add    %r12,0x18(%rbx)
 209:	48 8b 43 30          	mov    0x30(%rbx),%rax
 20d:	48 89 df             	mov    %rbx,%rdi
 210:	65 c7 00 00 00 00 00 	movl   $0x0,%gs:(%rax)
 217:	e8 00 00 00 00       	callq  21c <__percpu_counter_add+0x49>
 21c:	eb 04                	jmp    222 <__percpu_counter_add+0x4f>
 21e:	65 44 89 20          	mov    %r12d,%gs:(%rax)
 222:	5b                   	pop    %rbx
 223:	41 5c                	pop    %r12
 225:	c9                   	leaveq 
 226:	c3                   	retq   

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 lib/percpu_counter.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c	2010-11-03 12:25:37.000000000 -0500
+++ linux-2.6/lib/percpu_counter.c	2010-11-03 12:27:27.000000000 -0500
@@ -72,18 +72,16 @@ EXPORT_SYMBOL(percpu_counter_set);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
-	s32 *pcount;
 
 	preempt_disable();
-	pcount = this_cpu_ptr(fbc->counters);
-	count = *pcount + amount;
+	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
 		fbc->count += count;
-		*pcount = 0;
+		__this_cpu_write(*fbc->counters, 0);
 		spin_unlock(&fbc->lock);
 	} else {
-		*pcount = count;
+		__this_cpu_write(*fbc->counters, count);
 	}
 	preempt_enable();
 }

