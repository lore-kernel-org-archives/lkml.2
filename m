Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0H2Sa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:30:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35277 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0H2Sa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v2sA9d47tqLT6SOMNe5SFnqqZt7hoeIx51mAgvdJZMByr/gVEJzhEtCKhlq979mM9a
         nmDx6lo5o7cfKDTSMuGehOxO47jFmByRz7eD6ckHpsvjRYAZdEjv1g8LLEI5RdOvAzjT
         eYnUrGjiNhNnElEO0SUO38PrDesZWGGOfh8Ig=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-3-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-3-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:29:40 +0300
X-Google-Sender-Auth: xLN5lUkBt-m8qAzAYpb0qVH8eW0
Message-ID: <AANLkTinReUPW4auBZCHVZcHfZfMxEOa1qmaY+npV=UPY@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: Merge fpu_init()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> @@ -80,7 +80,6 @@ static void __cpuinit init_thread_xstate(void)
>  #endif
>  }
>
> -#ifdef CONFIG_X86_64
>  /*
>  * Called at bootup to set up the initial FPU state that is later cloned
>  * into all processes.
> @@ -88,12 +87,20 @@ static void __cpuinit init_thread_xstate(void)
>
>  void __cpuinit fpu_init(void)
>  {
> -       unsigned long oldcr0 = read_cr0();
> +       unsigned long cr0;
> +       unsigned long cr4_mask = 0;
>
> -       set_in_cr4(X86_CR4_OSFXSR);
> -       set_in_cr4(X86_CR4_OSXMMEXCPT);
> +       if (cpu_has_fxsr)
> +               cr4_mask |= X86_CR4_OSFXSR;
> +       if (cpu_has_xmm)
> +               cr4_mask |= X86_CR4_OSXMMEXCPT;
> +       set_in_cr4(cr4_mask);

Is calling set_in_cr4() unconditionally safe for 32-bit CPUs that
don't have cr4? AFAICT, no, because it uses read_cr4().
