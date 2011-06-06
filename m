Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1FFPXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:23:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39658 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P3dAP2zVUnUK7166dCSs5t6oComi9tvMHr6lrXBZDB+34EssAhkzKAQ2EpAUgkVSX2
         0nm/meoHzeJBjuve9O4QImY81SKQIIqoLS1SlfGoqL6tKJRfrJuaaGyhcZC142atdqhg
         8DSEsjErkwotgVf7R8/iN+mPEuLzREC/4rWEw=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Oliver <david@rgmadvisors.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 17:23:39 +0200
Message-ID: <1307373819.3098.40.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 09:28 -0500, David Oliver a écrit :
> Hello,
> 
> The functionality of the futex() system call appears to have changed
> between versions 2.6.18 and 2.6.32.28.
> 
> Specifically, performing a FUTEX_WAIT on a read-only mapped location
> results in an EFAULT. Although other operations, such as FUTEX_WAKE,
> are only meaningful for writable locations, FUTEX_WAIT is useful for
> processes with read-only access to a memory-mapped file.
> 
> The code below illustrates the changed behavior (each of the EXPECT
> operations succeed on the older kernel, the ASSERTs pass in each
> case), assuming the file /tmp/futex_test exists and contains int(42).
> 
> With the older kernel, the syscall() suspends until another process
> changes the file and issues a FUTEX_WAKE, whereas the new behavior is
> for an EFAULT error, independent of the file contents.
> 
> Let me know if you need further clarification.
> 
> Cheers!
> 
> David Oliver.
> 
> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdint.h>
> typedef uint32_t u32;   // for futex.h
> #include <linux/futex.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <unistd.h>
> #include "gtest/gtest.h" // test framework to illustrate issue.
> 
> 
> TEST(Futex, futex_in_read_only_file_is_ok) {
>   int fd = open("/tmp/futex_test", O_RDONLY);
>   ASSERT_GE(fd, 0);
>   int* futex = static_cast<int *>(mmap(0, sizeof(int), PROT_READ,
> MAP_SHARED, fd, 0));
>   ASSERT_NE((int *)(0), futex);
> 
>   int rc = syscall(SYS_futex, futex, FUTEX_WAIT, 42, 0, 0, 0);
> 
>   EXPECT_NE(-1, rc);              // fails.
>   if (rc == -1) {
>       EXPECT_NE(errno, EFAULT);   // fails.
>   }
> }
> 

Right you are, this came from commit 7485d0d3758e8e6491a5 (futexes:
Remove rw parameter from get_futex_key()) in 2.6.33

commit 7485d0d3758e8e6491a5c9468114e74dc050785d
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Tue Jan 5 16:32:43 2010 +0900

    futexes: Remove rw parameter from get_futex_key()
    
    Currently, futexes have two problem:
    
    A) The current futex code doesn't handle private file mappings properly.
    
    get_futex_key() uses PageAnon() to distinguish file and
    anon, which can cause the following bad scenario:
    
      1) thread-A call futex(private-mapping, FUTEX_WAIT), it
         sleeps on file mapping object.
      2) thread-B writes a variable and it makes it cow.
      3) thread-B calls futex(private-mapping, FUTEX_WAKE), it
         wakes up blocked thread on the anonymous page. (but it's nothing)
    
    B) Current futex code doesn't handle zero page properly.

    Read mode get_user_pages() can return zero page, but current
    futex code doesn't handle it at all. Then, zero page makes
    infinite loop internally.
    
    The solution is to use write mode get_user_page() always for
    page lookup. It prevents the lookup of both file page of private
    mappings and zero page.
    
    Performance concerns:
    
    Probaly very little, because glibc always initialize variables
    for futex before to call futex(). It means glibc users never see
    the overhead of this patch.
    
    Compatibility concerns:
    
    This patch has few compatibility issues. After this patch,
    FUTEX_WAIT require writable access to futex variables (read-only
    mappings makes EFAULT). But practically it's not a problem,
    glibc always initalizes variables for futexes explicitly - nobody
    uses read-only mappings.
    
    Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
    Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Acked-by: Darren Hart <dvhltc@us.ibm.com>
    Cc: <stable@kernel.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Ulrich Drepper <drepper@gmail.com>
    LKML-Reference: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>



