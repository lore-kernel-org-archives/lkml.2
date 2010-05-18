Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0ERJhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:37:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0ERJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:36:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=Ho5/UunvDx6+kTrWUcTykGOsP3FtH4NeRtEiwM8YQDoYygCxeByYdVFZhkl/9mjA+
	6GqjLYWJb7NpUUBoRs5dQ==
MIME-Version: 1.0
Date: Tue, 18 May 2010 11:36:52 +0200
Message-ID: <AANLkTimmScKO8YnPJWfTqFXBXQYwbbdej-gaYnHCgeTc@mail.gmail.com>
Subject: [BUG] perf: record does not seem to store buildids anymore
From: Stephane Eranian <eranian@google.com>
To: tzanussi@gmail.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to understand how perf record deals with buildids.
I am interested in offline and not live processing. According
to http://lkml.org/lkml/2010/5/1/5, the inject patch does not
change perf record. It should still save the buildids at the
end of the perf.data file. I suspect it does not anymore.

If I do:

$ perf record -o - noploop 2 | perf inject -b | perf report -v -i -
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.063 MB - (~2756 samples) ]
build id event received for
/lib/modules/2.6.34-tip-default+/build/vmlinux:
0ad6b5dd1295e0177be9d12acafa72daac664ee7
Looking at the vmlinux_path (5 entries long)
Using /lib/modules/2.6.34-tip-default+/build/vmlinux for symbols
build id event received for /usr/local/bin/noploop:
e8a36c0c1e36e18522233ff2a4b1fff0f9689b1c

There is indeed a buildid generated for my noploop test program.

But I do the simpler:

$ perf record -o perf.out noploop 2
noploop for 2 seconds
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.063 MB perf.out (~2739 samples) ]

$ perf buildid-list -i perf.out
$

I get nothing.

If I try with perf report -D:

$ perf report -D -i perf.out
   .....
     TOTAL events:       2011
      MMAP events:         21
      LOST events:          0
      COMM events:          1
      EXIT events:          1
  THROTTLE events:          0
UNTHROTTLE events:          0
      FORK events:          0
      READ events:          0
    SAMPLE events:       1988
      ATTR events:          0
EVENT_TYPE events:          0
TRACING_DATA events:          0
  BUILD_ID events:          0

It shows no buildid events found.

So either something is broken or I don't understand the logic here.
