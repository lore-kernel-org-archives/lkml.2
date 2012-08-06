Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2HFFIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:08:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44046 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2HFFId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:08:33 -0400
Message-ID: <501F514C.2090909@ozlabs.ru>
Date: Mon, 06 Aug 2012 15:08:28 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: how to implement platform specific per process parameter?
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

There is a per core register on modern POWER processors (POWER6+) called 
"DSCR": The DSCR (aka Data Stream Control Register) is supported on some
server PowerPC chips and allow some control over the prefetch of data
streams.

Its "per process" support has been added by
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=efcac6589a277c10060e4be44b9455cf43838dc1
"powerpc: Per process DSCR + some fixes (try#4)"

The patch adds the DSCR value into "struct thread_struct" and 
saves/restores it when the context is switched. Also, there is some policy 
to initialize the register when a thread starts. So far so good.

Here is the problem.

Some customer(s) of this feature want an ability to change the DSCR value 
of the already running process. I.e. we need some kernel interface which 
would accept pid and the register value and change it.

There are 4 options:
1. [not a kernel interface] use ptrace to execute the register changing 
command inside the specified pid. The next context switch saves the new 
value in the thread_struct. Dirty hack.

2. Add a new syscall which would receive pid + register value and do the 
job. A bit too much.

3. Add some hook in /proc filesystem but so far there were no platform 
specific bits, right?

4. Implement a static node "/sys/devices/system/cpu/dscr_control". write() 
would parse the input stream, call scanf("%d %x", &pid, &dscr) and do the job.

What is the correct approach? Thanks.


-- 
Alexey
