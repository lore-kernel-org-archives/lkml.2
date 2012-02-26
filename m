Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2BZIoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 03:44:06 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:54018 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab2BZIoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 03:44:04 -0500
Date: Sun, 26 Feb 2012 08:44:03 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: avoid EINVAL if user input is valid
Message-ID: <20120226084403.GA4641@dcvr.yhbt.net>
References: <20120225022710.GA29455@dcvr.yhbt.net>
 <CAJd=RBDHB8yM=LGkzhOWZO6ftYFyZ42SQKySc0hUzNEQzrmVTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBDHB8yM=LGkzhOWZO6ftYFyZ42SQKySc0hUzNEQzrmVTw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton <dhillf@gmail.com> wrote:
> On Sat, Feb 25, 2012 at 10:27 AM, Eric Wong <normalperson@yhbt.net> wrote:
> > index 469491e0..f9e48dd 100644
> > --- a/mm/fadvise.c
> > +++ b/mm/fadvise.c
> > @@ -43,13 +43,13 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
> >                goto out;
> >        }
> >
> > -       mapping = file->f_mapping;
> > -       if (!mapping || len < 0) {
> > +       if (len < 0) {
> 
> Current code makes sure mapping is valid after the above check,

Right.  I moved the !mapping check down a few lines.

> >                ret = -EINVAL;
> >                goto out;
> >        }

Now the check hits the "goto out" the get_xip_mem check hits:

> > -       if (mapping->a_ops->get_xip_mem) {
> > +       mapping = file->f_mapping;
> > +       if (!mapping || mapping->a_ops->get_xip_mem) {
> >                switch (advice) {
> >                case POSIX_FADV_NORMAL:
> >                case POSIX_FADV_RANDOM:

		case POSIX_FADV_SEQUENTIAL:
		case POSIX_FADV_WILLNEED:
		case POSIX_FADV_NOREUSE:
		case POSIX_FADV_DONTNEED:
			/* no bad return value, but ignore advice */
			break;
		default:
			ret = -EINVAL;
		}
		goto out; <------ we hit this if (mapping == NULL)
	}

> but backing devices info is no longer evaluated with that
> guarantee in your change.
> 
> -hd
> 
> 75:	bdi = mapping->backing_dev_info;

The above line still doesn't evaluated because of the goto.

out:
	fput(file);
	return ret;
}
