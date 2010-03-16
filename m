Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0CPLvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:51:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0CPLvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:51:35 -0400
Date: Tue, 16 Mar 2010 12:51:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Fix holdoff for accelerated GPs for last
 non-dynticked CPU
Message-ID: <20100316115123.GA25467@elte.hu>
References: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <tip-622ea685f1fafdf84d612440535c84341f0860b8@git.kernel.org>
 <20100316110036.GA4554@elte.hu>
 <20100316110323.GA31038@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316110323.GA31038@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on vanilla .34-rc1 i get this crash:

[    3.375120] initcall init_stack_trace+0x0/0x12 returned 0 after 136718 usecs                   
[    3.376739] calling  init_function_trace+0x0/0x3e @ 1                                          
[    3.390046] Testing tracer function:                                                           
[    3.416665] BUG: unable to handle kernel paging request at ffffffffffffffaf                    
[    3.416666] IP: [<ffffffff81a5b222>] schedule+0x33b/0x6ed                                      
[    3.416666] PGD 23b9067 PUD 23ba067 PMD 0                                                      
[    3.416666] Oops: 0002 [#1] PREEMPT SMP                                                        
[    3.416666] last sysfs file:                                                                   
[    3.416666] CPU 1                                                                              
[    3.416666] Pid: 40, comm: rcu_torture_rea Not tainted 2.6.34-rc1-dirty #112 /                 
[    3.416666] RIP: 0010:[<ffffffff81a5b222>]  [<ffffffff81a5b222>] schedule+0x33b/0x6ed          
[    3.416666] RSP: 0018:ffff88003c871d30  EFLAGS: 00010082                                       
[    3.416666] RAX: ffff88003c869640 RBX: ffff8800093d5200 RCX: 0000000001e9ab12                  
[    3.416666] RDX: 0000000000334987 RSI: ffff88003c869640 RDI: ffff8800093d5200                  
[    3.416666] RBP: ffffffffffffffff R08: ffff88003c869678 R09: 0000000000000001                  
[    3.416666] R10: 0000000291cd04d1 R11: ffff8800093d5200 R12: ffff88003c870000                  
[    3.416666] R13: ffff88003c869bb8 R14: ffff88003c871df0 R15: 0000000000000001                  
[    3.416666] FS:  0000000000000000(0000) GS:ffff880009200000(0000) knlGS:0000000000000000       
[    3.416666] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                  
[    3.416666] CR2: ffffffffffffffaf CR3: 00000000023b7000 CR4: 00000000000006a0                  
[    3.416666] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                  
[    3.523560] .. no entries found ..FAILED!                                                      
[    3.523576] initcall init_function_trace+0x0/0x3e returned -1 after 139973 usecs               
[    3.523582] initcall init_function_trace+0x0/0x3e returned with error code -1                  
[    3.523588] calling  init_irqsoff_tracer+0x0/0x14 @ 1                                          
[    3.416666] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                  
[    3.416666] Process rcu_torture_rea (pid: 40, threadinfo ffff88003c870000, task ffff88003c8696)
[    3.416666] Stack:                                                                             
[    3.416666]  ffff88003c871d50 ffff88003c871fd8 ffff88003c869640 ffff88003c870000               
[    3.416666] <0> 0000000000000033 ffffffff8103995b 0000000000000001 000000000000002b            
[    3.416666] <0> ffff88003c871fd8 ffff88003c869640 0000000000000001 ffffffff8108d451            
[    3.416666] Call Trace:                                                                        
[    3.416666]  [<ffffffff8103995b>] ? put_prev_task_fair+0x10/0xa4                               
[    3.416666]  [<ffffffff8108d451>] ? rcu_torture_reader+0x1dc/0x28c                             
[    3.416666]  [<ffffffff8108d456>] ? rcu_torture_reader+0x1e1/0x28c                             
[    3.416666]  [<ffffffff8108d17b>] ? rcu_torture_timer+0x0/0xfa                                 
[    3.416666]  [<ffffffff8108d275>] ? rcu_torture_reader+0x0/0x28c                               
[    3.416666]  [<ffffffff8105a664>] ? kthread+0x9a/0xa2                                          
[    3.416666]  [<ffffffff8106c483>] ? trace_hardirqs_on_caller+0x114/0x13f                       
[    3.416666]  [<ffffffff81003a54>] ? kernel_thread_helper+0x4/0x10                              
[    3.416666]  [<ffffffff810366e7>] ? finish_task_switch+0x70/0xa5                               
[    3.416666]  [<ffffffff81a5e1c0>] ? restore_args+0x0/0x30                                      
[    3.416666]  [<ffffffff8105a5ca>] ? kthread+0x0/0xa2                                           
[    3.416666]  [<ffffffff81003a50>] ? kernel_thread_helper+0x0/0x10                              
[    3.416666] Code: 30 48 89 fe 48 89 df ff 50 30 48 8b 83 a8 00 00 00 48 39 43 40 74 09 49 c7 c 
[    3.416666] RIP  [<ffffffff81a5b222>] schedule+0x33b/0x6ed                                     
[    3.416666]  RSP <ffff88003c871d30>                                                            
[    3.416666] CR2: ffffffffffffffaf                      

(same config) I'll try to bisect it.

	Ingo
