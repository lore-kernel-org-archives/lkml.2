Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2CATRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:17:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53507 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2CATRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:17:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.133.210 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Thu, 1 Mar 2012 23:17:14 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120301191714.GF9930@moon>
References: <20120229151634.GE4796@moon>
 <20120229192400.GA13194@redhat.com>
 <20120229200103.GJ11326@moon>
 <20120301180616.GA7652@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301180616.GA7652@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 07:06:16PM +0100, Oleg Nesterov wrote:
...
> 
> OK, now that I understand the locking, we can't race with
> added_exe_file_vma/removed_exe_file_vma. But I still think we
> can race with set_mm_exe_file().
> 
> And yes, I think you missed something obvious ;) Suppose that
> 2 threads call prctl_set_mm(PR_SET_MM_EXE_FILE) at the same
> time. Both threads can take ->mmap_sem for reading and do
> set_mm_exe_file() at the same time.
> 

Hi Oleg, thanks a lot for comments! Today I started remakeing
the patch and found one obvious problem -- the mmap_sem should
be taken for write not read, since otherwise someone might get
wrong reference when we're chenging this symlink. So sure, this
was incorrect in first place ;)

> > > And. set_mm_exe_file() sets ->num_exe_file_vmas = 0, this is
> > > simply wrong? It should match the number of VM_EXECUTABLE
> > > vmas.
> > >
> >
> > yes, it's a nit which sould be fixed. thanks!
> 
> OK, but then you do not need to check ->num_exe_file_vmas at all?
> 
> Except, of course, I think we should fail if this counter is zero.
> 
> The changelog says:
> 
> 	Note, if mm_struct::exe_file already mapped more than once
> 	we refuse to change anything (which prevents kernel from
> 	potential problems).
> 
> why? which problems?
> 

I've some gut feeling that if I have num_exe_file_vmas more than
one I might broke something if I replace exe_file (actually I'm
checking this, was interrupted with other duties).

> > > In short, I do not understand the patch at all. It seems, you
> > > only need to replace mm->exe_file under down_write(mmap_sem)
> > > and nothing else.
> >
> > I can't just replace it, I wanted to check it the new symlink
> > will indeed point to executable
> 
> I meant I see no reason to play with num_exe_file_vmas, you only
> need to replace ->exe_file.

Yes, I tend to think the same (but as I mentioned, I'm checking
if this really wont break anything).

So, Oleg, basically the new version will use opened fd in form
like (note, I'll recheck for refs and locks more so this is
a draft version to point idea)

static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
{
	struct files_struct *files;
	struct file *file;
	int ret;

	/*
	 * Make sure if someone is trying to obtain
	 * the existing exe_file it will not get
	 * results until we've finished.
	 */
	down_write(&mm->mmap_sem);

	files = get_files_struct(current);
	if (!files)
		return -EINVAL;

	spin_lock(&files->file_lock);

	file = fcheck_files(files, fd);
	if (!file) {
		ret = -EBADFD;
		goto out_unlock;
	}
	get_file(file);
	spin_unlock(&files->file_lock);

	if (mm->num_exe_file_vmas)
		removed_exe_file_vma(mm);

-> This are two lines I'm doubt about
->	set_mm_exe_file(mm, file);
->	added_exe_file_vma(mm);

out_unlock:
	put_files_struct(files);
out:
	up_write(&mm->mmap_sem);
	return ret;
}

	Cyrill
