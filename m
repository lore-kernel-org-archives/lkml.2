Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1DOUrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:47:51 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44053 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753200Ab1DOUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:49 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Zq4M7VsVM1mH_n4Kfef1vmk.pHi.FS638r5qzO2IbJWY3g7
 qppKTiYB1c.b4BoDHNFSaIcpTv77RnJ0NST9Fk6g0v2LUUzF7MUF8_czNKdO
 Xx8couYYnry7T394K3Imio4upKtpK7ST6WFAP4P09T8Mn_erhzINUb5rF94N
 yyWADRM311BQhZgS9T4GiyTVXxm1WcnyhF4Q7ocHBfhj6.UJGO3sPgy9B58d
 g65Al5CMmhPr7dMk8aGLD1_c42hI1kbCq1fEJchEg1i2Edw50q8AIluSpDQ5
 L9pkmWsIqvnBVmighxiDMuypf6vSdYCdyvfPr1reVyY0p0bXY
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204730.326790555@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:30 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 00/21] SLUB: Lockless freelists for objects V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2->V3
	- Provide statistics
	- Fallback logic to page lock if cmpxchg16b is not available.
	- Better counter support
	- More cleanups and clarifications

Well here is another result of my obsession with SLAB allocators. There must be
some way to get an allocator done that is faster without queueing and I hope
that we are now there (maybe only almost...).

This patchset implement wider lockless operations in slub affecting most of the
slowpaths. In particular the patch decreases the overhead in the performance
critical section of __slab_free.

One test that I ran was "hackbench 200 process 200" on 2.6.29-rc3 under KVM

Run	SLAB	SLUB	SLUB LL
1st	35.2	35.9	31.9
2nd	34.6	30.8	27.9
3rd	33.8	29.9	28.8

Note that the SLUB version in 2.6.29-rc1 already has an optimized allocation
and free path using this_cpu_cmpxchg_double(). SLUB LL takes it to new heights
by also using cmpxchg_double() in the slowpaths (especially in the kfree()
case where we cannot queue).

The patch uses a cmpxchg_double (also introduced here) to do an atomic change
on the state of a slab page that includes the following pieces of information:

1. Freelist pointer
2. Number of objects inuse
3. Frozen state of a slab

Disabling of interrupts (which is a significant latency in the
allocator paths) is avoided in the __slab_free case.

There are some concerns with this patch. The use of cmpxchg_double on
fields of the page struct requires alignment of the fields to double
word boundaries. That can only be accomplished by adding some padding
to struct page which blows it up to 64 byte  (on x86_64). Comments
in the source describe these things in more detail.

The cmpxchg_double() operation introduced here could also be used to
update other doublewords in the page struct in a lockless fashion. One
can envision page state changes that involved flags and mappings or
maybe do list operations locklessly (but with the current scheme we
would need to update two other words elsewhere at the same time too,
so another scheme would be needed).

