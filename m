Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab2DIS6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:58:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57393 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab2DIS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:58:36 -0400
From: Paul Moore <paul@paul-moore.com>
To: libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
Subject: ANN: libseccomp
Date: Mon, 09 Apr 2012 14:58:32 -0400
Message-ID: <1540670.AFBi1SpGoi@sifl>
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the seccomp patches finally stabilizing a bit, it seems like now is a 
good time to announce libseccomp: a library designed to make it easier to 
create complex, architecture independent seccomp filters.

 * http://sourceforge.net/projects/libseccomp/
 * git clone git://git.code.sf.net/p/libseccomp/libseccomp

The library has only been in development for the past couple months, so it may 
be a little rough around the edges, and definitely could use more testing, but 
it is functional and has had some basic testing against the seccomp v17 
patches.  The project currently lacks any online documentation or a website 
beyond the basic SF.net tools, but there are current man pages in the source 
repository and the code is reasonably well commented.

For those of you who are interested in making use of the library, or 
contributing to its development and testing, we do have a mailing list setup 
(see the To/CC line above) and you can subscribe at the link below; all are 
welcome.

 * https://lists.sourceforge.net/lists/listinfo/libseccomp-discuss

To demonstrate some of the basic libseccomp capabilities, I've included a 
short example below.  The example is trivial, it opens /dev/zero and writes to 
/dev/null, but it shows how to use libseccomp to create a simple filter and 
load it into the kernel; filtering both on just the syscall and a syscall with 
specific arguments.

> #include <errno.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> #include <seccomp.h>
> 
> #define BUF_LEN		256
> 
> int main(int argc, char *argv[])
> {
> 	int rc;
> 	FILE *read_stream, *write_stream;
> 	unsigned char buf[BUF_LEN];
> 	size_t op_len;
> 
> 	/* initialize the seccomp filter */
> 	printf("scmp: initializing the seccomp filter ...");
> 	rc = seccomp_init(SCMP_ACT_KILL);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	printf("ok\n");
> 
> 	/* do the setup */
> 	printf("info: opening /dev/zero for reading ... ");
> 	read_stream = fopen("/dev/zero", "r");
> 	if (read_stream == NULL)
> 		goto failure;
> 	printf("ok\n");
> 	printf("info: opening /dev/null for writing ... ");
> 	write_stream = fopen("/dev/null", "w");
> 	if (write_stream == NULL)
> 		goto failure;
> 	printf("ok\n");
> 
> 	/* configure the seccomp filter */
> 	printf("scmp: configuring the seccomp_filter ... ");
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(read), 1,
> 			      SCMP_A0(SCMP_CMP_EQ, fileno(read_stream)));
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(write), 1,
> 			      SCMP_A0(SCMP_CMP_EQ, STDOUT_FILENO));
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(write), 1,
> 			      SCMP_A0(SCMP_CMP_EQ, STDERR_FILENO));
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(write), 1,
> 			      SCMP_A0(SCMP_CMP_EQ, fileno(write_stream)));
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(close), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(fstat), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(ioctl), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(mmap), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(mprotect), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	rc = seccomp_rule_add(SCMP_ACT_ALLOW, SCMP_SYS(munmap), 0);
> 	if (rc < 0)
> 		goto failure_scmp;
> 	printf("ok\n");
> 
> 	/* load the seccomp filter into the kernel */
> 	printf("scmp: load the filter ... ");
> 	rc = seccomp_load();
> 	if (rc < 0)
> 		goto failure_scmp;
> 	seccomp_release();
> 	printf("ok\n");
> 
> 	/* perform the i/o */
> 	printf("info: attempting to read BUF_LEN bytes ... ");
> 	op_len = fread(buf, BUF_LEN, 1, read_stream);
> 	if (op_len != 1)
> 		return errno;
> 	printf("ok\n");
> 
> 	printf("info: attempting to write BUF_LEN bytes ... ");
> 	op_len = fwrite(buf, BUF_LEN, 1, write_stream);
> 	if (op_len != 1)
> 		return errno;
> 	printf("ok\n");
> 
> 	/* shutdown */
> 	printf("info: closing file streams and exiting\n");
> 	fclose(write_stream);
> 	fclose(read_stream);
> 	return 0;
> 
> failure_scmp:
> 	errno = -rc;
> failure:
> 	/* oops ... */
> 	printf("failed, errno = %u\n", errno);
> 	return errno;
> }

-- 
paul moore
www.paul-moore.com

