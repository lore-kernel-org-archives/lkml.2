Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2AaDH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:07:28 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35673 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2AaDHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:07:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Damien Millescamps <damien.millescamps@6wind.com>
Subject: Re: [PATCH 24/29] sysctl: Replace root_list with links between sysctl_table_sets.
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	<1327639925-12920-24-git-send-email-ebiederm@xmission.com>
	<CAPLs8y8YV0MiNhR0SnviBHPQb-oMj+_DLvRpJN89Yrbyjsf2xg@mail.gmail.com>
Date: Mon, 30 Jan 2012 19:10:04 -0800
In-Reply-To: <CAPLs8y8YV0MiNhR0SnviBHPQb-oMj+_DLvRpJN89Yrbyjsf2xg@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Mon, 30 Jan 2012 02:01:48
	+0200")
Message-ID: <m1mx94efeb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19X0QnNKOjLp2Sxapxnd3LoTKrKBIQ9g7c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> Very nice way to handle netns specific files with links between sets!
>
> You did a much better job than I did at dealing with them.
>
> It took me a while to understand how the code works. I'll try to write
> something for Documentation/ because the inner workings are a bit
> intertwined.
>
> A few comments bellow.

Thank you for your review.

I'm going to see how many of your comments I can incorporate into the
code.

Since no significant bugs have been seen my plan is to use incremental
patches on top of the existing code, to address the small issues that
have been seen.  That way I don't have to retest yet again.

>>  void register_sysctl_root(struct ctl_table_root *root)
>>  {
>> -       spin_lock(&sysctl_lock);
>> -       list_add_tail(&root->root_list, &sysctl_table_root.root_list);
>> -       spin_unlock(&sysctl_lock);
>>  }
>
>
> This function is empty. Can be deleted (there are two callers in
> net/sysctl_net.c.

Agreed.  There might be something useful by registering roots.  Perhaps
initialize the default set.  So I have kept the function for the short
term.  register_sysctl_root makes sense as an interface.  We just don't
have anything for register_sysctl_root to do right now.

>> @@ -400,6 +373,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
>>        struct inode *inode;
>>        struct dentry *err = ERR_PTR(-ENOENT);
>>        struct ctl_dir *ctl_dir;
>> +       int ret;
>>
>>        if (IS_ERR(head))
>>                return ERR_CAST(head);
>> @@ -410,6 +384,11 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
>>        if (!p)
>>                goto out;
>>
>
>
> "sysctl_follow_link" implies that it will follow the link. I would
> pull out the check whether the header is a link or not. This wouldn't
> save much (a function call), but it would make the code easier to
> read:
>
> 	/* Get out quickly if not a link */
>         if (S_ISLNK(p->mode)) {
> 		ret = sysctl_follow_link(&h, &p, current->nsproxy);
> 		err = ERR_PTR(ret);
> 		if (ret)
> 		        goto out;
>         }

Good point, and obviousness is part of what I am aiming for.


>>  {
>> +       struct ctl_table_set *set = dir->header.set;
>>        struct ctl_dir *subdir, *new = NULL;
>>
>>        spin_lock(&sysctl_lock);
>> -       subdir = find_subdir(dir->header.set, dir, name, namelen);
>> -       if (!IS_ERR(subdir))
>> -               goto found;
>> -       if ((PTR_ERR(subdir) == -ENOENT) && set != dir->header.set)
>> -               subdir = find_subdir(set, dir, name, namelen);
>> +       subdir = find_subdir(dir, name, namelen);
>>        if (!IS_ERR(subdir))
>>                goto found;
>>        if (PTR_ERR(subdir) != -ENOENT)
>> @@ -817,13 +815,14 @@ static struct ctl_dir *get_subdir(struct ctl_table_set *set,
>>        if (!new)
>>                goto failed;
>>
>> -       subdir = find_subdir(set, dir, name, namelen);
>> +       subdir = find_subdir(dir, name, namelen);
>>        if (!IS_ERR(subdir))
>>                goto found;
>>        if (PTR_ERR(subdir) != -ENOENT)
>>                goto failed;
>
> I think you're returning the wrong error here. If we got to this point
> then subdir == ERR_PTR(-ENOENT).
> We want to create a new dir here even if one doesn't exist.
> So if we have an error in insert_header() we don't return that error,
> but ENOENT.
>
>>
>> -       insert_header(dir, &new->header);
>> +       if (insert_header(dir, &new->header))
>> +               goto failed;
>>        subdir = new;
>
> Something like this would fix it:
>
>         if (subdir = insert_header(dir, &new->header))
>
>
>
>>  found:
>>        subdir->header.nreg++;
>> @@ -841,6 +840,57 @@ failed:
>>        return subdir;
>>  }
>>
