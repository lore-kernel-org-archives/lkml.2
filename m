Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2EOEu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:50:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47777 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2EOEu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:50:28 -0400
X-AuditID: 9c93016f-b7cecae000000e00-c1-4fb1e090e496
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	<CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	<1336994000.2443.24.camel@twins> <20120514115551.GA6479@gmail.com>
	<1337007985.1552.5.camel@leonhard>
Date: Tue, 15 May 2012 13:48:47 +0900
In-Reply-To: <1337007985.1552.5.camel@leonhard> (Namhyung Kim's message of
	"Tue, 15 May 2012 00:06:25 +0900")
Message-ID: <874nri1234.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 00:06:25 +0900, Namhyung Kim wrote:
> 2012-05-14 (월), 13:55 +0200, Ingo Molnar:
>> Another detail seems to be that the bug takes per-task-inherited 
>> profiling. Doing:
>> 
>>    perf record -a -e cycles:pp make -j64 bzImage
>> 
>> produces the expected number of events. Without the '-a' the bug 
>> Linus found triggers.
>> 
>> Similarly, 'perf top' does not trigger the bug - because it's 
>> using per CPU, not per task (inherited) profiling.
>> 
>
> perf_evlist__config_attrs() has this:
>
> 	if (evlist->cpus->map[0] < 0)
> 		opts->no_inherit = true;
>
> meaning that per task profiling won't enable event inheritance. I don't
> know why it's needed though.

I found this on commit 5d2cd90922c7 ("perf evsel: Fix use of inherit"):

-               /*
-                * Don't allow mmap() of inherited per-task counters. This
-                * would create a performance issue due to all children writing
-                * to the same buffer.
-                *
-                * FIXME:
-                * Proper fix is not to pass 'inherit' to perf_evsel__open*,
-                * but a 'flags' parameter, with 'group' folded there as well,
-                * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
-                * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
-                * set. Lets go for the minimal fix first tho.
-                */
-               evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;

Hmm.. still don't know what to do then.

Thanks,
Namhyung
