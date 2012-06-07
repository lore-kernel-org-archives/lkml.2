Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab2FGJHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:07:15 -0400
Received: from canardo.mork.no ([148.122.252.1]:40366 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760214Ab2FGJHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:07:12 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 02/13] code cleanup
Organization: m
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
	<1339057243-10029-3-git-send-email-stefani@seibold.net>
Date: Thu, 07 Jun 2012 11:06:24 +0200
In-Reply-To: <1339057243-10029-3-git-send-email-stefani@seibold.net>
	(stefani@seibold.net's message of "Thu, 7 Jun 2012 10:20:32 +0200")
Message-ID: <877gvjtrsf.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefani@seibold.net writes:

> @@ -95,15 +93,12 @@ static int skel_open(struct inode *inode, struct file *file)
>  	if (!interface) {
>  		pr_err("%s - error, can't find device for minor %d\n",
>  			__func__, subminor);
> -		retval = -ENODEV;
> -		goto exit;
> +		return -ENODEV;
>  	}


This may save you a line, but that line was there for a reason...

Using a common exit path for errors makes it easier to keep unlocking,
deallocation and other cleanups correct.  Although you *can* do that
change now, you introduce future bugs here.  Someone adding a lock
before this will now have to go through all the error paths to ensure
that they unlock before exiting.

See "Chapter 7: Centralized exiting of functions" in
Documentation/CodingStyle.

Most of this patch consists of this kind of bogus changes.  I won't
comment on the rest of them.

Focus on creating a *good* example.  Compacting the code is not
necessarily improving the code...



>  	/* verify that we actually have some data to write */
> -	if (count == 0)
> -		goto exit;
> +	if (!count)
> +		return 0;

zero-testing is discussed over and over again, and is a matter of
taste. But I fail to see how changing it can be part of a cleanup.  It
just changes the flavour to suit another taste.  What's the reason for
doing that?



Bjørn
