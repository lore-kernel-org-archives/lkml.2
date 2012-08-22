Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab2HVQJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:09:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47033 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2HVQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120822072822.GA11042@gmail.com>
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
	<20120822072822.GA11042@gmail.com>
Date: Wed, 22 Aug 2012 09:09:10 -0700
X-Google-Sender-Auth: YEt7HwmjjRK1ANNa6bzk38_OGUw
Message-ID: <CAA25o9RJOre2mw4z7Mh94iRKcHVdby9RjLfP91far16me8_94Q@mail.gmail.com>
Subject: Re: [PATCH] perf: do not flush maps on COMM for perf report
From: Luigi Semenzato <semenzato@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:28 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Luigi Semenzato <semenzato@chromium.org> wrote:
>
>> This fixes a long-standing bug caused by the lack of separate
>> COMM and EXEC record types, which makes "perf report" lose
>> track of symbols when a process renames itself.
>>
>> With this fix (suggested by Stephane Eranian), a COMM (rename)
>> no longer flushes the maps, which is the correct behavior.
>> An EXEC also no longer flushes the maps, but this doesn't
>> matter because as new mappings are created (for the executable
>> and the libraries) the old mappings are automatically removed.
>> This is not by accident: the functionality is necessary because
>> DLLs can be explicitly loaded at any time with dlopen(),
>> possibly on top of existing text, so "perf report" handles
>> correctly the clobbering of new mappings on top of old ones.
>>
>> An alternative patch (which I proposed earlier) would be to
>> introduce a separate PERF_RECORD_EXEC type, but it is a much
>> larger change (about 300 lines) and is not necessary.
>
> It would be nice to add that too - we already have FORK/EXIT,
> this seems like a natural extension.

Yes.  Adding PERF_RECORD_EXEC is/would be the right long-term
solution.  But there are two issues.

1. One nice aspect of perf is that perf.data files and "perf report"
are compatible across a large number of versions.  Adding
PERF_RECORD_EXEC breaks compatibility in a somewhat unpleasant manner.
 New perf.data files won't work with old versions of perf and *might*
fail poorly (segv) although this situation is difficult to analyze.

2. Adding a new record type is messy.  It replicates a lot of
boilerplate code, much of it in the kernel, and affects many parts of
the system.  It adds to size, complexity, and likelihood of new bugs.

I would prioritize the "would be nice" category as follows.

1. Improve the handling of unknown record types for future better
backward compatibility.  (Small change.)

2. Refactor/cleanup code to improve readability and robustness.  (Big
change, but can be broken into many smaller pieces.)

3. Add PERF_RECORD_EXEC.

If there is consensus, I might be able to give a shot to 1 and 2
(courtesy of Google).
