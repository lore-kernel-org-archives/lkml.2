Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0DHGqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:46:11 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53405 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab0DHGqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:46:08 -0400
Message-ID: <4BBD7BB1.1070105@dcl.info.waseda.ac.jp>
Date: Thu, 08 Apr 2010 15:46:09 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Floating point exception by perf record
References: <4BB84991.5080301@dcl.info.waseda.ac.jp> <20100405183127.GA3677@ghostprotocols.net> <4BBC4318.1070702@dcl.info.waseda.ac.jp> <20100407103855.GC3908@ghostprotocols.net>
In-Reply-To: <20100407103855.GC3908@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/10 19:38, Arnaldo Carvalho de Melo wrote:
 > Em Wed, Apr 07, 2010 at 05:32:24PM +0900, Hitoshi Mitake escreveu:
 >> On 04/06/10 03:31, Arnaldo Carvalho de Melo wrote:
 >>> Em Sun, Apr 04, 2010 at 05:10:57PM +0900, Hitoshi Mitake escreveu:
 >>> [root@doppio ~]# perf lock report | head -3
 >>>     Warning: Error: expected 'data' but read 'overwrite'
 >>>                   ID                 Name   acquired  contended
 >> total wait (ns)   max wait (ns)   min wait (ns)
 >>>
 >>> 0xffff8800029d4b28&q->lock          0          0               0
 >> 0               0
 >>> [root@doppio ~]#
 >>>
 >>> My system details:
 >>>
 >>> [root@doppio ~]# uname -a
 >>> Linux doppio.ghostprotocols.net 2.6.34-rc3-tip+ #1 SMP Mon Apr 5
 >> 13:49:42 BRT 2010 x86_64 x86_64 x86_64 GNU/Linux
 >>> [root@doppio ~]# rpm -q newt
 >>> newt-0.52.10-4.fc11.x86_64
 >>> [root@doppio ~]#
 >>>
 >>> No segfaults here :-\
 >>>
 >>> - Arnaldo
 >>>
 >>
 >> I tested perf lock trace and got a similar error (but different).
 >> % sudo ./perf lock trace
 >>    Fatal: reading input file (size expected=3 received=0)
 >> It seems that perf.data is broken :( I'll search the cause.
 >
 > Take a look at:
 >
 > http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=summary
 >
 > "perf" branch, there is at least one fix there, the "overwrite" one.
 >

Thanks for your notify!
I applied changes on your branch, but my problem was not solved...

I found that the member "offset" of struct perf_file_header is broken.
I made this easy change,

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6c9aa16..dbea087 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -571,6 +571,7 @@ int perf_header__process_sections(struct perf_header 
*self, int fd,
         if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
                 goto out_free;

+       printf("feat_sec->offset:%llu\n", feat_sec->offset);
         err = 0;
         while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
                 if (perf_header__has_feat(self, feat)) {

And the result is this:

% sudo ./perf lock report
   Fatal: reading input file (size expected=3 received=0)
feat_sec->offset:18014402804449281 # <- Wow! :(

It seems that header of perf.data is broken...
But it may be a cause of this problem, I'll try to fix it.

Thanks,
    Hitoshi

