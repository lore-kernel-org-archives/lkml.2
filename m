Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab2DJPO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:14:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56590 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab2DJPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:14:56 -0400
Message-ID: <4F844E6B.2070005@gmail.com>
Date: Tue, 10 Apr 2012 09:14:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        paulus@samba.org, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG PATCH] perf: kvm - finding struct machine fails for PERF_RECORD_MMAP
References: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com> <4F8369E6.5090608@gmail.com> <87iph8xnim.fsf@abhimanyu.in.ibm.com>
In-Reply-To: <87iph8xnim.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/12 9:40 PM, Nikunj A Dadhania wrote:
> I can think of two places where it can happen:
>
> 1) perf_event__synthesize_kernel_mmap
>
>          [...]
>   	mmap_name = machine__mmap_name(machine, name_buff, sizeof(name_buff));
> 	if (machine__is_host(machine)) {
>             ...
> 	} else {
> 		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
> 		if (machine__is_default_guest(machine))
> 			filename = (char *) symbol_conf.default_guest_kallsyms;
> 		else {
> 			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
> 			filename = path;
> 		}
> 	}
>          [...]
> 	event->mmap.header.type = PERF_RECORD_MMAP;
>          [...]
>          event->mmap.pid   = machine->pid;
>
> 2) perf_event__synthesize_modules
>
>          [...]
> 	if (machine__is_host(machine))
> 		event->header.misc = PERF_RECORD_MISC_KERNEL;
> 	else
> 		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
>          [...]
> 	event->mmap.header.type = PERF_RECORD_MMAP;
>          [...]
>          event->mmap.pid   = machine->pid;
>
> BTW, i am testing this on latest -tip(498c911).
>
> In my case, I am able to recreate this everytime. And have verified that
> the event->header.type that I hit here is of type PERF_RECORD_MMAP.

I was thinking runtime, not initialization. Adding -o direct_io to the 
sshfs mount did the trick. Reading guest /proc files exposes the segfault.

David
