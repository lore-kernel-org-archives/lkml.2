Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2ASOwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:52:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2ASOwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:52:17 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7NbQWiCA6LkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=4YwogqHhuDc9IwgOm4gA:9 a=JIzc0PVEWnAGq2cIOWQA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326984732.17534.122.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/2] jump labels: Add infrastructure to update jump
 labels at compile time
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Date: Thu, 19 Jan 2012 09:52:12 -0500
In-Reply-To: <20120119142419.GA32451@Krystal>
References: <20120118195340.767928915@goodmis.org>
	 <20120118195926.570504231@goodmis.org> <20120119142419.GA32451@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 09:24 -0500, Mathieu Desnoyers wrote:
> Hi Steven,
> 
> I really like this patchset! A few comments below,
> 
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Add the infrastructure to allow architectures to modify the jump label
> > locations at compile time. This is mainly for x86, where the jmps may
> 
> is it "at compile time" or "after compilation" ? AFAIU, this
> update_jump_label script gets executed on the .o, which makes it
> technically more part of the linking stage than the compilation
> stage.

We usually denote things as "at compile time" or "at run time" whether
it is the linker or not, we don't differentiate because it's not
important. The "at compile time" means, it happens once before you boot
the kernel, as suppose to, it happens every time your run the kernel.
That's the important part.


> 
> > be either 2 bytes or 5 bytes. Instead of wasting 5 bytes for all jump labels,
> > this code will let x86 put in a jmp instead of a 5 byte nop. Then the
> > assembler will make either a 2 byte or 5 byte jmp depending on where
> > the target is.
> > 
> > At compile time, this code will replace the jmps with either a 2 byte
> > or 5 byte nop depending on the size of the jmp that was added.
> > 
> 
> A small note somewhere saying that this 2 vs 5 bytes choice done by the
> compiler is a pessimistic approximation would be good, so people don't
> end up complaining if they see that the compiler chose a 5-byte nop for
> a 120 bytes offset.

Hmm, that really doesn't have anything to do with this patch. If someone
is anal enough to complain, then they can complain to the gcc people. As
it would do the same with other jmps not associated with jumplabels too.


> 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  Makefile                    |    7 +
> >  arch/Kconfig                |    6 +
> >  scripts/Makefile            |    1 +
> >  scripts/Makefile.build      |   15 ++-
> >  scripts/update_jump_label.c |  335 +++++++++++++++++++++++++++++++++++++++++++
> >  scripts/update_jump_label.h |  283 ++++++++++++++++++++++++++++++++++++
> >  6 files changed, 645 insertions(+), 2 deletions(-)
> >  create mode 100644 scripts/update_jump_label.c
> >  create mode 100644 scripts/update_jump_label.h
> > 
> [...]
> > diff --git a/scripts/update_jump_label.c b/scripts/update_jump_label.c
> > new file mode 100644
> > index 0000000..399d898
> > --- /dev/null
> > +++ b/scripts/update_jump_label.c
> > @@ -0,0 +1,335 @@
> > +/*
> > + * update_jump_label.c: replace jmps with nops at compile time.
> > + * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
> > + *  Parsing of the elf file was influenced by recordmcount.c
> > + *  originally written by and copyright to John F. Reiser <jreiser@BitWagon.com>.
> > + */
> > +
> > +/*
> > + * Note, this code is originally designed for x86, but may be used by
> > + * other archs to do the nop updates at compile time instead of at boot time.
> > + * X86 uses this as an optimization, as jmps can be either 2 bytes or 5 bytes.
> > + * Inserting a 2 byte where possible helps with both CPU performance and
> > + * icache strain.
> > + */
> > +#include <sys/types.h>
> > +#include <sys/mman.h>
> > +#include <sys/stat.h>
> > +#include <getopt.h>
> > +#include <elf.h>
> > +#include <fcntl.h>
> > +#include <setjmp.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <stdarg.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +
> > +static int fd_map;	/* File descriptor for file being modified. */
> > +static struct stat sb;	/* Remember .st_size, etc. */
> > +static int mmap_failed; /* Boolean flag. */
> > +
> > +static void die(const char *err, const char *fmt, ...)
> > +{
> > +	va_list ap;
> > +
> > +	if (err)
> > +		perror(err);
> > +
> > +	if (fmt) {
> > +		va_start(ap, fmt);
> > +		fprintf(stderr, "Fatal error:  ");
> > +		vfprintf(stderr, fmt, ap);
> > +		fprintf(stderr, "\n");
> > +		va_end(ap);
> > +	}
> > +
> > +	exit(1);
> > +}
> > +
> > +static void usage(char **argv)
> > +{
> > +	char *arg = argv[0];
> > +	char *p = arg+strlen(arg);
> 
> I'm pretty sure checkpatch will complain about the coding style of this
> file. I won't point out the various nits, but there is a need for
> cleanup before pulling it.

Yeah, this code was based off of the record_mcount.c file. I need to
clean that up too. And not just a trivial clean up, but a complete
overhaul. It's had a couple already. The guy who wrote the original code
use some really strange coding conventions and was really hard to read
and understand. I spent days cleaning it up to make it presentable for
Linux. I now know this code enough to make another pass at it and make
it a bit more readable.

I can fix this little thing up now.

> 
> > +
> > +	while (p >= arg && *p != '/')
> > +		p--;
> > +	p++;
> > +
> > +	printf("usage: %s file\n"
> > +	       "\n", p);
> > +	exit(-1);
> > +}
> 
> [...]
> 
> > +/*
> > + * Read the relocation table again, but this time its called on sections
> > + * that are not going to be traced. The mcount calls here will be converted
> 
> mcount calls -> jump labels

Hehe, like I said, this was based off of the record_mcount code. I did
state that in the original code. Thanks, I'll fix this too.

> 
> > + * into nops.
> > + */
> > +static void FUNC(nop_jump_label)(Elf_Shdr const *const relhdr,
> > +		       Elf_Ehdr const *const ehdr,
> > +		       const char *const txtname)
> > +{
> > +	Elf_Shdr *const shdr0 = get_shdr(ehdr);
> > +	Elf_Sym const *sym0;
> > +	char const *str0;
> > +	Elf_Rel const *relp;
> > +	Elf_Rela const *relap;
> > +	Elf_Shdr const *const shdr = &shdr0[w(relhdr->sh_info)];
> > +	unsigned rel_entsize = w(relhdr->sh_entsize);
> > +	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
> > +	int t;
> > +
> > +	FUNC(get_sym_str_and_relp)(relhdr, ehdr, &sym0, &str0, &relp);
> > +
> > +	for (t = nrel; t > 0; t -= 3) {
> > +		int ret = -1;
> > +
> > +		relap = (Elf_Rela const *)relp;
> > +		printf("rel offset=%lx info=%lx sym=%lx type=%lx addend=%lx\n",
> > +		       (long)relap->r_offset, (long)relap->r_info,
> > +		       (long)ELF_R_SYM(relap->r_info),
> > +		       (long)ELF_R_TYPE(relap->r_info),
> > +		       (long)relap->r_addend);
> > +
> > +		if (0 && make_nop)
> > +			ret = make_nop((void *)ehdr, shdr->sh_offset + relp->r_offset);
> 
> if (0 &&  -> leftover code ?
> 
> This whole FUNC(nop_jump_label) function seems to be unused.

Yeah, I still need to remove this crap. I posted this as an RFC to get
ideas before I ripped out all the debug (and crap). This was code that I
wasn't sure I would use. Yes, it will be removed before the final
version. I probably can nuke it now, as I'm now comfortable that this
will not be needed.

> 
> > +
> > +		/* jump label sections are paired in threes */
> > +		relp = (Elf_Rel const *)(rel_entsize * 3 + (void *)relp);
> > +	}
> > +}
> > +
> > +/* Find relocation section hdr for a given section */
> > +static const Elf_Shdr *
> > +FUNC(find_relhdr)(const Elf_Ehdr *ehdr, const Elf_Shdr *shdr)
> > +{
> > +	const Elf_Shdr *shdr0 = get_shdr(ehdr);
> > +	int nhdr = w2(ehdr->e_shnum);
> > +	const Elf_Shdr *hdr;
> > +	int i;
> > +
> > +	for (hdr = shdr0, i = 0; i < nhdr; hdr = &shdr0[++i]) {
> > +		if (w(hdr->sh_type) != SHT_REL &&
> > +		    w(hdr->sh_type) != SHT_RELA)
> > +			continue;
> > +
> > +		/*
> > +		 * The relocation section's info field holds
> > +		 * the section index that it represents.
> > +		 */
> > +		if (shdr == &shdr0[w(hdr->sh_info)])
> > +			return hdr;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +/* Find a section headr based on name and type */
> > +static const Elf_Shdr *
> > +FUNC(find_shdr)(const Elf_Ehdr *ehdr, const char *name, uint_t type)
> > +{
> > +	const Elf_Shdr *shdr0 = get_shdr(ehdr);
> > +	const Elf_Shdr *shstr = &shdr0[w2(ehdr->e_shstrndx)];
> > +	const char *shstrtab = (char *)get_section_loc(ehdr, shstr);
> > +	int nhdr = w2(ehdr->e_shnum);
> > +	const Elf_Shdr *hdr;
> > +	const char *hdrname;
> > +	int i;
> > +
> > +	for (hdr = shdr0, i = 0; i < nhdr; hdr = &shdr0[++i]) {
> > +		if (w(hdr->sh_type) != type)
> > +			continue;
> > +
> > +		/* If we are just looking for a section by type (ie. SYMTAB) */
> > +		if (!name)
> > +			return hdr;
> > +
> > +		hdrname = &shstrtab[w(hdr->sh_name)];
> > +		if (strcmp(hdrname, name) == 0)
> > +			return hdr;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static void
> > +FUNC(section_update)(const Elf_Ehdr *ehdr, const Elf_Shdr *symhdr,
> > +		     unsigned shtype, const Elf_Rel *rel, void *data)
> > +{
> > +	const Elf_Shdr *shdr0 = get_shdr(ehdr);
> > +	const Elf_Shdr *targethdr;
> > +	const Elf_Rela *rela;
> > +	const Elf_Sym *syment;
> > +	uint_t offset = _w(rel->r_offset);
> > +	uint_t info = _w(rel->r_info);
> > +	uint_t sym = ELF_R_SYM(info);
> > +	uint_t type = ELF_R_TYPE(info);
> > +	uint_t addend;
> > +	uint_t targetloc;
> > +
> > +	if (shtype == SHT_RELA) {
> > +		rela = (const Elf_Rela *)rel;
> > +		addend = _w(rela->r_addend);
> > +	} else
> > +		addend = _w(*(int *)(data + offset));
> > +
> > +	syment = (const Elf_Sym *)get_section_loc(ehdr, symhdr);
> > +	targethdr = &shdr0[w2(syment[sym].st_shndx)];
> > +	targetloc = _w(targethdr->sh_offset);
> > +
> > +	/* TODO, need a separate function for all archs */
> 
> maybe this is where you want to call FUNC(nop_jump_label) too ?

It would be where something similar goes, but not that function. I
should still nuke it.

> 
> > +	if (type != R_386_32)
> > +		die(NULL, "Arch relocation type %d not supported", type);
> > +
> > +	targetloc += addend;
> > +
> > +#if 0
> > +	printf("offset=%x target=%x shoffset=%x add=%x indx=%x\n",
> > +	       offset, targetloc, _w(targethdr->sh_offset), addend,
> > +	       targetloc - _w(targethdr->sh_offset));
> > +#endif

This obviously needs to be nuked too.

> > +	*(uint_t *)(data + offset) = targetloc;
> > +}
> > +
> > +/* Overall supervision for Elf32 ET_REL file. */
> > +static void
> > +FUNC(do_func)(Elf_Ehdr *ehdr, char const *const fname, unsigned const reltype)
> > +{
> > +	const Elf_Shdr *jlshdr;
> > +	const Elf_Shdr *jlrhdr;
> > +	const Elf_Shdr *symhdr;
> > +	const Elf_Rel *rel;
> > +	unsigned size;
> > +	unsigned cnt;
> > +	unsigned i;
> > +	uint_t type;
> > +	void *jdata;
> > +	void *data;
> > +
> > +	jlshdr = FUNC(find_shdr)(ehdr, "__jump_table", SHT_PROGBITS);
> > +	if (!jlshdr)
> > +		return;
> > +
> > +	jlrhdr = FUNC(find_relhdr)(ehdr, jlshdr);
> > +	if (!jlrhdr)
> > +		return;
> > +
> > +	/*
> > +	 * Create and fill in the __jump_table section and use it to
> > +	 * find the offsets into the text that we want to update.
> > +	 * We create it so that we do not depend on the order of the
> > +	 * relocations, and use the table directly, as it is broken
> > +	 * up into sections.
> > +	 */
> > +	size = _w(jlshdr->sh_size);
> > +	data = umalloc(size);
> > +
> > +	jdata = (void *)get_section_loc(ehdr, jlshdr);
> > +	memcpy(data, jdata, size);
> > +
> > +	cnt = _w(jlrhdr->sh_size) / w(jlrhdr->sh_entsize);
> > +
> > +	rel = (const Elf_Rel *)get_section_loc(ehdr, jlrhdr);
> > +
> > +	/* Is this as Rel or Rela? */
> > +	type = w(jlrhdr->sh_type);
> > +
> > +	symhdr = FUNC(find_shdr)(ehdr, NULL, SHT_SYMTAB);
> > +
> > +	for (i = 0; i < cnt; i++) {
> > +		FUNC(section_update)(ehdr, symhdr, type, rel, data);
> > +		rel = (void *)rel + w(jlrhdr->sh_entsize);
> > +	}
> > +
> > +	/*
> > +	 * This is specific to x86. The jump_table is stored in three
> > +	 * long words. The first is the location of the jmp target we
> > +	 * must update.
> > +	 */
> > +	cnt = size / sizeof(uint_t);
> > +
> > +	for (i = 0; i < cnt; i += 3)
> > +		make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));
> > +
> 
> Why is this function iterating twice on the __jump_table section rather
> than simply writing the nops in the first pass, within the
> section_update function ?

To simplify things. There's also no guarantee that the relocation table
is in order. It usually is, but I don't want to assume that. Thus I need
to first read the entire relocation table to find the locations of all
the jump labels, and fill in the locations as they would have been
linked. And after that is complete, then I can iterate over that section
and look at every third entry which is the jump label location.

-- Steve



