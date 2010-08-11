Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0HKIus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:50:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49020 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab0HKIur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U3EaroQVI/68H9FhiV0yw13BxmIk6Ye1zp3dBN4AZohXCJdxYo5l2uJvGbjBb1pMmk
         GpyFNhvN0g+OfXgF5bE8lmd8i+w4Tkpiu5cUuuT04+sV7ATwdEfwG3w7pDHiv0ZitlLF
         9SX+4ophlUrnJvksO7EJjHaOJ+9u6I4EhFrO0=
MIME-Version: 1.0
In-Reply-To: <20100811084828.GA5709@nb-core2.darkstar.lan>
References: <20100811084828.GA5709@nb-core2.darkstar.lan>
Date: Wed, 11 Aug 2010 18:50:45 +1000
Message-ID: <AANLkTimx0No2RgS8EdZCz=X8urJ8u4hVEVH5c1mcz_CW@mail.gmail.com>
Subject: Re: [DRM] BUG: sleeping function called from invalid context, drm_lastclose
From: Dave Airlie <airlied@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 6:48 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Hi Arnd,
> this commit:
>
> commit 58374713c9dfb4d231f8c56cac089f6fbdedc2ec
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Sat Jul 10 23:51:39 2010 +0200
>
>    drm: kill BKL from common code
>
>
> moved the call to (inside drm_release) drm_lastclose inside dev->count_lock
> spinlock.
> drm_lastclose however takes dev->struct_mutex (now inside an atomic
> context):

I have a patch from Chris Wilson that I need to push to fix this,
basically reducing the spin lock coverage,
and relying on the global mutex to handle the open race.

Dave.

>
> BUG: sleeping function called from invalid context at /home/kronos/src/linux-2.6.git/kernel/mutex.c:94
> in_atomic(): 1, irqs_disabled(): 0, pid: 3331, name: Xorg
> Pid: 3331, comm: Xorg Not tainted 2.6.35-06113-gf6cec0a #272
> Call Trace:
>  [<ffffffff8102770e>] __might_sleep+0xf8/0xfa
>  [<ffffffff8127cf18>] mutex_lock+0x1f/0x3e
>  [<ffffffffa052d1c1>] drm_lastclose+0x92/0x2ad [drm]
>  [<ffffffffa052dbc7>] drm_release+0x5ca/0x60d [drm]
>  [<ffffffff810b118f>] fput+0x130/0x1f7
>  [<ffffffff810ae77d>] filp_close+0x63/0x6d
>  [<ffffffff810ae82f>] sys_close+0xa8/0xe2
>  [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
>
>
> Luca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
