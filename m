Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1LDViS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 16:38:18 -0500
Received: from science.horizon.com ([71.41.210.146]:63655 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754058Ab1LDViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:38:17 -0500
Date: 4 Dec 2011 16:38:16 -0500
Message-ID: <20111204213816.12121.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, viro@ZenIV.linux.org.uk
Subject: Re: Is there a reason hard links from /proc/$PID/fd/$NUM are disallowed?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20111204210027.GA2203@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You do realize that link(2) does *NOT* follow links, do you?  linkat(2)
> does, if you explicitly ask for that:
> 
> linkat(AT_FDCWD, "/proc/42/fd/1", AT_FDCWD, "/tmp/foo", AT_SYMLINK_FOLLOW)
> 
> will do it just fine.

Thank you very much!  What's embarrassing is that I actually *knew* that once.

That seems to change the error message.

cd /run/shm	# A tmpfs directory
echo foo > foo
sleep 10000 < foo &
pid=$!
rm foo
strace ln -L /proc/$pid/fd/0 bar

produces:
stat64("/run/shm/bar", 0xbfb7b46c)      = -1 ENOENT (No such file or directory)
stat64("/proc/25098/fd/0", {st_mode=S_IFREG|0644, st_size=4, ...}) = 0
linkat(AT_FDCWD, "/proc/25098/fd/0", AT_FDCWD, "/run/shm/bar", 1024) = -1 ENOENT
 (No such file or directory)

(1024 is indeed AT_SYMLINK_FOLLOW)

It seems to work, however, if the file is *not* deleted first.
