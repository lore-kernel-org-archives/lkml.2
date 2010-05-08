Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0EHQOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 12:14:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38697 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab0EHQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 12:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LebGlnoRPNpNENVRy+BRIjGflC6aVk3zBnoUgKVctKPX6Yp/IZv6vx8lEGOalW6CI+
         IDALnFVN49QxzHPnL+CguaU7vce86XI/s+GPauEkCpcu/xCuTAYNZBzgHOeKEb0Ve9A5
         93LVJDXGkEDGD9iFHpxWHKjpSzUQjpOLjwsnM=
Date: Sat, 8 May 2010 18:14:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Drop "-a" option from set of default
	arguments to cmd_record()
Message-ID: <20100508161404.GB5444@nowhere>
References: <4BE51A90.2060305@dcl.info.waseda.ac.jp> <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 08, 2010 at 05:10:29PM +0900, Hitoshi Mitake wrote:
> This patch drops "-a" from record_args, which is passed to cmd_record().
> 
> Even if user wants to record all lock events during process runs,
>         perf lock record -a <program> <argument> ...
> is enough for this purpose.
> 
> This can reduce size of perf.data.
> 
> % sudo ./perf lock record whoami
> root
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.439 MB perf.data (~19170 samples) ]
> % sudo ./perf lock record -a whoami   # with -a option
> root
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 48.962 MB perf.data (~2139197 samples) ]
> 
> This patch was made on perf/test of random-tracing.git,
> could you queue this, Frederic?
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>


Thanks, will test it and if it's fine I'll queue.

I did a lot of tests these last days to understand what was going on
with perf lock, I mean the fact we have various bad locking scenario.

So far, the state machine looks rather good. In fact, the real problem
is that we don't have every events. We lose a _lot_ of them and that's
because the frequency of lock events is too high and perf record
can't keep up.

I think I'm going to unearth the injection code to reduce the size
of these events.

