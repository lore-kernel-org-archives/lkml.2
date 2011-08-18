Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1HRKJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:09:32 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62221 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1HRKJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <1313484365-22129-1-git-send-email-corentincj@iksaif.net>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	<1313484365-22129-1-git-send-email-corentincj@iksaif.net>
Date: Thu, 18 Aug 2011 18:09:29 +0800
Message-ID: <CAM_iQpX2xwutn8czOayYZ1fWBKzNpqnXtU0s-SpZRszXKAc9kg@mail.gmail.com>
Subject: Re: [PATCH v3] scripts: add extract-vmlinux
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dick Streefland <dick@streefland.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

I don't know any way to check vmlinux, we can only check if it is ELF,
so this patch looks good.

Michal?

On Tue, Aug 16, 2011 at 4:46 PM, Corentin Chary <corentincj@iksaif.net> wrote:
> This script can be used to extract vmlinux from a compressed
> kernel image (bzImage, etc..). It's inspired from (a subset of)
> extract-ikconfig.
>
> It's something a lot of people have been looking for (mainly
> people with xen < 4 that doesn't support bzImages at all).
>
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
>
> Since v1:
> * update license
>
> Since v2:
> * add some comments
>
>  scripts/extract-vmlinux |   62 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 62 insertions(+), 0 deletions(-)
>  create mode 100755 scripts/extract-vmlinux
>
> diff --git a/scripts/extract-vmlinux b/scripts/extract-vmlinux
> new file mode 100755
> index 0000000..4ab8517
> --- /dev/null
> +++ b/scripts/extract-vmlinux
> @@ -0,0 +1,62 @@
> +#!/bin/sh
> +# ----------------------------------------------------------------------
> +# extract-vmlinux - Extract uncompressed vmlinux from a kernel image
> +#
> +# Inspired from extract-ikconfig
> +# (c) 2009,2010 Dick Streefland <dick@streefland.net>
> +#
> +# (c) 2011      Corentin Chary <corentin.chary@gmail.com>
> +#
> +# Licensed under the GNU General Public License, version 2 (GPLv2).
> +# ----------------------------------------------------------------------
> +
> +check_vmlinux()
> +{
> +       # Use readelf to check if it's a valid ELF
> +       # TODO: find a better to way to check that it's really vmlinux
> +       #       and not just an elf
> +       readelf -h $1 > /dev/null 2>&1 || return 1
> +
> +       cat $1
> +       exit 0
> +}
> +
> +try_decompress()
> +{
> +       # The obscure use of the "tr" filter is to work around older versions of
> +       # "grep" that report the byte offset of the line instead of the pattern.
> +
> +       # Try to find the header ($1) and decompress from here
> +       for     pos in `tr "$1\n$2" "\n$2=" < "$img" | grep -abo "^$2"`
> +       do
> +               pos=${pos%%:*}
> +               tail -c+$pos "$img" | $3 > $tmp 2> /dev/null
> +               check_vmlinux $tmp
> +       done
> +}
> +
> +# Check invocation:
> +me=${0##*/}
> +img=$1
> +if     [ $# -ne 1 -o ! -s "$img" ]
> +then
> +       echo "Usage: $me <kernel-image>" >&2
> +       exit 2
> +fi
> +
> +# Prepare temp files:
> +tmp=$(mktemp /tmp/vmlinux-XXX)
> +trap "rm -f $tmp" 0
> +
> +# Initial attempt for uncompressed images or objects:
> +check_vmlinux $img
> +
> +# That didn't work, so retry after decompression.
> +try_decompress '\037\213\010' xy    gunzip
> +try_decompress '\3757zXZ\000' abcde unxz
> +try_decompress 'BZh'          xy    bunzip2
> +try_decompress '\135\0\0\0'   xxx   unlzma
> +try_decompress '\211\114\132' xy    'lzop -d'
> +
> +# Bail out:
> +echo "$me: Cannot find vmlinux." >&2
> --
> 1.7.3.4
>
>
