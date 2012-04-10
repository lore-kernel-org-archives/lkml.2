Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab2DJDlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:41:00 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51792 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2DJDk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:40:59 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        paulus@samba.org, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG PATCH] perf: kvm - finding struct machine fails for PERF_RECORD_MMAP
In-Reply-To: <4F8369E6.5090608@gmail.com>
References: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com> <4F8369E6.5090608@gmail.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 10 Apr 2012 09:10:33 +0530
Message-ID: <87iph8xnim.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12041003-2000-0000-0000-000007100314
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2012 16:59:50 -0600, David Ahern <dsahern@gmail.com> wrote:
> On 4/9/12 2:22 AM, Nikunj A. Dadhania wrote:
> > From: Nikunj A. Dadhania<nikunj@linux.vnet.ibm.com>
> >
> > Running 'perf kvm --host --guest --guestmount /tmp/guestmount record -a -g -- sleep 2'
> >
> > Was resulting in a segfault. For event type PERF_RECORD_MMAP,
> > event->ip.pid is being used in perf_session__find_machine_for_cpumode,
> > which is not correct.
> >
> > event->ip.pid happens to be 0 in this case and results in returning a
> > NULL machine object. Finally, access to self->pid in
> > machine__mmap_name, results in a segfault later.
> 
> I have tried unsuccessfully to recreate the segfault. All of the samples 
> I get are of type PERF_RECORD_SAMPLE. I do not see how an MMAP event can 
> be generated in a guest context.
> 
I can think of two places where it can happen:

1) perf_event__synthesize_kernel_mmap

        [...]
 	mmap_name = machine__mmap_name(machine, name_buff, sizeof(name_buff));
	if (machine__is_host(machine)) {
           ...
	} else {
		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
		if (machine__is_default_guest(machine))
			filename = (char *) symbol_conf.default_guest_kallsyms;
		else {
			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
			filename = path;
		}
	}
        [...]
	event->mmap.header.type = PERF_RECORD_MMAP;
        [...]
        event->mmap.pid   = machine->pid;        

2) perf_event__synthesize_modules

        [...]
	if (machine__is_host(machine))
		event->header.misc = PERF_RECORD_MISC_KERNEL;
	else
		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
        [...]             
	event->mmap.header.type = PERF_RECORD_MMAP;
        [...]
        event->mmap.pid   = machine->pid;

BTW, i am testing this on latest -tip(498c911).

In my case, I am able to recreate this everytime. And have verified that
the event->header.type that I hit here is of type PERF_RECORD_MMAP.

Let me know if you want me to test out some debug patches.

Regards,
Nikunj

