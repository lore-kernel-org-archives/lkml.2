Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2BGAPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:15:04 -0500
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:39958 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227Ab2BGAPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:15:02 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 19:15:02 EST
Message-ID: <4F306ACA.4090404@akamai.com>
Date: Mon, 06 Feb 2012 18:05:30 -0600
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] poll() in 32-bit applications does not handle timeout
 of -1 properly on 64-bit kernels
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------010505020704050305040502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010505020704050305040502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

We've hit an issue where our 32-bit applications, when running on a
64-bit kernel, using poll() and passing in a value of -1 for the timeout
return after ~49 days (2^32 msec). Instead of waiting indefinitely as it
is stated they should. Reproducing the issue is trivial. I've
instrumented the kernel and found we are hitting the case where poll()
believes we've passed in a positive number and thus creates a timespec,
etc. Currently poll() is defined in userspace as:

int poll(struct pollfd *ufds, nfds_t nfds, int timeout);

but in the kernel timeout is of type long.

I can think of a few ways to solve this. One, which is the patch I've
attached, is to change the type of timeout to int in the kernel. I'm not
certain the ramifications this may have since it's changing a syscall's
arguments which may be a big no-no :) Another way I am proposing is by
bounds checking. Currently we do the following:

if (timeout_msecs >= 0) {
        to = &end_time;
        poll_select_set_timeout(to, timeout_msecs / MSEC_PER_SEC,
                        NSEC_PER_MSEC * (timeout_msecs % MSEC_PER_SEC));
}

We could add an upper bound on timeout_msecs to say < 0xffffffff. I'm
not sure if either is acceptable though.

Josh



--------------010505020704050305040502
Content-Type: text/x-patch;
 name="poll-timeout-try1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="poll-timeout-try1.patch"

commit 7f2c4ee58b66f51b5e2c79fc42db84ca4d6c0a18
Author: Josh Hunt <johunt@akamai.com>
Date:   Mon Feb 6 15:21:04 2012 -0800

    poll() in 32-bit applications does not handle timeout of -1 properly on 64-bit kernels
    
    We have observed our 32-bit applications running on 64-bit kernels which
    pass a value of -1 to poll()'s timeout argument do not wait infinitely as
    it should. Instead it winds up waiting ~49 days which is approx the # of msecs
    in 2^32 (or 32-bit negative 1.) With this patch both 32 and 64 bit applications
    now support handling of -1 as an argument for timeout.
    
    Signed-off-by: Josh Hunt <johunt@akamai.com>

diff --git a/fs/select.c b/fs/select.c
index d33418f..e782258 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -912,7 +912,7 @@ static long do_restart_poll(struct restart_block *restart_block)
 }
 
 SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
-		long, timeout_msecs)
+		int, timeout_msecs)
 {
 	struct timespec end_time, *to = NULL;
 	int ret;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 515669f..8ec1153 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -624,7 +624,7 @@ asmlinkage long sys_socketpair(int, int, int, int __user *);
 asmlinkage long sys_socketcall(int call, unsigned long __user *args);
 asmlinkage long sys_listen(int, int);
 asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
-				long timeout);
+				int timeout);
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
 asmlinkage long sys_old_select(struct sel_arg_struct __user *arg);

--------------010505020704050305040502--
