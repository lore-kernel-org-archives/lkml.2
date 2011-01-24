Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1AXRFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:05:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33646 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1AXRFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gg1Ft1vUg3GpfLSDutc/U9hjMHF2uK53J52mTiaBnGBhyTEdiK3GlfAPMvZAmrOb+7
         daH2fc9VJTY5W3oyYCxcglllgKwQI0ZfLd7AFu4KdQ7qsGWTnArs4a7PDiuOUohUBKo5
         K0vvuk4uJm8AjSex0R7m1FiuZqfSLq5uV2Bso=
MIME-Version: 1.0
In-Reply-To: <4D359E5C.1070002@parallels.com>
References: <4D359E5C.1070002@parallels.com>
Date: Mon, 24 Jan 2011 12:05:09 -0500
Message-ID: <AANLkTi=hYycozY46ohaWNQ7pzSijnoAkeSOGfTG4CY2C@mail.gmail.com>
Subject: Re: [PATCH] Replace scripts/headers_install.pl with a shell script.
From: Arnaud Lacombe <lacombar@gmail.com>
To: Rob Landley <rlandley@parallels.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 18, 2011 at 9:06 AM, Rob Landley <rlandley@parallels.com> wrote:
> From: Rob Landley <rlandley@parallels.com>
>
> Remove perl from make headers_install by replacing a perl script (doing
> a simple regex search and replace) with a smaller and faster shell script
> implementation.  The new shell script is a single for loop calling sed and
> piping its output through unifdef to produce the target file.
>
> Change from last time: better error handling.  Split "sed | unifdef" into
> two stages with a temp file because dash hasn't got PIPEFAIL.  Add check
> for exit code, add trap handler to delete output when exiting prematurely.
>
one more thing,

> Signed-off-by: Rob Landley <rlandley@parallels.com>
> ---
>
>  scripts/Makefile.headersinst |    6 ++--
>  scripts/headers_install.pl   |   49 ---------------------------------
>  scripts/headers_install.sh   |   39 ++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 52 deletions(-)
>
> diff -ruN linux-2.6.30.old/scripts/headers_install.sh linux-2.6.30/scripts/headers_install.sh
> --- linux-2.6.30.old/scripts/headers_install.sh 1969-12-31 18:00:00.000000000 -0600
> +++ linux-2.6.30/scripts/headers_install.sh     2009-06-22 16:21:23.000000000 -0500
> @@ -0,0 +1,42 @@
> +#!/bin/sh
> +
> +if [ $# -lt 2 ]
> +then
> +       echo "Usage: headers_install.sh INDIR OUTDIR [FILES...]
> +       echo
> +       echo "Prepares kernel header files for use by user space, by removing"
> +       echo "all compiler.h definitions and #includes, removing any"
> +       echo "#ifdef __KERNEL__ sections, and putting __underscores__ around"
> +       echo "asm/inline/volatile keywords."
> +       echo
> +       echo "INDIR:  directory to read each kernel header FILE from."
> +       echo "OUTDIR: directory to write each userspace header FILE to."
> +       echo "FILES:  list of header files to operate on."
> +
> +       exit 1
> +fi
> +
> +# Grab arguments
> +
> +INDIR="$1"
> +shift
> +OUTDIR="$1"
> +shift
> +
> +# Iterate through files listed on command line
> +
> +trap "rm -f $OUTDIR/$i $OUTDIR.sed" EXIT
> +for i in "$@"
> +do
> +       sed -r \
> +               -e 's/([ \t(])(__user|__force|__iomem)[ \t]/\1/g' \
> +               -e 's/__attribute_const__([ \t]|$)/\1/g' \
> +               -e 's@^#include <linux/compiler.h>@@' \
> +               -e 's/(^|[ \t])(inline|asm|volatile)([ \t(]|$)/\1__\2__\3/g' \
> +               "$INDIR/$i" > "$OUTDIR/$i.sed" || exit 1
> +       scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ "$OUTDIR/$i.sed" \
> +               > "$OUTDIR/$i"
> +       [ $? -gt 1 ] && exit 1
> +       rm -f "$OUTDIR/$i.sed"
you can avoid all the ugly and inconsistent[0] errors checking by
adding a simple:

set -e

at the beginning of the script.

 - Arnaud

ps: sorry for the late review, I was AFK last week.

[0]: ie. using an explicit test (use of the || operator) for the sed
invocation, and an implicit test (check of the value of $?) for
unifdef.
