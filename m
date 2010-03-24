Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0CXWct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:32:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab0CXWcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:32:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 02/15] PM / Hibernate: snapshot cleanup
Date: Wed, 24 Mar 2010 23:35:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003242335.36816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Remove support of reads with offset. This means snapshot_read/write_next
> now does not accept count parameter.
> 
> /dev/snapshot handler is converted to simple_read_from_buffer/simple_write_to_buffer.

Makes sense.

One coding style comment, though.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/power.h    |   18 +-----
>  kernel/power/snapshot.c |  145 ++++++++++++++++++-----------------------------
>  kernel/power/swap.c     |    8 +-
>  kernel/power/user.c     |   39 ++++++++-----
>  4 files changed, 88 insertions(+), 122 deletions(-)
> 
...  
> @@ -159,13 +160,17 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
>  		res = -ENODATA;
>  		goto Unlock;
>  	}
> -	res = snapshot_read_next(&data->handle, count);
> -	if (res > 0) {
> -		if (copy_to_user(buf, data_of(data->handle), res))
> -			res = -EFAULT;
> -		else
> -			*offp = data->handle.offset;
> -	}
> +	if (!pg_offp) { /* on page boundary? */
> +		res = snapshot_read_next(&data->handle);
> +		if (res <= 0)
> +			goto Unlock;
> +	} else
> +		res = PAGE_SIZE - pg_offp;

The official kernel coding style is to put single instructions under if/else
like this in braces if the other branch of the if/else is multiline (and
therefore naturally in braces).   So please do:

+	if (!pg_offp) { /* on page boundary? */
+		res = snapshot_read_next(&data->handle);
+		if (res <= 0)
+			goto Unlock;
+	} else {
+		res = PAGE_SIZE - pg_offp;
+	}

and analogously wherever applicable.

Thanks,
Rafael
