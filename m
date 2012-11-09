Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2KITaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:30:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54389 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KITae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:30:34 -0500
MIME-Version: 1.0
Date: Fri, 9 Nov 2012 16:30:32 -0300
Message-ID: <CAGTBQpaDR4+V5b1AwAVyuVLu5rkU=Wc1WeUdLu5ag=WOk5oJzQ@mail.gmail.com>
Subject: fadvise interferes with readahead
From: Claudio Freire <klaussfreire@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. First of all, I'm not subscribed to this list, so I'd suggest all
replies copy me personally.

I have been trying to implement some I/O pipelining in Postgres (ie:
read the next data page asynchronously while working on the current
page), and stumbled upon some puzzling behavior involving the
interaction between fadvise and readahead.

I'm running kernel 3.0.0 (debian testing), on a single-disk system
which, though unsuitable for database workloads, is slow enough to let
me experiment with these read-ahead issues.

Typical random I/O performance is on the order of between 150 r/s to
200 r/s (ballpark 7200rpm I'd say), with thoughput around 1.5MB/s.
Sequential I/O can go up to 60MB/s, though it tends to be around 50.

Now onto the problem. In order to parallelize I/O with computation,
I've made postgres fadvise(willneed) the pages it will read next. How
far ahead is configurable, and I've tested with a number of
configurations.

The prefetching logic is aware of the OS and pg-specific cache, so it
will only fadvise a block once. fadvise calls will stay 1 (or a
configurable N) real I/O ahead of read calls, and there's no fadvising
of pages that won't be read eventually, in the same order. I checked
with strace.

However, performance when fadvising drops considerably for a specific
yet common access pattern:

When a nested loop with two index scans happens, access is random
locally, but eventually whole ranges of a file get read (in this
random order). Think block "1 6 8 100 34 299 3 7 68 24" followed by "2
4 5 101 298 301". Though random, there are ranges there that can be
merged in one read-request.

The kernel seems to do the merge by applying some form of readahead,
not sure if it's context, ondemand or adaptive readahead on the 3.0.0
kernel. Anyway, it seems to do readahead, as iostat says:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     4.40  224.20    2.00     4.16     0.03
37.86     1.91    8.43    8.00   56.80   4.40  99.44

(notice the avgrq-sz of 37.8)

With fadvise calls, the thing looks a lot different:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00    18.00  226.80    1.00     1.80     0.07
16.81     4.00   17.52   17.23   82.40   4.39  99.92

Notice the avgrq-sz of 16.8. Assuming it's 512-byte sectors, that's
spot-on with a postgres page (8k). So, fadvise seems to carry out the
requests verbatim, while read manages to merge at least two of them.

The random nature of reads makes me think the scheduler is failing to
merge the requests in both cases (rrqm/s = 0), because it only looks
at successive requests (I'm only guessing here though).

Looking into the kernel code, it seems the problem could be related to
how fadvise works in conjunction with readahead. fadvise seems to call
the function in readahead.c that schedules the asynchornous I/O[0]. It
doesn't seem subject to readahead logic itself[1], which in on itself
doesn't seem bad. But it does, I assume (not knowing the code that
well), prevent readahead logic[2] to eventually see the pattern. It
effectively disables readahead altogether.

This, I theorize, may be because after the fadvise call starts an
async I/O on the page, further reads won't hit readahead code because
of the page cache[3] (!PageUptodate I imagine). Whether this is
desirable or not is not really obvious. In this particular case, doing
fadvise calls in what would seem an optimum way, results in terribly
worse performance. So I'd suggest it's not really that advisable.

The fix would lay in fadvise, I think. It should update readahead
tracking structures. Alternatively, one could try to do it in
do_generic_file_read, updating readahead on !PageUptodate or even on
page cache hits. I really don't have the expertise or time to go
modifying, building and testing the supposedly quite simple patch that
would fix this. It's mostly about the testing, in fact. So if someone
can comment or try by themselves, I guess it would really benefit
those relying on fadvise to fix this behavior.

Additionally, I would welcome any suggestions for ways to mitigate
this problem on current kernels, as the patch I'm working I'd like to
deploy with older kernels. Even if the latest kernel had this behavior
fixed, I'd still welcome some workarounds.

More details on the benchmarks I've run can be found in the postgresql
dev ML archive[4].

[0] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=mm/fadvise.c#l95
[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=mm/readahead.c#l211
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=mm/readahead.c#l398
[3] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=mm/filemap.c#l1081
[4] http://archives.postgresql.org/pgsql-hackers/2012-10/msg01139.php
