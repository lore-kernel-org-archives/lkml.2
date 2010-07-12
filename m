Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0GLI2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:28:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43573 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0GLI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:27:58 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org,
        hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org
In-reply-to: <87pqytyxo3.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V16 10/12] vfs: Export file system uuid via /proc/<pid>mountinfo
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <87pqytyxo3.fsf@linux.vnet.ibm.com>
Message-Id: <E1OYEMi-0005ta-H7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 10:27:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K. V wrote:
> On Mon, 12 Jul 2010 12:05:43 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > We add a per superblock uuid field. File systems should
> > update the uuid in the fill_super callback
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/namespace.c     |    3 +++
> >  include/linux/fs.h |    1 +
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index 88058de..5dbdbd6 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -871,6 +871,9 @@ static int show_mountinfo(struct seq_file *m, void *v)
> >  	if (IS_MNT_UNBINDABLE(mnt))
> >  		seq_puts(m, " unbindable");
> > 
> > +	/* print the uuid */
> > +	seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
> > +
> >  	/* Filesystem specific data */
> >  	seq_puts(m, " - ");
> >  	show_type(m, sb);
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 3103c39..5f43472 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1367,6 +1367,7 @@ struct super_block {
> >  	wait_queue_head_t	s_wait_unfrozen;
> > 
> >  	char s_id[32];				/* Informational name */
> > +	u8 s_uuid[16];				/* UUID */
> > 
> >  	void 			*s_fs_info;	/* Filesystem private info */
> >  	fmode_t			s_mode;
> 
> since it is an optional tag is it ok to do the below patch ? or does
> optional is a way to introduce changes across kernel version  and
> each line is suppose to have new added fields ?.

Tagged fields are optional, so yes, the patch is OK.

>  Is there a userspace
> tool that use /proc/<pid>/mouninfo ?

libmount from recent enough util-linux is using mountinfo.  So
mount(8) should be using it, as well as some other utilities in
util-linux.

Thanks,
Miklos

> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 5dbdbd6..7542959 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -833,6 +833,16 @@ const struct seq_operations mounts_op = {
>  	.show	= show_vfsmnt
>  };
>  
> +static int uuid_is_nil(u8 *uuid)
> +{
> +	int i;
> +	u8  *cp = (u8 *)uuid;
> +
> +	for (i = 0; i < 16; i++)
> +		if (*cp++) return 0;	/* not nil */
> +	return 1;	/* is nil */
> +}
> +
>  static int show_mountinfo(struct seq_file *m, void *v)
>  {
>  	struct proc_mounts *p = m->private;
> @@ -871,8 +881,9 @@ static int show_mountinfo(struct seq_file *m, void *v)
>  	if (IS_MNT_UNBINDABLE(mnt))
>  		seq_puts(m, " unbindable");
>  
> +	if (!uuid_is_nil(mnt->mnt_sb->s_uuid))
>  	/* print the uuid */
> -	seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
> +		seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
>  
>  	/* Filesystem specific data */
>  	seq_puts(m, " - ");
> 
