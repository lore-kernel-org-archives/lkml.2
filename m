Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0H0Wfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:35:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50735 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab0H0Wfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tehxNN4m5ezmnNl+mMccNHqBrYTIm1X6ayYVwklH+fd0rvoHWGzJw2plH2MUq6EIzg
         zRw56pibI9apXauzfIkXGUnZktEj+3Dtx7ZaT4fp+5zYbVipjQun+POUQn+mUorSoYob
         NNgWyDLNLvVeltX9m8Jtyu9XuhmfIHNAuqUas=
MIME-Version: 1.0
In-Reply-To: <20100827212254.GB32275@bougret.hpl.hp.com>
References: <20100827210240.GC4703@outflux.net> <20100827212254.GB32275@bougret.hpl.hp.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 27 Aug 2010 15:35:19 -0700
Message-ID: <AANLkTimeEa_=dqX5yFnYzaSaL90TfOg3=MsydG81naAC@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix 64K kernel heap content leak via ioctl
To: jt@hpl.hp.com
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 2:22 PM, Jean Tourrilhes <jt@hpl.hp.com> wrote:
> On Fri, Aug 27, 2010 at 02:02:41PM -0700, Kees Cook wrote:
>> This problem was originally tracked down by Brad Spengler.
>>
>> When calling wireless ioctls, if a driver does not correctly
>> validate/shrink iwp->length, the resulting copy_to_user can leak up to
>> 64K of kernel heap contents.
>>
>> It seems that this is triggerable[1] in 2.6.32 at least on ath5k, but
>> I was not able to track down how. The twisty maze of ioctl handlers
>> stumped me. :)
>
>        You can always ask.
>
>> Other drivers I checked did not appear to have any problems,
>> but the potential remains. I'm not sure if this patch is the right approach;
>> it was fixed differently[2] in grsecurity.
>
>        Did you tried your patch for real ? With large scan request ?
>        I ask because at first glance, it looks incorrect, asI believe
> it kills large request. But someone would need to test, for sure.
>
>> [1] http://forums.grsecurity.net/viewtopic.php?f=3&t=2290&start=0
>> [2] http://grsecurity.net/~spender/wireless-infoleak-fix2.patch
>
>        I believe this patch would make the situation worse.
>
>        Would you mind validating the following patch ? I've just
> verified that it compiles and I believe it does what you are asking in
> a much more predictable way.
>        Regards,
>
>        Jean
>
> diff -u -p wext.j2.c wext.c
> --- wext.j2.c   2010-08-27 14:17:26.000000000 -0700
> +++ wext.c      2010-08-27 14:19:33.000000000 -0700
> @@ -800,9 +800,12 @@ static int ioctl_standard_iw_point(struc
>                        goto out;
>                }
>
> -               if (copy_to_user(iwp->pointer, extra,
> -                                iwp->length *
> -                                descr->token_size)) {
> +               /* Verify how much we should return. Some driver
> +                * may abuse iwp->length... */
> +               if((iwp->length * descr->token_size) < extra_size)
> +                       extra_size = iwp->length * descr->token_size;
> +
> +               if (copy_to_user(iwp->pointer, extra, extra_size)) {
>                        err = -EFAULT;
>                        goto out;
>                }


Jean, can you submit in a new thread and right before the SOB add in
the commit log Cc: stable@kernel.org [2.6.32+]

  Luis
