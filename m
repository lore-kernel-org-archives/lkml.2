Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab0FPOlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:41:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab0FPOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:40:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=tClvekrt6LrLxPByqtS61aQQob1pbTahVwDio/Jya0V4SqSdJ1TEiaTV5sYKN5UNd
	KRRluu+QEYycCiLyE0Jig==
MIME-Version: 1.0
Date: Wed, 16 Jun 2010 16:40:50 +0200
Message-ID: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
Subject: [RFC] perf/perf_events: misleading number of samples due to mmap()
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was using perf record to run various tests and I
realized perf output was rather misleading.

If you sample a noploop program wich runs for 10s:

$ perf record -F 1000  noploop 10

You expect a number of samples around: 10,000.

Now if you divide the rate by 4:

$ perf record -F 250  noploop 10
You expect around: 2500 samples

Well, it turns out the printed count depends on
the state of the whole system, not just noploop.

The reason is that perf reports an estimate based on the
number of bytes written to the buffer divided by the minimal
sample size of 24 bytes.

I think this is very confusing. It certainly got me.

I understand that perf does not parse the samples it gets from
the mmap'ed sampling buffer. Thus, it is not possible to get an
accurate average sample size nor actual number of samples.

What skews the estimate is the MMAP events (for the most part).
The sampling buffer records *all* mmap()s happening in the system
and this even if you are monitoring in per-thread mode. On a single-user
workstation that may be fine, but on a loaded server you get lots
of mmap events. And you don't care about most of them.

This leads me to another point. For per-thread sampling, why
do we need to record mmap() events happening *outside* of
the process? I can understand the exception of kernel modules.

Couldn't we restrict the event to those happening to the PID
the event is attached to?
