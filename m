Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1C1KfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:35:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56289 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1C1KfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:35:05 -0400
X-AuditID: b753bd60-a28b7ba000004916-f2-4d9064565c07
X-AuditID: b753bd60-a28b7ba000004916-f2-4d9064565c07
Message-ID: <4D906450.1040809@hitachi.com>
Date: Mon, 28 Mar 2011 19:34:56 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6> <20110324113209.20235.61900.stgit@localhost6.localdomain6> <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com> <4D8CAE74.9080805@gmail.com>
In-Reply-To: <4D8CAE74.9080805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/26 0:02), David Ahern wrote:
> On 03/25/11 04:14, Akihiro Nagai wrote:
>>> On 03/24/11 05:32, Akihiro Nagai wrote:
>>>> Provide the function to print pid and command name to
>>>> 'perf branch trace'. Users can select items to print with options.
>>>> For example,
>>>>       'perf branch -p trace' prints only pid,
>>>>       'perf branch -ac trace' prints address and comamnd name.
>>>>       'perf branch trace' prints only address (default)
>>>>
>>>> This is output sample (perf branch -ac trace):
>>>> command      address
>>>> ls           0xffffffff8146fe0e =>   ls           0x0000003806200b20
>>>> ls           0xffffffff8146fe0e =>   ls           0x0000003806200b20
>>>> ls           0x0000003806200b23 =>   ls           0x0000003806204910
>>>> ls           0xffffffff8146fe0e =>   ls           0x0000003806204910
>>>> ls           0xffffffff8146fe0e =>   ls           0x0000003806204936
>>>> ls           0xffffffff8146fe0e =>   ls           0x000000380620493d
>>>> ls           0x0000003806204981 =>   ls           0x00000038062049a3
>>>> ls           0x00000038062049a7 =>   ls           0x0000003806204988
>>>
>>> This can be easily added to perf-script. e.g,
>>>
>>> perf record -e branches:u -c 1 -d -- ls /tmp
>>>
>>> perf script -i /tmp/perf.data -f hw:comm,pid,event,sym,addr
>>>
>>> ...
>>> ls  8150 branches: 0x39d30144d0 ffffffff8146a48e  ()
>>> ls  8150 branches: 0x39d3014507 ffffffff8146a48e  ()
>>> ls  8150 branches: 0x39d3014510            14518 _dl_sysdep_start
>>> (/lib64/ld-2.13.so)
>>> ...
>>> ls  8150 branches: 0x39d3015250             1833 process_envvars
>>> (/lib64/ld-2.13.so)
>>> ls  8150 branches: 0x39d3015260            1526f _dl_next_ld_env_entry
>>> (/lib64/ld-2.13.so)
>>> ls  8150 branches: 0x39d3015260            1526f _dl_next_ld_env_entry
>>> (/lib64/ld-2.13.so)
>> It seems to analyze only 'branch from' address and,
>> print 'branch to' address just in hex.
>> I would like to analyze both of addresses branch from/to.
>
> from is sample->ip? to is sample->addr? In the above example
> 0x39d3015260 is the value from sample->addr, 1526f is sample->ip which
> resolves to _dl_next_ld_env_entry from /lib64/ld-2.13.so.
Yes.
In this example, resolved address is only sample->ip (branch from).
We need the resolved address of sample->addr (branch to) too, because
both of them are addresses of execution code.
For example, we need following output.

...
ls 0x00000038062152a9 _dl_sysdep_start+0x189     /lib64/ld-2.12.90.so             => ls           0x00000038062020e0 dl_main+0x0                /lib64/ld-2.12.90.so
ls 0xffffffff814547d2 irq_return+0x0             /lib/modules/2.6.38-rc8-tip+/build/vmlinux => ls 0x00000038062020e0 dl_main+0x0                /lib64/ld-2.12.90.so
ls 0x0000003806202155 dl_main+0x75               /lib64/ld-2.12.90.so             => ls           0x00000038062017d0 process_envvars+0x0        /lib64/ld-2.12.90.so
ls 0xffffffff814547d2 irq_return+0x0             /lib/modules/2.6.38-rc8-tip+/build/vmlinux => ls 0x00000038062017d0 process_envvars+0x0        /lib64/ld-2.12.90.so
ls 0x0000003806201833 process_envvars+0x63       /lib64/ld-2.12.90.so             => ls           0x0000003806215ec0 _dl_next_ld_env_entry+0x0  /lib64/ld-2.12.90.so
ls 0x0000003806215ed3 _dl_next_ld_env_entry+0x13 /lib64/ld-2.12.90.so             => ls           0x0000003806215ee5 _dl_next_ld_env_entry+0x25 /lib64/ld-2.12.90.so
ls 0x0000003806215ee9 _dl_next_ld_env_entry+0x29 /lib64/ld-2.12.90.so             => ls           0x0000003806215ed5 _dl_next_ld_env_entry+0x15 /lib64/ld-2.12.90.so
...

This example's left hand side which is separated by "=>" is a result of resolving sample->ip and,
right hand side is sample->addr's.

>
>>
>> Can perf-script do it by writing scripts?
>
> If you are pulling the data from a perf sample then you can accomplish
> the same goal within perf-script.
It seems that perf-script doesn't have the interface of converting
sample->addr to symbol, pid, comm and others. Of course, we can add
the interface to perf-script, and it could be another way to implement
this function using perf-script.
However, since BTS output usually becomes huge, it would be very slow
to convert all the data by python/perl.

>
>
> David
