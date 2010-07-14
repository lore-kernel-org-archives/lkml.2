Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0GNC0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:26:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40922 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0GNC0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:26:37 -0400
MIME-Version: 1.0
In-Reply-To: <20100713114322.57c8b166.sfr@canb.auug.org.au>
References: <20100713114322.57c8b166.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Jul 2010 20:26:16 -0600
X-Google-Sender-Auth: 2XGh0Re0TAqdOYEwY2HOLj4t-BU
Message-ID: <AANLkTimC_vXCAOrfTSndZyk8lgkjTlILVSYVYeIg6cUt@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Enable building defconfigs from Kconfig files
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing rmk and linux-arm-kernel]

On Mon, Jul 12, 2010 at 7:43 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After this change, doing a "make xxx_defconfig" will check first for
> a file called arch/<arch>/configs/Kconfig.xxx and use that to generate
> the .config (effectively starting from an allnoconfig).  If that file
> doesn't exist, it will use arch/<ARCH>/configs/xxx_defconfig as now.

Oops, I hadn't seen this patch when I wrote mine this afternoon[1].
:-)  A few minor differences, but essentially the same solution.

[1] http://patchwork.ozlabs.org/patch/58823/

I chose to use -D /dev/null (defconfig from an empty file) instead of
-n (allnoconfig) so that default values in Kconfig would get
respected.  For the benefit of everyone else, here's an excerpt from
our IRC conversation this afternoon:

19:49 < gcl> sfr: [...] Your patch and my patch are
             essentially doing exactly the same thing, except that I used '-d'
             and you used '-n'.
19:50 < gcl> s/-d/-D/
19:55 < sfr> right
19:55 < sfr> Linus wanted us to use -n
19:55 < sfr> because that way you get what you asked for, not what the defaults
             say ...
19:58 < gcl> I suppose we don't currently have a way to say "select FOO=n", so
             I suppose that makes sense
19:58 < gcl> although I think using the defaults unless told not to is a better
             approach in the long run
19:59 < gcl> most of the time I *don't want* to ask for something in the
             defconfig.  :-)
20:00 < gcl> I just want TheBestOrCorrectAnswer to be chosen for me
20:04 < sfr> gcl: go read Linus' vision :-)

> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  scripts/kconfig/Makefile |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
>
> Hi Linus,
>
> Is this more the direction you want to take?
>
> There are still 2 main problems with is approach:
>
>        - there are some config options that are globally and
> unconditionally enabled that some platforms may not want.  The only way
> currently to turn them off is to reproduce the config entry with the
> different default.  I am not sure if we need a wa to turn them off or to
> just change them to being neede to be selected by those that do want them.
>        - we have no way to select options that are neither bool or
> tristate to suitable values.  Again the only way to do that currently is
> to reproduce the config entry with a different default value.

For both of the above problems, what if we added syntax like the
following to Kconfig?

config FOO
        bool
        select BAR = n
        select FOO_VALUE = 54

> I am currently working towards using this to recreate the PowerPC
> defconfigs, but it is a slow process as they have some much stuff enabled
> in them and some of it is probably actually not relevant.

If the trimmed configs are merged, then there is no rush on this.  We
can keep them around and switch them over as people want to make
changes.

> This process is made easier by the recent commit "kbuild: Warn on
> selecting symbols with unmet direct dependencies" that is in the kbuild
> tree (and linux-next).

Ah, I didn't know that change was being merged.  That indeed makes
things easier, and eliminates the post-test that I do to make sure
that the resulting config is actually valid.

> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 7ea649d..1ab8f45 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -117,9 +117,21 @@ else
>        $(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
>  endif
>
> -%_defconfig: $(obj)/conf
> +configs_dir := $(srctree)/arch/$(SRCARCH)/configs
> +# We check a level of sub directories because arch/powerpc
> +# has its defconfig files arranged that way
> +old_defconfigs := $(patsubst $(configs_dir)/%,%,\
> +       $(wildcard $(configs_dir)/*_defconfig) \
> +       $(wildcard $(configs_dir)/*/*_defconfig))
> +defconfigs := $(patsubst $(configs_dir)/Kconfig.%,%_defconfig,\
> +       $(wildcard $(configs_dir)/Kconfig.*))
> +

Ugh.  My first impression is that all this shouldn't be necessary, and
it should be okay to just make the two following rules include a
pattern dependency for the source file.  However, as I play with it, I
cannot seem to get the rules right to handle the sub directories.  The
$(defconfigs) patsubst at least could be done solely with dependencies
on the target rule if the files were named *.Kconfig instead of
Kconfig.* (because subdirectories are not handled in that case).  For
example:

%_defconfig: $(obj)/conf arch/$(SRCARCH)/configs/%.Kconfig
        $(Q)$< -n arch/$(SRCARCH)/configs/$*.Kconfig

> +$(old_defconfigs): %_defconfig: $(obj)/conf
>        $(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
>
> +$(defconfigs): %_defconfig: $(obj)/conf
> +       $(Q)$< -n arch/$(SRCARCH)/configs/Kconfig.$*
> +
>  # Help text used by make help
>  help:
>        @echo  '  config          - Update current config utilising a line-oriented program'

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
