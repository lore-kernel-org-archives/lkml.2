Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905Ab2CAMmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:42:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55434 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030872Ab2CAMmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:42:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.70.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4F146C.9090300@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
	<4F4F146C.9090300@cn.fujitsu.com>
Date: Thu, 1 Mar 2012 20:42:50 +0800
Message-ID: <CAJd=RBB+2r-Q8K1FQqPh90EdtAdmz3R8FWU48M_ePqyziNfcLw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] xattr: extract kmem_xattr code from tmpfs
From: Hillf Danton <dhillf@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> +/*
> + * free all the xattrs
> + */
> +void kmem_xattrs_free(struct kmem_xattrs *xattrs)
> +{
> +       struct kmem_xattr *xattr, *node;
> +
> +       spin_lock(&xattrs->lock);
> +       list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
> +               kfree(xattr->name);
> +               kfree(xattr);
> +       }
> +       spin_unlock(&xattrs->lock);

In your work it is a library function, operations on &xattrs->head
are no longer allowed, say list_empty(), after it called, though I
dunno if such operations exist.

And kmem_xattrs is too close to kmem_xattr, kmem_xattr_list
is not pron of typo.

-hd

> +}
> +
[...]
> @@ -559,10 +551,7 @@ static void shmem_evict_inode(struct inode *inode)
>        } else
>                kfree(info->symlink);
>
> -       list_for_each_entry_safe(xattr, nxattr, &info->xattr_list, list) {
> -               kfree(xattr->name);
> -               kfree(xattr);
> -       }
> +       kmem_xattrs_free(&info->xattrs);
>        BUG_ON(inode->i_blocks);
>        shmem_free_inode(inode->i_sb);
>        end_writeback(inode);
