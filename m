Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1LURat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:30:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1LURas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:30:48 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=m9rXBrEGayMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=zd2uoN0lAAAA:8 a=HQ7H2QLLrSKk408_L_sA:9 a=V6mIvt4C4gx_6XknJHMA:7 a=PUjeQqilurYA:10 a=wu_e27o_rKQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324488646.5916.107.camel@gandalf.stny.rr.com>
Subject: oprofile patch broke s390 build in tip/perf/core
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 21 Dec 2011 12:30:46 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In doing my tests last night before sending out my patch series this
morning, I found that s390 build didn't work, but it wasn't due to my
patches. I removed all my patches and built with latest mainline (which
builds fine), and then merged the current tip/perf/core. The result
didn't build.

I kicked off a ktest git bisect with last night's Linus tree as good,
and with the merged in tip/perf/core as bad. It ended up with this patch
that broke the build (which looks like a likely suspect).


The break is this:

  LD      .tmp_vmlinux1
arch/s390/oprofile/built-in.o: In function `oprofile_arch_exit':
(.text+0x3f52): undefined reference to `oprofile_timer_exit'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

The patch the bisect found that breaks the build is this:

commit 75c43a20b220f885c39ffa7cdbbb1191e257a9a9
Author: Robert Richter <robert.richter@amd.com>
Date:   Fri Oct 14 15:46:10 2011 +0200

    oprofile: Remove exit function for timer mode
    
    Remove exit functions by moving init/exit code to oprofile's setup/
    shutdown functions. Doing so the oprofile module exit code will be
    easier and less error-prone.
    
    Signed-off-by: Robert Richter <robert.richter@amd.com>


-- Steve


