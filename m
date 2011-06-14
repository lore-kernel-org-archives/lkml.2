Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1FNAFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:05:19 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54105 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1FNAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:05:18 -0400
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307979239.9218.76.camel@gandalf.stny.rr.com>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>  <1307723232.3941.178.camel@twins>
	 <1307977614.17297.12.camel@atheurer-w510>
	 <1307979239.9218.76.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 19:05:10 -0500
Message-ID: <1308009910.23688.34.camel@atheurer-ubuntu10>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 11:33 -0400, Steven Rostedt wrote:
> On Mon, 2011-06-13 at 10:06 -0500, Andrew Theurer wrote:
> > On Fri, 2011-06-10 at 18:27 +0200, Peter Zijlstra wrote:
> > > On Fri, 2011-06-10 at 10:34 -0500, Andrew Theurer wrote:
> > > > RIP: 0010:[<ffffffff8104e8c1>]  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
> > > 
> > > If you've still got the vmlinux around, could you find out where in
> > > find_lowest_rq that RIP is? 
> > 
> > Does this help?
> 
> I take it back, it looks like this does help.
> 
> > 
> > 
> > from objdump -d -S
> > 
> > ffffffff8104e820 <find_lowest_rq>:
> > ffffffff8104e820:       55                      push   %rbp
> > ffffffff8104e821:       48 89 e5                mov    %rsp,%rbp
> > ffffffff8104e824:       48 83 ec 30             sub    $0x30,%rsp
> > ffffffff8104e828:       48 89 5d d8             mov    %rbx,-0x28(%rbp)
> > ffffffff8104e82c:       4c 89 65 e0             mov    %r12,-0x20(%rbp)
> > ffffffff8104e830:       4c 89 6d e8             mov    %r13,-0x18(%rbp)
> > ffffffff8104e834:       4c 89 75 f0             mov    %r14,-0x10(%rbp)
> > ffffffff8104e838:       4c 89 7d f8             mov    %r15,-0x8(%rbp)
> > ffffffff8104e83c:       e8 3f bf 48 00          callq  ffffffff814da780 <mcount>
> > ffffffff8104e841:       48 c7 c0 88 e8 00 00    mov    $0xe888,%rax
> > ffffffff8104e848:       65 48 03 04 25 50 dc    add    %gs:0xdc50,%rax
> > ffffffff8104e84f:       00 00
> > ffffffff8104e851:       65 44 8b 2c 25 58 dc    mov    %gs:0xdc58,%r13d
> > ffffffff8104e858:       00 00
> > ffffffff8104e85a:       83 bf bc 01 00 00 01    cmpl   $0x1,0x1bc(%rdi)
> > ffffffff8104e861:       4c 8b 20                mov    (%rax),%r12
> > ffffffff8104e864:       48 8b 47 08             mov    0x8(%rdi),%rax
> > ffffffff8104e868:       8b 58 18                mov    0x18(%rax),%ebx
> > ffffffff8104e86b:       75 23                   jne    ffffffff8104e890 <find_lowest_rq+0x70>
> > ffffffff8104e86d:       b8 ff ff ff ff          mov    $0xffffffff,%eax
> > ffffffff8104e872:       48 8b 5d d8             mov    -0x28(%rbp),%rbx
> > ffffffff8104e876:       4c 8b 65 e0             mov    -0x20(%rbp),%r12
> > ffffffff8104e87a:       4c 8b 6d e8             mov    -0x18(%rbp),%r13
> > ffffffff8104e87e:       4c 8b 75 f0             mov    -0x10(%rbp),%r14
> > ffffffff8104e882:       4c 8b 7d f8             mov    -0x8(%rbp),%r15
> > ffffffff8104e886:       c9                      leaveq
> > ffffffff8104e887:       c3                      retq
> > ffffffff8104e888:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
> > ffffffff8104e88f:       00
> > ffffffff8104e890:       89 d8                   mov    %ebx,%eax
> > ffffffff8104e892:       49 c7 c7 c0 2a 01 00    mov    $0x12ac0,%r15
> > ffffffff8104e899:       48 89 fe                mov    %rdi,%rsi
> > ffffffff8104e89c:       48 8b 04 c5 40 a3 bf    mov    -0x7e405cc0(,%rax,8),%rax
> > ffffffff8104e8a3:       81
> > ffffffff8104e8a4:       4c 89 e2                mov    %r12,%rdx
> > ffffffff8104e8a7:       49 8b 84 07 88 08 00    mov    0x888(%r15,%rax,1),%rax
> > ffffffff8104e8ae:       00
> > ffffffff8104e8af:       48 83 c0 38             add    $0x38,%rax
> > ffffffff8104e8b3:       48 89 c7                mov    %rax,%rdi
> > ffffffff8104e8b6:       e8 85 75 0a 00          callq  ffffffff810f5e40 <cpupri_find>
> > ffffffff8104e8bb:       85 c0                   test   %eax,%eax
> > ffffffff8104e8bd:       74 ae                   je     ffffffff8104e86d <find_lowest_rq+0x4d>
> > ffffffff8104e8bf:       89 d8                   mov    %ebx,%eax
> > ffffffff8104e8c1:       41 0f a3 1c 24          bt     %ebx,(%r12)
> 
> Following the asm here, I figured we are here:
> 
> static int find_lowest_rq(struct task_struct *task)
> {
> 	struct sched_domain *sd;
> 	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
> 	int this_cpu = smp_processor_id();
> 	int cpu      = task_cpu(task);
> 
> 	if (task->rt.nr_cpus_allowed == 1)
> 		return -1; /* No other targets possible */
> 
> 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
> 		return -1; /* No targets found */
> 
> 	/*
> 	 * At this point we have built a mask of cpus representing the
> 	 * lowest priority tasks in the system.  Now we want to elect
> 	 * the best one based on our affinity and topology.
> 	 *
> 	 * We prioritize the last cpu that the task executed on since
> 	 * it is most likely cache-hot in that location.
> 	 */
> 	if (cpumask_test_cpu(cpu, lowest_mask))  <<<----------- HERE
> 		return cpu;
> 
> 
> Looks to me that lowest_mask is NULL???
> 
> Does this happen on boot up? Hmm, could be, by looking at Peter's patch,
> he could be waking them up and we are getting into this code before
> lowest_mask is defined.
> 
> Could you try this patch?

Yes, and it works!  Thanks very much!
> 
> -- Steve

-Andrew
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..46e3e09 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1239,6 +1239,10 @@ static int find_lowest_rq(struct task_struct *task)
>  	int this_cpu = smp_processor_id();
>  	int cpu      = task_cpu(task);
> 
> +	/* Make sure everything is initialized first */
> +	if (system_state != SYSTEM_RUNNING)
> +		return -1;
> +
>  	if (task->rt.nr_cpus_allowed == 1)
>  		return -1; /* No other targets possible */
> 
> 
> 


