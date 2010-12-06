Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0LFHqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 02:46:15 -0500
Received: from ozlabs.org ([203.10.76.45]:43430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0LFHqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 02:46:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux.com>
Subject: Re: [thisops uV3 14/18] lguest: Use this_cpu_ops
Date: Mon, 6 Dec 2010 18:16:07 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
References: <20101130190707.457099608@linux.com> <20101130190849.422541374@linux.com>
In-Reply-To: <20101130190849.422541374@linux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012061816.07860.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 05:37:21 am Christoph Lameter wrote:
> Use this_cpu_ops in a couple of places in lguest.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Christoph Lameter <cl@linux.com>

This doesn't even compile :(

I've applied it, and applied the following fixes, too:

lguest: compile fixes

arch/x86/lguest/boot.c: In function ‘lguest_init_IRQ’:
arch/x86/lguest/boot.c:824: error: macro "__this_cpu_write" requires 2 arguments, but only 1 given
arch/x86/lguest/boot.c:824: error: ‘__this_cpu_write’ undeclared (first use in this function)
arch/x86/lguest/boot.c:824: error: (Each undeclared identifier is reported only once
arch/x86/lguest/boot.c:824: error: for each function it appears in.)

drivers/lguest/x86/core.c: In function ‘copy_in_guest_info’:
drivers/lguest/x86/core.c:94: error: lvalue required as left operand of assignment

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -821,7 +821,7 @@ static void __init lguest_init_IRQ(void)
 
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
-		__this_cpu_write(vector_irq[i]) = i - FIRST_EXTERNAL_VECTOR;
+		__this_cpu_write(vector_irq[i], i - FIRST_EXTERNAL_VECTOR);
 		if (i != SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -91,7 +91,7 @@ static void copy_in_guest_info(struct lg
 	 * Guest has changed.
 	 */
 	if (__this_cpu_read(lg_last_cpu) != cpu || cpu->last_pages != pages) {
-		__this_cpu_read(lg_last_cpu) = cpu;
+		__this_cpu_write(lg_last_cpu, cpu);
 		cpu->last_pages = pages;
 		cpu->changed = CHANGED_ALL;
 	}
