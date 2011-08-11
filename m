Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1HKNIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:08:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47995 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab1HKNIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <1313062101.8300.23.camel@x61.thuisdomein>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	<1313052783-27607-1-git-send-email-corentin.chary@gmail.com>
	<1313062101.8300.23.camel@x61.thuisdomein>
Date: Thu, 11 Aug 2011 15:08:42 +0200
Message-ID: <CAHR064h8souTS7HZBk_6Kc0uRqRhJDGaB_4pFgHGJRSAF_50ig@mail.gmail.com>
Subject: Re: [PATCH] scripts: add extract-vmlinux
From: Corentin Chary <corentin.chary@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 1:28 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Thu, 2011-08-11 at 10:53 +0200, Corentin Chary wrote:
>> This script can be used to extract vmlinux from a compressed
>> kernel image (bzImage, etc..). It's inspired from (a subset of)
>> extract-ikconfig.
>
> This is more specific than what this scripts actually does, isn't it? At
> least when I tried to read this script my impression is that it does two
> things:
> - check whether the input file is a valid ELF file;
> - if not; try to find a compressed ELF file somewhere in the input file.
>
> There's no checking whether the input file is a kernel image and there's
> no checking whether the found ELF file actually is was a, well, vmlinux.
> Both checks are perhaps far from trivial. Anyhow, if that's correct this
> should be made more clear. Perhaps the script should even be called
> something like extract-elf.

Yep, I didn't found a quick way to check that the file is a valid
vmlinux and the function check_elf() has a configusing name.

Is that one better ?

check_vmlinux()
{
        # Use readelf to check if it's a valid ELF
        # TODO: find a better to way to check that it's really vmlinux
        #       and not just another elf
        readelf -h $1 > /dev/null 2>&1 || return 1

        cat $1
        exit 0
}

If you have a good way to check that an elf is a valid vmlinux, I'd be
happy to implement it.

>> It's something a lot of people have been looking for (mainly
>> people with xen < 4 that doesn't support bzImages at all).
>>
>> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
>> [...]
>> +try_decompress()
>> +{
>> +     for     pos in `tr "$1\n$2" "\n$2=" < "$img" | grep -abo "^$2"`
>> +     do
>> +             pos=${pos%%:*}
>> +             tail -c+$pos "$img" | $3 > $tmp 2> /dev/null
>
> Perhaps a few comments on the above lines would be nice. Without those
> comments I must guess you're finding compressed data somewhere in the
> input file. It also seems you're looping through the entire input file.
> Or are (sequences of) commands like the above considered obvious?

It's copied from extract-ikconfig, there was no comment in it, so I
assumed it's obvious.
Basically it uses brute force (tm) to find well known headers and try
to decompress from here.

>> +             check_elf $tmp
>> +     done
>> +}
>> +
>> [...]
>> +# Initial attempt for uncompressed images or objects:
>> +check_elf $img
>> +
>> +# That didn't work, so retry after decompression.
>> +try_decompress '\037\213\010' xy    gunzip
>> +try_decompress '\3757zXZ\000' abcde unxz
>> +try_decompress 'BZh'          xy    bunzip2
>> +try_decompress '\135\0\0\0'   xxx   unlzma
>> +try_decompress '\211\114\132' xy    'lzop -d'
>
> Perhaps you could first test whether these commands are available before
> running try_decompress() with them?

Same as before, if it's ok for extract-ikconfig not to check the
command, then it's ok for me.
If it's not, then we should patch both.

Personnaly I think that the script is small enought so that someone
who try to use it and can't make it work will understand what's
happening.

Note that extract-ikconfig is used in the build system and is far more
"critical" that extract-vmlinux, and nobody complained before :).

-- 
Corentin Chary
http://xf.iksaif.net
