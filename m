Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2DIW74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:59:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41727 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab2DIW7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:59:55 -0400
Message-ID: <4F8369E6.5090608@gmail.com>
Date: Mon, 09 Apr 2012 16:59:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
CC: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        paulus@samba.org, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
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
>
> event->ip.pid happens to be 0 in this case and results in returning a
> NULL machine object. Finally, access to self->pid in
> machine__mmap_name, results in a segfault later.

I have tried unsuccessfully to recreate the segfault. All of the samples 
I get are of type PERF_RECORD_SAMPLE. I do not see how an MMAP event can 
be generated in a guest context.

David


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

