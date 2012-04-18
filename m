Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab2DRGvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:51:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52389 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2DRGvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:51:43 -0400
Date: Wed, 18 Apr 2012 08:51:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com
Subject: Re: [RFCv2 00/15] perf: Add backtrace post dwarf unwind
Message-ID: <20120418065134.GA25568@somewhere>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 01:17:05PM +0200, Jiri Olsa wrote:
> hi,
> sending another RFC version. There are some fixies and some
> yet unresolved issues outlined below.
> 
> thanks for comments,
> jirka
> 
> v2 changes:
> 	02/16 - fixed register enums
> 	12/16 - fixed the perf_evlist__* names
> 	14/16 - 'fp' stays default even if compiled with dwarf unwind
> 	15/16 - added cache to the DSO data interface, it makes the
>                 dwarf unwind real fast now
> 
> v2 not solved yet:
>   1) generic user regs capturing
>      discussed in here:
>        http://marc.info/?l=linux-kernel&m=133304076114629&w=2
> 
>      Looks like we could have a generic way of getting registers
>      on samples and support more than only user level registers.
>      But looks like it wasn't completely decided what register
>      levels are worth to store..

Right but I think this is outside the scope of this patchset.
Especially without a proper usecase in tools, we can only do
mistakes by implementing early support for other kind of regs dump in
samples.

> 
>      It looks to me that each level could add its own registers
>      mask and it'd be used/saved if the mask is non zero.
>      The same way the user level regs are dealt with now ;).
> 
>      Or we could add something that Stephane came up with:
>        attr->sample_type |= PERF_SAMPLE_REGS
>        attr->sample_regs = EAX | EBX | EDI | ESI |.....
>        attr->sample_reg_mode = { INTR, PRECISE, USER }

If we do this we won't be able to record user regs and, say, precise regs
at the same time. These should be different sample types that can be set
at the same time: PERF_SAMPLE_UREGS | PERF_SAMPLE_PRECISE_REGS | ...

And then have attr->sample_uregs, attr->sample_pregs, ...

This is scary because I fear we'll need to increase the size of attr
and the ABI is then going to become incompatible. We'll probably need a way
to extend properly.

Anyway, no need to implement support for regs samples (other than user) in
this patchset. But we indeed need to make plans such that the ABI is ready to
host that later.

> 
>      But I guess we need to decide what levels make sense
>      to store first. Also if there's like 2 or 3 only, it might be
>      better to use separate masks as pointed out above.
> 
>   2) compat task handling
>      we dont handle compat tasks unwinding currently, we probably want
>      to make it part of the 1) solution or add something like:
> 	__u64 user_regs_compat;

Yep. One question I have for those who know well architectures support
in general is: do we have some archs that support more than just one
kind of compat/emulated mode?

If so I think we can't rely on that native/compat dichotomy but rather
we need to treat all these modes as different architectures.

In this case, attr->sample_regs would only make sense with some arch ID.

Anybody, more clues on this?

> 
>      Handling the compat task would also need some other changes in the
>      unwind code and I'm not completely sure how libunwind deals with that,
>      need to check.

Indeed.

> 
>      How much do we want this? ;)

I think we do. But there is no emergency. We can do it incrementally once
we have native support. But then again I think we need to ensure we got the
things right to make the ABI able to host that in the future.

> 
>   3) registers version names
>      this one is now probably connected to 1) and 2) ;)
>      I kept the register version, since I think it might be usefull
>      for dealing with compat tasks - to recognize what type of registers
>      were stored

Right. Hm, I need to look at this deeper.

Thanks!
