Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2DZVNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:13:09 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:38568 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab2DZVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:13:06 -0400
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
From: Namhyung Kim <namhyung@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4F996433.7040003@gmail.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
	 <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
	 <4F996433.7040003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 06:12:58 +0900
Message-ID: <1335474778.1497.14.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-04-26 (Thu), 09:05 -0600, David Ahern wrote:
> On 4/25/12 11:15 PM, Namhyung Kim wrote:
> > Currently, 'perf record -- sleep 1' creates a cpu map for all online
> > cpus since it turns out calling cpu_map__new(NULL). Fix it. Also it
> > is guaranteed that cpu_list is NULL if PID/TID is given by calling
> > perf_target__validate(), so we can make the conditional bit simpler.
> >
> > This also fixes perf test 7 (Validate) failure on my 6 core machine:
> >
> >    $ cat /sys/devices/system/cpu/online
> >    0-11
> >    $ ./perf test -v 7
> >     7: Validate PERF_RECORD_* events&  perf_sample fields:
> >    --- start ---
> >    perf_evlist__mmap: Operation not permitted
> >    ---- end ----
> >    Validate PERF_RECORD_* events&  perf_sample fields: FAILED!
> 
> Works fine for me with latest tip:
> $ cat /sys/devices/system/cpu/online
> 0-15
> 
> $ /tmp/perf/perf test -v 7
>   7: Validate PERF_RECORD_* events & perf_sample fields:
> --- start ---
> 64740167922229 0 PERF_RECORD_SAMPLE
> 64740167926354 0 PERF_RECORD_SAMPLE
> 64740167928389 0 PERF_RECORD_SAMPLE
> 64740167930832 0 PERF_RECORD_SAMPLE
> 64740168404145 0 PERF_RECORD_COMM: sleep:16523
> 64740168424672 0 PERF_RECORD_MMAP 16523/16523: [0x400000(0x6000) @ 0]: 
> /bin/sleep
> 64740168441676 0 PERF_RECORD_MMAP 16523/16523: [0x7f83de5bb000(0x224000) 
> @ 0]: /lib64/ld-2.14.90.so
> 64740168458460 0 PERF_RECORD_MMAP 16523/16523: [0x7fff009ff000(0x1000) @ 
> 0x7fff009ff000]: [vdso]
> 64740168586358 0 PERF_RECORD_MMAP 16523/16523: [0x7f83de203000(0x3b8000) 
> @ 0]: /lib64/libc-2.14.90.so
> 64741168625653 0 PERF_RECORD_EXIT(16523:16523):(16523:16523)
> ---- end ----
> Validate PERF_RECORD_* events & perf_sample fields: Ok
> 
> Is the failure a by-product of the other patches in this set?
> 

Hmm.. No, I can reproduce it without any of this series. And now I think
that it is not related to the number of cpus. On my 4 core (no
hyperthreading) machine at home, the result was same.

BTW, did you change sysctl settings?

  $ cat /sys/devices/system/cpu/online 
  0-3
  $ grep . /proc/sys/kernel/perf_event_*
  /proc/sys/kernel/perf_event_max_sample_rate:100000
  /proc/sys/kernel/perf_event_mlock_kb:516
  /proc/sys/kernel/perf_event_paranoid:1
  $ ./perf test 7
   7: Validate PERF_RECORD_* events & perf_sample fields: FAILED!
  $ ./perf --version
  perf version 3.4.rc1


Thanks.

-- 
Regards,
Namhyung Kim


