Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1IRRPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:15:21 -0400
Received: from mail3.vodafone.ie ([213.233.128.45]:25794 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1IRRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:15:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAP0ldk5tTGa5/2dsb2JhbAAMNqoEAQEBAQMnCwFGEAsNCwkWDwkDAgECAUUGDQEHAQGHd7QZhngEmQWLcg
Message-ID: <4E762725.7050003@draigBrady.com>
Date: Sun, 18 Sep 2011 18:15:17 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Bruno Haible <bruno@clisp.org>
CC: bug-gnulib@gnu.org, Vadim Lobanov <vlobanov@speakeasy.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: a Linux select() bug
References: <201109181658.36654.bruno@clisp.org> <4E7620BC.1080407@draigBrady.com>
In-Reply-To: <4E7620BC.1080407@draigBrady.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 05:47 PM, Pádraig Brady wrote:
> On 09/18/2011 03:58 PM, Bruno Haible wrote:
>> Hi Jim, Pádraig,
>>
>> To whom best to report this Linux kernel bug?
>>
>> ==================================== bug.c ====================================
>> /* A POSIX compliance bug in select() (and pselect() also).
>>    <http://pubs.opengroup.org/onlinepubs/9699919799/functions/select.html>
>>    says:
>>
>>      "pselect() and select() shall fail and set errno to:
>>       [EBADF]
>>         One or more of the file descriptor sets specified a file descriptor
>>         that is not a valid open file descriptor."
>>  */
>>
>> #include <errno.h>
>> #include <stdio.h>
>> #include <sys/select.h>
>> #include <sys/time.h>
>>
>> static void
>> test (int fd)
>> {
>>   struct timeval tv0;
>>   fd_set rfds, wfds, xfds;
>>   int r;
>>
>>   tv0.tv_sec = 0;
>>   tv0.tv_usec = 0;
>>   FD_ZERO (&rfds);
>>   FD_ZERO (&wfds);
>>   FD_ZERO (&xfds);
>>   FD_SET (fd, &rfds);
>>   r = select (fd + 1, &rfds, &wfds, &xfds, &tv0);
>>   if (r < 0 && errno == EBADF)
>>     printf ("fd=%d: OK, POSIX compliant\n", fd);
>>   else
>>     printf ("fd=%d: r=%d, bug\n", fd, r);
>> }
>>
>> int
>> main (void)
>> {
>>   test (49);
>> #if 0 /* This test succeeds when "grep FDSize /proc/self/status" is 256
>>          but fails when it is 64.  */
>>   test (99);
>> #endif
>>   test (399);
>>
>>   return 0;
>> }
>> /*
>> Expected result:
>> fd=49: OK, POSIX compliant
>> fd=399: OK, POSIX compliant
>>
>> Actual result on Linux 2.6.37.6:
>> fd=49: OK, POSIX compliant
>> fd=399: r=0, bug
>> */
>> ===============================================================================
>>
>> I found this while extending tests/test-select.c to detect EBADF.
>> I randomly used fd = 99. Interestingly, the test failed 100% of the
>> time under "make":
>>
>> $ make check TESTS=test-select
>> make  check-recursive
>> make[1]: Entering directory `/tmp/testdir3/gltests'
>> Making check in .
>> make[2]: Entering directory `/tmp/testdir3/gltests'
>> make  check-TESTS
>> make[3]: Entering directory `/tmp/testdir3/gltests'
>> Invalid fd test... failed (select returned 0)
>>   failed (invalid fd among rfds)
>>   failed (select returned 0)
>>   failed (invalid fd among wfds)
>>   failed (select returned 0)
>>   failed (invalid fd among xfds)
>> Unconnected socket test... passed
>> Connected sockets test... passed
>> General socket test with fork... passed
>> Pipe test... passed
>> FAIL: test-select
>> ==================
>> 1 of 1 test failed
>> ==================
>> make[3]: *** [check-TESTS] Error 1
>> make[3]: Leaving directory `/tmp/testdir3/gltests'
>> make[2]: *** [check-am] Error 2
>> make[2]: Leaving directory `/tmp/testdir3/gltests'
>> make[1]: *** [check-recursive] Error 1
>> make[1]: Leaving directory `/tmp/testdir3/gltests'
>> make: *** [check] Error 2
>>
>> Whereas it passed 100% of the time when invoked directly from the command line:
>>
>> $ ./test-select
>> Invalid fd test... passed
>> Unconnected socket test... passed
>> Connected sockets test... passed
>> General socket test with fork... passed
>> Pipe test... passed
>> $ echo $?
>> 0
>>
>> The reason is that the bug occurs only for 'fd' number >= fdt->max_fds,
>> where fdt is the process' file descriptor table in the kernel. This is the
>> value you get through "grep FDSize /proc/$pid/status". This number is 256,
>> _except_ that it is only 64 in processes created by 'make' through the vfork()
>> system call and their children and offspring.
>>
>> The issue is the same whether 'make' is built as a 32-bit or 64-bit binary.
>>
>> Bruno
> 
> Hrm, perhaps this is due to increasing performance while
> supporting old code. I.E. the kernel increases FDSize as the number
> of file descriptors are increased, so that only that number of
> descriptors are ever inspected by select.
> I've seen lots of code do select (FD_SETSIZE, ...)
> so for the performance tweak to work, select() would have
> to effectively use MIN (nfds, FDSize)?
> Now performant code should be using an appropriate nfds variable,
> so I would be a bit surprised if Linux did make lazy user code
> faster, while making erroneous descriptors not give an error.

So I had a look at the code:

https://github.com/mirrors/linux-2.6/blame/master/fs/select.c

which lead to:

https://github.com/mirrors/linux-2.6/commit/bbea9f6

So it does look like a performance tweak.

cheers,
Pádraig.
