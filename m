Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2IEVy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:54:27 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:35997 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759653Ab2IEVyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:54:25 -0400
Subject: Re: [PATCH] KVM: VMX: invalidate vpid for invlpg instruction
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <50447442.2050307@redhat.com>
References: <1346429448.2823.1.camel@offbook>
	 <20120831173707.GA3895@amt.cnet> <1346628440.3170.3.camel@offbook>
	 <50447442.2050307@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 05 Sep 2012 23:54:21 +0200
Message-ID: <1346882061.6304.17.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-03 at 12:11 +0300, Avi Kivity wrote:
> On 09/03/2012 02:27 AM, Davidlohr Bueso wrote:
> > On Fri, 2012-08-31 at 14:37 -0300, Marcelo Tosatti wrote:
> >> On Fri, Aug 31, 2012 at 06:10:48PM +0200, Davidlohr Bueso wrote:
> >> > For processors that support VPIDs we should invalidate the page table entry
> >> > specified by the lineal address. For this purpose add support for individual
> >> > address invalidations.
> >> 
> >> Not necessary - a single context invalidation is performed through
> >> KVM_REQ_TLB_FLUSH.
> > 
> > Since vpid_sync_context() supports both single and all-context vpid
> > invalidations, wouldn't it make sense to also add individual address
> > ones as well, supporting further granularity?
> 
> It might.  Do you have benchmarks supporting this?
> 

I ran two benchmarks: Java Dacapo[1] Sunflow (renders a set of images
using ray tracing) and a vanilla 3.2 kernel build (with 1 job and -j8).

The host configuration is an Intel i7-2635QM (4 cores + HT) with 4Gb RAM
running Linus's latest and only running standard system daemons. For KVM
I disabled EPT.
The guest configuration is a 64bit 4 core 4Gb RAM, running Linux 3.2
(debian) and only running the benchmark.

All results represent the mean of 5 runs, with time(1).

Dacapo without individual addr invvpid:
real   1m25.406s
user   4m59.315s
sys    1m25.406s

Dacapo with individual addr invvpid:
real   1m4.421s
user   3m47.150s
sys    0m1.592s

--

vanilla kernel build without individual addr invvpid:
real   16m42.571s
user   13m28.975s
sys    2m54.487s

vanilla kernel build with individual addr invvpid:
real   15m45.789s
user   12m25.691s
sys    2m44.806s

--

vanilla kernel build (-j8) without individual addr invvpid:
real   10m32.276s
user   33m47.687s
sys    5m37.725s

vanilla kernel build (-j8) with individual addr invvpid:
real   8m29.789s
user   28m12.850s
sys    4m34.353s


In all cases using individual address invalidation outperforms single
context ones regarding wall time. Comments?

[1] http://dacapobench.org/


Thanks,
Davidlohr

