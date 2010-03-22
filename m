Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0CVWVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:21:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617Ab0CVWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:21:52 -0400
Date: Mon, 22 Mar 2010 15:21:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Lynch <maglyx@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet: factor timer allocate from open
Message-Id: <20100322152103.86cfec45.akpm@linux-foundation.org>
In-Reply-To: <4ba2f862.4902be0a.0815.0d09@mx.google.com>
References: <20100318121151.cedeb849.akpm@linux-foundation.org>
	<4ba2f862.4902be0a.0815.0d09@mx.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 21:06:58 -0700 (PDT)
Magnus Lynch <maglyx@gmail.com> wrote:

> Andrew Morton wrote:
> > Please always retain and maintain the changelog with each version of a patch.
> >
> > Please resend this patch with a complete changelog.
> 
> OK, here's my description from the original posting:
> <<
> The current implementation of the /dev/hpet driver couples opening the
> device with allocating one of the (scarce) timers (aka comparators).
> This is a limitation in that the main counter may be valuable to
> applications seeking a high-resolution timer who have no use for the
> interrupt generating functionality of the comparators.
> 
> This patch alters the open semantics so that when the device is
> opened, no timer is allocated. Operations that depend on a timer being
> in context implicitly attempt allocating a timer, to maintain backward
> compatibility. There is also an IOCTL (HPET_ALLOC_TIMER _IO) added so
> that the allocation may be done explicitly. (I prefer the explicit
> open then allocate pattern but don't know how practical it would be to
> require all existing code to be changed.)

A stylistic nit:

> @@ -384,6 +408,10 @@ static int hpet_fasync(int fd, struct file *file, int on)
>  {
>  	struct hpet_dev *devp;
>  
> +	int r = hpet_alloc_timer(file);
> +	if (r < 0)
> +		return r;
> +
>  	devp = file->private_data;
>  
>  	if (fasync_helper(fd, file, on, &devp->hd_async_queue) >= 0)
>
> ...
>
> @@ -438,6 +469,10 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  {
>  	struct hpet_dev *devp;
>  
> +	int r = hpet_alloc_timer(file);
> +	if (r < 0)
> +		return r;
> +
>  	devp = file->private_data;
>  	return hpet_ioctl_common(devp, cmd, arg, 0);
>  }

The above constructs make it harder for people to modify the code
later.  If they want to add a new local, where to put it?  If they want
to add more code, where to put it?  Plus there are risks that people
will accidentally turn the code into c99-style definitions.

One could do

 {
 	struct hpet_dev *devp;
	int r = hpet_alloc_timer(file);

	if (r < 0)
		return r;


but that's not terribly good either: it adds risk that someone will
later add a leak.

Better is the plain old simple approach:


 {
 	struct hpet_dev *devp;
	int r;

	r = hpet_alloc_timer(file);
	if (r < 0)
		return r;


