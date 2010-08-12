Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab0HLJjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:39:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0HLJjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:39:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=kVRGS0xxCnwxiQ/nyDp2W+VNOsxf+7RJwZHkfKjmKPeqM67QUBW6MGKB+vt++eg4E
	p5QxfOk8+b1DwPDW8u6Xw==
MIME-Version: 1.0
Date: Thu, 12 Aug 2010 11:39:34 +0200
Message-ID: <AANLkTinSpaSMusUkBZG3-b_hNf5ADfOw2jHE=yE4ysZ_@mail.gmail.com>
Subject: [BUG] perf: trace -s script is broken
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to understand how you're supposed to use perf trace with a
script using tip-x86.
I am running into several problems.

I did:
$ make prefix=/usr
$ sudo make install prefix=/usr

$ sudo perf record -c 1 -e raw_syscalls:sys_enter -a -- sleep 1
$ sudo perf trace -s sctop.py
Can't open python script "sctop.py": No such file or directory

I looked into this a bit more, and sure enough, it seems perf is only looking
in the current subdir to find sctop.py. However if you do:
$ perf trace -l
List of available trace scripts:
  failed-syscalls [comm]               system-wide failed syscalls
  rw-by-file <comm>                    r/w activity for a program, by file
  rw-by-pid                            system-wide r/w activity
  rwtop [interval]                     system-wide r/w top
  wakeup-latency                       system-wide min/max/avg wakeup latency
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  failed-syscalls-by-pid [comm]        system-wide failed syscalls, by pid
  sctop [comm] [interval]              syscall top
  syscall-counts-by-pid [comm]         system-wide syscall counts, by pid
  syscall-counts [comm]                system-wide syscall counts

The listing requires trace to look at /usr/libexec/perf-core/scripts/*

I think in builtin-trace.c, you need to add the path prefix, perf_path_exec()
to the script_name for this to work correctly. Or am I missing something here?

Similarly, all the -report scripts installed via make install, still
have the ~/libexec
prefix hardcoded into them. I believe those should be relative to the
install prefix
instead.
