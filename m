Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1BHXes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:34:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1BHXer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=UPkQK+Ha8o2VXTcBL4x99Q3M0QZFWFYMa/n2UrQ7sm6QYb08/9L0ew2sfJ08jgjztV
         un9NwT+LiTdW/9zKEgpQ==
MIME-Version: 1.0
Date: Wed, 9 Feb 2011 00:34:44 +0100
Message-ID: <AANLkTi=mRvkO-0Lvf4OhnnAg6X0Z-RpeKpCD3JtANJZ8@mail.gmail.com>
Subject: [BUG] perf: perf report -n shows bogus number of samples
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

I think the -n option of perf report shows bogus number of samples.

I believe it does not print the number of samples but rather the
number of events if I understand the code in hist_entry__snprintf().
I think that's useless, the number of samples is more useful.

$ perf report -h

 usage: perf report [<options>] <command>

    -i, --input <file>    input file name
    -v, --verbose         be more verbose (show symbol address, etc)
    -D, --dump-raw-trace  dump raw trace in ASCII
    -k, --vmlinux <file>  vmlinux pathname
        --kallsyms <file>
                          kallsyms pathname
    -f, --force           don't complain, do it
    -m, --modules         load module symbols - WARNING: use only with
-k and LIVE kernel
    -n, --show-nr-samples
                          Show a column with the number of samples

$ perf record -e cycles ./repmov
$ perf report -D | fgrep RECORD_SAMPLE | wc -l
86346
$ ./perf report -n
# Events: 86K cycles
#
# Overhead  Samples    Command      Shared Object                     Symbol
# ........ ..........  .......  .................  .........................
#
    98.92%238206388334   repmov  repmov             [.] main
     0.08%  189506224   repmov  [kernel.kallsyms]  [k] perf_ctx_adjust_freq
     0.06%  147582706   repmov  [kernel.kallsyms]  [k] perf_event_task_tick

It should be easy to reproduce with any other program.
