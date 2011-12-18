Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1LRKLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 05:11:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39327 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1LRKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 05:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111212210328.GA29248@host2.jankratochvil.net>
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
	<CAE04G=D_OzrDRUOj-iVPJY5sNTLMfUKAeikks8TWMYOWvh6HeA@mail.gmail.com>
	<20111212210328.GA29248@host2.jankratochvil.net>
Date: Sun, 18 Dec 2011 18:10:55 +0800
Message-ID: <CAE04G=Bj+EsLbdrUDjvt3BfNee8TH-0ud2knc75JiRFKNfCvDg@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
From: t cheney <cdmalord@gmail.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: gdb <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        gdb-patches@sourceware.org, binutils@sourceware.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank your suggestion.

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
 #define NT_TASKSTRUCT  4               /* Contains copy of task struct */
 #define NT_AUXV                6               /* Contains copy of
Elfxx_auxv_t */
-#define NT_MAPS         7               /* Contains copy of maps*/
 #define NT_PRXFPREG    0x46e62b7f      /* Contains a user_xfpregs_struct; */
                                        /*   note name must be "LINUX".  */
 #define NT_PPC_VMX     0x100           /* PowerPC Altivec/VMX registers */


On 12/13/11, Jan Kratochvil <jan.kratochvil@redhat.com> wrote:
> On Sun, 11 Dec 2011 15:10:00 +0100, t cheney wrote:
>> This patch just add memory layout(same as /proc/pid/maps) to
>> coredump file. The layout is appended to corenote segment with
>> flag NT_MAPS=7.
>
> FYI this has been solved by ABRT - Automated Bug-Reporting Tool
> 	https://fedorahosted.org/abrt/
> 	(it is distro-neutral despite its homepage)
>
> Core file is there a subdirectory where the core file is just one of the
> many
> associated files:
> /var/spool/abrt/ccpp-*:
> 	abrt_version analyzer architecture cmdline component coredump count
> 	dso_list environ executable hostname kernel maps os_release package
> 	pid pwd reason time uid username uuid var_log_messages
>
> More info files are being continually added, such as /proc/PID/fd{,info}/
> mapping at the crash dump time etc.  You would need to add many more core
> file
> notes to make the core files useful for later analysis.
>
>
> Regards,
> Jan
>
