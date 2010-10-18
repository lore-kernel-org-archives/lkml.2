Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab0JRTns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:43:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50773 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965Ab0JRTnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dGdjuw9CfmEa+yNRlmfPcXOohKcXNAdKEIz9SM1+JFdJ581lqfyrdFwKCScZpK7aUG
         pUCeQPWT+glaa/P0X5/OTZd96iYgA9wtvcNB9rahBh8G9c5vvsb/ZnGpq3g5V/Y1HKEN
         zDfTcl9bmR/EQaCcSS3eyoyzW5ckZbSUVphRo=
MIME-Version: 1.0
In-Reply-To: <201010182131.33385.richard@nod.at>
References: <1287419814-20086-1-git-send-email-richard@nod.at>
	<20101018114039.503233da.akpm@linux-foundation.org>
	<AANLkTimpmcZEV-V6rhZtJXnXLdtB_HRTxM+ExM-YyWmh@mail.gmail.com>
	<201010182131.33385.richard@nod.at>
Date: Mon, 18 Oct 2010 21:43:44 +0200
X-Google-Sender-Auth: yNQSy_PMRRTFT66ZlLUUjNEm2QE
Message-ID: <AANLkTim1sUog=5cDRHRxRhg6P0QKCe-SkNMTAgmNa3Qt@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 1/1] hostfs: fix UML crash
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, toralf.foerster@gmx.de,
        jdike@addtoit.com, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 21:31, Richard Weinberger <richard@nod.at> wrote:
> Am Montag 18 Oktober 2010, 21:22:31 schrieb Geert Uytterhoeven:
>> On Mon, Oct 18, 2010 at 20:40, Andrew Morton <akpm@linux-foundation.org>
> wrote:
>> > On Mon, 18 Oct 2010 18:36:54 +0200 Richard Weinberger <richard@nod.at>
> wrote:
>> >> 365b1818 resized f_spare within struct statfs.
>> >> hostfs accesses f_spare directly and needs an update.
>> >>
>> >> Signed-off-by: Richard Weinberger <richard@nod.at>
>> >> Reported-by: Toralf F__rster <toralf.foerster@gmx.de>
>> >> Tested-by: Toralf F__rster <toralf.foerster@gmx.de>
>> >> ---
>> >>  fs/hostfs/hostfs_user.c |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
>> >> index 6777aa0..ce2f168 100644
>> >> --- a/fs/hostfs/hostfs_user.c
>> >> +++ b/fs/hostfs/hostfs_user.c
>> >> @@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long
>> >> *blocks_out, spare_out[1] = buf.f_spare[1];
>> >>       spare_out[2] = buf.f_spare[2];
>> >>       spare_out[3] = buf.f_spare[3];
>> >> -     spare_out[4] = buf.f_spare[4];
>> >> +
>> >>       return 0;
>> >>  }
>> >
>> > Thanks.
>> >
>> > Is there any reason for hostfs to be playing with the f_spare field at
>> > all?
>>
>> It just copies it from struct statfs64 on the host to struct kstatfs
>> on the guest.
>> Probably a memcpy() is more future-safe, if it's combined with a
>> BUILD_BUG_ON(sizeof(statfs64.f_spare) != sizeof(kstatfs.f_spare)).
>>
>> Still, currently it doesn't copy the recently added f_flags field.
>> To protect against future changes like that, an explicit
>> BUILD_BUG_ON(sizeof(kstatfs.f_spare) != 4*sizeof(long)) may be even
>> better...
>
> Anyway, why do we need to copy f_spare from the host to the guest?
> I'm quite sure it can be omitted.

I guess it wants to preserve fields that are added in the future,
which may be useful
if the host is more recent than the guest.

Still, even if you don't want to preserve them, you probably want to clear them,
so memset() is better than a fixed loop through 4 elements.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
