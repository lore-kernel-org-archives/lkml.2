Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0DGFYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 01:24:23 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:39769 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854Ab0DGFYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 01:24:17 -0400
Subject: Re: [PATCH] relay: move remove_buf_file inside relay_close_buf
From: Tom Zanussi <zanussi@comcast.net>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, dwilder@us.ibm.com,
       lkessler@us.ibm.com
In-Reply-To: <87hbnox6ty.fsf@openvz.org>
References: <1267292137-12930-1-git-send-email-dmonakhov@openvz.org>
	 <87hbnox6ty.fsf@openvz.org>
Content-Type: text/plain
Date: Wed, 07 Apr 2010 00:24:14 -0500
Message-Id: <1270617854.6416.21.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 13:34 +0400, Dmitry Monakhov wrote:
> add Tom Zanussi to recipients.
> Tom, please take a look at the patch, it is simple and clean and it able
> to solve long standing blktrace related bug.

Hi,

It looks ok to me - I don't see any problems with it, but you should
probably get the official relay maintainer(s?) to take a look at it as
well - adding them to the cc: list.

Tom

> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> > Currently remove_buf_file callback is called from from kobject
> > release method. This result in follow issue:
> > # blktrace -d /dev/sda1 -d /dev/sda -o test
> > blktrace_setup()
> >  dir = create_dir()
> >  rchan = relay_open(dir,...)
> >  ->create_buf_file_callback
> >     buf_file  = debugfs_create_file(dir, )
> >
> > Userspace will open buf_file.
> > Later we make a decision to stop tracing
> > blktrace_down()
> >   relay_close(rhcan)  /* just decrement kobj reference  */
> >                       /* since it is not zero then callback not called */
> >   debugfs_remove(dir) /* FAIL due to non empty dir   */
> >
> > Later user space will close the file and file will be deleted,
> > but directory still exist.
> > user_space_close()
> >  ->file_release
> >    ->release_buf_file_callback
> >      ->debugfs_remove(buf_file)
> >
> > In fact this is general issue, blktrace is just one of examples.
> > We can not reliably remove parent dir until all users close the
> > buf_file.
> >
> > We don't have to wait this long. File may be deleted
> > inside relay_close_buf().
> >
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  kernel/relay.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/relay.c b/kernel/relay.c
> > index c705a41..dcf71c8 100644
> > --- a/kernel/relay.c
> > +++ b/kernel/relay.c
> > @@ -237,7 +237,6 @@ static void relay_destroy_buf(struct rchan_buf *buf)
> >  static void relay_remove_buf(struct kref *kref)
> >  {
> >  	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
> > -	buf->chan->cb->remove_buf_file(buf->dentry);
> >  	relay_destroy_buf(buf);
> >  }
> >  
> > @@ -487,6 +486,7 @@ static void relay_close_buf(struct rchan_buf *buf)
> >  {
> >  	buf->finalized = 1;
> >  	del_timer_sync(&buf->timer);
> > +	buf->chan->cb->remove_buf_file(buf->dentry);
> >  	kref_put(&buf->kref, relay_remove_buf);
> >  }

