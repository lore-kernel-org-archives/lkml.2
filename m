Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0F3VY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:24:26 -0400
Received: from smtp-out.google.com ([74.125.121.35]:48009 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab0F3VYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:24:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RnvZzCt/lzDt6o8GBJSWGzxDg7k6IhzetEEW+DW7g56x0RSaWm3R82U2eNkcPj+Te
	i6ONqYPQdMX6KEw9/G1Nw==
MIME-Version: 1.0
In-Reply-To: <1277136847-13266-10-git-send-email-stefano@stabellini.net>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
	<1277136847-13266-10-git-send-email-stefano@stabellini.net>
Date: Wed, 30 Jun 2010 14:24:21 -0700
Message-ID: <AANLkTilecD4_542ftaoCIuAzlHgCI63i7rio9C-zuwZH@mail.gmail.com>
Subject: Re: [PATCH 10/13] Do not try to disable hpet if it hasn't been 
	initialized before
From: Venkatesh Pallipadi <venki@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stefano.Stabellini@eu.citrix.com, sheng@linux.intel.com,
       ddutile@redhat.com, jeremy@goop.org, stefano@stabellini.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks Good.
Acked-by: Venkatesh Pallipadi <venki@google.com>

Copying Thomas/Ingo/Peter.

On Mon, Jun 21, 2010 at 9:14 AM,  <stefano@stabellini.net> wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>
> hpet_disable is called unconditionally on machine reboot if hpet support
> is compiled in the kernel.
> hpet_disable only checks if the machine is hpet capable but doesn't make
> sure that hpet has been initialized.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/kernel/hpet.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 23b4ecd..2b299da 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -959,16 +959,18 @@ fs_initcall(hpet_late_init);
>
>  void hpet_disable(void)
>  {
> -       if (is_hpet_capable()) {
> -               unsigned int cfg = hpet_readl(HPET_CFG);
> +       unsigned int cfg;
>
> -               if (hpet_legacy_int_enabled) {
> -                       cfg &= ~HPET_CFG_LEGACY;
> -                       hpet_legacy_int_enabled = 0;
> -               }
> -               cfg &= ~HPET_CFG_ENABLE;
> -               hpet_writel(cfg, HPET_CFG);
> +       if (!is_hpet_capable() || !hpet_address || !hpet_virt_address)
> +               return;
> +
> +       cfg = hpet_readl(HPET_CFG);
> +       if (hpet_legacy_int_enabled) {
> +               cfg &= ~HPET_CFG_LEGACY;
> +               hpet_legacy_int_enabled = 0;
>        }
> +       cfg &= ~HPET_CFG_ENABLE;
> +       hpet_writel(cfg, HPET_CFG);
>  }
>
>  #ifdef CONFIG_HPET_EMULATE_RTC
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
