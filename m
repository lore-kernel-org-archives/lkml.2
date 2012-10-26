Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2JZKYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:24:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab2JZKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:23:58 -0400
Date: Fri, 26 Oct 2012 12:23:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Message-ID: <20121026102336.GA1067@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <87txti81i2.fsf@sejong.aot.lge.com>
 <1351242885.16863.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351242885.16863.0.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:14:45AM +0200, Peter Zijlstra wrote:
> On Fri, 2012-10-26 at 10:29 +0900, Namhyung Kim wrote:
> > Hi Jiri,
> > 
> > On Sat, 20 Oct 2012 16:33:08 +0200, Jiri Olsa wrote:
> > > hi,
> > > adding support to read sample values through the PERF_SAMPLE_READ
> > > sample type. It's now possible to specify 'S' modifier for an event
> > > and get its sample value by PERF_SAMPLE_READ.
> > 
> > I have a question.  What's an actual impact of specifying 'S' modifiere
> > to a non-group event or even only a (non-leader) member of a group?  For
> > instance, 'cycles:S' or '{branches,branch-misses:S}'.
> 
> I would hope a syntax error from the parser ;-)

yeaa.. no ;)

$ ./perf record -e '{cycles:S,cache-misses}' ls
...
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.011 MB perf.data (~476 samples) ]

$ ./perf report
non matching sample_type

> 
> I haven't actually looked at the implementation, but I understood it to
> be a group modifier, not an event modifier.

we might want to be able to use PERF_SAMPLE_READ for single event
same as for groups

the difference between single event and group 'S' modifier:

  $ ./perf record -e 'cycles:S' ls
  - records 'cycles' samples and read period value via PERF_SAMPLE_READ

  $ ./perf record -e '{cycles,cache-misses}:S'
  - samples just on 'cycles' samples and read both period values
   (cycles and cache-misses) via PERF_SAMPLE_READ group format

  $ ./perf record -e '{cycles,cache-misses}:S,instructions' ls
  $ ./perf record -e '{cycles:S,cache-misses},instructions' ls
  $ ./perf record -e 'cycles:S,instructions' ls
  - non matching sample_type

hm, thats the unique sample_type issue again ;) Once we set
PERF_SAMPLE_READ for event or group, we need to set it for
all other events in session, otherwise the report fails

sooo, it looks like:
  - global record '-S' option instead, setting PERF_SAMPLE_READ sample type
    globaly for all events
  - and ':S' group modifier to enable sampling only on leader
    with group format reading for the rest of the group
  - ':S' group modifier alone would imply -S

How about that?

thanks,
jirka
