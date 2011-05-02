Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1EBL53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 07:57:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1EBL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 07:57:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH v3] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Mon, 2 May 2011 13:57:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>,
        Matthew Wilcox <matthew@wil.cx>, Al Viro <viro@zeniv.linux.org.uk>,
        Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1304093980-12877-1-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1304093980-12877-1-git-send-email-andrea@betterlinux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021357.10560.arnd@arndb.de>
X-Provags-ID: V02:K0:4zQbzxwQM5IzmdCTRSNqdm/9NvjsoIgPopVvOxcQKqt
 KH4WRlGefrV/8T43EEahB9CCVZqogJd7k091nlA/oRzRVyp9Ph
 QJrAcxYns5vZNosnrhH4vgY5nQHfITGzM9YiCb7KkFg6j/eKU5
 YMepRODB2iHreTlJmt/3Cl8XXGKyE6WULuzHQbnOXxJN+ya7UB
 xLU5l2PEJGFd1SLyGg0CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 April 2011, Andrea Righi wrote:
> NOTE #1: to avoid potential DoS in the system the rate of calls to
> fadvise(POSIX_FADV_DONTNEED_FS) from non-privileged users are limited
> according to these settings:
> 
>  - /proc/sys/vm/drop_pagecache_ratelimit: the minimum length of time
>    allowed beetween two different bursts of fadvise(POSIX_FADV_DONTNEED_FS)
> 
>  - /proc/sys/vm/drop_pagecache_ratelimit_burst: the number of calls to
>    fadvise(POSIX_FADV_DONTNEED_FS) that can be issued before enforcing
>    the rate limiting

The ratelimiting interface does not give me the happy feeling I had with
the original extremely syscall and fadvise, or with strictly limiting it
to certain capabilities. The ratelimit bursts seem well suited for log
messages, but it's not like you would expect anyone to read the fadvise
man page describing these and think "oh, of course, that's obviously
why it has to be done this way".

I don't have a perfect solution myself, but there are a few things
that feel wrong about yours:

* The rules for /proc/sys/vm/drop_caches and the fadvise are different
* You need to tune two variables to set one thing
* The rate limit is independent of the number of file systems you
  operate on: When you have mounted 20 file systems, you need to
  sleep for five seconds after flushing half of them, but you can
  flush one ten times in a row without being throttled.
* Returning an error gives no feedback about how soon it can
  be retried, in case you really need to flush.

	Arnd
