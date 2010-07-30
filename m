Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0G3JUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:20:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0G3JU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RnbRY7BtoNwiLgym2T5PSNPxHRGd3Oop39DE+z4RWo3Xrzta44xy1RwMl4hJtFwgh4
         fF7pQ8tu9x9CdLV6MjMzGLlRqkZ8sjPiWT/jPV7Nw+Ci9ysfnq7pIIYtQyfDQ2HXIQVv
         au6W40wLnxUDjwXFt/zNEuWFdfbEyZX1GuJhM=
MIME-Version: 1.0
In-Reply-To: <1280440089-3203-2-git-send-email-john.johansen@canonical.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
	<1280440089-3203-2-git-send-email-john.johansen@canonical.com>
Date: Fri, 30 Jul 2010 12:20:27 +0300
X-Google-Sender-Auth: hD3yDOd7y-uwqOgltOhoiCgerUY
Message-ID: <AANLkTikk3tNM-fsXuS_SeAWgaYYCFrFAToRXOBkPxwy9@mail.gmail.com>
Subject: Re: [PATCH 01/13] AppArmor: misc. base functions and defines
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, xiaosuo@gmail.com,
        laijs@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 12:47 AM, John Johansen
<john.johansen@canonical.com> wrote:
> +/**
> + * kvmalloc - do allocation preferring kmalloc but falling back to vmalloc
> + * @size: size of allocation
> + *
> + * Return: allocated buffer or NULL if failed
> + *
> + * It is possible that policy being loaded from the user is larger than
> + * what can be allocated by kmalloc, in those cases fall back to vmalloc.
> + */
> +void *kvmalloc(size_t size)
> +{
> +       void *buffer = NULL;
> +
> +       if (size == 0)
> +               return NULL;
> +
> +       /* do not attempt kmalloc if we need more than 16 pages at once */
> +       if (size <= (16*PAGE_SIZE))
> +               buffer = kmalloc(size, GFP_NOIO | __GFP_NOWARN);

16 pages is a lot of memory for 64 K pages. What's the purpose of
GFP_NOIO here? vmalloc() will do GFP_KERNEL allocations anyway.

> +       if (!buffer) {
> +               /* see kvfree for why size must be at least work_struct size
> +                * when allocated via vmalloc
> +                */
> +               if (size < sizeof(struct work_struct))
> +                       size = sizeof(struct work_struct);
> +               buffer = vmalloc(size);
> +       }
> +       return buffer;
> +}

Please don't hide this into apparmor internals. People have invented
this function in the past so maybe it's time to put it in mm/util.c?

> +
> +/**
> + * do_vfree - workqueue routine for freeing vmalloced memory
> + * @work: data to be freed
> + *
> + * The work_struct is overlaid to the data being freed, as at the point
> + * the work is scheduled the data is no longer valid, be its freeing
> + * needs to be delayed until safe.
> + */
> +static void do_vfree(struct work_struct *work)
> +{
> +       vfree(work);
> +}
> +
> +/**
> + * kvfree - free an allocation do by kvmalloc
> + * @buffer: buffer to free (MAYBE_NULL)
> + *
> + * Free a buffer allocated by kvmalloc
> + */
> +void kvfree(void *buffer)
> +{
> +       if (is_vmalloc_addr(buffer)) {
> +               /* Data is no longer valid so just use the allocated space
> +                * as the work_struct
> +                */
> +               struct work_struct *work = (struct work_struct *) buffer;
> +               INIT_WORK(work, do_vfree);
> +               schedule_work(work);

I don't understand this part here. Is it needed for interrupt contexts
or does vfree() sleep somewhere? If it's for the former, I think we
can just add a comment saying that kvmalloc/kvfree is not safe from
interrupt context and remove the schedule_work() parts here.

> +       } else
> +               kfree(buffer);
> +}
