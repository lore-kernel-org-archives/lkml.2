Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0FSApy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 20:45:54 -0400
Received: from smtp-out.google.com ([74.125.121.35]:5939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0FSApx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 20:45:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WlougpIvNNhr0nwKVXVXE7v+cYBCUQoi0fwk3+hgCE5rhtVIJ/F37t9GygTJDqiAd
	CjDz6PwvZqTLviP0ZzpjQ==
MIME-Version: 1.0
In-Reply-To: <1276700102-18254-1-git-send-email-leonardoaltt@gmail.com>
References: <1276700102-18254-1-git-send-email-leonardoaltt@gmail.com>
Date: Fri, 18 Jun 2010 17:45:49 -0700
Message-ID: <AANLkTimTqgTMvHfChqJSqEi-Lkh6flS2rhvudvRpOzZv@mail.gmail.com>
Subject: Re: [PATCH] x86, hpet.c: Changed type of field work of 
	hpet_work_struct (delayed_work to work_struct)
From: Venkatesh Pallipadi <venki@google.com>
To: =?ISO-8859-1?Q?Leonardo_de_S=E1_Alt?= <leonardoaltt@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Acked-by: Venkatesh Pallipadi <venki@google.com>

On Wed, Jun 16, 2010 at 7:55 AM, Leonardo de Sá Alt
<leonardoaltt@gmail.com> wrote:
> Hi Venki,
> here the new patch with the changes you requested.
>
> Thanks.
>
> The hpet_work_struct has a delayed_work (field work), but it doesn't use
> delay. So this field type was changed for work_struct, and its utilizations
> as delayed_work were adapted to work_struct.
>
> Signed-off-by: Leonardo de Sá Alt <leonardoaltt@gmail.com>
>
> ---
>  arch/x86/kernel/hpet.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index a198b7c..b05935f 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -696,7 +696,7 @@ static struct hpet_dev *hpet_get_unused_timer(void)
>  }
>
>  struct hpet_work_struct {
> -       struct delayed_work work;
> +       struct work_struct work;
>        struct completion complete;
>  };
>
> @@ -706,7 +706,7 @@ static void hpet_work(struct work_struct *w)
>        int cpu = smp_processor_id();
>        struct hpet_work_struct *hpet_work;
>
> -       hpet_work = container_of(w, struct hpet_work_struct, work.work);
> +       hpet_work = container_of(w, struct hpet_work_struct, work);
>
>        hdev = hpet_get_unused_timer();
>        if (hdev)
> @@ -724,12 +724,10 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
>
>        switch (action & 0xf) {
>        case CPU_ONLINE:
> -               INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
> +               INIT_WORK_ON_STACK(&work.work, hpet_work);
>                init_completion(&work.complete);
> -               /* FIXME: add schedule_work_on() */
> -               schedule_delayed_work_on(cpu, &work.work, 0);
> +               schedule_work_on(cpu, &work.work);
>                wait_for_completion(&work.complete);
> -               destroy_timer_on_stack(&work.work.timer);
>                break;
>        case CPU_DEAD:
>                if (hdev) {
> --
> 1.6.3.3
>
>
