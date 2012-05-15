Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab2EOBwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:52:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab2EOBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:52:47 -0400
Message-ID: <4FB1B6EA.1060206@gmail.com>
Date: Mon, 14 May 2012 19:52:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung.kim@lge.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com> <87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com> <4FB114CE.10904@gmail.com> <20120514145416.GB4254@infradead.org>
In-Reply-To: <20120514145416.GB4254@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/12 8:54 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 14, 2012 at 08:21:02AM -0600, David Ahern escreveu:
>> On 5/14/12 7:09 AM, David Ahern wrote:
>>>> A problem I see is that it'll break group handling again:
>>>>
>>>> $ ./perf stat -g sleep 1
>>>>
>>>> Performance counter stats for 'sleep 1':
>>>>
>>>> <not counted>  task-clock
>>>> <not counted>  context-switches
>>>> <not counted>  CPU-migrations
>>>> <not counted>  page-faults
>>>> <not counted>  cycles
>>>> <not counted>  stalled-cycles-frontend
>>>> <not counted>  stalled-cycles-backend
>>>> <not counted>  instructions
>>>> <not counted>  branches
>>>> <not counted>  branch-misses
>>>>
>>>> 1.000868932 seconds time elapsed
>>>>
>>>> So I suggest changing perf_target__none() check to a proper one
>>>> (perf_target__no_cpu? - the name might be changed soon) for your
>>>> purpose.
>>>
>>> Something else is wrong then. I tested that command (saw your patch in
>>> the history) and it worked for me. Also, this code path does not affect
>>> perf-stat -- it touches perf-record and perf-test only.
>>
>> I think it is something else. I am running latest git tree
>> (3.4.0-rc7). perf from Linus' tree and acme/core both show:
>>
>> perf stat -g  -- find /usr>/dev/null
>>
>>   Performance counter stats for 'find /usr':
>>
>>       <not counted>  task-clock
>>       <not counted>  context-switches
>>       <not counted>  CPU-migrations
>>       <not counted>  page-faults
>>       <not counted>  cycles
>>       <not counted>  stalled-cycles-frontend
>>       <not counted>  stalled-cycles-backend
>>       <not counted>  instructions
>>       <not counted>  branches
>>       <not counted>  branch-misses
>>
>>         0.111976940 seconds time elapsed
>>
>> (Using find to make sure some work is done as opposed to sleep;
>> openssl speed also shows the above.)
>
> [acme@sandy ~]$ perf stat -g  -- find /usr>/dev/null
> find: `/usr/lib64/audit': Permission denied
> ^Cfind: Interrupt
>
>   Performance counter stats for 'find /usr':
>
>       <not counted>  task-clock
>       <not counted>  context-switches
>       <not counted>  CPU-migrations
>       <not counted>  page-faults
>       <not counted>  cycles
>       <not counted>  stalled-cycles-frontend
>       <not counted>  stalled-cycles-backend
>       <not counted>  instructions
>       <not counted>  branches
>       <not counted>  branch-misses
>
>         1.282060271 seconds time elapsed
>
>
> [acme@sandy ~]$ uname -r
> 3.4.0-rc4-uprobes+
>
> But:
>
> [acme@felicio linux]$ uname -r
> 3.4.0-rc3+
> [acme@felicio linux]$ perf stat -g  -- find /usr>/dev/null
> ^Cfind: Interrupt
>
>   Performance counter stats for 'find /usr':
>
>          126.499751 task-clock                #    0.122 CPUs utilized
>       <not counted>  context-switches
>       <not counted>  CPU-migrations
>       <not counted>  page-faults
>         366,694,182 cycles                    #    2.899 GHz
>         151,332,137 stalled-cycles-frontend   #   41.27% frontend cycles idle
>         103,373,418 stalled-cycles-backend    #   28.19% backend  cycles idle
>         408,309,250 instructions              #    1.11  insns per cycle
>                                               #    0.37  stalled cycles
>                                               #    per insn
>          77,453,802 branches                  #  612.284 M/sec
>           1,703,728 branch-misses             #    2.20% of all branches
>
>         1.032917277 seconds time elapsed
>
>
> [acme@felicio linux]$
>
> Bisecting...
>
> - Arnaldo

Seems like a few issues going on here. In all case the command run is:
     perf stat -g -- find / >/dev/null

v3.1 kernel, v3.1 perf command -- command runs fine and generates output.

v3.2 kernel, v3.2 perf command -- fails - no output and nothing in dmesg.

Using latest acme/core version of perf generates a WARNING on all 
versions tried - v3.1, v3.2, v3.4-rc3, and v3.4-rc7:

[  143.964857] ------------[ cut here ]------------
[  143.964870] WARNING: at 
/mnt/sw/kernels/kernel-2.6.git/arch/x86/kernel/cpu/perf_event.c:860 
x86_pmu_start+0xdc/0x110()
[  143.964873] Hardware name: Bochs
[  143.964875] Modules linked in: lockd ip6t_REJECT nf_conntrack_ipv6 
nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 xt_state nf_conntrack 
ip6table_filter ip6_tables ppdev parport_pc parport virtio_net i2c_piix4 
i2c_core sunrpc virtio_blk [last unloaded: scsi_wait_scan]
[  143.964897] Pid: 968, comm: find Not tainted 3.2.0 #1
[  143.964900] Call Trace:
[  143.964908]  [<ffffffff8106dd2f>] warn_slowpath_common+0x7f/0xc0
[  143.964913]  [<ffffffff8106dd8a>] warn_slowpath_null+0x1a/0x20
[  143.964917]  [<ffffffff810248bc>] x86_pmu_start+0xdc/0x110
[  143.964921]  [<ffffffff81024f32>] x86_pmu_enable+0x212/0x270
[  143.964928]  [<ffffffff8110f946>] perf_event_context_sched_in+0xe6/0x100
[  143.964932]  [<ffffffff8111131e>] perf_event_comm+0x11e/0x330
[  143.964940]  [<ffffffff81378284>] ? get_random_int+0x74/0x90
[  143.964947]  [<ffffffff8117be40>] set_task_comm+0x60/0x70
[  143.964951]  [<ffffffff8117c541>] setup_new_exec+0xe1/0x2d0
[  143.964958]  [<ffffffff811c47ec>] load_elf_binary+0x3ec/0x1a10
[  143.964972]  [<ffffffff8113c672>] ? get_user_pages+0x52/0x60
[  143.964977]  [<ffffffff8117a168>] ? get_user_arg_ptr+0x38/0x80
[  143.964982]  [<ffffffff8117af2c>] search_binary_handler+0xec/0x300
[  143.964986]  [<ffffffff811c4400>] ? do_mmap+0x40/0x40
[  143.964990]  [<ffffffff8117c2eb>] do_execve_common+0x2ab/0x330
[  143.964994]  [<ffffffff8117c3aa>] do_execve+0x3a/0x40
[  143.964998]  [<ffffffff8101d347>] sys_execve+0x47/0x70
[  143.965010]  [<ffffffff815d9bdc>] stub_execve+0x6c/0xc0
[  143.965013] ---[ end trace 8de43f6b89ac81e1 ]---

David
