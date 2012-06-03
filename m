Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab2FCC0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 22:26:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48146 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2FCC03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 22:26:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1338362354-19519-1-git-send-email-vdavydov@parallels.com>
Date: Sat, 02 Jun 2012 20:26:15 -0600
In-Reply-To: <1338362354-19519-1-git-send-email-vdavydov@parallels.com>
	(Vladimir Davydov's message of "Wed, 30 May 2012 11:19:14 +0400")
Message-ID: <87aa0lf7w8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX191etWlXoHDPkgNh+BLjjyFBK0XnJAuKEE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1979]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vladimir Davydov <vdavydov@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC] fs: make reading /proc/mounts consistent
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir Davydov <vdavydov@parallels.com> writes:

> Reading /proc/mounts from userspace is atomic, but only within a single system
> call. That means that if there are ongoing unmounts while a userspace process
> is reading /proc/mounts, the process can omit some mount points.
>
> The patch makes /proc/mounts more-or-less consistent: a userspace process is
> guaranteed to read all mount points that will exist when the process closes the
> file.

The guarantee for readdir and directories and I think the one you should
aim for is to return all mounts that do not change between beginning
reading of the file at offset 0 and ending reading the file.

> This is achieved by keeping the position where a process stopped as a
> pointer to mount entry and resuming reading from the position. If a mount entry
> is removed, all processes that stopped on the entry are advanced i.e.  their
> position is moved to the next entry. To achieve this, all processes reading
> /proc/mounts are organized in a linked list.
>
> An example of /proc/mounts inconsistency is here:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593516

In the specific case of schroot I'm not convinced that you shouldn't
just increase the user space buffer size if you don't read everything.
Or to simply use mount namespaces to make unmounting unnecessary.

> ---
>  fs/mount.h          |    7 ++++++
>  fs/namespace.c      |   61 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/proc_namespace.c |    5 ++++
>  3 files changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/fs/mount.h b/fs/mount.h
> index 4ef36d9..d02574a 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -70,7 +70,14 @@ struct proc_mounts {
>  	struct seq_file m; /* must be the first element */
>  	struct mnt_namespace *ns;
>  	struct path root;
> +	struct list_head *iter;
> +	loff_t iter_pos;
> +	int iter_advanced; 

iter_advanced appears totally unnecessary.

> +	struct list_head reader;
>  	int (*show)(struct seq_file *, struct vfsmount *);
>  };
>  
> +extern void register_mounts_reader(struct proc_mounts *p);
> +extern void unregister_mounts_reader(struct proc_mounts *p);
> +
>  extern const struct seq_operations mounts_op;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index e608199..504940a 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -51,6 +51,37 @@ EXPORT_SYMBOL_GPL(fs_kobj);
>   */
>  DEFINE_BRLOCK(vfsmount_lock);
>  
> +static LIST_HEAD(mounts_readers);
> +static DEFINE_SPINLOCK(mounts_lock);

Since we are traversing a per mount namespace list we should make
mounts_readers, and mounts_lock also per mount namespace.  It is trivial
and it reduces the trouble they can introduce into the system.

> +void register_mounts_reader(struct proc_mounts *p)
> +{
> +	spin_lock(&mounts_lock);
> +	list_add(&p->reader, &mounts_readers);
> +	spin_unlock(&mounts_lock);
> +}
> +
> +void unregister_mounts_reader(struct proc_mounts *p)
> +{
> +	spin_lock(&mounts_lock);
> +	list_del(&p->reader);
> +	spin_unlock(&mounts_lock);
> +}
> +
> +static void advance_mounts_readers(struct list_head *iter)
> +{
> +	struct proc_mounts *p;
> +
> +	spin_lock(&mounts_lock);
> +	list_for_each_entry(p, &mounts_readers, reader) {
> +		if (p->iter == iter) {
> +			p->iter = p->iter->next;
> +			p->iter_advanced = 1;
> +		}
> +	}
> +	spin_unlock(&mounts_lock);

This isn't horrible but the list walk does mean an unprivileged process
can open /proc/mounts many times and effectively perform a DOS against
unmount. I don't know that we actually care but I figure it is worth
mentioning.

> +}
> +
>  static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
>  {
>  	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
> @@ -941,14 +972,39 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>  	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
>  
>  	down_read(&namespace_sem);
> -	return seq_list_start(&p->ns->list, *pos);
> +	if (p->iter_advanced) {
> +		p->iter_advanced = 0;
> +		if (p->iter_pos < *pos)
> +			p->iter_pos++;
> +	}

What does the iter_advanced special case acheive?

I would think what you would want instead of all of these complications
is simply:

	/* A seek happened disregard our cached position */
	if (p->iter_pos != *pos) {
                p->iter = p->ns->list.next;
                p->iter_pos = 0;
                while (p->iter_pos < *pos && p->iter != &p->ns->list) {
                	p->iter = p->iter->list.next;
                        p->iter_pos++;
                }

                p->iter_pos = *pos;
	}
	return p->iter != &p->ns->list ? p->iter : NULL;

> +
> +	if (!p->iter || (p->iter_pos > *pos && p->iter == &p->ns->list)) {
> +		p->iter = p->ns->list.next;
> +		p->iter_pos = 0;
> +	}
> +
> +	while (p->iter_pos < *pos && p->iter != &p->ns->list) {
> +		p->iter = p->iter->next;
> +		p->iter_pos++;
> +	}
> +
> +	while (p->iter_pos > *pos && p->iter != p->ns->list.next) {
> +		p->iter = p->iter->prev;
> +		p->iter_pos--;
> +	}
> +
> +	p->iter_pos = *pos;
> +	return p->iter != &p->ns->list ? p->iter : NULL;
>  }
>  
>  static void *m_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>  	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
>  
> -	return seq_list_next(v, &p->ns->list, pos);
> +	p->iter = p->iter->next;
> +	p->iter_pos++;
> +	*pos = p->iter_pos;
> +	return p->iter != &p->ns->list ? p->iter : NULL;
>  }
>  
>  static void m_stop(struct seq_file *m, void *v)
> @@ -1071,6 +1127,7 @@ void umount_tree(struct mount *mnt, int propagate, struct list_head *kill)
>  
>  	list_for_each_entry(p, &tmp_list, mnt_hash) {
>  		list_del_init(&p->mnt_expire);
> +		advance_mounts_readers(&p->mnt_list);
>  		list_del_init(&p->mnt_list);
>  		__touch_mnt_namespace(p->mnt_ns);
>  		p->mnt_ns = NULL;
> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
> index 1241285..4f4524d 100644
> --- a/fs/proc_namespace.c
> +++ b/fs/proc_namespace.c
> @@ -273,6 +273,10 @@ static int mounts_open_common(struct inode *inode, struct file *file,
>  	p->root = root;
>  	p->m.poll_event = ns->event;
>  	p->show = show;
> +	p->iter = NULL;
> +	p->iter_pos = 0;
> +	p->iter_advanced = 0;
> +	register_mounts_reader(p);
>  
>  	return 0;
>  
> @@ -289,6 +293,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
>  static int mounts_release(struct inode *inode, struct file *file)
>  {
>  	struct proc_mounts *p = file->private_data;
> +	unregister_mounts_reader(p);
>  	path_put(&p->root);
>  	put_mnt_ns(p->ns);
>  	return seq_release(inode, file);

Eric
