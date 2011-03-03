Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1CCBrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:47:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39847 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CCBrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cmpHViRHdxW51DGEg6++AndmwoYXF2xdK0tTjC++cDSJH0XLN2+zFTRRadopYhraCZ
         v85JmbbWidrcMWtvG3e6WheDcbUprLBQ5gsM43ySJsK/4jLbV5xpW9atUnHUZMaLQUT3
         6yjrdpfumv5Yqwy85ij7kZsCRRcLkgpBpCxdI=
MIME-Version: 1.0
In-Reply-To: <1299082575-3084-1-git-send-email-pholasek@redhat.com>
References: <1299082575-3084-1-git-send-email-pholasek@redhat.com>
Date: Thu, 3 Mar 2011 09:47:12 +0800
Message-ID: <AANLkTim5k4zaqVR3EEua1YRF5z4F8nRhDxr61cvg0=6x@mail.gmail.com>
Subject: Re: [PATCH] sysctl: some input constraints checks were added for
 /proc/sys/vm directory
From: Dave Young <hidave.darkstar@gmail.com>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p231lLis023190

On Thu, Mar 3, 2011 at 12:16 AM, Petr Holasek <pholasek@redhat.com> wrote:
> There were added boundaries of allowed input ranges for: dirty_expire_centisecs,
> drop_caches, overcommit_memory, page-cluster and panic_on_oom.
>
> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> ---
>  fs/drop_caches.c |    6 +++++-
>  kernel/sysctl.c  |   17 +++++++++++++----
>  2 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 2195c21..8e61858 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -45,7 +45,11 @@ static void drop_slab(void)
>  int drop_caches_sysctl_handler(ctl_table *table, int write,
>        void __user *buffer, size_t *length, loff_t *ppos)
>  {
> -       proc_dointvec_minmax(table, write, buffer, length, ppos);
> +       int ret;
> +
> +       ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
> +       if (ret)
> +           return ret;

s/space/tab, otherwise Acked-by: Dave Young <hidave.darkstar@gmail.com>

>        if (write) {
>                if (sysctl_drop_caches & 1)
>                        iterate_supers(drop_pagecache_sb, NULL);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0f1bd83..e0a4d50 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -117,6 +117,7 @@ static int neg_one = -1;
>  static int zero;
>  static int __maybe_unused one = 1;
>  static int __maybe_unused two = 2;
> +static int __maybe_unused three = 3;
>  static unsigned long one_ul = 1;
>  static int one_hundred = 100;
>  #ifdef CONFIG_PRINTK
> @@ -978,14 +979,18 @@ static struct ctl_table vm_table[] = {
>                .data           = &sysctl_overcommit_memory,
>                .maxlen         = sizeof(sysctl_overcommit_memory),
>                .mode           = 0644,
> -               .proc_handler   = proc_dointvec,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
> +               .extra2         = &two,
>        },
>        {
>                .procname       = "panic_on_oom",
>                .data           = &sysctl_panic_on_oom,
>                .maxlen         = sizeof(sysctl_panic_on_oom),
>                .mode           = 0644,
> -               .proc_handler   = proc_dointvec,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
> +               .extra2         = &two,
>        },
>        {
>                .procname       = "oom_kill_allocating_task",
> @@ -1013,7 +1018,8 @@ static struct ctl_table vm_table[] = {
>                .data           = &page_cluster,
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
> -               .proc_handler   = proc_dointvec,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
>        },
>        {
>                .procname       = "dirty_background_ratio",
> @@ -1061,7 +1067,8 @@ static struct ctl_table vm_table[] = {
>                .data           = &dirty_expire_interval,
>                .maxlen         = sizeof(dirty_expire_interval),
>                .mode           = 0644,
> -               .proc_handler   = proc_dointvec,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
>        },
>        {
>                .procname       = "nr_pdflush_threads",
> @@ -1137,6 +1144,8 @@ static struct ctl_table vm_table[] = {
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
>                .proc_handler   = drop_caches_sysctl_handler,
> +               .extra1         = &one,
> +               .extra2         = &three,
>        },
>  #ifdef CONFIG_COMPACTION
>        {
> --
> 1.7.1
>
>



-- 
Regards
dave
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
