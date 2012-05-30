Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2E3PBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:01:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39102 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2E3PBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:01:41 -0400
MIME-Version: 1.0
Date: Wed, 30 May 2012 17:01:39 +0200
Message-ID: <CABPqkBRSRZR4KwbauNTDfH19w+1sDZ3yfnihMHzQg312mWPzSQ@mail.gmail.com>
Subject: [BUG] perf tools: does not load global variables syms from main program
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

I am working on the PEBS Load Latency support for perf_events.
This HW feature can capture load/store accesses. I have extended
perf record/report to collect and process the data. However, I ran into
a serious issue with symbols and maps. I want to be able to symbolize
data and not just code. For global variables declared inside shared objects
or the main program, we should be able to get to the variable names. At least
that seems to be the intent of the code.

But in practice, I ran into an issue with global variables of the main program.
My test program has a simple int tab[] array declared global. The program
is statically linked. The /proc/maps output is as follows:

00400000-004b3000 r-xp 00000000 08:11 1748297                            foo
006b3000-006b5000 rw-p 000b3000 08:11 1748297                            foo
006b5000-006dc000 rw-p 00000000 00:00 0                                  [heap]
7f05a0e8f000-7f05a0e90000 rw-p 00000000 00:00 0
7fffc0bdb000-7fffc0bfc000 rw-p 00000000 00:00 0                          [stack]
7fffc0bff000-7fffc0c00000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
  [vsyscall]

$ nm -v foo
...
00000000006b7c90 b unseen_objects
00000000006b7c98 b marker.8271
00000000006b7ca0 b frame_hdr_cache_head
00000000006b7cc0 b frame_hdr_cache
00000000006b7e40 b subs.8531
00000000006b7e60 B the_tab      <==== my table
00000000006b7e80 B loop
00000000006b7e88 B fast
00000000006b7e90 B tab
00000000006b7e98 B zero
00000000006b7e9c B pin
...

$ readelf -e foo
...
LOAD           0x00000000000b3ef0 0x00000000006b3ef0 0x00000000006b3ef0
                 0x0000000000000f20 0x0000000000004428  RW     200000
...

The global variables are mapped into the heap segment. But the logic in
perf assumes that heap has no file backing and therefore there is no
point in calling dso__load_syms() for DATA (MAP__VARIABLE). Hence,
I cannot symbolize global variables.

To prove the problem for my little test case, I  added a gross hacks into
dso__load_syms().

Seems to me like we would need to keep track of the elf image of the
main program
and associate it with the [heap] segment. Furthermore, we would need to skip the
addr adjustment based on .gnu.prelink_undo.

I am not too much of an expert is that area, so I am seeking advice on
how to best
fix this ASAP.

Thanks.
