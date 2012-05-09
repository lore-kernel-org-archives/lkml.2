Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2EIW6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:58:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59396 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758466Ab2EIW6s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120508165118.GA11750@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org> <20120428205919.GC7442@merkur.ravnborg.org>
 <4FA460AB.6060309@suse.cz> <20120505082916.GA14006@merkur.ravnborg.org>
 <CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com> <20120508165118.GA11750@merkur.ravnborg.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 9 May 2012 18:58:16 -0400
X-Google-Sender-Auth: hBZjgnkToQiuUDj08rIywATPKZ8
Message-ID: <CAP=VYLobO--uwxv_hiMYBnjD-AU_0fqyQJD6argQygnkHnm5Vg@mail.gmail.com>
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        ralf@linux-mips.org, linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 12:51 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Tony.
>
> On Mon, May 07, 2012 at 04:15:44PM -0700, Tony Luck wrote:
>> This patch is now in linux-next (tag next-20120507). But it looks to have
>> broken the ia64 build. I see this error:
>>
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   KSYM    .tmp_kallsyms1.o
>> ld: .tmp_kallsyms1.o: linking constant-gp files with non-constant-gp files
>> ld: failed to merge target specific data of file .tmp_kallsyms1.o
>> make: *** [vmlinux] Error 1
>>
>> which looks like we used the wrong compile options when building
>> .tmp_kallsyms1.o
>
> Thanks for testing!
>
> Could you try if this helps.
>
>        Sam
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 26c5b65..1f4c27b 100644
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -78,8 +78,8 @@ kallsyms()
>                kallsymopt=--all-symbols
>        fi
>
> -       local aflags="${KBUILD_AFLAGS} ${NOSTDINC_FLAGS}                     \
> -                     ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
> +       local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
> +                     ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"

All the linux-next builds for mips are failing, which I tracked down to this.
Applying the above update doesn't help.  What is happening is that MIPS
gets KBUILD_CPPFLAGS double-quoted, and then you get:

+ mips-wrs-linux-gnu-nm -n .tmp_vmlinux1
+ scripts/kallsyms
+ mips-wrs-linux-gnu-gcc -D__ASSEMBLY__ <..snip..>  -D__KERNEL__
'-D"VMLINUX_LOAD_ADDRESS=0xffffffff81100000"' '-D"DATAOFFSET=0"' -c -o
.tmp_kallsyms1.o -x assembler-with-cpp -
<command-line>:0: error: macro names must be identifiers
<command-line>:0: error: macro names must be identifiers
make[1]: *** [vmlinux] Error 1

Note the  '-D"VMLINUX_LOAD_ADDRESS=0xffffffff81100000"' '-D"DATAOFFSET=0"'
part -- that is what triggers the two above errors.

Paul.

>
>        ${NM} -n ${1} | \
>                scripts/kallsyms ${kallsymopt} | \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
