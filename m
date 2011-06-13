Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1FMNko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:40:44 -0400
Received: from col0-omc4-s9.col0.hotmail.com ([65.55.34.211]:43181 "EHLO
	col0-omc4-s9.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008Ab1FMNkm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:40:42 -0400
Message-ID: <COL116-W230B4B23DAABAEFBA9E79A3690@phx.gbl>
X-Originating-IP: [174.89.114.54]
From: John Lumby <johnlumby@hotmail.com>
To: Robert Richter <robert.richter@amd.com>
CC: Maynard Johnson <maynardj@us.ibm.com>,
        oprofile list <oprofile-list@lists.sourceforge.net>, <mingo@elte.hu>,
        <peterz@infradead.org>,
        linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile, x86: Fix nmi-unsafe callgraph support in,
 2.6.27  and later
Date: Mon, 13 Jun 2011 09:40:42 -0400
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2011 13:40:42.0375 (UTC) FILETIME=[7D482170:01CC29CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/09/11 08:57, Robert Richter wrote:
> On 08.06.11 13:43:56, John Lumby wrote:
>
> "EIP is at print_context_stack=0x45/0xb0
>
> and from a machine-code listing, I found that that offset corresponds
> to the line
>
>         addr = *stack;
>
> in arch/x86/kernel/dumpstack.c"
>
> Actually this should not happen, because of checking the stack pointer
> in valid_stack_ptr(). So could you apply the change below and test if
> this throws a bug message?

I applied that change and,  yes,  it throws the BUG :
     kernel BUG at arch/x86/kernel/dumpstack.c : 76!
It appears that the existing test in valid_stack_ptr makes too many assumptions 
about the other variables involved to catch all cases.

Also,   changing that test by adding a simplistic check for an absolute 
range is not sufficient,  as another crash then occurs in dump_trace at 
the line
        stack = (unsigned long *)context->previous_esp;

This patch to dumpstack_32.c seems to work for my system:
 (although it is probably more of a cover-up than a fix)

--- linux-2.6.39-FLG/arch/x86/kernel/dumpstack_32.c.orig    2011-05-19 
00:06:34.000000000 -0400
+++ linux-2.6.39-FLG/arch/x86/kernel/dumpstack_32.c    2011-06-12 
23:09:16.000000000 -0400
@@ -42,6 +42,19 @@ void dump_trace(struct task_struct *task

          context = (struct thread_info *)
              ((unsigned long)stack & (~(THREAD_SIZE - 1)));
+
+        /* crude bugcheck */
+        if (    ((unsigned long)stack <= 1024)
+             || ((unsigned long)stack >= 0xffffe000)
+             || ((unsigned long)context <= 1024)
+             || ((unsigned long)context >= 0xffffe000)
+                   ) {
+#ifdef NOISY_DUMP_TRACE
+             printk("dump_trace: pid %d stack= %p context= %p\n"
+                   ,(task ? task->pid : -1),stack,context);
+#endif  /* NOISY_DUMP_TRACE  */
+            break;
+                }
          bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);

          stack = (unsigned long *)context->previous_esp;


> Thanks,
>
> -Robert
>
>
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index e2a3f06..37693f5 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -73,6 +73,8 @@ static inline int valid_stack_ptr(struct thread_info *tinfo,
>                          void *p, unsigned int size, void *end)
>   {
>          void *t = tinfo;
> +
> +       BUG_ON(p<  (void *)THREAD_SIZE);
>          if (end) {
>                  if (p<  end&&  p>= (end-THREAD_SIZE))
>                          return 1;
>
 		 	   		  