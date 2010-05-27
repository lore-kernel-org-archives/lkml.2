Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0E0NqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:46:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57570 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0E0NqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:46:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=cV1PXdlhtR0rEFu4ZhjulpIvwNYsiYNEoknoGjV1aCk6Q6Z1P9xlvOK7Y8HckHMwV
	9wqtHtyv66CpH1xJM+ljw==
MIME-Version: 1.0
Date: Thu, 27 May 2010 15:46:16 +0200
Message-ID: <AANLkTimTMDjP3fgcOv2kIUPYYONAiMYPdhDb1VsLrTE_@mail.gmail.com>
Subject: [BUG] perf: buildid not managed properly when cmd path is relative
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ran into another problem while running more tests with
perf record, perf buildid-list.

I do the following:

$ perf record foo/noploop 5
$ perf buildid-list
54b1e7cc3cf52e0db255aab44ce7538eb62655b8 [kernel.kallsyms]
875ae61623e89f408b425ca0486a9ec99e3ac73e
/home/eranian/perfmon/official/tip/build/tools/perf/foo/noploop

I know I have samples in noploop:
$ perf report -D
...
0x10a0 [0x20]: PERF_RECORD_SAMPLE(IP, 2): 14721/14721: 0x4006d6 period: 2351576
 ... thread: noploop:14721
 ...... dso: ./foo/noploop

But if I ask with buildid-list (like per-archive is doing) then I get:

$ perf buildid-list --with-hits
54b1e7cc3cf52e0db255aab44ce7538eb62655b8 [kernel.kallsyms]
0000000000000000000000000000000000000000 ./foo/noploop

The builid is bogus for noploop and it is relative path not full anymore.

I instrumented __dsos__fprintf_buildid() and I get:
hit=0 name=/home/eranian/perfmon/official/tip/build/tools/perf/foo/noploop
hit=1 name=./foo/noploop
0000000000000000000000000000000000000000 ./foo/noploop

So it looks like when cmd is relative there are two entries but the one
that counts the hits is the one with relative path. But is does not have
the buildid, the full path entry does.

This is an issue because perf-archive only packages the
content of .debug with hits.

The problem does not exists when cmd are found from PATH.
