Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2BGRwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:52:01 -0500
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:46160 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab2BGRv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:51:59 -0500
Message-ID: <4F3164BC.4080005@akamai.com>
Date: Tue, 07 Feb 2012 11:51:56 -0600
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        arnd@arndb.de, linux-arch@vger.kernel.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] poll() in 32-bit applications does not handle timeout
 of -1 properly on 64-bit kernels
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------040602070607000404020709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602070607000404020709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/06/2012 06:38 PM, Al Viro wrote:
> On Mon, Feb 06, 2012 at 06:05:30PM -0600, Josh Hunt wrote:
>> We've hit an issue where our 32-bit applications, when running on a
>> 64-bit kernel, using poll() and passing in a value of -1 for the timeout
>> return after ~49 days (2^32 msec). Instead of waiting indefinitely as it
>> is stated they should. Reproducing the issue is trivial. I've
>> instrumented the kernel and found we are hitting the case where poll()
>> believes we've passed in a positive number and thus creates a timespec,
>> etc. Currently poll() is defined in userspace as:
>>
>> int poll(struct pollfd *ufds, nfds_t nfds, int timeout);
>>
>> but in the kernel timeout is of type long.
>>
>> I can think of a few ways to solve this. One, which is the patch I've
>> attached, is to change the type of timeout to int in the kernel. I'm not
>> certain the ramifications this may have since it's changing a syscall's
>> arguments which may be a big no-no :) Another way I am proposing is by
>> bounds checking. Currently we do the following:
>>
>> if (timeout_msecs >= 0) {
>>         to = &end_time;
>>         poll_select_set_timeout(to, timeout_msecs / MSEC_PER_SEC,
>>                         NSEC_PER_MSEC * (timeout_msecs % MSEC_PER_SEC));
>> }
>>
>> We could add an upper bound on timeout_msecs to say < 0xffffffff. I'm
>> not sure if either is acceptable though.
> 
> Or just add compat_sys_poll() with that argument being int and have it call
> sys_poll().  The value will be sign-extended...

Al

I've implemented what you suggested by adding compat_sys_poll() with
an int argument for timeout allowing it to do the sign extension. I
wanted to point out there was an almost identical patch submitted last
year, which appears to have gotten lost in the wash:
https://lkml.org/lkml/2011/9/18/19

I am guessing there are other architectures affected by this bug. This
patch only fixes x86.

Josh


--------------040602070607000404020709
Content-Type: text/x-patch;
 name="compat-sys-poll.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="compat-sys-poll.patch"

commit cde9eb901ccb3b5af3e501b018b90f16c53942c2
Author: Josh Hunt <johunt@akamai.com>
Date:   Mon Feb 6 20:51:31 2012 -0800

    compat: poll() in 32-bit applications does not handle negative timeout values properly on 64-bit kernels

    We have observed our 32-bit applications running on 64-bit kernels do not
    wait infinitely when passed a negative value for the timeout argument.
    Instead we see poll() returning in ~49 days or 2^32 msecs, because the
    timeout argument is not getting sign-extended. Implementing
    compat_sys_poll() to handle this case.

    Reported-by: Phil Lisiecki <lisiecki@akamai.com>
    Signed-off-by: Josh Hunt <johunt@akamai.com>
    Cc: <stable@vger.kernel.org>

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index ce98e28..8407150 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -174,7 +174,7 @@
 165	i386	getresuid		sys_getresuid16
 166	i386	vm86			ptregs_vm86			sys32_vm86_warning
 167	i386	query_module
-168	i386	poll			sys_poll
+168	i386	poll			sys_poll			compat_sys_poll
 169	i386	nfsservctl
 170	i386	setresgid		sys_setresgid16
 171	i386	getresgid		sys_getresgid16
diff --git a/fs/compat.c b/fs/compat.c
index fa9d721..77bd50e 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1611,6 +1611,12 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				 sigsetsize);
 }
 
+asmlinkage long compat_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
+	int timeout_msecs)
+{
+	return sys_poll(ufds, nfds, timeout_msecs);
+}
+
 asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 	unsigned int nfds, struct compat_timespec __user *tsp,
 	const compat_sigset_t __user *sigmask, compat_size_t sigsetsize)
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 41c9f65..66e61e0 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -433,6 +433,8 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *exp,
 				    struct compat_timespec __user *tsp,
 				    void __user *sig);
+asmlinkage long compat_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
+				int timeout_msecs);
 asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 				 unsigned int nfds,
 				 struct compat_timespec __user *tsp,

--------------040602070607000404020709--
