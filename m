Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2GXWqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:46:40 -0400
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:54625
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab2GXWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:46:39 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 18:46:39 EDT
Date: Tue, 24 Jul 2012 15:37:02 -0700
From: Zach Brown <zab@zabbo.net>
To: Ankit Jain <jankit@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
Message-ID: <20120724223702.GB6723@lenny.home.zabbo.net>
References: <500E89D1.9010303@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E89D1.9010303@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 05:11:05PM +0530, Ankit Jain wrote:
> 
> Currently, io_submit tries to execute the io requests on the
> same thread, which could block because of various reaons (eg.
> allocation of disk blocks). So, essentially, io_submit ends
> up being a blocking call.

Yup, sadly that's how its built.  A blocking submission phase that
returns once completion doesn't need the submitters's context.  It
happens to mostly work for O_DIRECT block IO most of the time.

> With this patch, io_submit prepares all the kiocbs and then
> adds (kicks) them to ctx->run_list (kicked) in one go and then
> schedules the workqueue. The actual operations are not executed
> on io_submit's process context, so it can return very quickly.

Strong nack; this isn't safe without having done the work to ensure that
all the task_struct references under the f_op->aio_*() paths won't be
horribly confused to find a kernel thread instead of the process that
called io_submit().

The one-off handling of the submitters's cred is an indication that
there might be other cases to worry about :).

> 3. Also, I tried not using aio_queue_work from io_submit call, and instead
> depending on an already scheduled one or the iocbs being run when
> io_getevents gets called. This seemed to give improved perfomance. But
> does this constitute as change of api semantics?

You can't rely on io_getevents() being called for forward progress.  Its
perfectly reasonable for a task to wait for io completion by polling an
eventfd that aio_complete() notifies, for instance.

- z
