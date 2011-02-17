Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1BQXf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:35:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1BQXf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PlJ927nWGbK+fYRbkxNMJ8KgPEL4YuNjTqu0dLR7ZYYR7eMt4gmxRUtauTl/q+FkL5
         BAqujpOGs5r9gRYKN/cA==
MIME-Version: 1.0
In-Reply-To: <4D5C7EA7.1030409@cn.fujitsu.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Thu, 17 Feb 2011 15:35:30 -0800
Message-ID: <AANLkTinsj4OagOQhaPL=6-3awQo9ssh06NgwTg1kOsYh@mail.gmail.com>
Subject: Re: [PATCH 1/4] cpuset: Remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 5:49 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> It's not necessary to copy cpuset->mems_allowed to a buffer
> allocated by NODEMASK_ALLOC(). Just pass it to nodelist_scnprintf().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

The only downside is that we're now doing more work (and more complex
work) inside callback_mutex, but I guess that's OK compared to having
to do a memory allocation. (I poked around in lib/vsprintf.c and I
couldn't see any cases where it might allocate memory, but it would be
particularly bad if there was any way to trigger an Oops.)

> ---
>  kernel/cpuset.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 10f1835..f13ff2e 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1620,20 +1620,12 @@ static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
>
>  static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
>  {
> -       NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
>        int retval;
>
> -       if (mask == NULL)
> -               return -ENOMEM;
> -

And this was particularly broken since the only caller of
cpuset_sprintf_memlist() doesn't handle a negative error response
anyway and would then overwrite byte 4083 on the preceding page with a
'\n'. And then since the (size_t)(s-page) that's passed to
simple_read_from_buffer() would be a very large number, it would write
arbitrary (user-controlled) amounts of kernel data to the userspace
buffer.

Maybe we could also rename 'retval' to 'count' in this function (and
cpuset_sprintf_cpulist()) to make it clearer that callers don't expect
negative error values?

>        mutex_lock(&callback_mutex);
> -       *mask = cs->mems_allowed;
> +       retval = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
>        mutex_unlock(&callback_mutex);
>
> -       retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
> -
> -       NODEMASK_FREE(mask);
> -
>        return retval;
>  }
>
> --
> 1.7.3.1
>
