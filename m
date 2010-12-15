Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab0LOGpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:45:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65534 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0LOGpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:45:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cQJvPBizyaQO6nNTb5QXG50S9NxcQldwhRcfnCype9PxWFTbDLUaGL5gQFOyfV4Ie9
         KLWt7PEFC0lTj0M9j7Tmhef/UOq6k8eMQ7AuBaf1dQyGoPZUjxxxbB3CSaZKHrtfSeE7
         R7nXO72EItEq95hdr0yR6QDTaYk7UfEcKWYW0=
MIME-Version: 1.0
In-Reply-To: <20101215160440.bafbe38c.sfr@canb.auug.org.au>
References: <20101215160440.bafbe38c.sfr@canb.auug.org.au>
Date: Wed, 15 Dec 2010 01:45:45 -0500
Message-ID: <AANLkTimgNVUaQcRdva_usq1XX=vp1xwHM3rUeT_hNCZd@mail.gmail.com>
Subject: Re: ftrace/MIPS related x86_64 build failure on in Linus' tree
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, John Reiser <jreiser@bitwagon.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 15, 2010 at 12:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Since October 31 our x86_64 allmodconfig builds have been failing like this:
>
> /opt/crosstool/gcc-4.4.3-nolibc/x86_64-linux/bin/x86_64-linux-ld: arch/x86/ia32/sys_ia32.o: bad reloc symbol index (0x1000000 >= 0x6b) for offset 0x808080 in section `__mcount_loc'
> arch/x86/ia32/sys_ia32.o: could not read symbols: Bad value
>
I got the same on mips, target was BE, toolchain's host was LE.
Doesn't https://lkml.org/lkml/2010/12/2/224 address the issue ? This
patch does not seem to have reached Linus tree yet.

 - Arnaud

> and many similar
> (http://fandango2.ozlabs.ibm.com/kisskb/buildresult/3423985/).  I finally
> got around to bisecting it and it comes down to this commit:
>
> a2d49358ba9bc93204dc001d5568c5bdb299b77d is the first bad commit
> commit a2d49358ba9bc93204dc001d5568c5bdb299b77d
> Author: John Reiser <jreiser@BitWagon.com>
> Date:   Wed Oct 27 18:59:07 2010 +0800
>
>    ftrace/MIPS: Add MIPS64 support for C version of recordmcount
>
>    MIPS64 has 'weird' Elf64_Rel.r_info[1,2], which must be used instead of
>    the generic Elf64_Rel.r_info, otherwise, the C version of recordmcount
>    will not work for "segmentation fault".
>
>    Usage of "union mips_r_info" and the functions MIPS64_r_sym() and
>    MIPS64_r_info() written by Maciej W. Rozycki <macro@linux-mips.org>
>
>    ----
>    [1] http://techpubs.sgi.com/library/manuals/4000/007-4658-001/pdf/007-4658-001.pdf
>    [2] arch/mips/include/asm/module.h
>
>    Tested-by: Wu Zhangjin <wuzhangjin@gmail.com>
>    Signed-off-by: John Reiser <jreiser@BitWagon.com>
>    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
>    LKML-Reference: <AANLkTinwXjLAYACUfhLYaocHD_vBbiErLN3NjwN8JqSy@mail.gmail.com>
>    LKML-Reference: <910dc2d5ae1ed042df4f96815fe4a433078d1c2a.1288176026.git.wuzhangjin@gmail.com>
>    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>
> :040000 040000 c208c976b8bd3eb28791d0e96dcb24967586fbb0 28da1214674ed267e0c4aa249379504bc8b20216 M      scripts
>
> This seems to be tool chain specific.  We are using a PowerPC hosted
> x86_64 cross compiler:
>
> x86_64-linux-gcc (GCC) 4.4.3
> GNU ld (GNU Binutils) 2.20
>
> [It does *not* fail for our x86_64 hosted x86_64 compiler:
>
> x86_64-linux-gcc (GCC) 4.4.4
> GNU ld (GNU Binutils) 2.20
> ]
>
> I tried reverting that commit (and the next commit
> 412910cd046c1f14f0fba9c0aec401d47e57dcd1 "ftrace/MIPS: Add module support
> for C version of recordmcount" because of conflicts) and the build of
> Linus' current tree now succeeds with the above toolchain,
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
