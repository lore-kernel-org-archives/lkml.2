Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0JDJy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:54:29 -0400
Received: from www.tglx.de ([62.245.132.106]:41093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab0JDJy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:54:28 -0400
Date: Mon, 4 Oct 2010 11:56:06 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] libunload: A library to help remove open files
Message-ID: <20101004095606.GB1867@silverbox.local>
References: <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <20100924104555.GC1819@silverbox.local>
 <m1hbhfcbdo.fsf@fess.ebiederm.org>
 <20100924173106.GA4966@silverbox.local>
 <m14ode662q.fsf@fess.ebiederm.org>
 <20100925003308.GA29910@suse.de>
 <m1wrqa4mg5.fsf@fess.ebiederm.org>
 <20100926192142.GA7252@kroah.com>
 <m1ocbk86k3.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocbk86k3.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 03:48:44PM -0700, Eric W. Biederman wrote:

This doesn't build, see below.

Thanks,
Hans

[...]
> +}
> +EXPORT_SYMBOL_GPL(unload_release_unlock);
> +
> +
> +void unload_barrier(struct unload *unload)
> +{
> +	struct unload_barrier barrier;
> +	struct unload_file *ufile;
> +	struct hlist_node *pos;
> +
> +	/* Guarantee that when this function returns I am not
> +	 * executing any code protected by the unload_lock or
> +	 * unload_releas_lock, and that I will never again execute
> +	 * code protected by those locks.
> +	 *
> +	 * Also guarantee the file count for every file remaining on
> +	 * the unload ufiles list has been incremented.  The increment
> +	 * of the file count guarantees __fput will not be called.
> +	 */
> +	init_completion(&barrier.completion);
> +	barrier.releasers = 0;
> +
> +	spin_lock(&unload->lock);
> +	unload->barrier = &barrier;
> +
> +	hlist_for_each_entry(ufile, pos, &unload->ufiles, list)
> +		if (!atomic_long_inc_not_zero(&ufile->file->f_count))
> +			barrier.releasers++;
> +	unload->active--;
> +	if (unload->active || barrier.releasers) {
> +		spin_unlock(&unload->lock);
> +		wait_for_completion(&barrier.completion);
> +		spin_lock(&unload->lock);
> +	}
> +	spin_unlock(&unload->lock);
> +}

There's an EXPORT_SYMBOL_GPL(unload_barrier) missing here...

> diff --git a/include/linux/unload.h b/include/linux/unload.h
> new file mode 100644
> index 0000000..fc1b4f6
> --- /dev/null
> +++ b/include/linux/unload.h
> @@ -0,0 +1,33 @@
> +#ifndef _LINUX_UNLOAD_H
> +#define _LINUX_UNLOAD_H
> +
> +#include <linux/list.h>
> +
> +struct file;
> +struct vm_operations_struct;
> +struct unload_barrier;
> +
> +struct unload {
> +	struct hlist_head	ufiles;
> +	struct unload_barrier	*barrier;
> +	spinlock_t		lock;
> +	int			active;
> +};
> +
> +struct unload_file {
> +	struct unload		*unload;
> +	struct hlist_node	list;
> +	struct file 		*file;
> +};
> +
> +void unload_init(struct unload *unload);
> +void unload_file_init(struct unload_file *ufile, struct file *file, struct unload *unload);
> +bool unload_trylock(struct unload *unload);
> +void unload_unlock(struct unload *unload);
> +bool unload_release_trylock(struct unload_file *ufile);
> +void unload_release_unlock(struct unload_file *ufile);
> +void unload_file_attach(struct unload_file *ufile, struct unload *unload);
> +void unload_file_detach(struct unload_file *ufile);
> +struct unload_file *find_unload_file(struct unload *unload, struct file *file);
> +void unload_barrier(struct unload *unload);
> +#endif /* _LINUX_UNLOAD_H */
> -- 
> 1.7.2.2
