Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1LIJBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:01:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:40704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1LIJBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:01:21 -0500
Message-ID: <1323421218.17673.37.camel@twins>
Subject: Re: [PATCH 09/12] perf_events: add hook to flush branch_stack on
 context switch (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Fri, 09 Dec 2011 10:00:18 +0100
In-Reply-To: <CABPqkBTw2c=EXRzcnfmR9RjYXNcRVkOB1BzmsF==rd=mp-QXgA@mail.gmail.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-10-git-send-email-eranian@google.com>
	 <1323121074.32012.40.camel@twins>
	 <CABPqkBT=XrbyLLzxUf7KKwk4MGcSVq-b0DtDQL1cgg1z1b0UpQ@mail.gmail.com>
	 <1323341376.17673.10.camel@twins>
	 <CABPqkBTJ1M0Hpm-VHXGSSOtLHFQWuuo7AnaJzwEQ9a4WD8YFbw@mail.gmail.com>
	 <1323368035.17673.20.camel@twins>
	 <CABPqkBTw2c=EXRzcnfmR9RjYXNcRVkOB1BzmsF==rd=mp-QXgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 14:06 -0800, Stephane Eranian wrote:
> > That's not regardless of the TOS. If the TOS was a full u64 you wouldn't
> > need the TID (which would be good, since the hardware has no such
> > concept).
> >
> Maybe I missed the trick but I don't quite see how a 64-bit TOS would
> solve the TID
> problem. It's not about the wraparound issue, i.e., not like the
> sampling buffer indexes.
> Could you describe the trick again? 

LBR 0
.
.
.        <-- TOS % n
.
LBR n-1


So the LBR is an array of n entries which is written to in a cyclic
fashion. The Top-Of-Stack or TOS indicates the last written entry and we
can read n entries backwards from there.

Something like:

  tos = rdmsr(lbr_tos);
  for (i = 0; i < n; i++) {
	idx = (tos - i) % n;

	from = rdmsr(lbr_from + idx);
	to   = rdmsr(lbr_to   + idx);
  }

Now the hardware keeps (TOS % n) by limiting the bits in the counter (n
= 2^m etc..), if it wouldn't do that, we could sample the TOS on ctxsw
and modify the read to:

  tos = rdmsr(lbr_tos)
  for (i = 0; i < n && (tos - i) > ctxsw_tos; i++) {
	idx = (tos - i) % n;

	...
  }

This would ensure we never read back past the context-switch. But we
need the extra bits for this to work, since with the current limited
(TOS % n) bits we get into trouble as soon as the ctxsw was more than n
branches ago (which is something very likely).

[ With 16 bits we'd get into trouble when the ctxsw was 65536 branch
ago, which is still quite possible, at 32 bits we'd need 4G branches,
which is rather unlikely, with 64 bits the sun will have died or so.. ]

Also note we can make this extra condition conditional on the event
being a task event, so that the cpu events always consume all n entries.


