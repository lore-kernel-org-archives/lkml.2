Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1I1Qi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:38:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57206 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1I1Qi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwf3iOwyDDxjKbJ0fs=fy+-8mkoFHdgsEq32nAkerXS4g@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
	<CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
	<CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
	<CACqU3MU8jkysNxFasdfy9ksqSo2ojiZ5LUwfcfX13MMRgVx2Xw@mail.gmail.com>
	<CACqU3MWyCknNH3xmVmbJJu+w9ugNc3e4K3e3_6cY1RAy4ynJCQ@mail.gmail.com>
	<CA+55aFxp8bNhLs+v69gp7XxBGq6wkmLkZKjB2_09H3qsZC_pzw@mail.gmail.com>
	<CACqU3MUbiQW3E8GeSbzkikMqvV1VKAnF2Ro-P2BWwih=s6vABA@mail.gmail.com>
	<CA+55aFwf3iOwyDDxjKbJ0fs=fy+-8mkoFHdgsEq32nAkerXS4g@mail.gmail.com>
Date: Wed, 28 Sep 2011 12:38:56 -0400
Message-ID: <CACqU3MX_OAAiuUZh-qFVLTJVGAp_jTS+d3Lc-T_E0XTj=xa=Zg@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 28, 2011 at 11:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 27, 2011 at 10:34 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> <off-topic>
>> Speaking of corruption, I'm encountering another set on an external
>> hard-drive, connected through USB.
>
> I don't think it's unrelated or off-topic.
>
>>     The same corruption pop up (at least in those text file): a
>> sequence of 4 bytes is replaced by 0x000000E0 at offset 0x1E4 of the
>> start of the file for some of them, 0x3E4 for two other (same
>> corruption though). Locating the corruption will be more tricky in
>> binary files.
>
> So it's possible that it's some rogue kernel pointer. We've certainly
> had those before. Constants offsets like that happen with some
> structure allocation that just happens to be say 1kB in size, and the
> rogue kernel pointer assigns at a fixed offset to something that has
> already been free'd.
>
> You might want to try to compile the kernel with SLUB_DEBUG_ON set,
> and possibly also DEBUG_PAGEALLOC.
>
I'll give it a try.

> HOWEVER. It's quite possible that it's hardware too.
>
Yes.

>> I may not trust the drive, but the fact that only known offset are
>> corrupted (in text files), the exact same way, sounds too much of a
>> coincidence. Anyway, I started a long SMART self test to see if it
>> catches anything, as there was no DMA transfer error[0].
>
> It *could* be the disk, but it's much more likely to be something like
> memory or a bad cable. Which wouldn't show up with SMART, since that
> just tests internal disk issues.
>
At some point I did not trust the internal disk, but SMART tests
(`short', `'long', `conveyance') passed successfully. I'd assume that
a bad cable issue between the USB adapter and the disk would be caught
by the UDMA_CRC_Error_Count counter (it already did), and would be
somehow truly random. I'm not sure if USB do any kind of data checksum
between the host and the device. I'd assume so.

> Do you get some occasional random SIGSEGV's too?
>
Over the last month, not much, mostly chrome (unstable version), and WIP stuff:

# sed -r '/kernel:.*segfault/!d; s/.*kernel:.* ([a-z]+)\[.*/\1/'
/var/log/messages* | sort | uniq -c
      4 chrome
      5 conf
     19 nconf

However, the list of program which dumped core is different:
# sed '/core dump/!d; s/.*(\(.*\)) to .*/\1/' /var/log/messages* |
sort | uniq -c
      1 /bin/zsh
      1 /src/linux/linux/scripts/kconfig/conf
     24 /src/linux/linux/scripts/kconfig/nconf
      1 /opt/google/chrome/chrome
      2 /usr/bin/evince
      1 /usr/bin/mplayer
     45 /usr/lib64/nspluginwrapper/npviewer.bin

Comparatively, on another machine (F15, 2.6.40.4, chromium
13.0.782.215), same time period:

# sed -r '/kernel:.*segfault/!d; s/.*kernel:.* ([a-z\.-]+)\[.*/\1/'
/var/log/messages* | sort | uniq -c
      1 aplay
     33 chromium-browser

and no specific core dump listed (my setup may be wrong).

I'll try to gather more information.

Thanks,
 - Arnaud

>                        Linus
>
