Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2ASOY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:24:26 -0500
Received: from mail.openrapids.net ([64.15.138.104]:55520 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240Ab2ASOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:24:23 -0500
Date: Thu, 19 Jan 2012 09:24:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 1/2] jump labels: Add infrastructure to update jump
	labels at compile time
Message-ID: <20120119142419.GA32451@Krystal>
References: <20120118195340.767928915@goodmis.org> <20120118195926.570504231@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118195926.570504231@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:00:54 up 421 days, 19:03,  2 users,  load average: 0.02, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I really like this patchset! A few comments below,

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add the infrastructure to allow architectures to modify the jump label
> locations at compile time. This is mainly for x86, where the jmps may

is it "at compile time" or "after compilation" ? AFAIU, this
update_jump_label script gets executed on the .o, which makes it
technically more part of the linking stage than the compilation
stage.

> be either 2 bytes or 5 bytes. Instead of wasting 5 bytes for all jump labels,
> this code will let x86 put in a jmp instead of a 5 byte nop. Then the
> assembler will make either a 2 byte or 5 byte jmp depending on where
> the target is.
> 
> At compile time, this code will replace the jmps with either a 2 byte
> or 5 byte nop depending on the size of the jmp that was added.
> 

A small note somewhere saying that this 2 vs 5 bytes choice done by the
compiler is a pessimistic approximation would be good, so people don't
end up complaining if they see that the compiler chose a 5-byte nop for
a 120 bytes offset.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  Makefile                    |    7 +
>  arch/Kconfig                |    6 +
>  scripts/Makefile            |    1 +
>  scripts/Makefile.build      |   15 ++-
>  scripts/update_jump_label.c |  335 +++++++++++++++++++++++++++++++++++++++++++
>  scripts/update_jump_label.h |  283 ++++++++++++++++++++++++++++++++++++
>  6 files changed, 645 insertions(+), 2 deletions(-)
>  create mode 100644 scripts/update_jump_label.c
>  create mode 100644 scripts/update_jump_label.h
> 
[...]
> diff --git a/scripts/update_jump_label.c b/scripts/update_jump_label.c
> new file mode 100644
> index 0000000..399d898
> --- /dev/null
> +++ b/scripts/update_jump_label.c
> @@ -0,0 +1,335 @@
> +/*
> + * update_jump_label.c: replace jmps with nops at compile time.
> + * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
> + *  Parsing of the elf file was influenced by recordmcount.c
> + *  originally written by and copyright to John F. Reiser <jreiser@BitWagon.com>.
> + */
> +
> +/*
> + * Note, this code is originally designed for x86, but may be used by
> + * other archs to do the nop updates at compile time instead of at boot time.
> + * X86 uses this as an optimization, as jmps can be either 2 bytes or 5 bytes.
> + * Inserting a 2 byte where possible helps with both CPU performance and
> + * icache strain.
> + */
> +#include <sys/types.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <getopt.h>
> +#include <elf.h>
> +#include <fcntl.h>
> +#include <setjmp.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdarg.h>
> +#include <string.h>
> +#include <unistd.h>
> +
> +static int fd_map;	/* File descriptor for file being modified. */
> +static struct stat sb;	/* Remember .st_size, etc. */
> +static int mmap_failed; /* Boolean flag. */
> +
> +static void die(const char *err, const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	if (err)
> +		perror(err);
> +
> +	if (fmt) {
> +		va_start(ap, fmt);
> +		fprintf(stderr, "Fatal error:  ");
> +		vfprintf(stderr, fmt, ap);
> +		fprintf(stderr, "\n");
> +		va_end(ap);
> +	}
> +
> +	exit(1);
> +}
> +
> +static void usage(char **argv)
> +{
> +	char *arg = argv[0];
> +	char *p = arg+strlen(arg);

I'm pretty sure checkpatch will complain about the coding style of this
file. I won't point out the various nits, but there is a need for
cleanup before pulling it.

> +
> +	while (p >= arg && *p != '/')
> +		p--;
> +	p++;
> +
> +	printf("usage: %s file\n"
> +	       "\n", p);
> +	exit(-1);
> +}

[...]

> +/*
> + * Read the relocation table again, but this time its called on sections
> + * that are not going to be traced. The mcount calls here will be converted

mcount calls -> jump labels

> + * into nops.
> + */
> +static void FUNC(nop_jump_label)(Elf_Shdr const *const relhdr,
> +		       Elf_Ehdr const *const ehdr,
> +		       const char *const txtname)
> +{
> +	Elf_Shdr *const shdr0 = get_shdr(ehdr);
> +	Elf_Sym const *sym0;
> +	char const *str0;
> +	Elf_Rel const *relp;
> +	Elf_Rela const *relap;
> +	Elf_Shdr const *const shdr = &shdr0[w(relhdr->sh_info)];
> +	unsigned rel_entsize = w(relhdr->sh_entsize);
> +	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
> +	int t;
> +
> +	FUNC(get_sym_str_and_relp)(relhdr, ehdr, &sym0, &str0, &relp);
> +
> +	for (t = nrel; t > 0; t -= 3) {
> +		int ret = -1;
> +
> +		relap = (Elf_Rela const *)relp;
> +		printf("rel offset=%lx info=%lx sym=%lx type=%lx addend=%lx\n",
> +		       (long)relap->r_offset, (long)relap->r_info,
> +		       (long)ELF_R_SYM(relap->r_info),
> +		       (long)ELF_R_TYPE(relap->r_info),
> +		       (long)relap->r_addend);
> +
> +		if (0 && make_nop)
> +			ret = make_nop((void *)ehdr, shdr->sh_offset + relp->r_offset);

if (0 &&  -> leftover code ?

This whole FUNC(nop_jump_label) function seems to be unused.

> +
> +		/* jump label sections are paired in threes */
> +		relp = (Elf_Rel const *)(rel_entsize * 3 + (void *)relp);
> +	}
> +}
> +
> +/* Find relocation section hdr for a given section */
> +static const Elf_Shdr *
> +FUNC(find_relhdr)(const Elf_Ehdr *ehdr, const Elf_Shdr *shdr)
> +{
> +	const Elf_Shdr *shdr0 = get_shdr(ehdr);
> +	int nhdr = w2(ehdr->e_shnum);
> +	const Elf_Shdr *hdr;
> +	int i;
> +
> +	for (hdr = shdr0, i = 0; i < nhdr; hdr = &shdr0[++i]) {
> +		if (w(hdr->sh_type) != SHT_REL &&
> +		    w(hdr->sh_type) != SHT_RELA)
> +			continue;
> +
> +		/*
> +		 * The relocation section's info field holds
> +		 * the section index that it represents.
> +		 */
> +		if (shdr == &shdr0[w(hdr->sh_info)])
> +			return hdr;
> +	}
> +	return NULL;
> +}
> +
> +/* Find a section headr based on name and type */
> +static const Elf_Shdr *
> +FUNC(find_shdr)(const Elf_Ehdr *ehdr, const char *name, uint_t type)
> +{
> +	const Elf_Shdr *shdr0 = get_shdr(ehdr);
> +	const Elf_Shdr *shstr = &shdr0[w2(ehdr->e_shstrndx)];
> +	const char *shstrtab = (char *)get_section_loc(ehdr, shstr);
> +	int nhdr = w2(ehdr->e_shnum);
> +	const Elf_Shdr *hdr;
> +	const char *hdrname;
> +	int i;
> +
> +	for (hdr = shdr0, i = 0; i < nhdr; hdr = &shdr0[++i]) {
> +		if (w(hdr->sh_type) != type)
> +			continue;
> +
> +		/* If we are just looking for a section by type (ie. SYMTAB) */
> +		if (!name)
> +			return hdr;
> +
> +		hdrname = &shstrtab[w(hdr->sh_name)];
> +		if (strcmp(hdrname, name) == 0)
> +			return hdr;
> +	}
> +	return NULL;
> +}
> +
> +static void
> +FUNC(section_update)(const Elf_Ehdr *ehdr, const Elf_Shdr *symhdr,
> +		     unsigned shtype, const Elf_Rel *rel, void *data)
> +{
> +	const Elf_Shdr *shdr0 = get_shdr(ehdr);
> +	const Elf_Shdr *targethdr;
> +	const Elf_Rela *rela;
> +	const Elf_Sym *syment;
> +	uint_t offset = _w(rel->r_offset);
> +	uint_t info = _w(rel->r_info);
> +	uint_t sym = ELF_R_SYM(info);
> +	uint_t type = ELF_R_TYPE(info);
> +	uint_t addend;
> +	uint_t targetloc;
> +
> +	if (shtype == SHT_RELA) {
> +		rela = (const Elf_Rela *)rel;
> +		addend = _w(rela->r_addend);
> +	} else
> +		addend = _w(*(int *)(data + offset));
> +
> +	syment = (const Elf_Sym *)get_section_loc(ehdr, symhdr);
> +	targethdr = &shdr0[w2(syment[sym].st_shndx)];
> +	targetloc = _w(targethdr->sh_offset);
> +
> +	/* TODO, need a separate function for all archs */

maybe this is where you want to call FUNC(nop_jump_label) too ?

> +	if (type != R_386_32)
> +		die(NULL, "Arch relocation type %d not supported", type);
> +
> +	targetloc += addend;
> +
> +#if 0
> +	printf("offset=%x target=%x shoffset=%x add=%x indx=%x\n",
> +	       offset, targetloc, _w(targethdr->sh_offset), addend,
> +	       targetloc - _w(targethdr->sh_offset));
> +#endif
> +	*(uint_t *)(data + offset) = targetloc;
> +}
> +
> +/* Overall supervision for Elf32 ET_REL file. */
> +static void
> +FUNC(do_func)(Elf_Ehdr *ehdr, char const *const fname, unsigned const reltype)
> +{
> +	const Elf_Shdr *jlshdr;
> +	const Elf_Shdr *jlrhdr;
> +	const Elf_Shdr *symhdr;
> +	const Elf_Rel *rel;
> +	unsigned size;
> +	unsigned cnt;
> +	unsigned i;
> +	uint_t type;
> +	void *jdata;
> +	void *data;
> +
> +	jlshdr = FUNC(find_shdr)(ehdr, "__jump_table", SHT_PROGBITS);
> +	if (!jlshdr)
> +		return;
> +
> +	jlrhdr = FUNC(find_relhdr)(ehdr, jlshdr);
> +	if (!jlrhdr)
> +		return;
> +
> +	/*
> +	 * Create and fill in the __jump_table section and use it to
> +	 * find the offsets into the text that we want to update.
> +	 * We create it so that we do not depend on the order of the
> +	 * relocations, and use the table directly, as it is broken
> +	 * up into sections.
> +	 */
> +	size = _w(jlshdr->sh_size);
> +	data = umalloc(size);
> +
> +	jdata = (void *)get_section_loc(ehdr, jlshdr);
> +	memcpy(data, jdata, size);
> +
> +	cnt = _w(jlrhdr->sh_size) / w(jlrhdr->sh_entsize);
> +
> +	rel = (const Elf_Rel *)get_section_loc(ehdr, jlrhdr);
> +
> +	/* Is this as Rel or Rela? */
> +	type = w(jlrhdr->sh_type);
> +
> +	symhdr = FUNC(find_shdr)(ehdr, NULL, SHT_SYMTAB);
> +
> +	for (i = 0; i < cnt; i++) {
> +		FUNC(section_update)(ehdr, symhdr, type, rel, data);
> +		rel = (void *)rel + w(jlrhdr->sh_entsize);
> +	}
> +
> +	/*
> +	 * This is specific to x86. The jump_table is stored in three
> +	 * long words. The first is the location of the jmp target we
> +	 * must update.
> +	 */
> +	cnt = size / sizeof(uint_t);
> +
> +	for (i = 0; i < cnt; i += 3)
> +		make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));
> +

Why is this function iterating twice on the __jump_table section rather
than simply writing the nops in the first pass, within the
section_update function ?

Thanks,

Mathieu


> +	free(data);
> +}
> -- 
> 1.7.8.3
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
