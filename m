Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2KBNB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2KBNBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:01:54 -0400
Message-ID: <5093C43F.9050508@redhat.com>
Date: Fri, 02 Nov 2012 14:01:51 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jaxboe@fusionio.com, kzak@redhat.com
Subject: Re: [RFC PATCH 0/4] Remove cryptoloop support (cryptsetup replacement)
References: <cover.1351799189.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 09:11 PM, Milan Broz wrote:

> Dm-crypt/cryptsetup provides replacement for long time already.

Just one addition, here are notes how to replace cryptoloop
with cryptsetup.

Because there are several incompatible lostup implementations,
it cannot be automated. But you can easily find proper options
using few switches below.

Note, that some configurations are insecure and often
the insecure variant is mostly the default.

One such example is a passphrase used directly as key (not hashed)
(option -N which is sometimes default) an key is padded.
So with 8 char password and 256bit key 192bits of key is zeroed.

Another problem is with using predictable IV (initial vector, which
is basically just sector number in losetup) and CBC mode.
For CBC mode this is not secure, because it open system to
watermarking attacks.
(Cryptsetup uses ESSIV by default or XTS mode.)

Cryptsetup will not stop you to use such configurations though,
it is designed to allow everything possible if user wants.


LOSETUP -> CRYPTSETUP replacement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(N.B. for new images you should you use cryptsetup defaults and get rid
of most compat options.)

Short example for compatible mapping:

  "losetup -e twofish -N /dev/loop0 /image.img"

can be used by cryptsetup

  "cryptsetup create image_plain /image.img -c twofish-cbc-plain -H plain"

(Plaintext device will be /dev/mapper/image_plain instead of /dev/loop0.)


Details
~~~~~~~
In Debian and some other distros is hashing default, hash is "ripemd160",
default key size is mostly 256bits. In some distros hashing is not used.

For cryptsetup (plain mode, no LUKS) you will need these options:

 [-c|--cipher]   - cipher specification
 [-s|--key-size] - key size in bits
 [-h|--hash]     - password hashing function ("plain" is no hashing)
 [-o|--offset]   - offset (in 512 sectors!)
 [-p|--skip]     - IV offset (in 512 sectors!) (usually the same as -o)

Here are some common combinations and cryptsetup replacements:

  losetup parameters     |  cryptsetup paramaters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -e twofish [-N]        | -c twofish-cbc-plain -H plain [-s 256]
  -e twofish             | -c twofish-cbc-plain -H ripemd160 [-s 256]

Ditto for most other ciphers:

  -e aes [-N]            | -c aes-cbc-plain -H plain [-s 256]
  -e aes                 | -c aes-cbc-plain -H ripemd160 [-s 256]
...

Key size (Debian option -k, not upstream)

  -k 128                 | -s 128

Specifying offset, note losetup takes bytes, cryptsetup sectors.
Offset must be multiple of sectors (even in losetup).
SKip (-p) means offset for IV, you need specify both here.

  -o 2560                | -o 5 -p 5       # 2560/512 = 5

Even some esoteric configurations possible
(This example was default for some very old SuSe distro.)

Loop using twofish with only 160 bit key (zero padded to 192 bits) with no IV.

   cryptsetup -c twofish-cbc-null -s 192 -h ripemd160:20

Cryptsetup doesn't provide direct replacement for --pass-fd option
(pass file descriptor to read key) but you can use directly keyfile
option and keyfile size (see cryptsetup man page).

Also note, that cryptsetup allows mapping of loop-aes (multi-key) devices
(see loopaesOpen command in man page).
But this was never part of mainline kernel, so it is not important
for mainline cryptoloop replacement.

Thanks,
Milan
