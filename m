Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030291Ab2CBPd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:33:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab2CBPd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:33:26 -0500
Date: Fri, 2 Mar 2012 16:26:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120302152621.GA29744@redhat.com>
References: <20120229151634.GE4796@moon> <20120229192400.GA13194@redhat.com> <20120229200103.GJ11326@moon> <20120301180616.GA7652@redhat.com> <20120301191714.GF9930@moon> <20120301194120.GA11400@redhat.com> <20120302142630.GK8681@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302142630.GK8681@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Cyrill Gorcunov wrote:
>
> On Thu, Mar 01, 2012 at 08:41:20PM +0100, Oleg Nesterov wrote:
> ...
> > Still can't understand. I think you need:
> >
> > 	file = fget(fd);
> > 	if (!file)
> > 		return -EBADF;
> >
> > 	down_write(&mm->mmap_sem);
> > 	if (mm->num_exe_file_vmas) {
> > 		fput(mm->exe_file);
> > 		mm->exe_file = file;
> > 		file = NULL;
> > 	}
> > 	up_write(&mm->mmap_sem);
> >
> > 	if (!file)
> > 		return 0;
> >
> > 	fput(file);
> > 	return -ESOMETHING;
> >
> > and that is all.
>
> Hi Oleg, sure you were right. I even think testing for
> num_exe_file_vmas is not needed, since until real
> executable VMA is read and mapped it might remain
> zero. So I guess something like below should work.

No, you need to check num_exe_file_vmas != 0.

> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *new_exe_file, *old_exe_file;
> +
> +	new_exe_file = fget(fd);
> +	if (!new_exe_file)
> +		return -EBADF;
> +
> +	down_write(&mm->mmap_sem);
> +	old_exe_file = mm->exe_file;
> +	mm->exe_file = new_exe_file;
> +	up_write(&mm->mmap_sem);

This changes the current rule: mm->exe_file goes away once
num_exe_file_vmas becomes zero.

Oleg.

