Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2DSReu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:34:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59977 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab2DSRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:34:48 -0400
Message-ID: <4F904C6C.7020407@fb.com>
Date: Thu, 19 Apr 2012 10:33:32 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, "Paul Mackerras" <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Stephane Eranian" <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Tom Zanussi" <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Disable sanity check
References: <1334791449-402-1-git-send-email-asharma@fb.com> <20120419052208.GA29875@somewhere.redhat.com>
In-Reply-To: <20120419052208.GA29875@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-04-19_05:2012-04-19,2012-04-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/12 10:22 PM, Frederic Weisbecker wrote:

> So rbp is part of the JIT stack but not rsp?
> Do you have a practical example of that? I must confess I don't know
> much about JIT stack.

Nothing specific to JITs here. Any time an app has two stacks S1 and S2 
(with S1 at a lower address and S2 at a higher address) and %rsp at the 
time of a perf event is pointing to S2, we don't get traces beyond S2.

               |                 |
               |                 |
               |   0x1000000     |  <-- %rbp
               |                 |
               |                 |
S2: 0x2000000 |                 |  <-- %rsp
               |                 |
               |                 |
               |                 |
               |    frame3       |
               |                 |
               |    frame2       |
               |                 |
S1: 0x1000000 |    frame1       |
               |                 |
               |                 |
               |                 |
               |                 |

gdb is able to show:

(gdb) bt
<frame at 0x2000000>
frame1
frame2
frame3
frame4
..

just fine.

In our use case, there may be multiple transitions between S1 and S2. 
For eg: frame4 could be on S2 (i.e 0x2xxxxxx range).

  -Arun
