Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab2FAPkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:40:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50393 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2FAPke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:40:34 -0400
Message-ID: <4FC8E26E.7060309@gmail.com>
Date: Fri, 01 Jun 2012 09:40:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, ryanh@linux.vnet.ibm.com
Subject: Re: perf kvm segfaults while reporting events
References: <20120601135627.GA3004@linux.vnet.ibm.com>
In-Reply-To: <20120601135627.GA3004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/12 7:56 AM, Pradeep Kumar Surisetty wrote:
> Hello
>
> perf kvm generats segfaults while reporting events.
>
> host&  guest:  3.4.0-rc4
>
> 1) Copied kallsyms, modules from guest to host.
>
> 2) recorded  events on host and guest&  report it using below commands.
>
>
> [root@host]# ./perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms --guestmodules=/tmp/guest-modules record -a -o perf.data
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.381 MB perf.data (~16659 samples) ]
>
> [root@host]# ./perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms --guestmodules=/tmp/guest-modules report -i perf.data --force
> perf: Segmentation fault

The short of it is that perf-kvm needs some work.

More specifically, the guest 'machine' is not created on the report path 
for the above arguments. This will prevent the segfault:

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 93d355d..c8e1323 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -918,6 +918,8 @@ static int perf_session_deliver_event(struct 
perf_session *session,
         }
         return tool->sample(tool, event, sample, evsel, machine);
     case PERF_RECORD_MMAP:
+       if (machine == NULL)
+           return 0;
         return tool->mmap(tool, event, sample, machine);
     case PERF_RECORD_COMM:
         return tool->comm(tool, event, sample, machine);


The --guestmount option (which has its own problems) combined with 
specific pid is more stable . e.g.,

mkdir /tmp/guestmount/<vm-pid>
sshfs root@<vm-ip>:/  /tmp/guestmount/<vm-pid> -o direct_io

perf kvm --host --guest --guestmount=/tmp/guestmount \
   record -p <vm-pid>  -o /tmp/perf.data -- sleep 1

perf kvm --host --guest --guestmount=/tmp/guestmount  report -i 
/tmp/perf.data --force --stdio

If you use the -a argument on record with multiple VMs running without 
an entry in /tmp/guestmount you'll see:

Warning:
7 unprocessable samples recorded.
Do you have a KVM guest running and not using 'perf kvm'?

David
