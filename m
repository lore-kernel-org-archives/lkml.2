Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1LKNT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 08:19:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53323 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1LKNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 08:19:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAE04G=Bq+tyPnM+SVHUm+AQH4nLOy-KH7foRVNFs6GNdzpiX_Q@mail.gmail.com>
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
	<m2y5uknqjk.fsf@firstfloor.org>
	<CAE04G=Bq+tyPnM+SVHUm+AQH4nLOy-KH7foRVNFs6GNdzpiX_Q@mail.gmail.com>
Date: Sun, 11 Dec 2011 21:19:22 +0800
Message-ID: <CAE04G=A7WWG4WDoTfcBVMsxNB2xndVTq4s6DPdsyDEca4Up=SQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
From: t cheney <cdmalord@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is readelf's patch which can retrieve maps in coredump
file, and it is based on binutils-2.21.1.
Usage: ./readelf -m coredumpfile
https://github.com/cdma/coredumpmap/blob/dev/readelf.c
https://github.com/cdma/coredumpmap/blob/dev/common.h

Alternately, following is diff's result:
changed files:
./binutils-2.21.1/binutils/readelf.c
./binutils-2.21.1/include/elf/common.h

diff -u ./binutils-2.21.1/binutils/readelf.c
./binutils-2.21.1/binutils/readelf.c.orig
--- ./binutils-2.21.1/binutils/readelf.c        2011-12-07
14:54:45.000000000 -0500
+++ ./binutils-2.21.1/binutils/readelf.c.orig   2011-12-07
14:53:43.000000000 -0500
@@ -196,7 +196,6 @@
 static int do_notes;
 static int do_archive_index;
 static int is_32bit_elf;
-static int do_maps;

 struct group_list
 {
@@ -3072,7 +3071,6 @@
  {"dyn-syms",        no_argument, 0, OPTION_DYN_SYMS},
  {"relocs",          no_argument, 0, 'r'},
  {"notes",           no_argument, 0, 'n'},
-  {"maps",            no_argument, 0, 'm'},
  {"dynamic",         no_argument, 0, 'd'},
  {"arch-specific",    no_argument, 0, 'A'},
  {"version-info",     no_argument, 0, 'V'},
@@ -3112,7 +3110,6 @@
     --symbols           An alias for --syms\n\
  --dyn-syms             Display the dynamic symbol table\n\
  -n --notes             Display the core notes (if present)\n\
-  -m --maps              Display the core maps (if present)\n\
  -r --relocs            Display the relocations (if present)\n\
  -u --unwind            Display the unwind info (if present)\n\
  -d --dynamic           Display the dynamic section (if present)\n\
@@ -3231,7 +3228,7 @@
    usage (stderr);

  while ((c = getopt_long
-         (argc, argv, "ADHINR:SVWacdeghi:lnp:rstuvw::x:m", options,
NULL)) != EOF)
+         (argc, argv, "ADHINR:SVWacdeghi:lnp:rstuvw::x:", options,
NULL)) != EOF)
    {
      switch (c)
       {
@@ -3354,9 +3351,6 @@
       case 'W':
         do_wide++;
         break;
-       case 'm':
-         do_maps++;
-         break;
       default:
         /* xgettext:c-format */
         error (_("Invalid option '-%c'\n"), c);
@@ -3370,7 +3364,7 @@
      && !do_segments && !do_header && !do_dump && !do_version
      && !do_histogram && !do_debugging && !do_arch && !do_notes
      && !do_section_groups && !do_archive_index
-      && !do_dyn_syms && !do_maps)
+      && !do_dyn_syms)
    usage (stderr);
  else if (argc < 3)
    {
@@ -11855,8 +11849,6 @@
       return _("NT_LWPSINFO (lwpsinfo_t structure)");
      case NT_WIN32PSTATUS:
       return _("NT_WIN32PSTATUS (win32_pstatus structure)");
-      case NT_MAPS:
-       return _("NT_MAPS (maps info)");
      default:
       break;
      }
@@ -11970,9 +11962,6 @@
 {
  const char * name = pnote->namesz ? pnote->namedata : "(NONE)";
  const char * nt;
-
-  if (do_maps && pnote->type != NT_MAPS)
-       return 0;

  if (pnote->namesz == 0)
    /* If there is no note name, then use the default set of
@@ -12000,13 +11989,6 @@
      nt = get_note_type (pnote->type);

  printf ("  %s\t\t0x%08lx\t%s\n", name, pnote->descsz, nt);
-  if (do_maps && pnote->type == NT_MAPS)
-  {
-      pnote->descdata[pnote->descsz] = 0;
-      printf("Maps is following:\n");
-      printf("%s\n",pnote->descdata);
-  }
-
  return 1;
 }

@@ -12093,6 +12075,7 @@
       }

      res &= process_note (& inote);
+
      if (temp != NULL)
       {
         free (temp);
@@ -12150,7 +12133,7 @@
 process_notes (FILE * file)
 {
  /* If we have not been asked to display the notes then do nothing.  */
-  if (! do_notes && !do_maps)
+  if (! do_notes)
    return 1;

  if (elf_header.e_type != ET_CORE)


diff -u ./binutils-2.21.1/include/elf/common.h
./binutils-2.21.1/include/elf/common.h.orig
--- ./binutils-2.21.1/include/elf/common.h      2011-12-07
14:56:02.000000000 -0500
+++ ./binutils-2.21.1/include/elf/common.h.orig 2011-12-07
14:55:45.000000000 -0500
@@ -518,7 +518,6 @@
 #define NT_PRPSINFO    3               /* Contains copy of prpsinfo struct */
 #define NT_TASKSTRUCT  4             /* Contains copy of task struct */
 #define NT_AUXV                6            /* Contains copy of Elfxx_auxv_t */
-#define NT_MAPS         7               /* Contains copy of maps*/
 #define NT_PRXFPREG    0x46e62b7f      /* Contains a user_xfpregs_struct; */
                                       /*   note name must be "LINUX".  */
 #define NT_PPC_VMX     0x100           /* PowerPC Altivec/VMX registers */



On 12/11/11, t cheney <cdmalord@gmail.com> wrote:
> On 12/11/11, Andi Kleen <andi@firstfloor.org> wrote:
>> t cheney <cdmalord@gmail.com> writes:
>>
>>> This patch just add memory layout(same as /proc/pid/maps) to
>>> coredump file. The layout is appended to corenote segment with
>>> flag NT_MAPS=7.
>>
>> Seems like a reasonable idea, but can you please share code with
>> the proc implementation?
> Yes, I will post it in following mail.
>>
>> It's a bit unusal to have ASCII in a coredump, but I suppose expressing
>> this in binary would be somewhat ugly.
>>
>>> +	char *buf = notes->data;
>>> +	size_t core_limit = notes->datasz;
>>> +	gate_vma = get_gate_vma(current->mm);
>>> +
> The maps info is appended to core notes segment in which there are all
> ASCII text such as regs,signal and thread info.
>>
>> It seems a bit dubious to do this without locking even in a core dump.
>>
>>> +	for (vma = first_vma(current, gate_vma); vma != NULL;
>>> +		vma = next_vma(vma, gate_vma)) {
>>> +		flags = vma->vm_flags;
>>> +		maps_size += len;
>>> +		if (file) {
>>> +			if (maps_size > core_limit)
>>> +				break;
>>
>> You have a one-off bug here. Also below.
>>
>>> +			DUMP_WRITE(buf, len, foffset);
>>> +		}
>>
> Because proceses that could change vma pages are blocked in do_exit,
> here vma pages are safe.
>>
>> -Andi
>> --
>> ak@linux.intel.com -- Speaking for myself only
>>
>
