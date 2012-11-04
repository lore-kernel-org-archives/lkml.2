Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2KDKio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:38:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45892 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab2KDKim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:38:42 -0500
Message-ID: <509645A5.5070901@gmail.com>
Date: Sun, 04 Nov 2012 18:38:29 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Christoph Lameter <cl@linux.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of per_cpu_ptr(p,
 raw_smp_processor_id())
References: <5093EE6B.3070906@gmail.com> <20121102181026.GY3027@linux.vnet.ibm.com> <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com> <20121103091909.GI3027@linux.vnet.ibm.com>
In-Reply-To: <20121103091909.GI3027@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney said, at 2012/11/3 17:19:
> OK, I do understand why it happens to work.  My question is instead why
> it is considered a good idea.  

Maybe objdump gives the answer.
 __this_cpu_read which read member pointer of per-cpu variable
can reduce two instructions on x86-64 arch.


*test code:* 
struct eater_state {
        u32 state;
        struct eater __percpu *eater_info;
};

struct eater {
        char name[4];
        u32 age;
};

static u32 test_func(struct eater_state *tstas)
{
        struct eater *aeater;

        //aeater = __this_cpu_ptr(tstas->eater_info);   <-----------------1
        //return aeater->age;
        return  __this_cpu_read(tstas->eater_info->age); <-----------------2
}

static int __init demo_init(void)
{
        int ret = 0 ;
        int age;
        struct eater_state as;
        struct eater david;

        as.state = 1;
        as.eater_info = &david;

        age = test_func(&as);

        return ret;
}


__this_cpu_ptr <-----------------1
0000000000000000 <init_module>:
   0:   55                      push   %rbp
   1:   48 89 e5                mov    %rsp,%rbp
   4:   48 83 ec 10             sub    $0x10,%rsp
   8:   48 8d 45 f0             lea    -0x10(%rbp),%rax
   c:   65 48 03 04 25 00 00 00 00      add    %gs:0x0,%rax
  15:   31 c0                   xor    %eax,%eax
  17:   c9                      leaveq 
  18:   c3                      retq   


 __this_cpu_read<-----------------2
0000000000000000 <init_module>:
   0:   55                      push   %rbp
   1:   31 c0                   xor    %eax,%eax
   3:   48 89 e5                mov    %rsp,%rbp
   6:   48 83 ec 10             sub    $0x10,%rsp
   a:   c9                      leaveq 
   b:   c3                      retq   


