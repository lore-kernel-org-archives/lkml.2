Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab2DDDBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:01:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39820 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2DDDBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:01:21 -0400
Date: Wed, 4 Apr 2012 04:01:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120404030117.GA6589@ZenIV.linux.org.uk>
References: <20120401125741.GA7484@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 03:57:42PM +0300, Alexey Dobriyan wrote:
> Currently there is no reliable way to close all opened file descriptors
> (which daemons need and like to do):
> 
> * dumb close(fd) loop is slow, upper bound is unknown and
>   can be arbitrary large,
> 
> * /proc/self/fd is unreliable:
>   proc may be unconfigured or not mounted at expected place.
>   Looking at /proc/self/fd requires opening directory
>   which may not be available due to malicious rlimit drop or ENOMEM situations.
>   Not opening directory is equivalent to dumb close(2) loop except slower.
> 
> BSD added closefrom(fd) which is OK for this exact purpose but suboptimal
> on the bigger scale. closefrom(2) does only close(2) (obviously :-)
> closefrom(2) siletly ignores errors from close(2) which in theory is not OK
> for userspace.
> 
> So, don't add closefrom(2), add nextfd(2).

Or unshare(CLONE_FILES_EMPTY) to steal an idea from rfork(2) (Plan 9 one,
that is - I don't remember if its *BSD analog has that).  Basically, they
allow 3 kinds of behaviour on clone(2) analog (and unshare(2) is part of
the same thing there):
	1) share descriptor table with parent (default for rfork(2))
	2) copy descriptor table from parent (RFFDG is set in flags)
	3) give child an empty descriptor table (RFCFDG is set in flags)
They have something similar for namespace, BTW - the same share/copy/clean
triple.

