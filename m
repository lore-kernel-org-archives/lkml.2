Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1C2UYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:24:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43505 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1C2UYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=obGPhLiFcVD7p8mHZSZqzFn6jGKcMQxx2bDE6Of+0qqnrEJox35bG5a/B5IZBpK3LO
         nD3uu8HqaIrWZOpXRl/NrvueJAomngMj2Bi6waL6khN5ATd0eWTxJI5kxPD3TBrONr3o
         1c5KImmlTTCCliBM3bOVRo0dXTzWraEHIsz9Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz>
	<AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
	<alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz>
	<AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com>
	<alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz>
Date: Tue, 29 Mar 2011 22:24:21 +0200
X-Google-Sender-Auth: exkcxuKY9WHRsKiTAr4Vqj3zMlw
Message-ID: <AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com>
Subject: Re: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound
 computation for COMPAT_BRK
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, Mar 28, 2011 at 16:20, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 26 Mar 2011, Geert Uytterhoeven wrote:
>> >> | RAMDISK: gzip image found at block 0
>> >> | VFS: Mounted root (ext2 filesystem) readonly on device 1:0.
>> >> | warning: process `update' used the obsolete bdflush system call
>> >> | Fix your initscripts?
>> >> | init: cannot open inittab
>> >> | Kernel panic - not syncing: Attempted to kill init!

> Hmm, I think we'd need some refresh on what the ancient libc5-based
> binaries are actually doing.
>
> Could you please send me strace of this application (restricting it to
> brk()/mmap() calls should be enough).

I managed to reproduce it inside ARAnyM, by chrooting into the ramdisk image.
After adding strace, "strace /sbin/init" for the success case gives:

old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xc0004000
old_mmap(NULL, 578, PROT_READ, MAP_SHARED, 3, 0) = 0xc0007000
old_mmap(NULL, 663552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc0008000
old_mmap(0xc0008000, 426908, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_FIXED, 3, 0) = 0xc0008000
old_mmap(0xc0072000, 24256, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED, 3, 0x68000) = 0xc0072000
old_mmap(0xc0078000, 204696, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xc0078000
brk(0x80005c8e)                         = 0x80005c8e
brk(0x80006000)                         = 0x80006000
old_mmap(NULL, 1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xc0007000

For the failure case:

old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xc0004000
old_mmap(NULL, 578, PROT_READ, MAP_SHARED, 3, 0) = 0xc0007000
old_mmap(NULL, 663552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc0008000
old_mmap(0xc0008000, 426908, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_FIXED, 3, 0) = 0xc0008000
old_mmap(0xc0072000, 24256, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED, 3, 0x68000) = 0xc0072000
old_mmap(0xc0078000, 204696, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xc0078000
brk(0x80005c8e)                         = 0x80006000

Major difference:

-brk(0x80005c8e)                         = 0x80005c8e
-brk(0x80006000)                         = 0x80006000
-open("/etc/inittab", O_RDONLY)          = 3
-fstat(3, {st_mode=S_IFREG|0644, st_size=140, ...}) = 0
-old_mmap(NULL, 1024, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xc0007000
-read(3, "tty1:console:/sbin/getty 9600 tt"..., 1024) = 140
-read(3, "", 1024)                       = 0
+brk(0x80005c8e)                         = 0x80006000
+open("/dev/console", O_WRONLY)          = 3
+write(3, "init: ", 6)                   = 6
+write(3, "cannot open inittab\n", 20)   = 20
 close(3)                                = 0

Seems like the binary doesn't like brk() rounding up the requested
value to the next page...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
