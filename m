Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1ALWfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:35:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40772 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1ALWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:35:17 -0500
Message-ID: <4D2E2C9E.2010805@linux.vnet.ibm.com>
Date: Wed, 12 Jan 2011 14:35:10 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmU=?= =?UTF-8?B?Y2tlcg==?= 
	<fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [BUG] perf sched broken
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
In-Reply-To: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 01:29 AM, Stephane Eranian wrote:
> Hi,
>
> I am trying to use perf sched from tip-x86 but it fails for all my attempts.
>
> First of, I think the event list is stale. This is not so much the
> events themselves
> but rather the flags.

I'm currently using the master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

Without your :r patch, I do see the problem with the :r modifier, but 
this sequence

$ perf record -R -a -c 1 -e sched:sched_switch -- sleep 1
 > [ perf record: Woken up 1 times to write data ]
 > [ perf record: Captured and wrote 0.365 MB perf.data (~15962 samples) ]
 > $./perf report -D

is working fine for me.  I even removed /usr/bin from my search path to 
make sure /usr/bin/perf wasn't getting found during the run of ./perf.

I am running on a different environment than you, though.  I am using 
Fedora 14 (2.6.35 kernel).

For the record, this is what I see:
[root@oc7708135540 perf]# ./perf report -D
WARNING: No sample_id_all support, falling back to unordered processing

0x100 [0x40]: event: 1
.
. ... raw event: size 64 bytes
.  0000:  01 00 00 00 01 00 40 00 ff
  ff ff ff 00 00 00 00  ...
...@.........
.  0010:  00 00 00 00 00 00 00 00 ff
  ff ff 9f ff ff ff ff  ...
.............
.  0020:  00 00 00 81 ff ff ff ff 5b
  6b 65 72 6e 65 6c 2e  ...
.....[kernel.
.  0030:  6b 61 6c 6c 73 79 6d 73 5d
  5f 74 65 78 74 00 00  kal
lsyms]_text..
.
-1 -1 0x100 [0x40]: PERF_RECORD_MMAP -1/0: [0(0xffffffff9fffffff) @ 
0xffffffff81000000]: [kernel
.kallsyms]_text

0x140 [0x38]: event: 1
.
. ... raw event: size 56 bytes
.  0000:  01 00 00 00 01 00 38 00 ff
  ff ff ff 00 00 00 00  ...
...8.........
.  0010:  00 00 00 a0 ff ff ff ff ff
  2f 00 00 00 00 00 00  ...
....../......
.  0020:  00 00 00 00 00 00 00 00 5b
  6f 75 74 70 75 74 5d  ...
.....[output]
.  0030:  00 00 00 00 00 00 00 00
                         ...
.....
.
-1 -1 0x140 [0x38]: PERF_RECORD_MMAP -1/0: [0xffffffffa0000000(0x2fff) @ 
0]: [output]

.. and so on ..


I will look into the :r problem now.

- Corey
