Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2KMShJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:37:09 -0500
Received: from tex.lwn.net ([70.33.254.29]:44368 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2KMShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:37:07 -0500
Date: Tue, 13 Nov 2012 11:38:53 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 1/3] mm: Add VM pressure notifications
Message-ID: <20121113113853.56d71f27@lwn.net>
In-Reply-To: <20121107110128.GA30462@lizard>
References: <20121107105348.GA25549@lizard>
	<20121107110128.GA30462@lizard>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012 03:01:28 -0800
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> This patch introduces vmpressure_fd() system call. The system call creates
> a new file descriptor that can be used to monitor Linux' virtual memory
> management pressure.

I noticed a couple of quick things as I was looking this over...

> +static ssize_t vmpressure_read(struct file *file, char __user *buf,
> +			       size_t count, loff_t *ppos)
> +{
> +	struct vmpressure_watch *watch = file->private_data;
> +	struct vmpressure_event event;
> +	int ret;
> +
> +	if (count < sizeof(event))
> +		return -EINVAL;
> +
> +	ret = wait_event_interruptible(watch->waitq,
> +				       atomic_read(&watch->pending));

Would it make sense to support non-blocking reads?  Perhaps a process would
like to simply know that current pressure level?

> +SYSCALL_DEFINE1(vmpressure_fd, struct vmpressure_config __user *, config)
> +{
> +	struct vmpressure_watch *watch;
> +	struct file *file;
> +	int ret;
> +	int fd;
> +
> +	watch = kzalloc(sizeof(*watch), GFP_KERNEL);
> +	if (!watch)
> +		return -ENOMEM;
> +
> +	ret = copy_from_user(&watch->config, config, sizeof(*config));
> +	if (ret)
> +		goto err_free;

This is wrong - you'll return the number of uncopied bytes to user space.
You'll need a "ret = -EFAULT;" in there somewhere.

jon
