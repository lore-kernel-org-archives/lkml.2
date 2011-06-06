Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1FFXvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:51:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab1FFXvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:51:08 -0400
Date: Mon, 6 Jun 2011 16:51:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Dmitriev <dimondmm@yandex.ru>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Corrupt inode flags when remove ATTR_SYS flag on fat
 file system mounted with =?UTF-8?Q?=E2=80=9Csys=5Fimmutable=E2=80=9D?=
 mount option.
Message-Id: <20110606165106.b0afea46.akpm@linux-foundation.org>
In-Reply-To: <31181306830445@web159.yandex.ru>
References: <31181306830445@web159.yandex.ru>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 12:27:24 +0400
Dmitry Dmitriev <dimondmm@yandex.ru> wrote:

> Hello,
> 
> Inode flags are corrupted when removing ATTR_SYS flag by FAT_IOCTL_SET_ATTRIBUTES ioctl on fat file system mounted with ___sys_immutable___ mount option. In this case S_IMMUTABLE flag must be removed from inode flags, but actually removed all other flags except S_IMMUTABLE. This problem observed on 2.6.34 kernel, but it seems still exist( after examine of 2.6.39 kernel source code ).
> 
> The problem in fat_ioctl_set_attributes function( fs/fat/file.c ). This function contains following code(2.6.39 kernel):
>  101        if (sbi->options.sys_immutable) {
>  102                if (attr & ATTR_SYS)
>  103                        inode->i_flags |= S_IMMUTABLE;
>  104                else
>  105                        inode->i_flags &= S_IMMUTABLE;
>  106        }
> 
> Instead of removing S_IMMUTABLE flag from inode flags on line 105 function removes all other flags from inode flags. I think that line 105 must be following:
> 
>  105                        inode->i_flags &= ~S_IMMUTABLE;
> 

Thank, I queued this:


From: Andrew Morton <akpm@linux-foundation.org>

Inode flags are corrupted when removing ATTR_SYS flag by
FAT_IOCTL_SET_ATTRIBUTES ioctl on fat file system mounted with
`sys_immutable' mount option.

Fix fat-fingered bitop from 21bea495943f9532 ("fat: split
fat_generic_ioctl").

Reported-by: Dmitry Dmitriev <dimondmm@yandex.ru>
Cc: Cristoph Hellwig <hch@lst.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/file.c~fs-fat-filec-fix-clearing-of-s_immutable fs/fat/file.c
--- a/fs/fat/file.c~fs-fat-filec-fix-clearing-of-s_immutable
+++ a/fs/fat/file.c
@@ -102,7 +102,7 @@ static int fat_ioctl_set_attributes(stru
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
 		else
-			inode->i_flags &= S_IMMUTABLE;
+			inode->i_flags &= ~S_IMMUTABLE;
 	}
 
 	fat_save_attrs(inode, attr);
_

