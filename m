Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab2ENWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:25:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2ENWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:25:54 -0400
Message-ID: <4FB1866E.9000604@gmail.com>
Date: Mon, 14 May 2012 16:25:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: Perf events warning..
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com> <1337034048.27020.137.camel@laptop>
In-Reply-To: <1337034048.27020.137.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/12 4:20 PM, Peter Zijlstra wrote:
> On Fri, 2012-05-11 at 08:43 -0700, Linus Torvalds wrote:
>> Peter, Ingo, Arnaldo,
>>   google doesn't find a warning like this, so it can't be *too*
>> commonly reported.
>>
>> Anyway, doing some profiling of git "make test" (wonderful load for
>> doing lots of small processes that do lots of page faults etc), this
>> WARN_ON_ONCE() triggered:
>>
>>      ------------[ cut here ]------------
>>      WARNING: at kernel/events/core.c:2066 task_ctx_sched_out+0x63/0x70()
>>      Hardware name: System Product Name
>>      Pid: 18120, comm: git Not tainted 3.4.0-rc6-00089-g4a01c681d58f-dirty #3
>>      Call Trace:
>>       [<ffffffff810308c5>] warn_slowpath_common+0x75/0xb0
>>       [<ffffffff810309c5>] warn_slowpath_null+0x15/0x20
>>       [<ffffffff81096d63>] task_ctx_sched_out+0x63/0x70
>>       [<ffffffff8109af06>] perf_event_comm+0x1d6/0x2e0
>>       [<ffffffff81368ba8>] ? get_random_int+0x88/0xb0
>>       [<ffffffff8102e1e2>] ? __mmdrop+0x62/0x90
>>       [<ffffffff810e1f93>] set_task_comm+0x63/0x80
>>       [<ffffffff810e3206>] setup_new_exec+0x86/0x250
>>       [<ffffffff81126b69>] load_elf_binary+0x389/0x1930
>>       [<ffffffff81125222>] ? load_misc_binary+0x292/0x390
>>       [<ffffffff810bcbdd>] ? get_user_pages+0x4d/0x50
>>       [<ffffffff810e13b2>] ? get_arg_page+0xa2/0xd0
>>       [<ffffffff810e2b65>] search_binary_handler+0xd5/0x200
>>       [<ffffffff811267e0>] ? elf_map+0x170/0x170
>>       [<ffffffff810e300d>] do_execve_common.clone.39+0x37d/0x430
>>       [<ffffffff810e30d6>] do_execve+0x16/0x20
>>       [<ffffffff8100ab75>] sys_execve+0x45/0x70
>>       [<ffffffff816b10ac>] stub_execve+0x6c/0xc0
>>      ---[ end trace 6fccf3db70f1b560 ]---
>>
>> any comments/ideas?
>
> So far I can't make any of the things I came up stick. You ran something
> simple like: 'perf record -e cycles:pp -F 20000 make test' ? Or did you
> do something more interesting?

By chance I just hit this:
[   31.528795] WARNING: at 
/mnt/sw/kernel-2.6.git/arch/x86/kernel/cpu/perf_event.c:1054 
x86_pmu_start+0xdc/0x110()
[   31.528799] Hardware name: Bochs
[   31.528801] Modules linked in: nfs fscache auth_rpcgss nfs_acl lockd 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state ip6table_filter nf_conntrack ip6_tables 
virtio_net ppdev i2c_piix4 parport_pc parport i2c_core sunrpc virtio_blk 
[last unloaded: scsi_wait_scan]
[   31.528825] Pid: 959, comm: find Not tainted 3.4.0-rc6+ #1
[   31.528827] Call Trace:
[   31.528835]  [<ffffffff8105792f>] warn_slowpath_common+0x7f/0xc0
[   31.528839]  [<ffffffff8105798a>] warn_slowpath_null+0x1a/0x20
[   31.528843]  [<ffffffff8102543c>] x86_pmu_start+0xdc/0x110
[   31.528847]  [<ffffffff81025af2>] x86_pmu_enable+0x212/0x270
[   31.528854]  [<ffffffff81116466>] perf_event_context_sched_in+0xe6/0x100
[   31.528857]  [<ffffffff81118083>] perf_event_comm+0x103/0x2b0
[   31.528863]  [<ffffffff81184342>] set_task_comm+0x72/0xe0
[   31.528867]  [<ffffffff81184a1b>] setup_new_exec+0x8b/0x240
[   31.528873]  [<ffffffff811cc8b7>] load_elf_binary+0x3e7/0x19a0
[   31.528879]  [<ffffffff811443c2>] ? get_user_pages+0x52/0x60
[   31.528883]  [<ffffffff81182708>] ? get_user_arg_ptr+0x38/0x80
[   31.528887]  [<ffffffff81182bae>] search_binary_handler+0xee/0x340
[   31.528891]  [<ffffffff811cc4d0>] ? load_elf_library+0x230/0x230
[   31.528895]  [<ffffffff811847ff>] do_execve_common+0x36f/0x410
[   31.528899]  [<ffffffff811848da>] do_execve+0x3a/0x40
[   31.528903]  [<ffffffff8101d477>] sys_execve+0x47/0x70
[   31.528908]  [<ffffffff815f226c>] stub_execve+0x6c/0xc0
[   31.528911] ---[ end trace ba6387065a9b9696 ]---

As for the something interesting part - not really: debugging the 
regression on 'perf stat --group -- find /usr >/dev/null'

David
