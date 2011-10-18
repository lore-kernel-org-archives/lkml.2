Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1JRG4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:56:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab1JRG4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:56:38 -0400
Date: Tue, 18 Oct 2011 08:54:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov,
        yrl.pp-manager.tt@hitachi.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] x86: Add a sanity test of x86 decoder
Message-ID: <20111018065453.GL16304@elte.hu>
References: <20111012070601.GC18618@elte.hu>
 <20111013110127.28099.19162.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013110127.28099.19162.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Add a sanity test of x86 insn decoder against the random
> input. This test is also able to reproduce the bug by
> passing random-seed and iteration-number, or by passing
> input while which has invalid byte code.

Looks good in general.

a few nitpicking details:

> -posttest: $(obj)/test_get_len vmlinux
> +quiet_cmd_sanitytest = TEST    $@
> +      cmd_sanitytest = $(obj)/insn_sanity $(posttest_64bit) -m 1000000

Just curious, what's the execution time for this? I'd expect 
milliseconds, but there will also be urandom overhead.

> +#define unlikely(cond) (cond)
> +
> +#include <asm/insn.h>
> +#include <inat.c>
> +#include <insn.c>
> +
> +/*
> + * Test of instruction analysis against tampering.
> + * Feed random binary to instruction decoder and ensure not to
> + * access out-of-instruction-buffer.
> + */
> +
> +#define DEFAULT_MAX_ITER	10000
> +#define INSN_NOP 0x90
> +
> +static const char *prog;
> +static int verbose;
> +static int x86_64;
> +static unsigned int seed;
> +static unsigned long nr_iter;
> +static unsigned long max_iter = DEFAULT_MAX_ITER;
> +static char insn_buf[MAX_INSN_SIZE * 2];
> +static FILE *input_file;

This needs more comments and a bit more vertical structure.

> +static void dump_stream(FILE *fp, const char *msg, struct insn *insn)
> +{
> +	int i;
> +	fprintf(fp, "%s:\n code:", msg);

missing newline.

> +static int get_next_insn(void)
> +{
> +	char buf[256]  = "", *tmp;
> +	int i;
> +
> +	tmp = fgets(buf, 256, input_file);

ARRAY_SIZE().

> +	if (tmp == NULL || feof(input_file))
> +		return 0;
> +
> +	for (i = 0; i < MAX_INSN_SIZE; i++) {
> +		((unsigned char *)insn_buf)[i] = (unsigned char)strtoul(tmp, &tmp, 16);

why is this cast needed? Shouldnt insn_buf[] have this type if this 
is how it's used?

> +{
> +	int i;
> +	if (nr_iter >= max_iter)

missing newline.

> +	for (i = 0; i < MAX_INSN_SIZE; i += 2)
> +		*(unsigned short *)(&insn_buf[i]) = random() & 0xffff;

this silently assumes that MAX_INSN_SIZE is a multiple of 2. Which is 
true ... for now.

> +#define insn_complete(insn)	\
> +	(insn.opcode.got && insn.modrm.got && insn.sib.got && \
> +	 insn.displacement.got && insn.immediate.got)

This could move into insn.h (even though only user-space uses it), 
right?

> +	while (generate_random_insn()) {


this loop is really weird: half of it is hidden in 
generate_random_insn()'s use of nr_iter global variable!

Why not just do it in the old-fashioned way:

	for (i = 0; i < max_iter; i++) {
		...
	}

and keep generate_random_insn() loop-invariant?

> +		if (insn.next_byte <= insn.kaddr ||
> +		    insn.kaddr + MAX_INSN_SIZE < insn.next_byte) {
> +			/* Access out-of-range memory */
> +			dump_stream(stdout, "Find access violation", &insn);
> +			warnings++;

s/Find/Found ?

> +	if (warnings)
> +		fprintf(stdout, "Warning: decoded and checked %d insns with %d warnings (seed:0x%x)\n", insns, warnings, seed);
> +	else
> +		fprintf(stdout, "Succeed: decoded and checked %d insns (seed:0x%x)\n", insns, seed);

s/Succeed/Success ?

Also, s/insns/random instructions - there's rarely any good reason to 
abbreviate in human readable output.

Thanks,

	Ingo
