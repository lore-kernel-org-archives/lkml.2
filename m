Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0FOLcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:32:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab0FOLca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:32:30 -0400
Message-ID: <4C1764CD.3080402@suse.cz>
Date: Tue, 15 Jun 2010 13:32:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Running make install over sshfs is painful now
References: <20100607065324.GA25590@core.coreip.homeip.net>
In-Reply-To: <20100607065324.GA25590@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.6.2010 08:53, Dmitry Torokhov wrote:
> Hi,
> 
> With the following commit running "make modules_install install" over
> sshfs (and I suppose nfs) is extremely painful:
> 
> commit fb994ecc2b1c214951366c2ba5d8b121f0010d1f
> Author: Greg Thelen <gthelen@google.com>
> Date:   Wed May 5 10:41:44 2010 -0700
> 
>     kbuild: Fix checking of scm-identifier variable
...

Commit 85a256d8 and this one just exposed a problem we had before with
CONFIG_LOCALVERSION_AUTO, namely that the Makefile computes the release
string on _every_ invocation:

$ strace -feexecve make help 2>&1 | grep -v ' -1 ' | grep git
[pid 13788] execve("/usr/bin/git", ["git", "rev-parse", "--verify",
"--short", "HEAD"], [/* 88 vars */]) = 0
[pid 13790] execve("/usr/bin/git", ["git", "describe", "--exact-match"],
[/* 88 vars */]) = 0
[pid 13792] execve("/usr/bin/git", ["git", "describe"], [/* 88 vars */]) = 0
[pid 13795] execve("/usr/bin/git", ["git", "config", "--get",
"svn-remote.svn.url"], [/* 88 vars */]) = 0
[pid 13796] execve("/usr/bin/git", ["git", "update-index", "--refresh",
"--unmerged"], [/* 88 vars */]) = 0
[pid 13797] execve("/usr/bin/git", ["git", "diff-index", "--name-only",
"HEAD"], [/* 88 vars */]Process 13786 suspended

> Any cfhance we could generate the tag at compile time
> as opposed to install time?

The Makefile already stores the string in include/config/kernel.release
during 'make prepare', but it is nevertheless recomputed every time.
Need to clean this up.

Michal
