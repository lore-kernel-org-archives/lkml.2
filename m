Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931Ab0KQQWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:22:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934808Ab0KQQWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:22:00 -0500
Message-ID: <4CE400C9.8080707@redhat.com>
Date: Wed, 17 Nov 2010 18:20:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tom Zanussi <tzanussi@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>  <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>  <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>  <1290003110.2109.822.camel@laptop> <1290003505.2109.833.camel@laptop>  <alpine.LFD.2.00.1011171529120.2900@localhost6.localdomain6> <1290008466.1921.21.camel@elnicho> <4CE3FB0D.30902@redhat.com> <alpine.LFD.2.00.1011171657400.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011171657400.2900@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:58 PM, Thomas Gleixner wrote:
> >
> >  Filtering is also useful for fine-grained perf events; this cannot be done in
> >  userspace.
>
> Could you explain that a bit more detailed please ?

I have a tracepoint kvm:kvm_exit which is called every time a guest 
exits to the host (for whatever reason).  The first step in profiling 
kvm is checking the rate at which this tracepoint is triggered.

(I have a small tool kvm_stat which shows a 'perf top' like display, 
except that instead of showing functions, it shows kvm tracepoints 
sorted by triggering rate)

If you see a high exit rate, you may also be interested in what exit 
reasons triggered those exits.  So kvm_stat creates additional events, 
one per possible exit_reason (which is a field in the kvm_exit 
tracepoint), with a filter matching exit_reason to the enum describing 
the possible exit reasons.  We add that to the display and get a sort of 
histogram showing which exit_reason is responsible for how many exits.

A screenshot:

kvm statistics

  kvm_exit                                     40075   10293
  kvm_entry                                    40075   10293
  kvm_exit(EXCEPTION_NMI)                      29824    7712
  kvm_page_fault                               29642    7672
  kvm_emulate_insn                              9117    2205
  kvm_inj_exception                             8052    2134
  kvm_mmio                                      6160    1514
  kvm_apic                                      6143    1509
  kvm_exit(CR_ACCESS)                           2307     635
  kvm_cr                                        2307     635
  kvm_exit(INVLPG)                              1998     599
  kvm_userspace_exit                            2956     582
  kvm_exit(IO_INSTRUCTION)                      2954     582
  kvm_pio                                       2954     582
  kvm_inj_virq                                  2194     551
  kvm_apic_accept_irq                           2181     547
  kvm_exit(HLT)                                 1523     372
  kvm_exit(EXTERNAL_INTERRUPT)                  1131     304
  kvm_fpu                                        706     176
  kvm_set_irq                                    802     156
  kvm_pic_set_irq                                802     156
  kvm_ioapic_set_irq                             802     156
  kvm_apic_ipi                                   454     132
  kvm_exit(PENDING_INTERRUPT)                    175      44
  kvm_cpuid                                      163      42
  kvm_exit(CPUID)                                163      42
  kvm_ack_irq                                    152      29


So there are 10K exits/sec, of which 7.7K are EXCEPTION_NMI and 635 are 
CR_ACCESS.

Tool source http://tinyurl.com/2ue5tev; one day I'll make it a 
tools/perf script.

-- 
error compiling committee.c: too many arguments to function

