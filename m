Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0HaInm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:43:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52879 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0HaInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:43:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4C7CC08A.9010302@jp.fujitsu.com>
Date: Tue, 31 Aug 2010 17:42:50 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andreas Dilger <adilger@sun.com>, Chris Mason <chris.mason@oracle.com>,
        Jiri Olsa <jolsa@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] make file's timestamp more accurate
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

linux has supported nanosecond order file's timestamp since 2.5.48.
However current file timestamp is got by current_fs_time() and
is only updated once a tick. It can't say true nanosecond accuracy.
In addition, gettimeofday() before a file operation updating
{a,c,m}time would outstrip file's timestamp because of the difference
about time source between gettimeofday() and file's timestamp.
A certain kind of application would corrupted by this problem.

I attached a most simple patch fixing this problem here. However
it has several problems and I don't say it can be applied as is.
The most big two problems is the following:

 - It would cause performance regression, especially in
   not TSC capable system.
 - Is gettimeofday()'s monotonicity reliable on all systems?

The relative discussion:
http://lkml.org/lkml/2010/7/13/443

Does anybody have good idea? Should it be tunable, for example?

Thanks,
Satoru

Index: linux-2.6.36-rc3/kernel/time.c
===================================================================
--- linux-2.6.36-rc3.orig/kernel/time.c 2010-08-31 16:07:43.000000000 +0900
+++ linux-2.6.36-rc3/kernel/time.c      2010-08-31 16:08:11.000000000 +0900
@@ -227,7 +227,8 @@ SYSCALL_DEFINE1(adjtimex, struct timex _
  */
 struct timespec current_fs_time(struct super_block *sb)
 {
-       struct timespec now = current_kernel_time();
+       struct timespec now;
+       getnstimeofday(&now);
        return timespec_trunc(now, sb->s_time_gran);
 }
 EXPORT_SYMBOL(current_fs_time);

