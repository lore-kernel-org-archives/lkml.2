Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0KOX3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:29:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab0KOX3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZWHcukhrXiXFFUxc6L3L/cML3caYfIeVBxOPRCz78ufX5v4lQgHn+LC4ko1wLCzrJv
         cSIAzrWs91cmIHMeqLJo0gU23yyKl67YqH+G4OJV3IrSr1qKwTipVUct39HJ/UH4uOrS
         RpsWgjrgOGvSnOFhoZukm4eTOP3BBfcBSK4Lc=
MIME-Version: 1.0
In-Reply-To: <20101113023435.GB2713@localhost.localdomain>
References: <20101113023435.GB2713@localhost.localdomain>
Date: Tue, 16 Nov 2010 07:29:30 +0800
Message-ID: <AANLkTikrdQw1h=efa7EtnXCbQ5APT0PtWdaCUA83T5pN@mail.gmail.com>
Subject: Re: [PATCH] APPARMOR: code cleanup on context.h
From: wzt wzt <wzt.wzt@gmail.com>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, john, any comments?

On Sat, Nov 13, 2010 at 10:34 AM,  <wzt.wzt@gmail.com> wrote:
> Use current api to replace old codes.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>
> ---
>  security/apparmor/include/context.h |   34 +++++++++++++++-------------------
>  1 files changed, 15 insertions(+), 19 deletions(-)
>
> diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
> index a9cbee4..c9112f3 100644
> --- a/security/apparmor/include/context.h
> +++ b/security/apparmor/include/context.h
> @@ -82,23 +82,6 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token);
>  int aa_restore_previous_profile(u64 cookie);
>
>  /**
> - * __aa_task_is_confined - determine if @task has any confinement
> - * @task: task to check confinement of  (NOT NULL)
> - *
> - * If @task != current needs to be called in RCU safe critical section
> - */
> -static inline bool __aa_task_is_confined(struct task_struct *task)
> -{
> -       struct aa_task_cxt *cxt = __task_cred(task)->security;
> -
> -       BUG_ON(!cxt || !cxt->profile);
> -       if (unconfined(aa_newest_version(cxt->profile)))
> -               return 0;
> -
> -       return 1;
> -}
> -
> -/**
>  * aa_cred_profile - obtain cred's profiles
>  * @cred: cred to obtain profiles from  (NOT NULL)
>  *
> @@ -138,9 +121,8 @@ static inline struct aa_profile *aa_current_profile(void)
>  {
>        const struct aa_task_cxt *cxt = current_cred()->security;
>        struct aa_profile *profile;
> -       BUG_ON(!cxt || !cxt->profile);
>
> -       profile = aa_newest_version(cxt->profile);
> +       profile = __aa_current_profile();
>        /*
>         * Whether or not replacement succeeds, use newest profile so
>         * there is no need to update it after replacement.
> @@ -151,4 +133,18 @@ static inline struct aa_profile *aa_current_profile(void)
>        return profile;
>  }
>
> +/**
> + * __aa_task_is_confined - determine if @task has any confinement
> + * @task: task to check confinement of  (NOT NULL)
> + *
> + * If @task != current needs to be called in RCU safe critical section
> + */
> +static inline bool __aa_task_is_confined(struct task_struct *task)
> +{
> +       if (unconfined(aa_cred_profile(__task_cred(task))))
> +               return 0;
> +
> +       return 1;
> +}
> +
>  #endif /* __AA_CONTEXT_H */
> --
> 1.6.5.3
>
>
