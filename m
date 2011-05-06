Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1EFSG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:06:58 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22757 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751096Ab1EFSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:06:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: R96UCOYVM1kWc8ougMCEc3bzB3HfhsvVsP32q4QWYk74htq
 ievijltdGY.OTm07ahPFNswa5nfzah7BPiP.5k3NHa7b.SXGR6aDyT8TaxII
 ySsaensFB5h3G6qaHSFstx.ehX9bvMKXtQwTE._5YonExasliFoNIfcEKI9g
 shLUVsVSekDZhAHCFuwpFI_q0.dfhVxGiH3ykJNtp6SK5URswLLAkr2qDoBF
 p72xzpwLVsIOsL0Vf2e9LnYoApBVfSolVMP3zQThBhD6dFTlb8ZgCoCyyaHm
 vEwMgoat47r0mA0B2qqi72WVfBKeWapBwQYhhnEs8C8JrF.In
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180541.990069206@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:41 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 00/16] SLUB: Lockless freelists for objects V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3->V4	- Diffed against Pekka's slab/next tree plus the ifdef removal patch
		 (which should be in slab/next soon).
	- Numerous cleanups in particular as a result of the removal of the
	  #ifdef CMPXCHG_LOCAL stuff.
	- Smaller cleanups whereever I saw something.

V2->V3
	- Provide statistics
	- Fallback logic to page lock if cmpxchg16b is not available.
	- Better counter support
	- More cleanups and clarifications

Well here is another result of my obsession with SLAB allocators. There must be
some way to get an allocator done that is faster without queueing and I hope
that we are now there (maybe only almost...). Any help with cleaning up the
rough edges would be appreciated.

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
case where we frequently cannot use the fastpath because there is no queue).

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
to struct page which blows it up to 64 byte (on x86_64). Comments
in the source describe these things in more detail.

The cmpxchg_double() operation introduced here could also be used to
update other doublewords in the page struct in a lockless fashion. One
can envision page state changes that involved flags and mappings or
maybe do list operations locklessly (but with the current scheme we
would need to update two other words elsewhere at the same time too,
so another scheme would be needed).

