Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2CBFqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:46:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2217 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab2CBFqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:46:10 -0500
X-IronPort-AV: E=Sophos;i="4.73,516,1325433600"; 
   d="scan'208";a="4431324"
Message-ID: <4F505F52.9000509@cn.fujitsu.com>
Date: Fri, 02 Mar 2012 13:49:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2 2/3] cgroup: revise how we re-populate root directory
References: <4F4F1459.4080300@cn.fujitsu.com>	<4F4F148F.6040808@cn.fujitsu.com> <CAJd=RBAh-GzsfMiViGzKMeDV+G01K_OHZQHJ=amnp0trVhMABQ@mail.gmail.com>
In-Reply-To: <CAJd=RBAh-GzsfMiViGzKMeDV+G01K_OHZQHJ=amnp0trVhMABQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-02 13:44:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-02 13:44:19,
	Serialize complete at 2012-03-02 13:44:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20:48, Hillf Danton wrote:
> On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>> -static void cgroup_clear_directory(struct dentry *dentry)
>> +static void cgroup_clear_directory(struct dentry *dentry, bool remove_all,
>> +                                  unsigned long removed_bits)
>>  {
>> -       struct list_head *node;
>> +       LIST_HEAD(head);
>> +       struct dentry *d, *node;
>>
>>        BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
>> +
>>        spin_lock(&dentry->d_lock);
>> -       node = dentry->d_subdirs.next;
>> -       while (node != &dentry->d_subdirs) {
>> -               struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
>> +       list_for_each_entry_safe(d, node, &dentry->d_subdirs, d_u.d_child) {
>> +               struct cftype *cft = d->d_fsdata;
>> +
>> +               if (!remove_all && cft->subsys &&
>> +                   !test_bit(cft->subsys->subsys_id, &removed_bits))
>> +                       continue;
>>
>>                spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
>> -               list_del_init(node);
>> +               list_move(&d->d_u.d_child, &head);
>>                if (d->d_inode) {
>>                        /* This should never be called on a cgroup
>>                         * directory with child cgroups */
>>                        BUG_ON(d->d_inode->i_mode & S_IFDIR);
>>                        dget_dlock(d);
>> -                       spin_unlock(&d->d_lock);
>> -                       spin_unlock(&dentry->d_lock);
>> +               }
>> +               spin_unlock(&d->d_lock);
>> +       }
>> +       spin_unlock(&dentry->d_lock);
>> +
> 
> Safe to process isolated entries without dentry->d_lock held?
> 

no vfs expert, I need to check into the vfs code.

> -hd
> 
>> +       list_for_each_entry_safe(d, node, &head, d_u.d_child) {
>> +               spin_lock(&d->d_lock);
>> +               list_del_init(&d->d_u.d_child);
>> +               spin_unlock(&d->d_lock);
>> +               if (d->d_inode) {
>>                        d_delete(d);
>>                        simple_unlink(dentry->d_inode, d);
>>                        dput(d);
>> -                       spin_lock(&dentry->d_lock);
>> -               } else
>> -                       spin_unlock(&d->d_lock);
>> -               node = dentry->d_subdirs.next;
>> +               }
>>        }
>> -       spin_unlock(&dentry->d_lock);
>>  }
>>
