Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1JSE3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:29:42 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42162 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab1JSE3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:29:40 -0400
X-AuditID: b753bd60-a14abba0000019f4-6f-4e9e52317e9d
X-AuditID: b753bd60-a14abba0000019f4-6f-4e9e52317e9d
Message-ID: <4E9E522C.9030505@hitachi.com>
Date: Wed, 19 Oct 2011 13:29:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov,
        yrl.pp-manager.tt@hitachi.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] x86: Add a sanity test of x86 decoder
References: <20111012070601.GC18618@elte.hu> <20111013110127.28099.19162.stgit@localhost.localdomain> <20111018065453.GL16304@elte.hu>
In-Reply-To: <20111018065453.GL16304@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/18 15:54), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Add a sanity test of x86 insn decoder against the random
>> input. This test is also able to reproduce the bug by
>> passing random-seed and iteration-number, or by passing
>> input while which has invalid byte code.
> 
> Looks good in general.
> 
> a few nitpicking details:

Thank you for the comments :)

> 
>> -posttest: $(obj)/test_get_len vmlinux
>> +quiet_cmd_sanitytest = TEST    $@
>> +      cmd_sanitytest = $(obj)/insn_sanity $(posttest_64bit) -m 1000000
> 
> Just curious, what's the execution time for this? I'd expect 
> milliseconds, but there will also be urandom overhead.

I measured it with time command.
---
Succeed: decoded and checked 1000000 insns (seed:0x73f2b3bb)

real    0m0.152s
user    0m0.149s
sys     0m0.002s
---

Here, you can see how long it takes. It actually refers /dev/urandom
just one time at start, so I guess there is no urandom overhead.

>> +#define unlikely(cond) (cond)
>> +
>> +#include <asm/insn.h>
>> +#include <inat.c>
>> +#include <insn.c>
>> +
>> +/*
>> + * Test of instruction analysis against tampering.
>> + * Feed random binary to instruction decoder and ensure not to
>> + * access out-of-instruction-buffer.
>> + */
>> +
>> +#define DEFAULT_MAX_ITER	10000
>> +#define INSN_NOP 0x90
>> +
>> +static const char *prog;
>> +static int verbose;
>> +static int x86_64;
>> +static unsigned int seed;
>> +static unsigned long nr_iter;
>> +static unsigned long max_iter = DEFAULT_MAX_ITER;
>> +static char insn_buf[MAX_INSN_SIZE * 2];
>> +static FILE *input_file;
> 
> This needs more comments and a bit more vertical structure.

OK.

>> +static void dump_stream(FILE *fp, const char *msg, struct insn *insn)
>> +{
>> +	int i;
>> +	fprintf(fp, "%s:\n code:", msg);
> 
> missing newline.

This prints a header of code sequence, so that we'll see a
message like below;

Error message:
code: 00 01 02 03 04 ...

>> +static int get_next_insn(void)
>> +{
>> +	char buf[256]  = "", *tmp;
>> +	int i;
>> +
>> +	tmp = fgets(buf, 256, input_file);
> 
> ARRAY_SIZE().

OK.

>> +	if (tmp == NULL || feof(input_file))
>> +		return 0;
>> +
>> +	for (i = 0; i < MAX_INSN_SIZE; i++) {
>> +		((unsigned char *)insn_buf)[i] = (unsigned char)strtoul(tmp, &tmp, 16);
> 
> why is this cast needed? Shouldnt insn_buf[] have this type if this 
> is how it's used?

Yes, the type of insn_buf can be changed.

> 
>> +{
>> +	int i;
>> +	if (nr_iter >= max_iter)
> 
> missing newline.
> 
>> +	for (i = 0; i < MAX_INSN_SIZE; i += 2)
>> +		*(unsigned short *)(&insn_buf[i]) = random() & 0xffff;
> 
> this silently assumes that MAX_INSN_SIZE is a multiple of 2. Which is 
> true ... for now.

Ah, right. OK, add a line to fill the last byte if needed.

>> +#define insn_complete(insn)	\
>> +	(insn.opcode.got && insn.modrm.got && insn.sib.got && \
>> +	 insn.displacement.got && insn.immediate.got)
> 
> This could move into insn.h (even though only user-space uses it), 
> right?

Right.

> 
>> +	while (generate_random_insn()) {
> 
> 
> this loop is really weird: half of it is hidden in 
> generate_random_insn()'s use of nr_iter global variable!
> 
> Why not just do it in the old-fashioned way:
> 
> 	for (i = 0; i < max_iter; i++) {
> 		...
> 	}
> 
> and keep generate_random_insn() loop-invariant?

OK, I'll change this.

> 
>> +		if (insn.next_byte <= insn.kaddr ||
>> +		    insn.kaddr + MAX_INSN_SIZE < insn.next_byte) {
>> +			/* Access out-of-range memory */
>> +			dump_stream(stdout, "Find access violation", &insn);
>> +			warnings++;
> 
> s/Find/Found ?
> 
>> +	if (warnings)
>> +		fprintf(stdout, "Warning: decoded and checked %d insns with %d warnings (seed:0x%x)\n", insns, warnings, seed);
>> +	else
>> +		fprintf(stdout, "Succeed: decoded and checked %d insns (seed:0x%x)\n", insns, seed);
> 
> s/Succeed/Success ?

Oops...

> Also, s/insns/random instructions - there's rarely any good reason to 
> abbreviate in human readable output.

Agreed.

Thank you!

> 
> Thanks,
> 
> 	Ingo


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
