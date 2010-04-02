Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab0DBHOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:14:55 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:40779 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab0DBHOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PEiOcSmzRZHRQKW1xkeDg3hbUdjJAo2Wa2BO2YG2f0Hyr391AWrM4FYg1/Q/Mu+6Hi
         PsNYd6jjixb/pwx19TqftrF9Zrmb8yUyBVAXPp2Kq+a3jWliStlK6ykUC+Qeb7r8zJja
         kMJUpeNpSLbGBzDOTAmJHO5l+1aSDlGpsg5L0=
MIME-Version: 1.0
In-Reply-To: <20100330092132.GB2713@localhost.localdomain>
References: <20100330092132.GB2713@localhost.localdomain>
Date: Fri, 2 Apr 2010 15:14:42 +0800
Message-ID: <x2o7b6bb4a51004020014xb9ce0784ifdb255c28c6aa02d@mail.gmail.com>
Subject: Re: [PATCH] Block: Fix block/elevator.c elevator_get() off-by-one 
	error
From: Xiaotian Feng <xtfeng@gmail.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 5:21 PM,  <wzt.wzt@gmail.com> wrote:
> elevator_get() not check the name length, if the name length > sizeof(elv),
> elv will miss the '\0'. And elv buffer will be replace "-iosched" as something
> like aaaaaaaaa, then call request_module() can load an not trust module.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>
> ---
>  block/elevator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/block/elevator.c b/block/elevator.c
> index df75676..76e3702 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -154,7 +154,7 @@ static struct elevator_type *elevator_get(const char *name)
>
>                spin_unlock(&elv_list_lock);
>
> -               sprintf(elv, "%s-iosched", name);
> +               snprintf(elv, sizeof(elv), "%s-iosched", name);
>

elv is defined as char elv[ELV_NAME_MAX + strlen("-iosched")];
so if name length > sizeof(elv), the name length must already bigger
than ELV_NAME_MAX

elevator_get is used in elevator_init, so if elevator_init is passing
a super long name, why not just return -EINVAL?
In this patch, if we pass a super long name, we're still trying to cut
it and request_module an invalid name, right?
Although '\0' is kept, but name is still invalid, right?


>                request_module("%s", elv);
>                spin_lock(&elv_list_lock);
> --
> 1.6.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
