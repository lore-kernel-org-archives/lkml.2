Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1FFO2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:28:40 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48606 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab1FFO2g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:28:36 -0400
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 09:28:35 -0500
Message-ID: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
Subject: Change in functionality of futex() system call.
From: David Oliver <david@rgmadvisors.com>
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The functionality of the futex() system call appears to have changed
between versions 2.6.18 and 2.6.32.28.

Specifically, performing a FUTEX_WAIT on a read-only mapped location
results in an EFAULT. Although other operations, such as FUTEX_WAKE,
are only meaningful for writable locations, FUTEX_WAIT is useful for
processes with read-only access to a memory-mapped file.

The code below illustrates the changed behavior (each of the EXPECT
operations succeed on the older kernel, the ASSERTs pass in each
case), assuming the file /tmp/futex_test exists and contains int(42).

With the older kernel, the syscall() suspends until another process
changes the file and issues a FUTEX_WAKE, whereas the new behavior is
for an EFAULT error, independent of the file contents.

Let me know if you need further clarification.

Cheers!

David Oliver.


#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
typedef uint32_t u32;   // for futex.h
#include <linux/futex.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include "gtest/gtest.h" // test framework to illustrate issue.


TEST(Futex, futex_in_read_only_file_is_ok) {
  int fd = open("/tmp/futex_test", O_RDONLY);
  ASSERT_GE(fd, 0);
  int* futex = static_cast<int *>(mmap(0, sizeof(int), PROT_READ,
MAP_SHARED, fd, 0));
  ASSERT_NE((int *)(0), futex);

  int rc = syscall(SYS_futex, futex, FUTEX_WAIT, 42, 0, 0, 0);

  EXPECT_NE(-1, rc);              // fails.
  if (rc == -1) {
      EXPECT_NE(errno, EFAULT);   // fails.
  }
}


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

