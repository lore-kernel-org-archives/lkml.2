Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1CRLVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:21:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1CRLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j3ffDn3Ckb4DQKGfW3e8QfiPu/8P3O8D+eab3AobwJSSb5LemJVeKfnFFwL1Jdb2rK
         dawsCSu9yVzNs9IUcwBmu7Y+PAGD09BOQVim196/OeQui6Tn5M9+pINNYNJbbFu5nh7Y
         NPfQ7FJt2JGZcOoNY2GlHiVROv4JyvxxVI15g=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC 0/2] Correct stack trace info
Date: Fri, 18 Mar 2011 20:21:16 +0900
Message-Id: <1300447278-2073-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently I've spent some time with kgdb and found a interesting thing.
The code I've used is Jason Wessel's sample module which can be downloaded
at following URL.

  http://kernel.org/pub/linux/kernel/people/jwessel/dbg_webinar/crash_mod.tar.bz2

It build a kernel module "test_panic" and after the module is loaded it
makes some files in /proc/test_panic directory. Most of them are supposed
to kernel panic when they're written. A simple usage is like below:

# echo 1 > /proc/test_panic/panic

[   18.345571] Starting panic
[   18.345730] Kernel panic - not syncing: test_panic running!
[   18.345752]
[   18.345856] Pid: 36, comm: sh Not tainted 2.6.38-rc8+ #83
[   18.345923] Call Trace:
[   18.346001]  [<ffffffff812a8502>] panic+0x8c/0x18d
[   18.346257]  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- ???
[   18.346347]  [<ffffffff81104666>] proc_file_write+0x73/0x8d
[   18.346432]  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
[   18.346516]  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
[   18.346603]  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
[   18.346801]  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b

In this case, offending function is "panic_write()" but the trace showed
me a different function "deep01()". I was a bit confused at first. The
panic_write() function is a very simple code which calls panic() at the
end of the function.

static int panic_write(struct file *file, const char *buffer,
                       unsigned long count, void *data)
{
	trace_printk("Starting panic\n");
	printk(KERN_INFO "Starting panic\n");
	panic("test_panic running!\n");
	return count;
}

But where did the "deep01()" come from?

This was due to a gcc's optimization. Because the panic() was known not to
return to the caller (it has "noreturn" attribute), the gcc optimized out
remaining code after calling to the panic(). But PC was incremented after
the call as usual, so return address saved in stack pointed a different
(very next) function.

I ran objdump on test_panic.ko and got following result.

 ... (snipped) ...

000000000000010a <panic_write>:
 10a:	55                   	push   %rbp
 10b:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 112:	31 c0                	xor    %eax,%eax
 114:	48 89 e5             	mov    %rsp,%rbp
 117:	e8 00 00 00 00       	callq  11c <panic_write+0x12>
 11c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 123:	31 c0                	xor    %eax,%eax
 125:	e8 00 00 00 00       	callq  12a <deep01>   <--- call panic() !!!

000000000000012a <deep01>:
 12a:	55                   	push   %rbp
 12b:	31 c0                	xor    %eax,%eax
 12d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 ... (snipped) ...


To this end, I added sprint_trace() and %pT specifier for printk(). They'll
do the same symbol lookup but with the offset subtracted by 1 to ensure it
would be in the same function - and increment it again before printing.

It will not affect normal trace case and the only problematic case will be
the case where return address is really the start of a function (offset 0).
But I think this cannot happen during stack trace because calling a function
always increases PC and then saves. Thus even if there's a call at the
beginning in a function, its return address will not have the 0-offset. But
other symbol lookups could still use 0-offset for some purpose, I added new
helper to separate them.

I've only checked this on x86_64 on qemu, but other architectures may want
this too :) It seems work well for me.

[   22.224483] Call Trace:
[   22.224569]  [<ffffffff812bce69>] panic+0x8c/0x18d
[   22.224848]  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic]  <--- !!!
[   22.224979]  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
[   22.225089]  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
[   22.225199]  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
[   22.225304]  [<ffffffff810d91cb>] sys_write+0x45/0x6c
[   22.225408]  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b

Any comments are welcome.


Thanks.

---

Namhyung Kim (2):
  vsprintf: introduce %pT format specifier
  x86, dumpstack: use %pT format specifier for stack trace

 arch/x86/kernel/dumpstack.c |    2 +-
 include/linux/kallsyms.h    |    7 +++++++
 kernel/kallsyms.c           |   26 ++++++++++++++++++++++++++
 lib/vsprintf.c              |    7 ++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

--
1.7.4

