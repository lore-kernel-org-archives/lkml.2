Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1BBNXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:23:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1BBNXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:23:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OnEiCU+/bSB2eJ32pY2mQpZgoHuKc0lQS0fLtPV2aaSyOLmvJ2mvXbCdksx/XWoNx+
         wjOu8HvblT541iJvc+ZHIOEOs54TENIzflFp4tkXh22+8+pKmYYNsDnYF56+YTQ6KYuS
         cxDerBWieLWGcGzTGhfurgEgUTiHkG2YEsROo=
MIME-Version: 1.0
In-Reply-To: <1296651097-29288-1-git-send-email-glommer@redhat.com>
References: <1296651097-29288-1-git-send-email-glommer@redhat.com>
Date: Wed, 2 Feb 2011 11:23:43 -0200
Message-ID: <AANLkTimgKG=fB6ZTL2LrXTwz0OMMcYWH5TLtYg7Pfwcn@mail.gmail.com>
Subject: Re: [PATCH] use guest value of version field in kvmclock
From: Glauber Costa <glommer@gmail.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 10:51 AM, Glauber Costa <glommer@redhat.com> wrote:
> Avi noticed that we have to use guest's value for the version field,
> instead of keeping track of it ourselves. If we don't do that,
> the following situation can arise:
>
>  vcpu->arch.hv_clock.version is initialized to zero.
>  Guest reads version (result: 2)
>  Guest starts reading data
>  Live migration; vcpu->arch.hv_clock.version is zeroed
>  Steal time update; vcpu->arch.hv_clock.version += 2; write to guest
>  Guest continues reading data
>  Guest reads version (result: 2)
Please ignore it. I did test this patch but appearently used the wrong
module, and it tricked me
this version is obviously wrong.

>
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/kvm/x86.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c39ab4a..7fdc84a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1151,15 +1151,18 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>        vcpu->last_guest_tsc = tsc_timestamp;
>        vcpu->hv_clock.flags = 0;
>
> +       shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
> +
>        /*
>         * The interface expects us to write an even number signaling that the
>         * update is finished. Since the guest won't see the intermediate
> -        * state, we just increase by 2 at the end.
> +        * state, we just increase by 2 at the end. We use the guest's value as
> +        * a basis to make it migration-safe.
>         */
> +       memcpy(&vcpu->hv_clock, shared_kaddr + vcpu->time_offset,
> +              sizeof(vcpu->hv_clock));
>        vcpu->hv_clock.version += 2;
>
> -       shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
> -
>        memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
>               sizeof(vcpu->hv_clock));
>
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Sent from my Atari.
