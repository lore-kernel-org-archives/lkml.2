Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1LJEk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 23:40:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42348 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1LJEkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 23:40:55 -0500
MIME-Version: 1.0
In-Reply-To: <1323483097-24210-1-git-send-email-jack@suse.cz>
References: <1323483097-24210-1-git-send-email-jack@suse.cz>
Date: Sat, 10 Dec 2011 13:40:53 +0900
Message-ID: <CAKYAXd9jYMZMht02n=W4T8+hq8hU8owoZk07TbLb-myk52PNKw@mail.gmail.com>
Subject: Re: [PATCH] udf: Fix deadlock when converting file from in-ICB one to
 normal one
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Matthias Matiak <netzpython@mail-on.us>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/10 Jan Kara <jack@suse.cz>:
> During BKL removal, conversion of files from in-ICB format to normal format got
> broken. We call ->writepage with i_data_sem held but udf_get_block() also
> acquires i_data_sem thus creating A-A deadlock.
>
> We fix the problem by dropping i_data_sem before calling ->writepage() which is
> safe since i_mutex still protects us against any changes in the file. Also fix
> pagelock - i_data_sem lock inversion in udf_expand_file_adinicb() by dropping
> i_data_sem before calling find_or_create_page().
>
> Reported-by: Matthias Matiak <netzpython@mail-on.us>
> Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  fs/udf/file.c  |    6 +++---
>  fs/udf/inode.c |   20 +++++++++++++++++---
>  2 files changed, 20 insertions(+), 6 deletions(-)
>
>  I plan to merge this fix through my tree soon.
>
> +/*
> + * Expand file stored in ICB to a normal one-block-file
> + *
> + * This function requires i_data_sem for writing and releases it.
> + * This function requires i_mutex held
> + */
>  int udf_expand_file_adinicb(struct inode *inode)
>  {
>        struct page *page;
> @@ -171,6 +177,11 @@ int udf_expand_file_adinicb(struct inode *inode)
>                mark_inode_dirty(inode);
                  up_write(&iinfo->i_data_sem);
Hi Jan.
I do not know if that helps, Would it need here ?
Thanks.
>                return 0;
>        }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
