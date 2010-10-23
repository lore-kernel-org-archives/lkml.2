Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0JWLww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:52:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab0JWLwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:52:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH 1/6] udf: Replace BKL with superblock's mutex s_lock
Date: Sat, 23 Oct 2010 13:53:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010231353.12709.arnd@arndb.de>
X-Provags-ID: V02:K0:HQ9GhhxECEoW+YKzfwHQ/BKvr8LHzmymGO9DpuXPwhe
 mry/gARYgNbEUL4kWqPi0IDPNVfq0zNIZ5caqz6r6a5CN8Dg0z
 Gns5H/UloXZyXkw2XfIJeqLRByJt8vK4i0EfsnAEm5Okl3QX/u
 AxKjPEJSN3f2W67hIQPW4c5yTnO6h8nPO2CnH/Ka0YeILTLrRJ
 yDl6i3mH2MsmmJb6W+cRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 October 2010, Alessio Igor Bogani wrote:
> This work was supported by a hardware donation from the CE Linux Forum.
> 
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>

Hi Alessio,

Thanks a lot for joining in on the effort. Your patches look good for the
most part, but there are a few details you should change before they
go upstream. Most importantly, the subject lines of patches are currently
not unique and they tell very little about what is going on. You can
probably merge the three "remove BKL" patches into one and explain
why that is safe in a combined changelog.

> @@ -568,7 +568,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
>  	if (!udf_parse_options(options, &uopt, true))
>  		return -EINVAL;
>  
> -	lock_kernel();
> +	mutex_lock(&sb->s_lock);
>  	sbi->s_flags = uopt.flags;
>  	sbi->s_uid   = uopt.uid;
>  	sbi->s_gid   = uopt.gid;

As I recently learned, there is also an effort to get rid of sb->s_lock, so
the change in super.c is not all that helpful. When you need a per-filesystem
mutex, please instead add a new one to udf_sb_info. There is already the
s_alloc_mutex. While I haven't looked at that, maybe it can be extended to
cover the other areas that are under s_lock with your patch. Watch out for
put_super freeing sb_info under the lock though.

	Arnd
