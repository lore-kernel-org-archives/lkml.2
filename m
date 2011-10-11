Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1JKM7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:59:42 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39176 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1JKM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:59:41 -0400
X-AuditID: b753bd60-9e4a1ba000005c89-20-4e943dbae7ba
X-AuditID: b753bd60-9e4a1ba000005c89-20-4e943dbae7ba
Message-ID: <4E943DB4.1070400@hitachi.com>
Date: Tue, 11 Oct 2011 21:59:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
References: <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com> <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com> <1317984122.31132.6.camel@twins> <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com> <1317986519.31132.13.camel@twins> <4E8EE885.9040703@hitachi.com> <20111010060927.GG32173@elte.hu> <4E92FBAD.3000108@hitachi.com> <20111010144538.GZ14482@one.firstfloor.org>
In-Reply-To: <20111010144538.GZ14482@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/10 23:45), Andi Kleen wrote:
>> Ah, nice. Maybe we need another test binary, since current one is
>> just ensuring the output of objdump and decoder is same.
>> anyway it's not so difficult if it feeds random binaries to
>> ensure the decoder doesn't access bad address.
> 
> Pure /dev/urandom is not good because it cannot be ever reproduced.
> Better use a PRNG with random seed from urandom, but print the seed.

Sure,

> In addition to random I would do fuzzing: take an existing stream
> and just corrupt some bits and groups of bits. This will exercise different 
> paths.  In fact fuzzing is probably better than random for most tests.
> 
> Not sure it's needed to run on every build though, just checks
> now and then should be sufficient.

I made a test for that, and I didn't hit any random
bytes which can not be decoded after I've tested 100,000,000.
(with previous hardening patch)

since the number of the combination is 2^128 (MAX_INSN_SIZE is 16),
too huge to check all of them. Of course, the real number of
possible combination should be smaller than that.

- Because this decoder don't evaluate but just decode,
 we can skip immediates and operands.
- If we hit the non-oprand opcode, mod/rm, sib, or displacement
 in the middle of byte stream, we can stop trying decode tail bytes.

So I think there is smarter way to cover all possible combination
for the decoder than feeding random bytes.

Anyway, the decoder code can evolve in the future, I think it
should be put into the linux kernel.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
