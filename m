Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1ANEKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:10:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58111 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab1ANEKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sDAHKNGIt+x04ec65MbWFigTsChXJx3JFflOV7sVeOHKDAiLsVTjaurUtNeCEEjstg
         EuVVrq4K0gOz0PXlLz5+kT1y1NyeFso5eaq3vdnbGtEflqOQgluZJsdASSZqdhRQHySJ
         2jTFlTsDiLlM8tM6uz9dbrii1vQ4i7U73UV3A=
MIME-Version: 1.0
In-Reply-To: <4D2FCBDC.5040107@cn.fujitsu.com>
References: <12545.1294932849@localhost>
	<AANLkTikEYgsOjVhmuVCM8rzGRrQxRM0FO475=CEBEtxD@mail.gmail.com>
	<4D2FCBDC.5040107@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 15:10:31 +1100
Message-ID: <AANLkTikHdKf5_gtTTPY9z+ymyPP6enc3S_-d_zdzmLDJ@mail.gmail.com>
Subject: Re: linux-next: lockdep whinge in cgroup_rmdir
From: Nick Piggin <npiggin@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Valdis.Kletnieks@vt.edu, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Paul Menage <menage@google.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 3:06 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Nick Piggin wrote:
>> It looks like it is just a missing parent->child lock order annotation, but
>> mainline cgroupfs code looks to be OK there. What does
>> cgroup_clear_directory() look like in mmotm?
>
> It's not from cgroup_clear_directory()..
>
> This should fix it:

Yep, thanks!

> =========================
>
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Fri, 14 Jan 2011 11:34:34 +0800
> Subject: [PATCH] cgroups: Fix a lockdep warning at cgroup removal
>
> Commit 2fd6b7f5 ("fs: dcache scale subdirs") forgot to annotate a dentry
> lock, which caused a lockdep warning.
>
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5c5f4cc..db983e2 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -910,7 +910,7 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
>
>        parent = dentry->d_parent;
>        spin_lock(&parent->d_lock);
> -       spin_lock(&dentry->d_lock);
> +       spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>        list_del_init(&dentry->d_u.d_child);
>        spin_unlock(&dentry->d_lock);
>        spin_unlock(&parent->d_lock);
> --
> 1.7.3.1
>
>
