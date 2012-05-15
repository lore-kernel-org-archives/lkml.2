Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2EOJxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:53:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38994 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2EOJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:52:59 -0400
MIME-Version: 1.0
In-Reply-To: <1337073529.27694.8.camel@twins>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	<1337072138-8323-7-git-send-email-alex.shi@intel.com>
	<CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	<1337073529.27694.8.camel@twins>
Date: Tue, 15 May 2012 19:52:58 +1000
Message-ID: <CAPa8GCBaQhksvVT9DAgwzPPkCMrhcYnSdCtUHEe=cQS8_Cm7DQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Nick Piggin <npiggin@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2012 19:18, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-05-15 at 19:15 +1000, Nick Piggin wrote:
>> So this should go to linux-arch...
>>
>> On 15 May 2012 18:55, Alex Shi <alex.shi@intel.com> wrote:
>> > Not every flush_tlb_mm execution moment is really need to evacuate all
>> > TLB entries, like in munmap, just few 'invlpg' is better for whole
>> > process performance, since it leaves most of TLB entries for later
>> > accessing.
>> >
>> > This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start, end)
>> > in cases.
>>
>> What happened with Peter's comment about using flush_tlb_range for this?
>>
>> flush_tlb_mm() API should just stay unchanged AFAIKS.
>>
>> Then you need to work out the best way to give range info to the tlb/mmu gather
>> API. Possibly passing in the rage for that guy is OK, which x86 can
>> then implement
>> as flush range.
>
> Right, most archs that have tlb_flush_range() do range tracking in
> mmu_gather. Our TLB ops fully support that, there's absolutely no need
> to go change the interface for thos.

It could be warranted to change tlb_flush_mmu to a range API to
avoid doing the per-entry tracking which those architectures do?

The callers have range available easily, so ignoring those could be
noop for generic helpers.
