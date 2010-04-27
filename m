Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0D0MkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:40:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:47396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab0D0MkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:40:16 -0400
Message-ID: <4BD6DB2D.6080808@suse.cz>
Date: Tue, 27 Apr 2010 14:40:13 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.9 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nicolas Palix <npalix@diku.dk>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
References: <1272316279-12042-1-git-send-email-npalix@diku.dk> <1272316279-12042-2-git-send-email-npalix@diku.dk> <1272317821.15953.107.camel@Joe-Laptop.home> <201004270020.09447.npalix@diku.dk>
In-Reply-To: <201004270020.09447.npalix@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 27.4.2010 00:20, Nicolas Palix wrote:
> Four targets are added. Each one generates a different
> output kind: context, patch, org, report.
> Every SmPL file in 'scripts/smpl' is given to the spatch frontend
> (located in the 'scripts' directory), and applied to the entire
> source tree.

Cool!


> Signed-off-by: Nicolas Palix <npalix@diku.dk>
> ---
>  MAINTAINERS       |   10 ++++++++++
>  Makefile          |    9 +++++++++
>  scripts/spatch.sh |   14 ++++++++++++++
>  3 files changed, 33 insertions(+), 0 deletions(-)
>  create mode 100755 scripts/spatch.sh
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d29fa3..2aab763 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1533,6 +1533,16 @@ L:	platform-driver-x86@vger.kernel.org
>  S:	Supported
>  F:	drivers/platform/x86/classmate-laptop.c
>  
> +COCCINELLE/Semantic Patches (SmPL)
> +M:	Julia Lawall <julia@diku.dk>
> +M:	Gilles Muller <Gilles.Muller@lip6.fr>
> +M:	Nicolas Palix <npalix@diku.dk>
> +L:	cocci@diku.dk
> +W:	http://coccinelle.lip6.fr/
> +S:	Supported
> +F:	scripts/smpl/
> +F:	scripts/spatch.sh
> +
>  CODA FILE SYSTEM
>  M:	Jan Harkes <jaharkes@cs.cmu.edu>
>  M:	coda@cs.cmu.edu
> diff --git a/Makefile b/Makefile
> index 67c1001..293c88b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -325,6 +325,7 @@ INSTALLKERNEL  := installkernel
>  DEPMOD		= /sbin/depmod
>  KALLSYMS	= scripts/kallsyms
>  PERL		= perl
> +SPATCH          = spatch
>  CHECK		= sparse
>  
>  CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
> @@ -1424,6 +1425,14 @@ versioncheck:
>  		-name '*.[hcS]' -type f -print | sort \
>  		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
>  
> +coccicheck-context coccicheck-patch coccicheck-org coccicheck-report:
> +	@echo "\nPlease check for false positive in the output before submitting a patch.\n\n"\
> +		"Take particularly attention when using the \"patch\" mode\n"\
> +		"and carefully review the patch you are about to submit.\n"

This should be echo -e in bash, but then it won't work in dash I guess.
So better use multiple echo commands. Also please add the targets to
'make help' text and add coccicheck-% to the no-dot-config-targets variable.


> +	@find $(srctree)/scripts/smpl/                        \
> +		-name '*.cocci' -type f                       \
> +		-exec $(srctree)/scripts/spatch.sh $(SPATCH) $(@:coccicheck-%=%) \{} $(srctree) \;
> +

Please use 'for file in $(srctree)/scripts/smpl/*.cocci; do ...', so
that the reports are in a defined order. Or do you plan to use
subdirectories below scripts/smpl?


>  namespacecheck:
>  	$(PERL) $(srctree)/scripts/namespace.pl
>  
> diff --git a/scripts/spatch.sh b/scripts/spatch.sh
> new file mode 100755
> index 0000000..bdcca15
> --- /dev/null
> +++ b/scripts/spatch.sh
> @@ -0,0 +1,14 @@
> +#!/bin/sh
> +
> +SPATCH="$1"
> +MODE="$2"
> +COCCI="$3"
> +DIR="$4"
> +
> +OPT=`grep "Option" $COCCI | cut -d':' -f2`
> +FILE=`echo $COCCI | sed "s|$DIR/||"`
> +
> +echo Processing `basename $COCCI` with \"$OPT\"
> +echo Message example to submit a patch:
> +grep "^///" $COCCI | sed "s|///||" | sed "s|THISFILE|$FILE|"

echo "The semantic patch that makes this change is available"
echo "in $FILE"

Then you don't need to add the same comment to each of the *.cocci
files. Also is it necessary to advertise

"More information about semantic patching is available at
 http://coccinelle.lip6.fr/"

before processing each *.cocci file? If you want the banner, you could
append it to the "Please check for false positives..." text printed once
in the beginning.


> +$SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR

You can also print the URL here if the spatch command is not available.

Michal
