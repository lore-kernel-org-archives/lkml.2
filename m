Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1CIOiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:38:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47856 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab1CIOix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ey8a7CZxN2ADYqhFfee8dzA3mkUKvC+F7cvrhg8EN2PLIqvn+X/BRizOnWOdZJIz1x
         YHTIWkmfpG1JGOoNSYqONUFitZE2HZpOyax2pSNmjocfCM7bNnZcirepF1fV9gSMW7kH
         XRnoRvFwfnJskGPTNN1tqxzhJiAw4vO9yyUWo=
MIME-Version: 1.0
In-Reply-To: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com>
References: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com>
Date: Wed, 9 Mar 2011 22:38:52 +0800
Message-ID: <AANLkTikMi0TR9pUSG3bWdRvEOwKdFQ-5Ex5trjGEQBx0@mail.gmail.com>
Subject: Re: [PATCH] perf: Avoid resolving [kernel.kallsyms] to real path for
 buildid cache
From: Lin Ming <minggr@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>
Cc: Han Pingtian <phan@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

Could you have a look at this patch?

Thanks,
Lin Ming

On Thu, Mar 3, 2011 at 11:23 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> kallsyms has a virtual file name [kernel.kallsyms].
> Currently, it can't be added to buildid cache successfully
> because the code(build_id_cache__add_s) tries to resolve
> [kernel.kallsyms]to a real absolute pathname and that fails.
>
> Fixes it by not resolving it and just use the name [kernel.kallsyms].
> So dir ~/.debug/[kernel.kallsyms] is created.
>
> Original bug report at:
> https://lkml.org/lkml/2011/3/1/524
>
> Tested-by: Han Pingtian <phan@redhat.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/util/header.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 72c124d..1f8883b 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -271,11 +271,15 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
>                          const char *name, bool is_kallsyms)
>  {
>        const size_t size = PATH_MAX;
> -       char *realname = realpath(name, NULL),
> -            *filename = malloc(size),
> +       char *realname, *filename = malloc(size),
>             *linkname = malloc(size), *targetname;
>        int len, err = -1;
>
> +       if (is_kallsyms)
> +               realname = (char *)name;
> +       else
> +               realname = realpath(name, NULL);
> +
>        if (realname == NULL || filename == NULL || linkname == NULL)
>                goto out_free;
>
> @@ -307,7 +311,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
>        if (symlink(targetname, linkname) == 0)
>                err = 0;
>  out_free:
> -       free(realname);
> +       if (!is_kallsyms)
> +               free(realname);
>        free(filename);
>        free(linkname);
>        return err;
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
