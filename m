Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab0JRTWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:22:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57728 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab0JRTWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eUkVaw4fD1t9nuympqQPnkQhNJGUej7CwlCdlow1PE5kVtxN2/0Nsu3dOr4hmOuoEW
         igvLgNd03KWYBekHhWLs5Pufqn7HRGRkjs7uBpYEGBoei0PW7Va3MfOsHbc6LW73oZGn
         iw2MN3dcpfUTb2oQNsPd2k2TataXhhsje+6Ig=
MIME-Version: 1.0
In-Reply-To: <20101018114039.503233da.akpm@linux-foundation.org>
References: <1287419814-20086-1-git-send-email-richard@nod.at>
	<20101018114039.503233da.akpm@linux-foundation.org>
Date: Mon, 18 Oct 2010 21:22:31 +0200
X-Google-Sender-Auth: Kw5MtObK2w31qmQgiipEWK8HB30
Message-ID: <AANLkTimpmcZEV-V6rhZtJXnXLdtB_HRTxM+ExM-YyWmh@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 1/1] hostfs: fix UML crash
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, toralf.foerster@gmx.de,
        jdike@addtoit.com, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 20:40, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 18 Oct 2010 18:36:54 +0200 Richard Weinberger <richard@nod.at> wrote:
>> 365b1818 resized f_spare within struct statfs.
>> hostfs accesses f_spare directly and needs an update.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> Reported-by: Toralf F__rster <toralf.foerster@gmx.de>
>> Tested-by: Toralf F__rster <toralf.foerster@gmx.de>
>> ---
>>  fs/hostfs/hostfs_user.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
>> index 6777aa0..ce2f168 100644
>> --- a/fs/hostfs/hostfs_user.c
>> +++ b/fs/hostfs/hostfs_user.c
>> @@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long *blocks_out,
>>       spare_out[1] = buf.f_spare[1];
>>       spare_out[2] = buf.f_spare[2];
>>       spare_out[3] = buf.f_spare[3];
>> -     spare_out[4] = buf.f_spare[4];
>> +
>>       return 0;
>>  }
>
> Thanks.
>
> Is there any reason for hostfs to be playing with the f_spare field at all?

It just copies it from struct statfs64 on the host to struct kstatfs
on the guest.
Probably a memcpy() is more future-safe, if it's combined with a
BUILD_BUG_ON(sizeof(statfs64.f_spare) != sizeof(kstatfs.f_spare)).

Still, currently it doesn't copy the recently added f_flags field.
To protect against future changes like that, an explicit
BUILD_BUG_ON(sizeof(kstatfs.f_spare) != 4*sizeof(long)) may be even
better...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
