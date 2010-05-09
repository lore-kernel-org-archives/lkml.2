Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0EIOxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:53:24 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61593 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0EIOxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:53:23 -0400
Message-ID: <4BE6CC5F.2020503@dcl.info.waseda.ac.jp>
Date: Sun, 09 May 2010 23:53:19 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Drop "-a" option from set of default	arguments
 to cmd_record()
References: <4BE51A90.2060305@dcl.info.waseda.ac.jp> <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100508161404.GB5444@nowhere>
In-Reply-To: <20100508161404.GB5444@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/10 01:14, Frederic Weisbecker wrote:
 > On Sat, May 08, 2010 at 05:10:29PM +0900, Hitoshi Mitake wrote:
 >> This patch drops "-a" from record_args, which is passed to cmd_record().
 >>
 >> Even if user wants to record all lock events during process runs,
 >>          perf lock record -a<program>  <argument>  ...
 >> is enough for this purpose.
 >>
 >> This can reduce size of perf.data.
 >>
 >> % sudo ./perf lock record whoami
 >> root
 >> [ perf record: Woken up 1 times to write data ]
 >> [ perf record: Captured and wrote 0.439 MB perf.data (~19170 samples) ]
 >> % sudo ./perf lock record -a whoami   # with -a option
 >> root
 >> [ perf record: Woken up 0 times to write data ]
 >> [ perf record: Captured and wrote 48.962 MB perf.data (~2139197 
samples) ]
 >>
 >> This patch was made on perf/test of random-tracing.git,
 >> could you queue this, Frederic?
 >>
 >> Cc: Ingo Molnar<mingo@elte.hu>
 >> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
 >> Cc: Paul Mackerras<paulus@samba.org>
 >> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
 >> Cc: Jens Axboe<jens.axboe@oracle.com>
 >> Cc: Jason Baron<jbaron@redhat.com>
 >> Cc: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
 >> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
 >
 >
 > Thanks, will test it and if it's fine I'll queue.
 >
 > I did a lot of tests these last days to understand what was going on
 > with perf lock, I mean the fact we have various bad locking scenario.
 >
 > So far, the state machine looks rather good. In fact, the real problem
 > is that we don't have every events. We lose a _lot_ of them and that's
 > because the frequency of lock events is too high and perf record
 > can't keep up.

Really, I didn't think about lack of events :(

 >
 > I think I'm going to unearth the injection code to reduce the size
 > of these events.
 >
 >

Yeah, injection will be really helpful thing.

And I have a rough idea for reducing event frequency.

Many lock event sequences are like this form:
  * acquire -> acquired -> release
  * acquire -> contended -> acquired -> release
I think that making 3 or 4 events per each lock sequences
is waste of CPU time and memory space.

If threads store time of each events
and make only 1 event at time of release,
we will be able to reduce lots of time and space.

For example, ID of each lock instance is 8 byte in x86_64.
In this scheme 8 * 4 byte for ID will be only 8 byte.
I think this optimization has worth to consider because of
high frequency of lock events.

How do you think?
