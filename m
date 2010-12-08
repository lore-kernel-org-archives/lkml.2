Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0LHL3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:29:07 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:59165 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LHL3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:29:05 -0500
MIME-Version: 1.0
In-Reply-To: <20101206175957.GD5926@ghostprotocols.net>
References: <1291656331-24706-1-git-send-email-dave.martin@linaro.org>
	<20101206175957.GD5926@ghostprotocols.net>
Date: Wed, 8 Dec 2010 11:29:04 +0000
Message-ID: <AANLkTin6Ei5F46FuoqX_mYpL_qd1wWcXVfAeW7Ym4yMZ@mail.gmail.com>
Subject: Re: [PATCH v4] perf symbols: fix symbol offset breakage with
 separated debug
From: Dave Martin <dave.martin@linaro.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <Will.Deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-- just letting you know I haven't forgotten about this -- thanks
for your reply.

I'll have to have a think about how best to rework this patch based on
your feedback, so it may take me a while to follow up.

Cheers
---Dave

On Mon, Dec 6, 2010 at 5:59 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Mon, Dec 06, 2010 at 05:25:31PM +0000, Dave Martin escreveu:
>> v4: remove assert() calls
>>
>>   * Simply removed the assert() to validate section indices
>>     returned by libelf: libelf should validate the ELF file
>>     anyway.
>
> Thanks for doing this!
>
>>   * Replaced the assert() on arguments to dso__load_sym
>>     with a run-time check.
>
> Ditto.
>
>> v3: Fixed a minor error in v2 where a check was erronueously
>> done twice.
>>
>> Original description follows:
>>
>> The new patch loads the ELF section headers from a separate
>> file if necessary, to avoid getting confused by the different
>> section file offsets seen in debug images.  Invalid section
>> headers are detected by checking for the presence of non-
>> writable SHT_NOBITS sections, which don't make sense under
>> normal circumstances.
>>
>> In particular, this allows symbols in ET_EXEC images to get
>> fixed up correctly in the presence of separated debug images.
>
> But this is getting complicated, could you please try to reduce
> complexity by breaking this patch in three?
>
> One that fixes this minor bug, another that fixes the fallback to
> .dynsym that misses the build-id cache and the other checking the NOBITS
> part?
>
> See more below.
>
>> The image search loop is also tidied up to fix a minor bug
>> which would perform the same image load attempt more than
>> once in some situations.
>
> Also this want_symtab ends up just getting to:
>
>        sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
>        if (sec == NULL) {
>                if (want_symtab)
>                        goto out_elf_end;
>
>                sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
>                if (sec == NULL)
>                        goto out_elf_end;
>        }
>
> Wouldn't be better to have:
>
>        sec = elf_section_by_name(elf, &ehdr, &shdr, symtab_name, NULL);
>        if (sec == NULL)
>                goto out_elf_end;
>
>
> Instead?
>
>> For non-separated images, the headers should get loaded from
>> the same image as the symbols, in the usual way.
>> ---
>> KernelVersion: 2.6.37-rc3
>>
>>  tools/perf/util/symbol.c |  188 +++++++++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 176 insertions(+), 12 deletions(-)
>>
>> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
>> index b39f499..7d8fd34 100644
>> --- a/tools/perf/util/symbol.c
>> +++ b/tools/perf/util/symbol.c
>> @@ -992,8 +992,105 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
>>       return -1;
>>  }
>>
>> +/**
>> + * Read all section headers, copying them into a separate array so they survive
>> + * elf_end.
>> + *
>> + * @elf: the libelf instance to operate on.
>> + * @ehdr: the elf header: this must already have been read with gelf_getehdr().
>> + * @count: the number of headers read is assigned to *count on successful
>> + *   return.  count must not be NULL.
>> + *
>> + * Returns a pointer to the allocated headers, which should be deallocated with
>> + * free() when no longer needed.
>> + */
>> +static GElf_Shdr *elf_get_all_shdrs(Elf *elf, GElf_Ehdr const *ehdr,
>> +                                 unsigned *count)
>> +{
>> +     GElf_Shdr *shdrs;
>> +     Elf_Scn *scn;
>> +     unsigned max_index = 0;
>> +     unsigned i;
>> +
>> +     shdrs = malloc(ehdr->e_shnum * sizeof *shdrs);
>> +     if (!shdrs)
>> +             return NULL;
>> +
>> +     for (i = 0; i < ehdr->e_shnum; i++)
>> +             shdrs[i].sh_type = SHT_NULL;
>> +
>> +     for (scn = NULL; (scn = elf_nextscn(elf, scn)); ) {
>> +             size_t j;
>> +
>> +             /*
>> +              * Just assuming we get section 0, 1, ... in sequence may lead
>> +              * to wrong section indices.  Check the index explicitly:
>> +              */
>> +             j = elf_ndxscn(scn);
>> +
>> +             if (j > max_index)
>> +                     max_index = j;
>> +
>> +             if (!gelf_getshdr(scn, &shdrs[j]))
>> +                     goto error;
>> +     }
>> +
>> +     *count = max_index + 1;
>> +     return shdrs;
>> +
>> +error:
>> +     free(shdrs);
>> +     return NULL;
>> +}
>> +
>> +/**
>> + * Check that the section headers @shdrs reflect accurately the file data
>> + * layout of the image that was loaded during perf record.  This is generally
>> + * not true for separated debug images generated with e.g.,
>> + * objcopy --only-keep-debug.
>> + *
>> + * We identify invalid files by checking for non-empty sections which are
>> + * declared as having no file data (SHT_NOBITS) but are not writable.
>> + *
>> + * @shdrs: the full set of section headers, as loaded by elf_get_all_shdrs().
>> + * @count: the number of headers present in @shdrs.
>> + *
>> + * Returns 1 for valid headers, 0 otherwise.
>> + */
>> +static int elf_check_shdrs_valid(GElf_Shdr const *shdrs, unsigned count)
>> +{
>> +     unsigned i;
>> +
>> +     for (i = 0; i < count; i++) {
>> +             if (shdrs[i].sh_type == SHT_NOBITS &&
>> +                 !(shdrs[i].sh_flags & SHF_WRITE) &&
>> +                 shdrs[i].sh_size != 0)
>> +                     return 0;
>> +     }
>> +
>> +     return 1;
>> +}
>> +
>> +/*
>> + * Notes:
>> + *
>> + * If saved_shdrs is non-NULL, the section headers will be read if found, and
>> + * will be used for address fixups.  saved_shdrs_count must also be non-NULL in
>> + * this case.  This may be needed for separated debug images, since the section
>> + * headers and symbols may need to come from separate images in that case.
>> + *
>> + * Note: irrespective of whether this function returns successfully,
>> + * *saved_shdrs may get initialised if saved_shdrs is non-NULL.  It is the
>> + * caller's responsibility to free() it when non longer needed.
>> + *
>> + * If want_symtab == 1, this function will only load symbols from .symtab
>> + * sections.  Otherwise (want_symtab == 0), .dynsym or .symtab symbols are
>> + * loaded.  This feature is used by dso__load() to search for the best image
>> + * to load.
>> + */
>>  static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>>                        int fd, symbol_filter_t filter, int kmodule,
>> +                      GElf_Shdr **saved_shdrs, unsigned *saved_shdrs_count,
>>                        int want_symtab)
>>  {
>>       struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
>> @@ -1012,6 +1109,17 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>>       int nr = 0;
>>       size_t opdidx = 0;
>>
>> +     if(saved_shdrs != NULL && saved_shdrs_count == NULL) {
>> +             /*
>> +              * If you trigger this check, you're calling this function
>> +              * incorrectly.  Refer to the notes above for details.
>> +              */
>> +             pr_debug("%s: warning: saved_shdrs_count == NULL: "
>> +                      "ignoring the saved section headers.\n",
>> +                      __func__);
>> +             saved_shdrs = NULL;
>> +     }
>> +
>>       elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>>       if (elf == NULL) {
>>               pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
>> @@ -1035,6 +1143,34 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>>                       goto out_elf_end;
>>       }
>>
>> +     /*
>> +      * Copy all section headers from the image if requested and if not
>> +      * already loaded.
>> +      */
>> +     if (saved_shdrs != NULL && *saved_shdrs == NULL) {
>> +             GElf_Shdr *shdrs;
>> +             unsigned count;
>> +
>> +             shdrs = elf_get_all_shdrs(elf, &ehdr, &count);
>> +             if (shdrs == NULL)
>> +                     goto out_elf_end;
>> +
>> +             /*
>> +              * Only keep the headers if they reflect the actual run-time
>> +              * image's file layout:
>> +              */
>> +             if (elf_check_shdrs_valid(shdrs, count)) {
>> +                     *saved_shdrs = shdrs;
>> +                     *saved_shdrs_count = count;
>> +             } else
>> +                     free(shdrs);
>> +     }
>> +
>> +     /* If no genuine ELF headers are available yet, give up: we can't
>> +      * adjust symbols correctly in that case: */
>> +     if (saved_shdrs != NULL && *saved_shdrs == NULL)
>> +             goto out_elf_end;
>> +
>>       sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
>>       if (sec == NULL) {
>>               if (want_symtab)
>> @@ -1167,12 +1303,25 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>>                       goto new_symbol;
>>               }
>>
>> +             /*
>> +              * Currently, symbols for shared objects and PIE executables
>> +              * (i.e., ET_DYN) do not seem to get adjusted.  This might need
>> +              * to change if file offset == virtual address is not actually
>> +              * guaranteed for these images.  ELF doesn't provide this
>> +              * guarantee natively.
>> +              */
>>               if (curr_dso->adjust_symbols) {
>>                       pr_debug4("%s: adjusting symbol: st_value: %#Lx "
>>                                 "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
>>                                 (u64)sym.st_value, (u64)shdr.sh_addr,
>>                                 (u64)shdr.sh_offset);
>> -                     sym.st_value -= shdr.sh_addr - shdr.sh_offset;
>> +                     if (saved_shdrs && *saved_shdrs &&
>> +                         sym.st_shndx < *saved_shdrs_count)
>> +                             sym.st_value -=
>> +                                     (*saved_shdrs)[sym.st_shndx].sh_addr -
>> +                                     (*saved_shdrs)[sym.st_shndx].sh_offset;
>> +                     else
>> +                             sym.st_value -= shdr.sh_addr - shdr.sh_offset;
>>               }
>>               /*
>>                * We need to figure out if the object was created from C++ sources
>> @@ -1409,6 +1558,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>       struct machine *machine;
>>       const char *root_dir;
>>       int want_symtab;
>> +     GElf_Shdr *saved_shdrs = NULL;
>> +     unsigned saved_shdrs_count;
>>
>>       dso__set_loaded(self, map->type);
>>
>> @@ -1439,13 +1590,13 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>        * On the first pass, only load images if they have a full symtab.
>>        * Failing that, do a second pass where we accept .dynsym also
>>        */
>> -     for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
>> -          self->origin != DSO__ORIG_NOT_FOUND;
>> -          self->origin++) {
>> +     self->origin = DSO__ORIG_BUILD_ID_CACHE;
>> +     want_symtab = 1;
>> +     while (1) {
>
> Doing it this way and then using the continue or continue_next fixes the
> bug where we don't use the build-id cache for a .dynsym, i.e. when we
> don't find a .symtab and restart the loop, but then, its a separate
> patch, please break it into another patch.
>
>>               switch (self->origin) {
>>               case DSO__ORIG_BUILD_ID_CACHE:
>>                       if (dso__build_id_filename(self, name, size) == NULL)
>> -                             continue;
>> +                             goto continue_next;
>>                       break;
>>               case DSO__ORIG_FEDORA:
>>                       snprintf(name, size, "/usr/lib/debug%s.debug",
>> @@ -1459,7 +1610,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>                       char build_id_hex[BUILD_ID_SIZE * 2 + 1];
>>
>>                       if (!self->has_build_id)
>> -                             continue;
>> +                             goto continue_next;
>>
>>                       build_id__sprintf(self->build_id,
>>                                         sizeof(self->build_id),
>> @@ -1483,21 +1634,24 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>               default:
>>                       /*
>>                        * If we wanted a full symtab but no image had one,
>> -                      * relax our requirements and repeat the search.
>> +                      * relax our requirements and repeat the search,
>> +                      * providing we saw some valid section headers:
>>                        */
>> -                     if (want_symtab) {
>> +                     if (want_symtab && saved_shdrs != NULL) {
>>                               want_symtab = 0;
>>                               self->origin = DSO__ORIG_BUILD_ID_CACHE;
>> -                     } else
>>                               continue;
>> +                     } else
>> +                             goto done;
>>               }
>>
>>               /* Name is now the name of the next image to try */
>>               fd = open(name, O_RDONLY);
>>               if (fd < 0)
>> -                     continue;
>> +                     goto continue_next;
>>
>>               ret = dso__load_sym(self, map, name, fd, filter, 0,
>> +                                 &saved_shdrs, &saved_shdrs_count,
>>                                   want_symtab);
>>               close(fd);
>>
>> @@ -1506,7 +1660,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>                * info!?!?
>>                */
>>               if (!ret)
>> -                     continue;
>> +                     goto continue_next;
>>
>>               if (ret > 0) {
>>                       int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
>> @@ -1514,9 +1668,18 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
>>                               ret += nr_plt;
>>                       break;
>>               }
>> +
>> +continue_next:
>> +             self->origin++;
>> +             continue;
>
> This continue at the end is not needed, right?
>
>>       }
>>
>> +done:
>>       free(name);
>> +
>> +     if (saved_shdrs)
>> +             free(saved_shdrs);
>
> No need to check, call free straight away.
>
>> +
>>       if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
>>               return 0;
>>       return ret;
>> @@ -1782,7 +1945,8 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
>>               return -1;
>>
>>       dso__set_loaded(self, map->type);
>> -     err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
>> +     err = dso__load_sym(self, map, vmlinux, fd, filter, 0,
>> +                         NULL, NULL, 0);
>>       close(fd);
>>
>>       if (err > 0)
>> --
>> 1.7.1
>
