Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2JZMFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:05:53 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:54421 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab2JZMFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:05:50 -0400
Date: Fri, 26 Oct 2012 10:05:37 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JvQtdC+0L3RgtGM0LXQsg==?= 
	<dm.leontiev7@gmail.com>,
        linux-kernel@vger.kernel.org, dleontie@amd.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: procfs does not return error code when file name is already in
 use
Message-ID: <20121026120537.GB17909@oc0268524204.ibm.com>
References: <CA+JonM0vrXtGzhv44o5rOH-3z_BuU52=Nu8WmiMz5m1=ENZ9HA@mail.gmail.com>
 <alpine.LNX.2.00.1210261200500.19184@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1210261200500.19184@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102612-8936-0000-0000-00000861B7DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 12:06:08PM +0200, Jiri Kosina wrote:
> On Fri, 26 Oct 2012, Дмитрий Леонтьев wrote:
> 
> > I'm working a kernel module, and one of my tasks is to disallow a
> > process to open my character device(/dev/xxx) more than once. I tried
> > to solve this problem by creating /proc/apu directory, and creating a
> > /proc/xxx/{pid} file for when process opens /dev/xxx. This file will
> > act as per-process mutex, and provide a way to control resource usage.
> 
> Now that's a complex solution indeed! :)
> 
> Why not just handle that by looking at struct inode* passed to your open() 
> callback and checking whether you have that open already, for example?
> 
> > Then, I investigated,if procfs acts as I expect from it, and found
> > that procfs checks file names for uniqueness, but does not return an
> > error when I add two files with same name. Instead, it posts silly
> > messages to kernel log, and adds new entry as if nothing happened.
> > This is a vulnerability:
> > 
> > Let we have 2 modules A and B trying to create file /proc/foo on load,
> > and removing it on unload. Load A, Load B, unload B. at step 3 B
> > removed /proc/foo owned by A, and /proc/foo created by B remains
> > accessible from userspace.
> > 
> > My patch fixes this behaviour: proc_register will return -EEXIST when
> > file name is in use, and refuse to add a duplicate.
> 
> I wouldn't call it a vulnerability, but a bug, probably yes. Adding Andrew 
> and Al to CC.
> 

The real bug is when some code happens to create the same procfile
again. Perhaps because the module removal didn't remove the file. This
WARN is a good debug tool for those real bugs.

I can't think of a real usecase where it would be legitimate to try to
create a procfile which could possibly have been created before.

The only case is the one described here, where two different and
unrelated codes that could be simultaneously loaded try to create the
same file. In this case, I believe either only one of them should be
allowed to be loaded (and perhaps failing the creation of the file might
accomplish that) or they should be using different files (perhaps on a
common directory for that class of files).

Regards.
Cascardo.

> > 
> > ----start of patch for fs/proc/generic.c---------------------------------------
> > --- generic.c.orig	2012-10-25 22:20:05.196606263 +0400
> > +++ generic.c	2012-10-25 22:13:49.556955392 +0400
> 
> Please always generate the patches against kernel tree in a form so that 
> they could be applied using patch -p1.
> 
> > @@ -554,45 +554,51 @@ static const struct inode_operations pro
> > 
> >  static int proc_register(struct proc_dir_entry * dir, struct
> > proc_dir_entry * dp)
> >  {
> > +	int errorcode=-EAGAIN;
> >  	unsigned int i;
> >  	struct proc_dir_entry *tmp;
> >  	
> >  	i = get_inode_number();
> > -	if (i == 0)
> > -		return -EAGAIN;
> > -	dp->low_ino = i;
> > -
> > -	if (S_ISDIR(dp->mode)) {
> > -		if (dp->proc_iops == NULL) {
> > -			dp->proc_fops = &proc_dir_operations;
> > -			dp->proc_iops = &proc_dir_inode_operations;
> > +	if (i != 0)
> > +	{
> > +		errorcode=0;
> > +
> > +		dp->low_ino = i;
> > +
> > +		if (S_ISDIR(dp->mode)) {
> > +			if (dp->proc_iops == NULL) {
> > +				dp->proc_fops = &proc_dir_operations;
> > +				dp->proc_iops = &proc_dir_inode_operations;
> > +			}
> > +			dir->nlink++;
> > +		} else if (S_ISLNK(dp->mode)) {
> > +			if (dp->proc_iops == NULL)
> > +				dp->proc_iops = &proc_link_inode_operations;
> > +		} else if (S_ISREG(dp->mode)) {
> > +			if (dp->proc_fops == NULL)
> > +				dp->proc_fops = &proc_file_operations;
> > +			if (dp->proc_iops == NULL)
> > +				dp->proc_iops = &proc_file_inode_operations;
> >  		}
> > -		dir->nlink++;
> > -	} else if (S_ISLNK(dp->mode)) {
> > -		if (dp->proc_iops == NULL)
> > -			dp->proc_iops = &proc_link_inode_operations;
> > -	} else if (S_ISREG(dp->mode)) {
> > -		if (dp->proc_fops == NULL)
> > -			dp->proc_fops = &proc_file_operations;
> > -		if (dp->proc_iops == NULL)
> > -			dp->proc_iops = &proc_file_inode_operations;
> > -	}
> > 
> > -	spin_lock(&proc_subdir_lock);
> > +		spin_lock(&proc_subdir_lock);
> > 
> > -	for (tmp = dir->subdir; tmp; tmp = tmp->next)
> > -		if (strcmp(tmp->name, dp->name) == 0) {
> > -			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
> > -				dir->name, dp->name);
> > -			break;
> > +		for (tmp = dir->subdir; tmp; tmp = tmp->next)
> > +		{
> > +			if (strcmp(tmp->name, dp->name) == 0) {
> > +				errorcode=-EEXIST;
> > +				break;
> > +			}
> >  		}
> > -
> > -	dp->next = dir->subdir;
> > -	dp->parent = dir;
> > -	dir->subdir = dp;
> > -	spin_unlock(&proc_subdir_lock);
> > -
> > -	return 0;
> > +		if(!errorcode)
> > +		{
> > +			dp->next = dir->subdir;
> > +			dp->parent = dir;
> > +			dir->subdir = dp;
> > +		}
> > +		spin_unlock(&proc_subdir_lock);
> > +	}
> > +	return errorcode;
> >  }
> > 
> >  static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
> > ----end of patch---------------------------------------
> > 
> > Regards
> > Dmitry
> > 
> 
> -- 
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

