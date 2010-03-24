Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab0CXUnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:43:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756822Ab0CXUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:43:06 -0400
Date: Wed, 24 Mar 2010 21:42:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
Message-ID: <20100324204259.GA6423@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-9-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269361063-3341-9-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Switch /dev/snapshot writer to sws_module_ops approach so that we
> can transparently rewrite the rest of the snapshot from pages pulling
> to their pushing through layers.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/user.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 105 insertions(+), 8 deletions(-)
>

> +	if (test_bit(TODO_CLOSED, to_do_flags))
> +		return -EIO;
> +
> +	to_do_buf = buf;
> +	wmb();
> +	set_bit(TODO_WORK, to_do_flags);
> +	wake_up_interruptible(&to_do_wait);

Uhuh, open-coded barriers... these need to be commented, and I guess
you just should not play this kind of trickery.

spnlocks? Normal locks?

> +
> +	wait_event(to_do_done, !test_bit(TODO_WORK, to_do_flags) ||
> +			(err = test_bit(TODO_CLOSED, to_do_flags)));
> +
> +	return err ? -EIO : 0;
> +}
> +
> +static int put_user_writer(unsigned int flags, int error)
> +{
> +	int err = 0;
> +
> +	if (error)
> +		set_bit(TODO_ERROR, to_do_flags);
> +	set_bit(TODO_FINISH, to_do_flags);
> +	wake_up_interruptible(&to_do_wait);
> +
> +	wait_event(to_do_done, !test_bit(TODO_FINISH, to_do_flags) ||
> +			(err = test_bit(TODO_CLOSED, to_do_flags)));
> +
> +	if (!error && err)
> +		error = -EIO;
> +
> +	return error;
> +}
> +
>  struct sws_module_ops user_ops = {
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
