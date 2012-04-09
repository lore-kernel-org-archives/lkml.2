Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2DIUSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:18:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2DIUSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:18:12 -0400
Message-ID: <4F8343CA.7050208@gmail.com>
Date: Mon, 09 Apr 2012 14:17:14 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, acme@ghostprotocols.net
CC: mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        fweisbec@gmail.com, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG PATCH] perf: kvm - finding struct machine fails for PERF_RECORD_MMAP
References: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/12 2:22 AM, Nikunj A. Dadhania wrote:
> From: Nikunj A. Dadhania<nikunj@linux.vnet.ibm.com>
>
> Running 'perf kvm --host --guest --guestmount /tmp/guestmount record -a -g -- sleep 2'
>
> Was resulting in a segfault. For event type PERF_RECORD_MMAP,
> event->ip.pid is being used in perf_session__find_machine_for_cpumode,
> which is not correct.

I'm not getting the segfault with latest tip/perf/urgent, but I am 
getting a hang.

It's stuck on buildid:

(gdb) bt
#0  0x00007fabf53e79da in mmap64 () from /lib64/libc.so.6
#1  0x0000000000454656 in __perf_session__process_events 
(session=0x1e06110,
     data_offset=<value optimized out>, data_size=<value optimized out>, 
file_size=37328,
     tool=0x75db40) at util/session.c:1192
#2  0x00000000004102e6 in process_buildids (status=<value optimized 
out>, arg=0x75cc00)
     at builtin-record.c:320
#3  perf_record__exit (status=<value optimized out>, arg=0x75cc00) at 
builtin-record.c:333
#4  0x00007fabf53419c9 in exit () from /lib64/libc.so.6
#5  0x0000000000406b84 in handle_internal_command (argc=9, 
argv=0x7fff3f14d6c0) at perf.c:345
#6  run_argv (argc=9, argv=0x7fff3f14d6c0) at perf.c:389
#7  main (argc=9, argv=0x7fff3f14d6c0) at perf.c:487


Adding -B works around it and proves something is not right regarding 
buildid's and perf-kvm. I'll dig into it as time allows, but wanted to 
send this out in case Arnaldo understands the problem now.

David

>
> event->ip.pid happens to be 0 in this case and results in returning a
> NULL machine object. Finally, access to self->pid in
> machine__mmap_name, results in a segfault later.
>
> For PERF_RECORD_MMAP type, pass event->mmap.pid.
>
> Signed-off-by: Nikunj A. Dadhania<nikunj@linux.vnet.ibm.com>
> ---
>
>   tools/perf/util/session.c |   12 ++++++++++--
>   1 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 9412e3b..00923cd 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -826,8 +826,16 @@ static struct machine *
>   {
>   	const u8 cpumode = event->header.misc&  PERF_RECORD_MISC_CPUMODE_MASK;
>
> -	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL&&  perf_guest)
> -		return perf_session__find_machine(session, event->ip.pid);
> +	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL&&  perf_guest) {
> +		u32 pid;
> +
> +		if (event->header.type == PERF_RECORD_MMAP)
> +			pid = event->mmap.pid;
> +		else
> +			pid = event->ip.pid;
> +
> +		return perf_session__find_machine(session, pid);
> +	}
>
>   	return perf_session__find_host_machine(session);
>   }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

