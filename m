Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab2CAMsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:48:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41588 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162Ab2CAMsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:48:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.23.199 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4F148F.6040808@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
	<4F4F148F.6040808@cn.fujitsu.com>
Date: Thu, 1 Mar 2012 20:48:21 +0800
Message-ID: <CAJd=RBAh-GzsfMiViGzKMeDV+G01K_OHZQHJ=amnp0trVhMABQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] cgroup: revise how we re-populate root directory
From: Hillf Danton <dhillf@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q21CmUNR009993

On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> -static void cgroup_clear_directory(struct dentry *dentry)
> +static void cgroup_clear_directory(struct dentry *dentry, bool remove_all,
> +                                  unsigned long removed_bits)
>  {
> -       struct list_head *node;
> +       LIST_HEAD(head);
> +       struct dentry *d, *node;
>
>        BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
> +
>        spin_lock(&dentry->d_lock);
> -       node = dentry->d_subdirs.next;
> -       while (node != &dentry->d_subdirs) {
> -               struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
> +       list_for_each_entry_safe(d, node, &dentry->d_subdirs, d_u.d_child) {
> +               struct cftype *cft = d->d_fsdata;
> +
> +               if (!remove_all && cft->subsys &&
> +                   !test_bit(cft->subsys->subsys_id, &removed_bits))
> +                       continue;
>
>                spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
> -               list_del_init(node);
> +               list_move(&d->d_u.d_child, &head);
>                if (d->d_inode) {
>                        /* This should never be called on a cgroup
>                         * directory with child cgroups */
>                        BUG_ON(d->d_inode->i_mode & S_IFDIR);
>                        dget_dlock(d);
> -                       spin_unlock(&d->d_lock);
> -                       spin_unlock(&dentry->d_lock);
> +               }
> +               spin_unlock(&d->d_lock);
> +       }
> +       spin_unlock(&dentry->d_lock);
> +

Safe to process isolated entries without dentry->d_lock held?

-hd

> +       list_for_each_entry_safe(d, node, &head, d_u.d_child) {
> +               spin_lock(&d->d_lock);
> +               list_del_init(&d->d_u.d_child);
> +               spin_unlock(&d->d_lock);
> +               if (d->d_inode) {
>                        d_delete(d);
>                        simple_unlink(dentry->d_inode, d);
>                        dput(d);
> -                       spin_lock(&dentry->d_lock);
> -               } else
> -                       spin_unlock(&d->d_lock);
> -               node = dentry->d_subdirs.next;
> +               }
>        }
> -       spin_unlock(&dentry->d_lock);
>  }
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
