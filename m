Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0DFJe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:34:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2247 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0DFJeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:34:50 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Tom Zanussi <zanussi@comcast.net>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] relay: move remove_buf_file inside relay_close_buf
References: <1267292137-12930-1-git-send-email-dmonakhov@openvz.org>
Date: Tue, 06 Apr 2010 13:34:33 +0400
In-Reply-To: <1267292137-12930-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Sat, 27 Feb 2010 20:35:37 +0300")
Message-ID: <87hbnox6ty.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add Tom Zanussi to recipients.
Tom, please take a look at the patch, it is simple and clean and it able
to solve long standing blktrace related bug.
Dmitry Monakhov <dmonakhov@openvz.org> writes:
> Currently remove_buf_file callback is called from from kobject
> release method. This result in follow issue:
> # blktrace -d /dev/sda1 -d /dev/sda -o test
> blktrace_setup()
>  dir = create_dir()
>  rchan = relay_open(dir,...)
>  ->create_buf_file_callback
>     buf_file  = debugfs_create_file(dir, )
>
> Userspace will open buf_file.
> Later we make a decision to stop tracing
> blktrace_down()
>   relay_close(rhcan)  /* just decrement kobj reference  */
>                       /* since it is not zero then callback not called */
>   debugfs_remove(dir) /* FAIL due to non empty dir   */
>
> Later user space will close the file and file will be deleted,
> but directory still exist.
> user_space_close()
>  ->file_release
>    ->release_buf_file_callback
>      ->debugfs_remove(buf_file)
>
> In fact this is general issue, blktrace is just one of examples.
> We can not reliably remove parent dir until all users close the
> buf_file.
>
> We don't have to wait this long. File may be deleted
> inside relay_close_buf().
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  kernel/relay.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/relay.c b/kernel/relay.c
> index c705a41..dcf71c8 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -237,7 +237,6 @@ static void relay_destroy_buf(struct rchan_buf *buf)
>  static void relay_remove_buf(struct kref *kref)
>  {
>  	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
> -	buf->chan->cb->remove_buf_file(buf->dentry);
>  	relay_destroy_buf(buf);
>  }
>  
> @@ -487,6 +486,7 @@ static void relay_close_buf(struct rchan_buf *buf)
>  {
>  	buf->finalized = 1;
>  	del_timer_sync(&buf->timer);
> +	buf->chan->cb->remove_buf_file(buf->dentry);
>  	kref_put(&buf->kref, relay_remove_buf);
>  }
