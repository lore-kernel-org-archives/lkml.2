Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab0JUXSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:18:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618Ab0JUXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:18:08 -0400
Date: Thu, 21 Oct 2010 16:18:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-Id: <20101021161801.8149e2fe.akpm@linux-foundation.org>
In-Reply-To: <1287701894.2607.32.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
	<1287238754.2799.376.camel@edumazet-laptop>
	<20101021154333.f67fd870.akpm@linux-foundation.org>
	<1287701894.2607.32.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 00:58:14 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Then 39 instructions in hot path (no lock taken)

Wow, your compiler sucks.

.globl __percpu_counter_add
	.type	__percpu_counter_add, @function
__percpu_counter_add:
	pushq	%rbp	#
	movq	%rsp, %rbp	#,
	pushq	%r13	#
	movq	%rdi, %r13	# fbc, fbc
	pushq	%r12	#
	pushq	%rbx	#
	pushq	%r10	#
	movq	96(%rdi), %rbx	# <variable>.counters, pcount
#APP
	movl %gs:cpu_number,%eax	# cpu_number, pfo_ret__
#NO_APP
	cltq
	addq	__per_cpu_offset(,%rax,8), %rbx	# __per_cpu_offset, pcount
	movslq	(%rbx),%rax	#* pcount, tmp70
	leaq	(%rax,%rsi), %r12	#, count
	movslq	%edx,%rax	# batch, batch
	cmpq	%rax, %r12	# batch, count
	jge	.L43	#,
	negl	%edx	# batch
	movslq	%edx,%rax	# batch, tmp74
	cmpq	%rax, %r12	# tmp74, count
	jg	.L45	#,
.L43:
	movq	%r13, %rdi	# fbc, D.14396
	call	_raw_spin_lock	#
	addq	%r12, 72(%r13)	# count, <variable>.count
	movq	%r13, %rdi	# fbc, D.14396
	movl	$0, (%rbx)	#,* pcount
	call	_raw_spin_unlock	#
	jmp	.L47	#
.L45:
	movl	%r12d, (%rbx)	# count,* pcount
.L47:
	popq	%r9	#
	popq	%rbx	#
	popq	%r12	#
	popq	%r13	#
	leave
	ret

