Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0LaDRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 22:17:51 -0500
Received: from science.horizon.com ([71.41.210.146]:11391 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750812Ab0LaDRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 22:17:50 -0500
Date: 30 Dec 2010 22:17:48 -0500
Message-ID: <20101231031748.5006.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: Trond.Myklebust@netapp.com
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uncached_readdir is not really a problem. The real problem is
> filesystems that generate "infinite directories" by producing looping
> combinations of cookies.
> 
> IOW: I've seen servers that generate cookies in a sequence of a form
> vaguely resembling
> 
> 1 2 3 4 5 6 7 8 9 10 11 12 3...
> 
> (with possibly a thousand or so entries between the first and second
> copy of '3')
> 
> The kernel won't loop forever with something like that (because
> eventually filldir() will declare it is out of buffer space), but
> userland has a halting problem: it needs to detect that every
> sys_getdents() call it is making is generating another copy of the
> sequence associated with '4 5 6 7 8 9 10 11 12 3'...

Huh?  This is not only an easy problem, it's a well-known problem.
http://en.wikipedia.org/wiki/Cycle_detection

	Here's Brent's algorithm:

	n = 0;
	saved_cookie = <invalid>
	For each cookie {
		if (n && cookie == saved_cookie)
			die("Loop detected!");
		if (++n is a power of 2)
			saved_cookie = cookie;
	}

You can tweak the performance with other exponentially-growing
functions, saving k > 1 old cookies for comparison, etc., but the
above will work very well.
