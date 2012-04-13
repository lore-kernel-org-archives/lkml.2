Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2DMLw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2DMLw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:52:58 -0400
Date: Fri, 13 Apr 2012 13:32:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Force guest machine definition option
Message-ID: <20120413113207.GB3384@m.brq.redhat.com>
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
 <1334233262-5679-2-git-send-email-jolsa@redhat.com>
 <4F86E965.4010506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4F86E965.4010506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 08:40:37AM -0600, David Ahern wrote:
> On 4/12/12 6:21 AM, Jiri Olsa wrote:
> >Running 'perf kvm record' without any of following options:
> >   --guestmount
> >   --guestvmlinux
> >   --guestkallsyms
> >   --guestmodules
> >
> >is causing the guest machine to be ommited from the data file,
> >and all guest samples are counted in nr_unprocessable_samples.
> 
> Even with guestmount specified you can hit this path -- e.g., no
> pid-based directory under guestmount for a VM.

hm, something's wrong anyway..

[root@dhcp-26-214 perf]# ./perf kvm --guest --guestkallsyms=./kallsyms record -p 1791
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.013 MB perf.data.guest (~576 samples) ]
[root@dhcp-26-214 perf]# ./perf kvm --guest --guestkallsyms=./kallsyms report --stdio
Segmentation fault (core dumped)

it segfaults on guest mmap (attached bt) having NULL machine,
since no guest kernel buildid/dso was stored&loaded..
the host/guest machines code seems too 'complex' ;)

jirka


Program received signal SIGSEGV, Segmentation fault.
0x000000000046a35e in machine__mmap_name (self=0x0, bf=0x7fffffffbf30 "[kernel.kallsyms]", size=4096) at util/map.c:711
711                     snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
Missing separate debuginfos, use: debuginfo-install atk-2.2.0-2.fc16.x86_64 bzip2-libs-1.0.6-3.fc15.x86_64 cairo-1.10.2-4.fc16.x86_64 elfutils-libelf-0.153-1.fc16.x86_64 elfutils-libs-0.153-1.fc16.x86_64 fontconfig-2.8.0-4.fc16.x86_64 freetype-2.4.6-4.fc16.x86_64 gdk-pixbuf2-2.24.1-1.fc16.x86_64 glib2-2.30.2-1.fc16.x86_64 gtk2-2.24.8-3.fc16.x86_64 libX11-1.4.3-1.fc16.x86_64 libXau-1.0.6-2.fc15.x86_64 libXcomposite-0.4.3-2.fc15.x86_64 libXcursor-1.1.11-3.fc15.x86_64 libXdamage-1.1.3-2.fc15.x86_64 libXext-1.3.0-1.fc16.x86_64 libXfixes-5.0-1.fc16.x86_64 libXi-1.4.5-1.fc16.x86_64 libXinerama-1.1.1-2.fc15.x86_64 libXrandr-1.3.1-2.fc15.x86_64 libXrender-0.9.6-2.fc15.x86_64 libffi-3.0.10-1.fc16.x86_64 libpng-1.2.46-2.fc16.x86_64 libselinux-2.1.6-6.fc16.x86_64 libxcb-1.7-3.fc16.x86_64 newt-0.52.14-1.fc16.x86_64 nss-softokn-freebl-3.13.3-1.fc16.x86_64 pango-1.29.4-1.fc16.x86_64 perl-libs-5.14.2-197.fc16.x86_64 pixman-0.22.2-1.fc16.x86_64 python-libs-2.7.2-5.2.fc16.x86_64 slang-2.2.4-1.fc16.x86_64 xz-libs-5.1.1-1alpha.fc16.x86_64
(gdb) bt
#0  0x000000000046a35e in machine__mmap_name (self=0x0, bf=0x7fffffffbf30 "[kernel.kallsyms]", size=4096) at util/map.c:711
#1  0x0000000000443d84 in perf_event__process_kernel_mmap (tool=0x7fffffffdf40, event=0x7ffff7ff5168, machine=0x0) at util/event.c:550
#2  0x0000000000444265 in perf_event__process_mmap (tool=0x7fffffffdf40, event=0x7ffff7ff5168, sample=0x7fffffffd430, machine=0x0)
    at util/event.c:656
#3  0x000000000046d099 in perf_session_deliver_event (session=0x905570, event=0x7ffff7ff5168, sample=0x7fffffffd430, tool=
    0x7fffffffdf40, file_offset=360) at util/session.c:884
#4  0x000000000046d578 in perf_session__process_event (session=0x905570, event=0x7ffff7ff5168, tool=0x7fffffffdf40, file_offset=360)
    at util/session.c:990
#5  0x000000000046ddc6 in __perf_session__process_events (session=0x905570, data_offset=288, data_size=13824, file_size=14112, tool=
    0x7fffffffdf40) at util/session.c:1219
#6  0x000000000046df60 in perf_session__process_events (self=0x905570, tool=0x7fffffffdf40) at util/session.c:1258
#7  0x0000000000423b7d in __cmd_report (rep=0x7fffffffdf40) at builtin-report.c:367
#8  0x0000000000424f3e in cmd_report (argc=0, argv=0x9053a0, prefix=0x0) at builtin-report.c:752
#9  0x00000000004370c9 in __cmd_report (argc=2, argv=0x7fffffffe420) at builtin-kvm.c:84
#10 0x00000000004373ee in cmd_kvm (argc=2, argv=0x7fffffffe420, prefix=0x0) at builtin-kvm.c:131
#11 0x0000000000414ead in run_builtin (p=0x796488, argc=4, argv=0x7fffffffe420) at perf.c:273
#12 0x00000000004150a7 in handle_internal_command (argc=4, argv=0x7fffffffe420) at perf.c:345
#13 0x00000000004151f3 in run_argv (argcp=0x7fffffffe30c, argv=0x7fffffffe300) at perf.c:389
#14 0x0000000000415479 in main (argc=4, argv=0x7fffffffe420) at perf.c:487
