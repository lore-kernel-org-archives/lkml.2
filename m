Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2FZUUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:20:20 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63044 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2FZUUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:20:17 -0400
Date: Tue, 26 Jun 2012 15:20:09 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dash@vger.kernel.org
Subject: Re: [PATCH] fifo: Do not restart open() if it already found a partner
Message-ID: <20120626202009.GA382@burratino>
References: <1340712298-4583-1-git-send-email-andersk@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1340712298-4583-1-git-send-email-andersk@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anders Kaseorg wrote:

> The following test demonstrates the EINTR that was wrongly thrown from
> the parent’s open().  Change .sa_flags = 0 to .sa_flags = SA_RESTART
> to see a deadlock instead, in which the restarted open() waits for a
> second reader that will never come.

Nice.

To recap, reading a fifo without a writer (resp. when writing a fifo
without a reader), fifo_open() without O_NONBLOCK waits for the other
end to be opened:

	if (!pipe->writers) {
		if ((filp->f_flags & O_NONBLOCK)) {
			...
		} else {
			wait_for_partner(inode, &pipe->w_counter);

The wait_for_partner() function waits for the pipe to be opened.
It is interruptible.  Inlining a little for clarity[*]:

	int cur = pipe->w_counter;

	while (cur == pipe->w_counter) {
		DEFINE_WAIT(wait);

		prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
		pipe_unlock(pipe);
		schedule();
		finish_wait(&pipe->wait, &wait);
		pipe_lock(pipe);

		if (signal_pending(current))
			break;
	}

In the window while i_mutex is unlocked, it is possible for the fifo
to be opened for writing and closed again.  That's fine --- open()
should succeed as long as someone has successfully opened the pipe for
writing.  And similarly, if a writer opens the pipe and a signal
arrives, we should let open() succeed.  The rest of fifo_open() is
quick and the signal will still be promptly delivered afterwards.  So
this looks like a good patch.

Two small details:

 1. I wasn't able to get your testcase to reliably fail (on 3.0.36).
    Sometimes it would produce EINTR quickly and sometimes it prefers
    to spew out dots.  Perhaps a note would help avoid confusing people
    that want to see if their kernel is affected.

 2. The return value convention surprised me a little:

 -static void wait_for_partner(struct inode* inode, unsigned int *cnt)
 +static bool wait_for_partner(struct inode* inode, unsigned int *cnt)

It would be easier to guess the sense at a glance if it returned an
int (e.g., 0 or -ERESTARTSYS) so the caller could look like

	if (wait_for_partner(inode, &pipe->w_counter))
		/* wait failed */
		...

Documentation/CodingStyle says more about that in chapter 16.

Except for those two details,
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>

Thanks for a pleasant read.

[*] This is almost the same as

	int dummy;
	wait_event_interruptible(&pipe->wait, pipe->w_counter != cur, dummy);

except that we keep i_mutex held when placing the current task on the
waitqueue.  There's probably some simplification possible, but that's
a story for another day.
