Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2BOTON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:14:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab2BOTOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:14:09 -0500
Date: Wed, 15 Feb 2012 20:06:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215190622.GA25559@redhat.com>
References: <20120215143606.GA14037@redhat.com> <20120215151008.GL1894@moon> <20120215183203.GH4533@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215183203.GH4533@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Cyrill Gorcunov wrote:
>
> On Wed, Feb 15, 2012 at 07:10:08PM +0400, Cyrill Gorcunov wrote:
> > On Wed, Feb 15, 2012 at 03:36:06PM +0100, Oleg Nesterov wrote:
> > >
> > > task->files can be NULL, we can race with exit_files().
> >
> > So I need to call get_files_struct. Thanks Oleg!
> >
>
> Something like below I think, right? (it seems this
> patc doesn't hit lenux-next yet, so here is interdiff
> output)
>
> 	Cyrill
> ---
> diff -u linux-2.6.git/kernel/kcmp.c linux-2.6.git/kernel/kcmp.c
> --- linux-2.6.git/kernel/kcmp.c
> +++ linux-2.6.git/kernel/kcmp.c
> @@ -44,16 +44,25 @@
>  static struct file *
>  get_file_raw_ptr(struct task_struct *task, unsigned int idx)
>  {
> +	struct files_struct *files;
>  	struct fdtable *fdt;
>  	struct file *file;
>
> -	spin_lock(&task->files->file_lock);
> -	fdt = files_fdtable(task->files);
> +	files = get_files_struct(task);
> +	if (!files)
> +		return NULL;
> +
> +	rcu_read_lock();
> +
> +	fdt = files_fdtable(files);
>  	if (idx < fdt->max_fds)
>  		file = fdt->fd[idx];
>  	else
>  		file = NULL;
> -	spin_unlock(&task->files->file_lock);
> +
> +	rcu_read_unlock();
> +
> +	put_files_struct(files);

I think this should work. Or you can simply do

	struct file *file = NULL;

	task_lock(task);
	rcu_read_lock();
	if (task->files)
		file = fcheck_files(task->files, idx);
	rcu_read_unlock();
	task_unlock(task);

Oleg.

