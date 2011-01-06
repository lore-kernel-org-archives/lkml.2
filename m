Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1AFKFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab1AFKFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:05:40 -0500
From: Han Pingtian <phan@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: fix buffer overflow error caused by specifying all tracepoints with -e option
Date: Thu,  6 Jan 2011 18:08:07 +0800
Message-Id: <1294308488-13475-1-git-send-email-phan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


I found specifying all tracepoints within one "-e" option to perf top,
separating each other with commas, will trigger a buffer overflow.

The command line is:

./perf to  -e `perf list |grep Tracepoint|awk -F'[' '{gsub(/[[:space:]]+/,"",$1);array[FNR]=$1}END{outputs=array[1];for (i=2;i<=FNR;i++){ outputs=outputs "," array[i];};print outputs}'`

The error messages are:

*** buffer overflow detected ***: ./perf terminated
======= Backtrace: =========
/lib64/libc.so.6(__fortify_fail+0x37)[0x382cefb2c7]
/lib64/libc.so.6[0x382cef91c0]
/lib64/libc.so.6[0x382cef82f4]
./perf[0x424f9e]
./perf[0x425966]
./perf[0x42422b]
./perf[0x424468]
./perf[0x424a30]
./perf[0x41539a]
./perf[0x4056d4]
./perf[0x406126]
/lib64/libc.so.6(__libc_start_main+0xfd)[0x382ce1ec5d]
./perf[0x405409]
======= Memory map: ========
00400000-0051c000 r-xp 00000000 fd:06 4573758                            /home/hpt/temp/linux/perf/linux-2.6/tools/perf/perf
0071b000-00733000 rwxp 0011b000 fd:06 4573758                            /home/hpt/temp/linux/perf/linux-2.6/tools/perf/perf
00733000-00b90000 rwxp 00000000 00:00 0
024dc000-024fd000 rwxp 00000000 00:00 0                                  [heap]
... ...

And I have a patch for fixing this problem. Please review it. Thanks.
