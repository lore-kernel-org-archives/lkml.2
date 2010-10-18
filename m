Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0JRJbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:31:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44577 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0JRJbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pxJzKMiPo8DFpvP6jEDn2DPnl9mQ5ueL6Edn5g5UpkYSnEjlUVwGK9dVzrPTNwAWFJ
         0jZdyOGsHP3dVR/brb/Ig85WUHQhuf67p4arPy8HQRSwSCCb2rm6bNcMDtAYhCqbdoux
         2NOE3RNfTgsIxSYlcaBUXgfcF7IA7m0airQY4=
MIME-Version: 1.0
In-Reply-To: <201010181105.17077.toralf.foerster@gmx.de>
References: <201010131328.06465.toralf.foerster@gmx.de>
	<201010171555.40453.toralf.foerster@gmx.de>
	<20101017201837.GA16458@lst.de>
	<201010181105.17077.toralf.foerster@gmx.de>
Date: Mon, 18 Oct 2010 11:31:31 +0200
Message-ID: <AANLkTi=UyWg6PUrE_jEs0oqZ_tVw1mMQsoUrDnnqtcHa@mail.gmail.com>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 Toralf Förster <toralf.foerster@gmx.de>:
> Well, in addition to my last mail the following patch isn't a fix, but it
> might point to the culprit.
> If I apply this patch against latest tree, then the crash doesn't occur :
>
> diff --git a/include/linux/statfs.h b/include/linux/statfs.h
> index 0166d32..e336e70 100644
> --- a/include/linux/statfs.h
> +++ b/include/linux/statfs.h
> @@ -15,8 +15,8 @@ struct kstatfs {
>        __kernel_fsid_t f_fsid;
>        long f_namelen;
>        long f_frsize;
> -   long f_flags;
>        long f_spare[4];
> + long f_flags;
>  };
>
>
>
> Christoph Hellwig wrote at 22:18:37
>> On Sun, Oct 17, 2010 at 03:55:39PM +0200, Toralf F?rster wrote:
>> > I bisected it again w/ a fixed test script, got the same bad commit
>> > script and double checked, that this commit is really the culprit which
>> > crashes a user mode linux kernel at my 32bix x86 stable Gentoo running
>> > 2.6.35.6 vanilla kernel as host system and 2/ gcc version 4.4.3 (Gentoo
>> > 4.4.3-r2 p1.2) and glibc-2.11.2-r1 in the tool chain.
>>
>> I really can't see any relation to the patch.  Can you try the some
>> things in the following order, please:
>>
>>  (1) git-revert 365b18189789bfa1acd9939e6312b8a4b4577b28 on current
>>      Linus tree and see it it works.
>>      If it works try the next, else the bisect must have been a weird
>>      conicidence and I can't really help more.
>>  (2) re-apply only the changes to include/asm-generic/statfs.h from
>>      365b18189789bfa1acd9939e6312b8a4b4577b28 and see if that still
>>      boots.
>>  (3) re-apply the arch/mips/include/asm/statfs.h and
>>      arch/s390/include/asm/statfs.h changes and see if it still boots
>>  (4) re-apply the include/linux/statfs.h changes and see if it still
>>       boots
>>  (5) re-apply the fs/statfs.c changes, and by now it really shouldn't
>>      boot anymore
>>  (6) verify the code really is the same again as in current Linus' tree
>
>
> --
> MfG/Kind regards
> Toralf Förster
>
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Does this help?

--- linux-2.6.36-rc8/fs/hostfs/hostfs_user.c.orig       2010-10-18
11:24:33.844592000 +0200
+++ linux-2.6.36-rc8/fs/hostfs/hostfs_user.c    2010-10-18
11:24:44.594679000 +0200
@@ -388,6 +388,6 @@
        spare_out[1] = buf.f_spare[1];
        spare_out[2] = buf.f_spare[2];
        spare_out[3] = buf.f_spare[3];
-       spare_out[4] = buf.f_spare[4];
+
        return 0;
 }

-- 
Thanks,
//richard
