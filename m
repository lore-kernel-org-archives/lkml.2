Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0K0Wcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 17:32:33 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56692 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0K0Wcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 17:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pFvQc0mAuLglyMM96nBytT+fHah3kcGgCn57Tos4gYMGw7EaEeclnBxTupAlmY/lu2
         wyoytaBiXbQiGa/zlL350UgTOK1uU4j5b3eDcxIOrgAJk8MYOvngNFA/doWwq/hGGHli
         ucdqGDWorJncQxkExixxXG3oL/218fkyC2Tnc=
Date: Sat, 27 Nov 2010 16:32:19 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Message-ID: <20101127223217.GA26820@burratino>
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
 <20100826170142.e029cff5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826170142.e029cff5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:
> Sage Weil wrote:

>>  The ability to sync a single 
>> mount can be useful for both applications and administrators (e.g., when 
>> other mounts on the system are hung).
>> 
>> Introduce a simple ioctl to sync the super associated with an open file.
>> Pass any error returned by sync_filesystem() back to the user.
>
> The changelog forgot to tell us why this is a useful thing to add. 
> What is the use-case?

Here's a use case.

dpkg, like most package managers, occasionally needs to drop in a whole
bunch of new versions of essential files in the file system.  Since
ancient times, that has been done with the "rename trick":

	open("/lib/libc.so.6.dpkg-tmp", ...
	write(...
	open("/lib/libm.so.6.dpkg-tmp", ...
	write(...
	...
	/* done staging!  now move into place. */
	rename("/lib/libc.so.6.dpkg-tmp", "/lib/libc.so.6");
	rename("/lib/libm.so.6.dpkg-tmp", "/lib/libm.so.6");
	...

This way, each file has either the old content or the new content,
and we can back out upgrades for certain errors (e.g., disk full).

Great.  Problem is, filesystems with delayed allocation like XFS,
ubifs, ext4, hfs+ don't cope so well with that[1].  We need to sync
the files at some point before the rename[2] to prevent zero-length
files and similar oddities.  What system call to use?

 - a storm of fsyncs causes inappropriate constraints on the order
   of writes.  The result is very slow and can result in unnecessary
   wear.

 - a sync() causes I/O on unrelated filesystems.  The result can be
   very slow and can result in unnecessary wear.

A nice compromise is to only sync the affected filesystems, using
something like this ioctl[3].

> If we're going to add something like this then it will need to be
> documented in manpages.  Supposedly, a cc to linux-api@vger.kernel.org
> will help make all that happen, but I'm not sure who if anyone is
> answering the phone over there?

Michael, does the API look okay?

Hope that helps,
Jonathan

[1] Yes, even after v2.6.30-rc1~416^2~15 (ext4: Automatically allocate
delay allocated blocks on rename, 2009-02-23).
See https://bugzilla.kernel.org/show_bug.cgi?id=18632

[2] http://lists.debian.org/debian-dpkg/2010/11/msg00039.html
http://lists.debian.org/debian-devel/2010/11/msg00550.html

[3] http://lists.debian.org/debian-dpkg/2010/11/msg00069.html
