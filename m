Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab2BOGww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:52:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60803 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2BOGwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:52:50 -0500
Date: Wed, 15 Feb 2012 10:52:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [patch 2/4] syscalls, x86: Add __NR_kcmp syscall v8
Message-ID: <20120215065245.GB1894@moon>
References: <20120213164822.227219834@openvz.org>
 <20120213165137.903318774@openvz.org>
 <20120214151312.92afd44a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214151312.92afd44a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 03:13:12PM -0800, Andrew Morton wrote:
...
> 
> hm, what does all this stuff in the selftest makefile do?
> 
> The selftests code has undergone some changes since you last looked. 

Hmm, thanks for pointing.

> The rules are, roughly:
> 
> - In tools/testing/selftests, a "make" will compile but not run all
>   selftest code.
> 
> - In tools/testing/selftests, a "make run_tests" will compile all
>   selftest code (if needed) and will then run all the tests.
> 
>   If a test is not applicable (eg wrong architecture, kernel feature
>   not enabled, etc) then it should try to avoid breaking the build and,
>   when executed it should emit a diagnostic and then exit(0) (ie:
>   success) so as to avoid breaking the overall test run.
> 
>   IOW, the test should only fail if the feature is present but isn't
>   working correctly.
> 
> Also, I hate with a passion Makefiles which hide the command lines from
> me!  So I nuked all that E and Q stuff.
> 

make V=1 will show the command line, I tried to make the output to look
the same as in case of building kernel.

> 
> However that didn't work for me:
> 
> akpm:/usr/src/25/tools/testing/selftests/kcmp> make
> gcc -DCONFIG_X86_64 -D__x86_64__ -I../../../../arch/x86/include/generated/ ...
> kcmp_test.c: In function 'sys_kcmp':
> kcmp_test.c:22: error: '__NR_kcmp' undeclared (first use in this function)
...
> How are we supposed to be picking up __NR_kcmp?
> 

Initially I made it to look into arch/x86 directory and find __NR_kcmp
definition there but then I realised (and someone pointed me as
well) that headers should be taken from those which are generated
by kernel, ie the result of 'make headers_install'. So if you run
make headers_install then the test program should work. If this is
wrong, I can fix it and make a patch on top.

Ie instead of

+#include <linux/unistd.h>

there will be

+#ifdef CONFIG_X86_64
+#include <asm/unistd_64.h>
+#else
+#include <asm/unistd_32.h>
+#endif

	Cyrill
