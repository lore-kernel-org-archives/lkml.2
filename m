Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1G1Sj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:39:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12562 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1G1SjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:39:23 -0400
Date: Thu, 28 Jul 2011 20:39:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux child process does not core dump 
In-Reply-To: <1311857213.26660.YahooMailNeo@web137313.mail.in.yahoo.com>
Message-ID: <alpine.LNX.2.00.1107282026440.20379@swampdragon.chaosbits.net>
References: <1311857035.41442.YahooMailNeo@web137319.mail.in.yahoo.com> <1311857213.26660.YahooMailNeo@web137313.mail.in.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Srinivas Nayak wrote:

> Hi,
> 
> In my program, I fork() to get a child process.
> Because of some problem, child process terminates by a segmentation fault.
> Parent process is still running.
> 
> I have compiled my code with -g option.
> I have done: ulimit -c unlimited.
> 
> I am not getting core dump of the child process.
> 
> How can I get the core dump of child process?
> 

As you've noticed, by default core dumps are usually supressed (ulimit -c 
is 0 (zero)). As you mention yourself, you can change this with "ulimit -c 
unlimited" (or a specific size rather than "unlimited". But there are 
still a few things you need to be aware of:

1. The ulimit setting you just made only takes effect for the shell that 
you run it in. So if, for example, you are running "ulimit -c unlimited" 
in one xterm and then launch your app from a different xterm, then that 
second xterm will still have "ulimit -c 0" and you won't get your dump. So 
start the app from the same shell that you used to execute "ulimit -c 
unlimited".

2. If your application changes its working directory before crashing, then 
the core dump will be in the directory it changed to, not in the directory 
you launched it from. Be sure you are looking for the "core" file in the 
right location.

3. If the current working directory of the application is mounted 
read-only or doesn't have sufficient space to write your core dump, then 
you won't get any. Make sure the app's current working directory is 
writable and has sufficient space available.


Try this for a test:

$ cat crash.c
#include <stdlib.h>

int main()
{
  abort();
}
$ gcc crash.c
$ ./a.out
Aborted (core dumped)
$ ls -l core
-rw------- 1 jj users 221184 Jul 28 20:34 core
$ file core
core: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style, from './a.out'
$ 


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

