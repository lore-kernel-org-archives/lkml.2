Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab2HHMnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:43:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53887 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2HHMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WZWEO=b5Usx4RKDLC--TvLWnOom0P+HmXsxh7QZQQXQA@mail.gmail.com>
References: <CAB=NE6WZWEO=b5Usx4RKDLC--TvLWnOom0P+HmXsxh7QZQQXQA@mail.gmail.com>
Date: Wed, 8 Aug 2012 15:43:14 +0300
Message-ID: <CAFub=KRtuTDn1DnHP0aKZT6RBeA2kNkLm6ud-4Z=1ESPs==h0g@mail.gmail.com>
Subject: Re: Using vanilla kernels headers to do backport testing -- issues
 with memcpy()
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:28 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> A while ago we reviewed the idea of whether or not to use a set of
> distribution vanilla kernels to allow us to do compilation testing of
> modules on the compat backport project [0] with the benefit being that
> at least one Linux distribution was doing this work already and given
> that this work was using plain vanilla kernels directly from
> kernel.org, with no modifications. The other option that existed was
> that each distro could provide their own set of kernel packages along
> with their own kernel headers but it didn't seem like other Linux
> distributions were doing this and the information was not easy to
> gather. So we went with the Ubuntu vanilla kernels and Ozan later
> figured out a way to extract deb packages in a distribution agnostic
> manner [1] and later added an option to enable a way to install and
> use this for ckmake which test compiles against 21 kernels without
> requiring root [2].
>
> This works swell as it allows anyone on any Linux distribution to test
> compile against a series of older kernels, today 21 older kernels and
> all vanilla kernels which means we get to focus and prioritize
> upstream.
>
> This has started working well except for the fact that as of the >=
> v3.4 vanilla kernel releases, there are a few files which are binary
> in the kernel headers which use dynamic libraries. Of interest to us
> here are the ones required to build external modules. An example:
>
> /lib/modules/3.4.4-030404-generic/build/scripts/genksyms/genksyms
>
> It just so happens to be that the folks building these packages are
> using a glibc >= 2.14 and although the *only* symbol I see being
> required from glibc >= 2.14 being memcpy():
>
> mcgrof@garbanzo ~/compat (git::master)$ objdump -T
> /home/mcgrof/compat-ksrc/lib/modules/3.4.4-030404-generic/build/scripts/genksyms/genksyms
>
> /home/mcgrof/compat-ksrc/lib/modules/3.4.4-030404-generic/build/scripts/genksyms/genksyms:
>     file format elf64-x86-64
>
> DYNAMIC SYMBOL TABLE:
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.3.4 __snprintf_chk
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 free
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.3.4 __vfprintf_chk
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 __errno_location
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 ferror
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 isatty
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fread
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fclose
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 strlen
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.4   __stack_chk_fail
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 getopt_long
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 strchr
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 _IO_putc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fputs
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fgetc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fputc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 __strdup
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 __libc_start_main
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 strcmp
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 feof
> 0000000000000000  w   D  *UND*  0000000000000000              __gmon_start__
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 strtol
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 clearerr
>
>
> Bleh:
>
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.14  memcpy
>
>
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fileno
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 malloc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 _IO_getc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 ungetc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 realloc
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.3.4 __printf_chk
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fopen
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 perror
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 exit
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.2.5 fwrite
> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.3.4 __fprintf_chk
> 000000000060b160 g    DO .bss   0000000000000008  GLIBC_2.2.5 stdout
> 000000000060b168 g    DO .bss   0000000000000008  GLIBC_2.2.5 stdin
> 000000000060b178 g    DO .bss   0000000000000008  GLIBC_2.2.5 stderr
> 000000000060b170 g    DO .bss   0000000000000008  GLIBC_2.2.5 optarg
>
> It would be reasonable to simply require the users of ckmake to update
> their libc version but even Debian sid does not yet seem to have libc
>>= 2.14, not sure of others. The gains for requiring a glibc >= 2.14
> only for memcpy() would seem rather small for this particular case so
> I wanted to review the options to fix this.

Can't we just rebuild genksyms in compat? I already have glibc 2.15 on
my system so I can't test this but normally this should adapt to the
build environment as it rebuilds and relinks the binary.

[root@ozzyfedora compat]# make -C
/lib/modules/2.6.36-02063604-generic/build M=scripts/genksyms
make: Entering directory `/usr/src/linux-headers-2.6.36-02063604-generic'
  HOSTCC  scripts/genksyms/genksyms.o
  HOSTCC  scripts/genksyms/lex.o
  HOSTCC  scripts/genksyms/parse.o
  HOSTLD  scripts/genksyms/genksyms
  Building modules, stage 2.
  MODPOST 0 modules
make: Leaving directory `/usr/src/linux-headers-2.6.36-02063604-generic'

One other thing that I have found is to force linking memcpy to a
hard-coded (namely GLIBC_2.2.5) memcpy() symbol. I didn't know about
this so I'm posting this as a reference:

make HOSTCFLAGS="-Wa,--defsym,memcpy=memcpy@GLIBC_2.2.5" -C
/lib/modules/2.6.36-02063604-generic/build M=scripts/genksyms
