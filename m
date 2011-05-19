Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1ESN2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:28:07 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36343 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755990Ab1ESN2G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rfJM1fFfhw/xbGOaneq0E8OHmZGFpIINURpweiMCa3tuapRRuwQviuk6/bSpuyq+Je
         vxeI0lrTi239gEHO8iXMRSstFUBYg4BrH5uyjHjaGmrsvl4zG6QyWUdI7N28ULBYU3yi
         1AR2LlbqelmV1Ky0lw+7Cke4EzKNGa09UBe/Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=+V7PR_29pK3ooVggPmeicCG0eWg@mail.gmail.com>
References: <1305196419.2713.84.camel@localhost>
	<1305751647-3122-1-git-send-email-bengardiner@nanometrics.ca>
	<BANLkTi=+V7PR_29pK3ooVggPmeicCG0eWg@mail.gmail.com>
Date: Thu, 19 May 2011 09:28:00 -0400
Message-ID: <BANLkTi=nmvdKNaNDCUUZQF3QX-jDydTSng@mail.gmail.com>
Subject: Re: [PATCH] UBIFS: don't fail on -EBADMSG when fixing free space
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Matthew L. Creech" <mlcreech@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Wed, May 18, 2011 at 5:41 PM, Matthew L. Creech <mlcreech@gmail.com> wrote:
> On Wed, May 18, 2011 at 4:47 PM, Ben Gardiner
> <bengardiner@nanometrics.ca> wrote:
>> +       /*
>> +        * Don't fail on -EBADMSG since these are precisely the error codes that
>> +        * are returned by ubi_red in the cases where free-space fix-ups are
>> +        * required.
>> +        */
>
> Hi Ben,
>
> Off-hand, I don't see how this comment can be true.  It seems like
> we'll have 2 cases:
>
> 1. The pages in question are actually erased, in which case they'll be
> 0xff-filled by ubi_read() without error, or
> 2. The pages were programmed with all 0xff data, in which case the ECC
> info should be correct
>
> There's a third possibility, that the ECC info is bad because there's
> a real error, but that's not something we can reliably recover from.
> Am I overlooking another scenario?

Perhaps I am running into a nuance of the davinci nand driver. Back
when you started the 'Programming ubinized images' thread [1] some of
you problem description caught me eye:

On Mon, Apr 25, 2011 at 2:37 PM, Matthew L. Creech <mlcreech@gmail.com> wrote:
> We encountered one case in which we were re-flashing a device for
> testing using U-Boot's "nand erase", and got the "ubi_io_read: error
> -74" error from the FAQ.  That's no big deal, since we never do this
> in the field, and clearly "nand erase" isn't something we'd want to do
> even without this problem since it loses erase-counter info.

Because the "ubi_io_read: error -74 (ECC error)" is precisely what I
am encountering on my hardware when I do not flash with a utility that
drops empty pages at the end of eraseblocks. I imagined that this was
also the case for you. But I have also read that there are
peculiarities of the davinci nand driver (both in u-boot and linux).

So, at least on my hardware, the -74 error is expected when the 0xff
pages are not dropped and so without the 'err != -EBADMSG' exception
the free space fixup will cause the volume to fail mount for me:

UBIFS: start fixing up free space
UBI error: ubi_io_read: error -74 (ECC error) while reading 4096 bytes
from PEB 18:4096, read 4096 bytes
VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0)
[...]

Whereas, when the same image is flashed using a u-boot 'nand write'
variant that drops 0xff pages [2] there are no such -74 errors
encountered.

UBIFS: start fixing up free space
UBIFS: free space fixup complete
UBIFS: mounted UBI device 0, volume 1, name "rootfs"
[...]

The nand I am using is the micron part that ships with the da850evm;
it has eraseblocks of 128KiB and pages of 2048. Here is a dump of
eraseblock 18 from the ubinized image:

00240000  55 42 49 23 01 00 00 00  00 00 00 00 00 00 00 00  |UBI#............|
00240010  00 00 08 00 00 00 10 00  04 6c 24 45 00 00 00 00  |.........l$E....|
00240020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00240030  00 00 00 00 00 00 00 00  00 00 00 00 38 be e8 75  |............8..u|
00240040  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00240800  55 42 49 21 01 01 00 00  00 00 00 01 00 00 00 01  |UBI!............|
00240810  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00240830  00 00 00 00 00 00 00 00  00 00 00 00 5f 7f ac 08  |............_...|
00240840  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00241000  31 18 10 06 5f 3f 84 94  65 32 01 00 00 00 00 00  |1..._?..e2......|
00241010  00 02 00 00 07 00 00 00  53 2a 00 00 00 00 00 00  |........S*......|
00241020  00 00 00 00 00 00 00 00  02 00 00 00 03 00 00 00  |................|
00241030  f0 01 00 00 e0 8a 01 00  44 00 00 00 e3 01 00 00  |........D.......|
00241040  f0 01 00 00 00 90 01 00  b0 c7 18 00 00 00 00 00  |................|
00241050  00 18 05 00 00 00 00 00  00 49 05 00 00 00 00 00  |.........I......|
00241060  50 77 8a 03 00 00 00 00  78 fc 04 00 00 00 00 00  |Pw......x.......|
00241070  78 b8 01 00 00 00 00 00  08 00 00 00 12 0a 00 00  |x...............|
00241080  08 00 00 00 00 10 00 00  08 00 00 00 1e 0a 00 00  |................|
00241090  00 00 00 00 00 00 00 00  0b 00 00 00 01 00 00 00  |................|
002410a0  0d 00 00 00 f1 01 00 00  00 00 00 00 00 00 00 00  |................|
002410b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00241200  31 18 10 06 ef de 0e ee  00 00 00 00 00 00 00 00  |1...............|
00241210  1c 00 00 00 05 00 00 00  e4 05 00 00 00 00 00 00  |................|
00241220  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00241800  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00260000  55 42 49 23 01 00 00 00  00 00 00 00 00 00 00 00  |UBI#............|
00260010  00 00 08 00 00 00 10 00  04 6c 24 45 00 00 00 00  |.........l$E....|
00260020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00260030  00 00 00 00 00 00 00 00  00 00 00 00 38 be e8 75  |............8..u|
00260040  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00260800  55 42 49 21 01 01 00 00  00 00 00 01 00 00 00 02  |UBI!............|
[...]

The data between 0x00241800 and 0x00260000 is all 0xff, so there are
trailing empty pages in this block.

Here is a u-boot nand-dump of eraseblock 18 + 0x1800 when flashed
using the usual u-boot 'nand write':
        ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
[...]
        ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
OOB:
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        3f 27 56 f5 29 d8 61 d9
        9d 14 3f 27 56 f5 29 d8
        61 d9 9d 14 3f 27 56 f5
        29 d8 61 d9 9d 14 3f 27
        56 f5 29 d8 61 d9 9d 14

and here it is again when flashed with the 'nand write' variant that
drops 0xff pages [2]:

        ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
[...]
        ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
OOB:
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff
        ff ff ff ff ff ff ff ff

The former state of eraseblock 18 causes "ubi_io_read: error -74 (ECC
error)" during free-space-fixup and the latter does not.

So I guess my particular situation is a problem with the davinci nand
driver's ECC for 0xFF data and is _not_ covered by the free space
fixup? It would be really nice if the free space fixup supported both
1) setups that are such that the flash cannot be written to more than
once and 2) setups that are such that they return bogus -74 errors.
Both are caused by not dropping trailing 0xff pages when writing.

Best Regards,
Ben Gardiner

[1] http://article.gmane.org/gmane.linux.drivers.mtd/34890
[2] http://article.gmane.org/gmane.comp.boot-loaders.u-boot/98740

---
Nanometrics Inc.
http://www.nanometrics.ca
