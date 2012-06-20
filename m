Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2FTGOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:14:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35101 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab2FTGOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:14:30 -0400
Date: Wed, 20 Jun 2012 11:44:23 +0530
From: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ryanh@linux.vnet.ibm.com
Subject: Re: perf kvm segfaults while reporting events
Message-ID: <20120620061423.GB3488@linux.vnet.ibm.com>
Reply-To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
References: <20120601135627.GA3004@linux.vnet.ibm.com>
 <4FC8E26E.7060309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4FC8E26E.7060309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062006-6078-0000-0000-00000C4B6CBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Ahern <dsahern@gmail.com> [2012-06-01 09:40:30]:

> On 6/1/12 7:56 AM, Pradeep Kumar Surisetty wrote:
> >Hello
> >
> >perf kvm generats segfaults while reporting events.
> >
> >host&  guest:  3.4.0-rc4
> >
> >1) Copied kallsyms, modules from guest to host.
> >
> >2) recorded  events on host and guest&  report it using below commands.
> >
> >
> >[root@host]# ./perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms --guestmodules=/tmp/guest-modules record -a -o perf.data
> >^C[ perf record: Woken up 1 times to write data ]
> >[ perf record: Captured and wrote 0.381 MB perf.data (~16659 samples) ]
> >
> >[root@host]# ./perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms --guestmodules=/tmp/guest-modules report -i perf.data --force
> >perf: Segmentation fault
> 
> The short of it is that perf-kvm needs some work.
> 
> More specifically, the guest 'machine' is not created on the report
> path for the above arguments. This will prevent the segfault:
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 93d355d..c8e1323 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -918,6 +918,8 @@ static int perf_session_deliver_event(struct
> perf_session *session,
>         }
>         return tool->sample(tool, event, sample, evsel, machine);
>     case PERF_RECORD_MMAP:
> +       if (machine == NULL)
> +           return 0;


Ahhh perf kvm works fine if we record guest events for enough time. 
above patch works better, if some one doesnt record for adequate time. 


>         return tool->mmap(tool, event, sample, machine);
>     case PERF_RECORD_COMM:
>         return tool->comm(tool, event, sample, machine);
> 
> 
> The --guestmount option (which has its own problems) combined with
> specific pid is more stable . e.g.,
> 
> mkdir /tmp/guestmount/<vm-pid>
> sshfs root@<vm-ip>:/  /tmp/guestmount/<vm-pid> -o direct_io
> 
> perf kvm --host --guest --guestmount=/tmp/guestmount \
>   record -p <vm-pid>  -o /tmp/perf.data -- sleep 1
> 
> perf kvm --host --guest --guestmount=/tmp/guestmount  report -i
> /tmp/perf.data --force --stdio
> 
> If you use the -a argument on record with multiple VMs running
> without an entry in /tmp/guestmount you'll see:
> 
> Warning:
> 7 unprocessable samples recorded.
> Do you have a KVM guest running and not using 'perf kvm'?
> 
> David
> 

