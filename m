Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2IFIFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2IFIFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:05:44 -0400
Message-ID: <50485954.50204@redhat.com>
Date: Thu, 06 Sep 2012 11:05:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: dave@gnu.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: invalidate vpid for invlpg instruction
References: <1346429448.2823.1.camel@offbook>  <20120831173707.GA3895@amt.cnet> <1346628440.3170.3.camel@offbook>  <50447442.2050307@redhat.com> <1346882061.6304.17.camel@offbook>
In-Reply-To: <1346882061.6304.17.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 12:54 AM, Davidlohr Bueso wrote:
> On Mon, 2012-09-03 at 12:11 +0300, Avi Kivity wrote:
>> On 09/03/2012 02:27 AM, Davidlohr Bueso wrote:
>> > On Fri, 2012-08-31 at 14:37 -0300, Marcelo Tosatti wrote:
>> >> On Fri, Aug 31, 2012 at 06:10:48PM +0200, Davidlohr Bueso wrote:
>> >> > For processors that support VPIDs we should invalidate the page table entry
>> >> > specified by the lineal address. For this purpose add support for individual
>> >> > address invalidations.
>> >> 
>> >> Not necessary - a single context invalidation is performed through
>> >> KVM_REQ_TLB_FLUSH.
>> > 
>> > Since vpid_sync_context() supports both single and all-context vpid
>> > invalidations, wouldn't it make sense to also add individual address
>> > ones as well, supporting further granularity?
>> 
>> It might.  Do you have benchmarks supporting this?
>> 
> 
> I ran two benchmarks: Java Dacapo[1] Sunflow (renders a set of images
> using ray tracing) and a vanilla 3.2 kernel build (with 1 job and -j8).
> 
> The host configuration is an Intel i7-2635QM (4 cores + HT) with 4Gb RAM
> running Linus's latest and only running standard system daemons. For KVM
> I disabled EPT.

That's not very interesting.  In all real machines, if you have VPID you
also have EPT.  Intel are unlikely to produce a processor without EPT.

> The guest configuration is a 64bit 4 core 4Gb RAM, running Linux 3.2
> (debian) and only running the benchmark.
> 
> All results represent the mean of 5 runs, with time(1).

The results are impressive, but lack real-world relevance.
Individual-address invalidation isn't very useful with EPT, since we let
the guest issue INVLPG itself and otherwise don't bother with guest page
tables.

Individual-address INVEPT would probably be more useful, but there is no
such instruction variant.

-- 
error compiling committee.c: too many arguments to function
