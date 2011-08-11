Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1HKL2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:28:38 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:47403 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab1HKL2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:28:37 -0400
Subject: Re: [PATCH] scripts: add extract-vmlinux
From: Paul Bolle <pebolle@tiscali.nl>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <1313052783-27607-1-git-send-email-corentin.chary@gmail.com>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	 <1313052783-27607-1-git-send-email-corentin.chary@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 13:28:21 +0200
Message-ID: <1313062101.8300.23.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 10:53 +0200, Corentin Chary wrote:
> This script can be used to extract vmlinux from a compressed
> kernel image (bzImage, etc..). It's inspired from (a subset of)
> extract-ikconfig.

This is more specific than what this scripts actually does, isn't it? At
least when I tried to read this script my impression is that it does two
things:
- check whether the input file is a valid ELF file;
- if not; try to find a compressed ELF file somewhere in the input file.

There's no checking whether the input file is a kernel image and there's
no checking whether the found ELF file actually is was a, well, vmlinux.
Both checks are perhaps far from trivial. Anyhow, if that's correct this
should be made more clear. Perhaps the script should even be called
something like extract-elf.

> It's something a lot of people have been looking for (mainly
> people with xen < 4 that doesn't support bzImages at all).
> 
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
> [...]
> +try_decompress()
> +{
> +	for	pos in `tr "$1\n$2" "\n$2=" < "$img" | grep -abo "^$2"`
> +	do
> +		pos=${pos%%:*}
> +		tail -c+$pos "$img" | $3 > $tmp 2> /dev/null

Perhaps a few comments on the above lines would be nice. Without those
comments I must guess you're finding compressed data somewhere in the
input file. It also seems you're looping through the entire input file.
Or are (sequences of) commands like the above considered obvious?

> +		check_elf $tmp
> +	done
> +}
> +
> [...]
> +# Initial attempt for uncompressed images or objects:
> +check_elf $img
> +
> +# That didn't work, so retry after decompression.
> +try_decompress '\037\213\010' xy    gunzip
> +try_decompress '\3757zXZ\000' abcde unxz
> +try_decompress 'BZh'          xy    bunzip2
> +try_decompress '\135\0\0\0'   xxx   unlzma
> +try_decompress '\211\114\132' xy    'lzop -d'

Perhaps you could first test whether these commands are available before
running try_decompress() with them?


Paul Bolle

