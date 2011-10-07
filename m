Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab1JGKtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:49:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11970 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1JGKts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:49:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=e7xe6qhhW8MHHWAM1mDPsrF5Vbxr0VbgneShi2CgDp1mfvJppSSCr8iKFUUHlMFTT
	13Eys6bCPiwGIGCd4YoZQ==
MIME-Version: 1.0
In-Reply-To: <1317984122.31132.6.camel@twins>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-8-git-send-email-eranian@google.com>
	<20111006153229.GJ14482@one.firstfloor.org>
	<CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
	<CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
	<1317984122.31132.6.camel@twins>
Date: Fri, 7 Oct 2011 12:49:44 +0200
Message-ID: <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 12:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-10-07 at 12:40 +0200, Stephane Eranian wrote:
>> On Fri, Oct 7, 2011 at 12:38 PM, Stephane Eranian <eranian@google.com> wrote:
>> > On Thu, Oct 6, 2011 at 5:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >>> +     kernel_insn_init(&insn, kaddr);
>> >>> +     insn_get_opcode(&insn);
>> >>
>> >> This makes me uncomfortable. AFAIK that's the first use of the opcode
>> >> decoder being used directly for user space. It has a quite large attack
>> >> surface. Who says it cannot be exploited?
>> >>
>> > This is not new, it's already used for the PEBS fixups and that includes
>> > user level fixups, if possible.
>> >
>> > We are not executing the instruction here, just decoding it to filter it out
>> > from a buffer if necessary.
>> >
>> I would add that in this particular usage, the source address is coming
>> straight from LBR, it's not made up my SW. That means it corresponds
>> to a point where there was a control flow change. But it can certainly
>> be any x86 opcode (not just branches). LBR captures control flow changes
>> due to traps, faults, interrupts.
>
> You could still fuzz it after the cpu passed through and before the
> kernel reads the LBR. Its a narrow window, but quite feasible.
>
Yeah, depending on the depth of the LBR. But then what happens, you
decode an instruction that is not what was executed. In this scenario,
either that new instruction matches the user LBR filter or it does not.
In the latter situation, the LBR record is not copied into the sampling
buffer. In the former case, it is included and all you've done is generate
a false profile. I think this can happen even without being malicious but
just with self-modifying (JIT) code, though the depth of LBR is such that
this is very unlikely (it must happen in the last 16 branches before the
PMU interrupt).
