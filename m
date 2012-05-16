Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab2EPTc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:32:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20744 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2EPTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:32:26 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OBocRQu92-iGgfqHeJoA:9 a=F_p5B_INfqg1nH1VYdQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337196743.6724.66.camel@gandalf.stny.rr.com>
Subject: Re: Perf record format portability
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 15:32:23 -0400
In-Reply-To: <20120516174825.GA11516@m.brq.redhat.com>
References: <4FB275EB.5050904@linaro.org>
	 <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>
	 <20120516145927.GC7864@infradead.org>
	 <1337187503.6724.50.camel@gandalf.stny.rr.com>
	 <20120516174825.GA11516@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 19:48 +0200, Jiri Olsa wrote:

> for ppc64(record) vs x86_64(report) I got following report on latest tip:
> 
> [jolsa@dhcp-26-214 test]$ ../perf report > report.target
> Endianness of raw data not corrected!
> Warning:
> 718 samples with id not present in the header
> Warning:
> The perf.data file has no samples!
> 
> for following record:
> perf record -a -e sched:sched_switch -e sched:sched_process_exit -e sched:sched_process_fork -e sched:sched_wakeup -- sleep 10
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.178 MB perf.data (~7781 samples) ]
> 
> I haven't tried trace-cmd, but I guess let's wait for libparsevents
> perf integration then.. ;)
> 

It's in perf. It just needs to be set up.

Look at tools/perf/util/trace-event.h

There's a bigendian() function, a "file_bigendian" and a
"host_bigendian". If perf recorded what endian was used on the target,
and saves that in the perf.dat file, all it needs to do is update the
two variables.

file_bigendian = recorded_endian;
host_bigendian = bigendian();

1 for big endian, 0 for little endian.

Where host is the machine that is running the perf report or script.
After that, all reads of the data in events uses one of the
__data2host() macros to convert if necessary.

Note, latest trace-cmd has put all these in a pevent struct descriptor,
so that different files can be read at the same time, and these files
can be from different endian (and bit size) machines. The global
variables no longer exist.

My patches, that I and Frederic posted previously, convert perf to use
this descriptor so that perf could benefit and read multiple files too.

-- Steve


