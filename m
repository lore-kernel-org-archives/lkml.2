Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1JEO2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:28:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40311 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab1JEO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:28:09 -0400
Message-ID: <4E8C6836.1090601@suse.cz>
Date: Wed, 05 Oct 2011 16:22:46 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>
Subject: Re: NULL dereference in tty_open() [and other bugs there]
References: <20111004200544.GA21192@elgon.mountain>
In-Reply-To: <20111004200544.GA21192@elgon.mountain>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 10:05 PM, Dan Carpenter wrote:
> There is a NULL dereference here.  It was artificially triggered so
> not a huge priority.
> 
> drivers/tty/tty_io.c
>   1893          retval = tty_add_file(tty, filp);
>   1894          if (retval) {
>   1895                  tty_unlock();
>   1896                  tty_release(inode, filp);
>   1897                  return retval;
>   1898          }
> 
> tty_add_file() is supposed to setup filp->private_data but the
> allocation fails.  In tty_release() we call file_tty(filp),
> __tty_fasync() and tty_del_file() which dereference
> filp->private_data and Oops.

Thanks, that's very true. It was added by:
commit 0259894c732837c801565d038eaecdcf8fc5bbe7
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Wed Mar 23 10:48:37 2011 +0100

    TTY: fix fail path in tty_open
=====

So instead of leaks, we now crash, hmm.

> I looked at ptmx_open() to see how the error handling was done there.
> That function only calls tty_release() if tty_add_file() succeeds,
> so maybe we could just call devpts_kill_index() here and remove the
> tty_release()?  I don't know the code well enough to say.

No, that won't work. We need to revert all the changes done in
tty_reopen/tty_init_dev. Yes, ptmx_open looks broken to me too because
the tty is not properly freed.

What is worse, the tty_open code seems to be broken more than that.
* when tty_driver_lookup_tty fails in tty_open, we don't drop a
  reference to the tty driver.
* tty lookup looks broken for the current console. Look:

As of:
commit 4a2b5fddd53b80efcb3266ee36e23b8de28e761a
Author: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Date:   Mon Oct 13 10:42:49 2008 +0100

    Move tty lookup/reopen to caller
=====

The code looks like:
struct tty_struct *tty = NULL;
...
if (device == MKDEV(TTYAUX_MAJOR, 0)) {
  tty = get_current_tty(); // ==== tty is not NULL
...
  tty_kref_put(tty); // ==== tty is dropped
  goto got_driver;
}
... // ============== POINT 1 (see below)
if (tty) {
  retval = tty_reopen(tty);
  ...
}
=====

Previously we called tty_driver_lookup_tty unconditionally at POINT 1.
Now we pass a tty structure to tty_reopen for which we dropped a
reference count. I don't think this was intentional, right?


Back to the point of your email. I have a patch which splits
tty_add_file into:
* tty_alloc_file intented to be called earlier in the open functions, so
we don't need to rollback
* tty_add_file which doesn't fail. It sets up the structure and adds it
to the list.

Otherwise we would need to split tty_release into smaller functions
somehow. We would need at least decreasing refcounts, checking tty count
for zero and freeing tty.

I will submit the simpler way above (tty_add_file split) along with
fixes for the other 3 bugs (ptmx_open, tty driver refcount, tty_reopen
of an unreferenced tty) after I test them all a bit.

thanks,
-- 
js
suse labs
