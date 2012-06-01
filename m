Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2FAMiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:38:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37537 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab2FAMiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:38:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120601104925.5135263c@kryten>
References: <20120601104925.5135263c@kryten>
Date: Fri, 1 Jun 2012 21:38:13 +0900
Message-ID: <CAC5umygk+KnmkQ5O-YV+5a_rEyPbRvK6nkipJiw4Hg8uXXGHQA@mail.gmail.com>
Subject: Re: [PATCH] fault-inject: Avoid call to random32() if fault injection
 is disabled
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/1 Anton Blanchard <anton@samba.org>:
>
> After enabling CONFIG_FAILSLAB I noticed random32 in profiles even
> if slub fault injection wasn't enabled at runtime.
>
> should_fail forces a comparison against random32() even if
> probability is 0:
>
>        if (attr->probability <= random32() % 100)
>                return false;
>
> Add a check up front for probability == 0 and avoid all of the more
> complicated checks.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>
> Index: linux-build/lib/fault-inject.c
> ===================================================================
> --- linux-build.orig/lib/fault-inject.c 2012-02-11 21:22:32.303459860 +1100
> +++ linux-build/lib/fault-inject.c      2012-02-11 22:38:10.470977505 +1100
> @@ -101,6 +101,10 @@ static inline bool fail_stacktrace(struc
>
>  bool should_fail(struct fault_attr *attr, ssize_t size)
>  {
> +       /* No need to check any other properties if the probability is 0 */
> +       if (attr->probability == 0)
> +               return false;
> +
>        if (attr->task_filter && !fail_task(attr, current))
>                return false;
>

Looks good to me.

Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
