Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1FNESJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 00:18:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1FNESF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 00:18:05 -0400
Date: Tue, 14 Jun 2011 14:17:35 +1000
From: NeilBrown <neilb@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] sysctl: add support for poll()
Message-ID: <20110614141735.65e106b5@notabene.brown>
In-Reply-To: <1307981153.1449.19.camel@mop>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
	<BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
	<m18vtkq57c.fsf@fess.ebiederm.org>
	<BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
	<20110602134338.0c56160e@lxorguk.ukuu.org.uk>
	<BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
	<m1hb88e3qs.fsf@fess.ebiederm.org>
	<BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
	<20110608151732.2b321b9a.akpm@linux-foundation.org>
	<BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
	<1307981153.1449.19.camel@mop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011 18:05:51 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Thu, 2011-06-09 at 15:16 +0200, Kay Sievers wrote:
> > On Thu, Jun 9, 2011 at 00:17, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > We already have several pollable procfs files, such as
> > > fs/proc/base.c:mounts_poll() and I think drivers/md has one.  I do
> > > think that any work in this area should end up with those custom
> > > make-procfs-pollable hacks being identified and removed.
> > 
> > For these files we can probably move the event counter into the
> > seq_file structure, and get rid of the dance to kmalloc it and assign
> > it to seq_file->private. That might simplify the logic a bit.
> > 
> > [Adding Neil, to get his opinion of moving 'event' so seq_file and get
> > rid of the malloc dance]
> 
> I guess, we could do something like this, which looks quite a bit
> simpler by moving the poll event counter into the dynamically allocated
> seq_file structure itself, instead of having private structures
> allocated on top to just carry the counter (patch is just
> compile-tested).
> 
> Thanks,
> Kay

Acked-by: NeilBrown <neilb@suse.de>

Looks like a nice improvement - thanks.

It is a pity that files don't all respond the same way to select/poll though.

Some set POLLIN|POLLRDNORM always, some set it only when there is a new event.

I have found that the former is safer.  There are some frameworks that always
use select/poll before reading, and get confused when they cannot read from
some /proc file.

And uniformity is good anyway.

NeilBrown


> 
> ---
>  drivers/md/md.c               |   26 ++++++++------------------
>  fs/namespace.c                |    4 ++--
>  fs/proc/base.c                |    2 +-
>  include/linux/mnt_namespace.h |    1 -
>  include/linux/seq_file.h      |    1 +
>  mm/swapfile.c                 |   29 ++++++++---------------------
>  6 files changed, 20 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aa640a8..b073d36 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6377,16 +6377,11 @@ static void md_seq_stop(struct seq_file *seq, void *v)
>  		mddev_put(mddev);
>  }
>  
> -struct mdstat_info {
> -	int event;
> -};
> -
>  static int md_seq_show(struct seq_file *seq, void *v)
>  {
>  	mddev_t *mddev = v;
>  	sector_t sectors;
>  	mdk_rdev_t *rdev;
> -	struct mdstat_info *mi = seq->private;
>  	struct bitmap *bitmap;
>  
>  	if (v == (void*)1) {
> @@ -6398,7 +6393,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
>  
>  		spin_unlock(&pers_lock);
>  		seq_printf(seq, "\n");
> -		mi->event = atomic_read(&md_event_count);
> +		seq->poll_event = atomic_read(&md_event_count);
>  		return 0;
>  	}
>  	if (v == (void*)2) {
> @@ -6510,26 +6505,21 @@ static const struct seq_operations md_seq_ops = {
>  
>  static int md_seq_open(struct inode *inode, struct file *file)
>  {
> +	struct seq_file *seq;
>  	int error;
> -	struct mdstat_info *mi = kmalloc(sizeof(*mi), GFP_KERNEL);
> -	if (mi == NULL)
> -		return -ENOMEM;
>  
>  	error = seq_open(file, &md_seq_ops);
>  	if (error)
> -		kfree(mi);
> -	else {
> -		struct seq_file *p = file->private_data;
> -		p->private = mi;
> -		mi->event = atomic_read(&md_event_count);
> -	}
> +		return error;
> +
> +	seq = file->private_data;
> +	seq->poll_event = atomic_read(&md_event_count);
>  	return error;
>  }
>  
>  static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
>  {
> -	struct seq_file *m = filp->private_data;
> -	struct mdstat_info *mi = m->private;
> +	struct seq_file *seq = filp->private_data;
>  	int mask;
>  
>  	poll_wait(filp, &md_event_waiters, wait);
> @@ -6537,7 +6527,7 @@ static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
>  	/* always allow read */
>  	mask = POLLIN | POLLRDNORM;
>  
> -	if (mi->event != atomic_read(&md_event_count))
> +	if (seq->poll_event != atomic_read(&md_event_count))
>  		mask |= POLLERR | POLLPRI;
>  	return mask;
>  }
> diff --git a/fs/namespace.c b/fs/namespace.c
> index fe59bd1..cda50fe 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -934,8 +934,8 @@ int mnt_had_events(struct proc_mounts *p)
>  	int res = 0;
>  
>  	br_read_lock(vfsmount_lock);
> -	if (p->event != ns->event) {
> -		p->event = ns->event;
> +	if (p->m.poll_event != ns->event) {
> +		p->m.poll_event = ns->event;
>  		res = 1;
>  	}
>  	br_read_unlock(vfsmount_lock);
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 14def99..16d33a3 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -673,7 +673,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
>  	p->m.private = p;
>  	p->ns = ns;
>  	p->root = root;
> -	p->event = ns->event;
> +	p->m.poll_event = ns->event;
>  
>  	return 0;
>  
> diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
> index 0b89efc..2930485 100644
> --- a/include/linux/mnt_namespace.h
> +++ b/include/linux/mnt_namespace.h
> @@ -18,7 +18,6 @@ struct proc_mounts {
>  	struct seq_file m; /* must be the first element */
>  	struct mnt_namespace *ns;
>  	struct path root;
> -	int event;
>  };
>  
>  struct fs_struct;
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 03c0232..be720cd 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -23,6 +23,7 @@ struct seq_file {
>  	u64 version;
>  	struct mutex lock;
>  	const struct seq_operations *op;
> +	int poll_event;
>  	void *private;
>  };
>  
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d537d29..5161d7d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1681,19 +1681,14 @@ out:
>  }
>  
>  #ifdef CONFIG_PROC_FS
> -struct proc_swaps {
> -	struct seq_file seq;
> -	int event;
> -};
> -
>  static unsigned swaps_poll(struct file *file, poll_table *wait)
>  {
> -	struct proc_swaps *s = file->private_data;
> +	struct seq_file *seq = file->private_data;
>  
>  	poll_wait(file, &proc_poll_wait, wait);
>  
> -	if (s->event != atomic_read(&proc_poll_event)) {
> -		s->event = atomic_read(&proc_poll_event);
> +	if (seq->poll_event != atomic_read(&proc_poll_event)) {
> +		seq->poll_event = atomic_read(&proc_poll_event);
>  		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
>  	}
>  
> @@ -1783,24 +1778,16 @@ static const struct seq_operations swaps_op = {
>  
>  static int swaps_open(struct inode *inode, struct file *file)
>  {
> -	struct proc_swaps *s;
> +	struct seq_file *seq;
>  	int ret;
>  
> -	s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
> -	if (!s)
> -		return -ENOMEM;
> -
> -	file->private_data = s;
> -
>  	ret = seq_open(file, &swaps_op);
> -	if (ret) {
> -		kfree(s);
> +	if (ret)
>  		return ret;
> -	}
>  
> -	s->seq.private = s;
> -	s->event = atomic_read(&proc_poll_event);
> -	return ret;
> +	seq = file->private_data;
> +	seq->poll_event = atomic_read(&proc_poll_event);
> +	return 0;
>  }
>  
>  static const struct file_operations proc_swaps_operations = {
> 
> 

