Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2EJFQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:16:51 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:43942 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2EJFQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:16:48 -0400
Date: Thu, 10 May 2012 07:16:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Tony Luck <tony.luck@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        ralf@linux-mips.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
Message-ID: <20120510051646.GA14138@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org> <20120428205919.GC7442@merkur.ravnborg.org> <4FA460AB.6060309@suse.cz> <20120505082916.GA14006@merkur.ravnborg.org> <CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com> <20120508165118.GA11750@merkur.ravnborg.org> <CAP=VYLobO--uwxv_hiMYBnjD-AU_0fqyQJD6argQygnkHnm5Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=VYLobO--uwxv_hiMYBnjD-AU_0fqyQJD6argQygnkHnm5Vg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:58:16PM -0400, Paul Gortmaker wrote:
> On Tue, May 8, 2012 at 12:51 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Hi Tony.
> >
> > On Mon, May 07, 2012 at 04:15:44PM -0700, Tony Luck wrote:
> >> This patch is now in linux-next (tag next-20120507). But it looks to have
> >> broken the ia64 build. I see this error:
> >>
> >>   CC      init/version.o
> >>   LD      init/built-in.o
> >>   KSYM    .tmp_kallsyms1.o
> >> ld: .tmp_kallsyms1.o: linking constant-gp files with non-constant-gp files
> >> ld: failed to merge target specific data of file .tmp_kallsyms1.o
> >> make: *** [vmlinux] Error 1
> >>
> >> which looks like we used the wrong compile options when building
> >> .tmp_kallsyms1.o
> >
> > Thanks for testing!
> >
> > Could you try if this helps.
> >
> >        Sam
> >
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index 26c5b65..1f4c27b 100644
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -78,8 +78,8 @@ kallsyms()
> >                kallsymopt=--all-symbols
> >        fi
> >
> > -       local aflags="${KBUILD_AFLAGS} ${NOSTDINC_FLAGS}                     \
> > -                     ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
> > +       local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
> > +                     ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
> 
> All the linux-next builds for mips are failing, which I tracked down to this.
> Applying the above update doesn't help.  What is happening is that MIPS
> gets KBUILD_CPPFLAGS double-quoted, and then you get:
> 
> + mips-wrs-linux-gnu-nm -n .tmp_vmlinux1
> + scripts/kallsyms
> + mips-wrs-linux-gnu-gcc -D__ASSEMBLY__ <..snip..>  -D__KERNEL__
> '-D"VMLINUX_LOAD_ADDRESS=0xffffffff81100000"' '-D"DATAOFFSET=0"' -c -o
> .tmp_kallsyms1.o -x assembler-with-cpp -
> <command-line>:0: error: macro names must be identifiers
> <command-line>:0: error: macro names must be identifiers
> make[1]: *** [vmlinux] Error 1
> 
> Note the  '-D"VMLINUX_LOAD_ADDRESS=0xffffffff81100000"' '-D"DATAOFFSET=0"'
> part -- that is what triggers the two above errors.

Hi Paul.

I will take a look at this tonight. Thanks for the report!

	Sam
