Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2FCImw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 04:42:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:52494 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab2FCImr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 04:42:47 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 3 Jun 2012 12:42:39 +0400
Subject: Re: [PATCH RFC] make reading /proc/mounts consistent
Thread-Topic: [PATCH RFC] make reading /proc/mounts consistent
Thread-Index: Ac1BZNVbcPzbJAvFSP2gG67SVsCxuw==
Message-ID: <77E04EBA-1AD8-4D9D-930B-575F29E3EDC1@parallels.com>
References: <1338362354-19519-1-git-send-email-vdavydov@parallels.com>
 <87aa0lf7w8.fsf@xmission.com>
In-Reply-To: <87aa0lf7w8.fsf@xmission.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 3, 2012, at 6:26 AM, Eric W. Biederman wrote:

> Vladimir Davydov <vdavydov@parallels.com> writes:
> 
>> Reading /proc/mounts from userspace is atomic, but only within a single system
>> call. That means that if there are ongoing unmounts while a userspace process
>> is reading /proc/mounts, the process can omit some mount points.
>> 
>> The patch makes /proc/mounts more-or-less consistent: a userspace process is
>> guaranteed to read all mount points that will exist when the process closes the
>> file.
> 
> The guarantee for readdir and directories and I think the one you should
> aim for is to return all mounts that do not change between beginning
> reading of the file at offset 0 and ending reading the file.

Yes, that's what I try to achieve.

> 
>> This is achieved by keeping the position where a process stopped as a
>> pointer to mount entry and resuming reading from the position. If a mount entry
>> is removed, all processes that stopped on the entry are advanced i.e.  their
>> position is moved to the next entry. To achieve this, all processes reading
>> /proc/mounts are organized in a linked list.
>> 
>> An example of /proc/mounts inconsistency is here:
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593516
> 
> In the specific case of schroot I'm not convinced that you shouldn't
> just increase the user space buffer size if you don't read everything.
> Or to simply use mount namespaces to make unmounting unnecessary.

I agree, but there may be a lot of programs that already read /proc/mounts and don't care about its consistency.

> 
>> ---
>> fs/mount.h          |    7 ++++++
>> fs/namespace.c      |   61 +++++++++++++++++++++++++++++++++++++++++++++++++-
>> fs/proc_namespace.c |    5 ++++
>> 3 files changed, 71 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/mount.h b/fs/mount.h
>> index 4ef36d9..d02574a 100644
>> --- a/fs/mount.h
>> +++ b/fs/mount.h
>> @@ -70,7 +70,14 @@ struct proc_mounts {
>> 	struct seq_file m; /* must be the first element */
>> 	struct mnt_namespace *ns;
>> 	struct path root;
>> +	struct list_head *iter;
>> +	loff_t iter_pos;
>> +	int iter_advanced; 
> 
> iter_advanced appears totally unnecessary.

I think it is necessary (see below).

> 
>> +	struct list_head reader;
>> 	int (*show)(struct seq_file *, struct vfsmount *);
>> };
>> 
>> +extern void register_mounts_reader(struct proc_mounts *p);
>> +extern void unregister_mounts_reader(struct proc_mounts *p);
>> +
>> extern const struct seq_operations mounts_op;
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index e608199..504940a 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -51,6 +51,37 @@ EXPORT_SYMBOL_GPL(fs_kobj);
>>  */
>> DEFINE_BRLOCK(vfsmount_lock);
>> 
>> +static LIST_HEAD(mounts_readers);
>> +static DEFINE_SPINLOCK(mounts_lock);
> 
> Since we are traversing a per mount namespace list we should make
> mounts_readers, and mounts_lock also per mount namespace.  It is trivial
> and it reduces the trouble they can introduce into the system.

Agree.

> 
>> +void register_mounts_reader(struct proc_mounts *p)
>> +{
>> +	spin_lock(&mounts_lock);
>> +	list_add(&p->reader, &mounts_readers);
>> +	spin_unlock(&mounts_lock);
>> +}
>> +
>> +void unregister_mounts_reader(struct proc_mounts *p)
>> +{
>> +	spin_lock(&mounts_lock);
>> +	list_del(&p->reader);
>> +	spin_unlock(&mounts_lock);
>> +}
>> +
>> +static void advance_mounts_readers(struct list_head *iter)
>> +{
>> +	struct proc_mounts *p;
>> +
>> +	spin_lock(&mounts_lock);
>> +	list_for_each_entry(p, &mounts_readers, reader) {
>> +		if (p->iter == iter) {
>> +			p->iter = p->iter->next;
>> +			p->iter_advanced = 1;
>> +		}
>> +	}
>> +	spin_unlock(&mounts_lock);
> 
> This isn't horrible but the list walk does mean an unprivileged process
> can open /proc/mounts many times and effectively perform a DOS against
> unmount. I don't know that we actually care but I figure it is worth
> mentioning.

The spinlock is used only to sync access to the mounts_readers list, so it is possible to omit locking the spinlock in advance_mounts_readers() by calling register/unregister_mounts_reader() with namespace_sem held for reading. Will amend.

> 
>> +}
>> +
>> static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
>> {
>> 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
>> @@ -941,14 +972,39 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>> 	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
>> 
>> 	down_read(&namespace_sem);
>> -	return seq_list_start(&p->ns->list, *pos);
>> +	if (p->iter_advanced) {
>> +		p->iter_advanced = 0;
>> +		if (p->iter_pos < *pos)
>> +			p->iter_pos++;
>> +	}
> 
> What does the iter_advanced special case acheive?
> 
> I would think what you would want instead of all of these complications
> is simply:
> 
> 	/* A seek happened disregard our cached position */
> 	if (p->iter_pos != *pos) {
>                p->iter = p->ns->list.next;
>                p->iter_pos = 0;
>                while (p->iter_pos < *pos && p->iter != &p->ns->list) {
>                	p->iter = p->iter->list.next;
>                        p->iter_pos++;
>                }
> 
>                p->iter_pos = *pos;
> 	}
> 	return p->iter != &p->ns->list ? p->iter : NULL;

The trouble is that m_start() is not necessarily called with the position where m_stop() stopped. Currently, it can be called either with this position or with the position next to it (see seq_read()).

If the current iter was removed, m_start() should return the element next to the iter in both cases i.e. both for iter_pos and for iter_pos+1. That's why I need the iter_advanced flag here.

> 
>> +
>> +	if (!p->iter || (p->iter_pos > *pos && p->iter == &p->ns->list)) {
>> +		p->iter = p->ns->list.next;
>> +		p->iter_pos = 0;
>> +	}
>> +
>> +	while (p->iter_pos < *pos && p->iter != &p->ns->list) {
>> +		p->iter = p->iter->next;
>> +		p->iter_pos++;
>> +	}
>> +
>> +	while (p->iter_pos > *pos && p->iter != p->ns->list.next) {
>> +		p->iter = p->iter->prev;
>> +		p->iter_pos--;
>> +	}
>> +
>> +	p->iter_pos = *pos;
>> +	return p->iter != &p->ns->list ? p->iter : NULL;
>> }
>> 
>> static void *m_next(struct seq_file *m, void *v, loff_t *pos)
>> {
>> 	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
>> 
>> -	return seq_list_next(v, &p->ns->list, pos);
>> +	p->iter = p->iter->next;
>> +	p->iter_pos++;
>> +	*pos = p->iter_pos;
>> +	return p->iter != &p->ns->list ? p->iter : NULL;
>> }
>> 
>> static void m_stop(struct seq_file *m, void *v)
>> @@ -1071,6 +1127,7 @@ void umount_tree(struct mount *mnt, int propagate, struct list_head *kill)
>> 
>> 	list_for_each_entry(p, &tmp_list, mnt_hash) {
>> 		list_del_init(&p->mnt_expire);
>> +		advance_mounts_readers(&p->mnt_list);
>> 		list_del_init(&p->mnt_list);
>> 		__touch_mnt_namespace(p->mnt_ns);
>> 		p->mnt_ns = NULL;
>> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
>> index 1241285..4f4524d 100644
>> --- a/fs/proc_namespace.c
>> +++ b/fs/proc_namespace.c
>> @@ -273,6 +273,10 @@ static int mounts_open_common(struct inode *inode, struct file *file,
>> 	p->root = root;
>> 	p->m.poll_event = ns->event;
>> 	p->show = show;
>> +	p->iter = NULL;
>> +	p->iter_pos = 0;
>> +	p->iter_advanced = 0;
>> +	register_mounts_reader(p);
>> 
>> 	return 0;
>> 
>> @@ -289,6 +293,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
>> static int mounts_release(struct inode *inode, struct file *file)
>> {
>> 	struct proc_mounts *p = file->private_data;
>> +	unregister_mounts_reader(p);
>> 	path_put(&p->root);
>> 	put_mnt_ns(p->ns);
>> 	return seq_release(inode, file);
> 
> Eric

