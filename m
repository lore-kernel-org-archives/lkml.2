Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0DTRQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0DTRQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:16:46 -0400
Message-ID: <4BCDD7D5.7080404@redhat.com>
Date: Tue, 20 Apr 2010 12:35:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ian Munsie <imunsie@au1.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       benh@kernel.crashing.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v4 2/2] perf probe: Add PowerPC DWARF register number
 mappings
References: <1271746713-8347-1-git-send-email-imunsie@au1.ibm.com> <1271746713-8347-2-git-send-email-imunsie@au1.ibm.com> <1271746713-8347-3-git-send-email-imunsie@au1.ibm.com>
In-Reply-To: <1271746713-8347-3-git-send-email-imunsie@au1.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Munsie wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> This patch adds mappings from the register numbers from DWARF to the
> register names used in the PowerPC Regs and Stack Access API. This
> allows perf probe to be used to record variable contents on PowerPC.
> 
> This patch depends on functionality in the powerpc/next tree, though it
> will compile fine without it. Specifically this patch depends on commit
> "powerpc: Add kprobe-based event tracer"
> 
> Signed-off-by: Ian Munsie <imunsie@au.ibm.com>


Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
> Changes since v3:
> * Fix NO_DWARF build

Nice catch!

> 
>  tools/perf/arch/powerpc/Makefile          |    4 +
>  tools/perf/arch/powerpc/util/dwarf-regs.c |   88 +++++++++++++++++++++++++++++
>  2 files changed, 92 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/arch/powerpc/Makefile
>  create mode 100644 tools/perf/arch/powerpc/util/dwarf-regs.c
> 
> diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
> new file mode 100644
> index 0000000..15130b5
> --- /dev/null
> +++ b/tools/perf/arch/powerpc/Makefile
> @@ -0,0 +1,4 @@
> +ifndef NO_DWARF
> +PERF_HAVE_DWARF_REGS := 1
> +LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
> +endif
> diff --git a/tools/perf/arch/powerpc/util/dwarf-regs.c b/tools/perf/arch/powerpc/util/dwarf-regs.c
> new file mode 100644
> index 0000000..48ae0c5
> --- /dev/null
> +++ b/tools/perf/arch/powerpc/util/dwarf-regs.c
> @@ -0,0 +1,88 @@
> +/*
> + * Mapping of DWARF debug register numbers into register names.
> + *
> + * Copyright (C) 2010 Ian Munsie, IBM Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#include <libio.h>
> +#include <dwarf-regs.h>
> +
> +
> +struct pt_regs_dwarfnum {
> +	const char *name;
> +	unsigned int dwarfnum;
> +};
> +
> +#define STR(s) #s
> +#define REG_DWARFNUM_NAME(r, num) {.name = r, .dwarfnum = num}
> +#define GPR_DWARFNUM_NAME(num)	\
> +	{.name = STR(%gpr##num), .dwarfnum = num}
> +#define REG_DWARFNUM_END {.name = NULL, .dwarfnum = 0}
> +
> +/*
> + * Reference:
> + * http://refspecs.linuxfoundation.org/ELF/ppc64/PPC-elf64abi-1.9.html
> + */
> +static const struct pt_regs_dwarfnum regdwarfnum_table[] = {
> +	GPR_DWARFNUM_NAME(0),
> +	GPR_DWARFNUM_NAME(1),
> +	GPR_DWARFNUM_NAME(2),
> +	GPR_DWARFNUM_NAME(3),
> +	GPR_DWARFNUM_NAME(4),
> +	GPR_DWARFNUM_NAME(5),
> +	GPR_DWARFNUM_NAME(6),
> +	GPR_DWARFNUM_NAME(7),
> +	GPR_DWARFNUM_NAME(8),
> +	GPR_DWARFNUM_NAME(9),
> +	GPR_DWARFNUM_NAME(10),
> +	GPR_DWARFNUM_NAME(11),
> +	GPR_DWARFNUM_NAME(12),
> +	GPR_DWARFNUM_NAME(13),
> +	GPR_DWARFNUM_NAME(14),
> +	GPR_DWARFNUM_NAME(15),
> +	GPR_DWARFNUM_NAME(16),
> +	GPR_DWARFNUM_NAME(17),
> +	GPR_DWARFNUM_NAME(18),
> +	GPR_DWARFNUM_NAME(19),
> +	GPR_DWARFNUM_NAME(20),
> +	GPR_DWARFNUM_NAME(21),
> +	GPR_DWARFNUM_NAME(22),
> +	GPR_DWARFNUM_NAME(23),
> +	GPR_DWARFNUM_NAME(24),
> +	GPR_DWARFNUM_NAME(25),
> +	GPR_DWARFNUM_NAME(26),
> +	GPR_DWARFNUM_NAME(27),
> +	GPR_DWARFNUM_NAME(28),
> +	GPR_DWARFNUM_NAME(29),
> +	GPR_DWARFNUM_NAME(30),
> +	GPR_DWARFNUM_NAME(31),
> +	REG_DWARFNUM_NAME("%msr",   66),
> +	REG_DWARFNUM_NAME("%ctr",   109),
> +	REG_DWARFNUM_NAME("%link",  108),
> +	REG_DWARFNUM_NAME("%xer",   101),
> +	REG_DWARFNUM_NAME("%dar",   119),
> +	REG_DWARFNUM_NAME("%dsisr", 118),
> +	REG_DWARFNUM_END,
> +};
> +
> +/**
> + * get_arch_regstr() - lookup register name from it's DWARF register number
> + * @n:	the DWARF register number
> + *
> + * get_arch_regstr() returns the name of the register in struct
> + * regdwarfnum_table from it's DWARF register number. If the register is not
> + * found in the table, this returns NULL;
> + */
> +const char *get_arch_regstr(unsigned int n)
> +{
> +	const struct pt_regs_dwarfnum *roff;
> +	for (roff = regdwarfnum_table; roff->name != NULL; roff++)
> +		if (roff->dwarfnum == n)
> +			return roff->name;
> +	return NULL;
> +}

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
