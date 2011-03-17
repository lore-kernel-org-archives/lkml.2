Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1CQRTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:19:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52898 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1CQRTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wJRP0sVbID0cq10sijyRtMNjgikRffYXzDB8doIokNRcXw+roc3Exg7IiJxyzSIK4n
         S9y5CFNjRUTrhE8UamwidbUDuxhAuOEX0r7O8oZVMFtX3oAqCofYr/ygfcrAmkJ7rQV2
         XTCf/11rRAozcHDj1BYnZaIwzwTszbFHdIgDs=
MIME-Version: 1.0
In-Reply-To: <1300380909.16880.264.camel@gandalf.stny.rr.com>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	<1300370936.16880.96.camel@gandalf.stny.rr.com>
	<AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	<1300380909.16880.264.camel@gandalf.stny.rr.com>
Date: Thu, 17 Mar 2011 18:18:59 +0100
Message-ID: <AANLkTinOqxRTF0XqZEGxwyojeMhpdFr_yaPEcDtbADTk@mail.gmail.com>
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 5:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Here, test this patch. I'm in the process of committing it now.
> It will be two patches, one for the WARN_ON_SMP() change, the other for
> the futex change.
>
> -- Steve
>
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index c2c9ba0..25f1e9e 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -168,7 +168,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>  #ifdef CONFIG_SMP
>  # define WARN_ON_SMP(x)                        WARN_ON(x)
>  #else
> -# define WARN_ON_SMP(x)                        do { } while (0)
> +# define WARN_ON_SMP(x)                        ({0;})
>  #endif
>
>  #endif
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 9fe9131..850d00b 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -785,8 +785,8 @@ static void __unqueue_futex(struct futex_q *q)
>  {
>        struct futex_hash_bucket *hb;
>
> -       if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
> -                       || plist_node_empty(&q->list)))
> +       if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
> +           || WARN_ON(plist_node_empty(&q->list)))
>                return;
>
>        hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
>
>
>

Tested-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
