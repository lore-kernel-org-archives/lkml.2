Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2BHQzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:55:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58755 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BHQzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:55:39 -0500
Message-ID: <4F32A907.6030505@gmail.com>
Date: Wed, 08 Feb 2012 09:55:35 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: joerg.roedel@amd.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf: record segfaults for cycles event when collecting data on a
 VM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ ps -p 21483
  PID TTY          TIME CMD
21483 pts/3    00:30:20 qemu-kvm

perf record -e cycles -p 21483 -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.012 MB perf.data (~503 samples) ]
Segmentation fault

git bisect points to:

1aed2671738785e8f5aea663a6fda91aa7ef59b5 is the first bad commit
commit 1aed2671738785e8f5aea663a6fda91aa7ef59b5
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Jan 4 17:54:20 2012 +0100

    perf kvm: Do guest-only counting by default

    Make use of exclude_guest and exlude_host in perf-kvm to do only
    guest-only counting by default.

    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Joerg Roedel <joro@8bytes.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Gleb Natapov <gleb@redhat.com>
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    [ committer note: Moved perf_{guest,host} & event_attr_init to util.c ]
    [                 so as not to drag more stuff to the python binding]
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>



When processing the events at the end of the collection machine comes as
NULL. Top part of the stack trace:


#0  0x00000000004667c2 in machine__findnew_thread (self=0x0, pid=21483)
at util/thread.c:75
        p = 0x28
        parent = 0x0
        th = 0x8e51b0
#1  0x00000000004395bc in build_id__mark_dso_hit (tool=0x7802e0,
event=0x7ffff7ff9df8,
    sample=0x7fffffffe030, evsel=0x8e4c80, machine=0x0) at
util/build-id.c:27
        al = {thread = 0x7fffffffe030, map = 0x6f68f12cf0d73400, sym =
0x7fffffffdfa0,
          addr = 140737488347184, level = -8 '\370', filtered = 157,
cpumode = 255 '\377', cpu = 32767}
        cpumode = 4 '\004'
        thread = 0x8e50a0
#2  0x0000000000464aed in perf_session_deliver_event (session=0x8e50a0,
event=0x7ffff7ff9df8,
    sample=0x7fffffffe030, tool=0x7802e0, file_offset=11768) at
util/session.c:799
        evsel = 0x8e4c80
        machine = 0x0
#3  0x0000000000464fd4 in perf_session__process_event (session=0x8e50a0,
event=0x7ffff7ff9df8,
    tool=0x7802e0, file_offset=11768) at util/session.c:907
        sample = {ip = 18446744071579083331, pid = 21483, tid = 21487,
time = 18446744073709551615,
          addr = 0, id = 18446744073709551615, stream_id =
18446744073709551615, period = 10325467,
          cpu = 4294967295, raw_size = 0, raw_data = 0x0, callchain = 0x0}
        ret = 0
