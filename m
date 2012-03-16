Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005Ab2CPB2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:28:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55569 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab2CPB2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:28:33 -0400
Message-ID: <4F629725.30306@fb.com>
Date: Thu, 15 Mar 2012 18:28:05 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: <linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <acme@redhat.com>,
        <ravitillo@lbl.gov>, <vweaver1@eecs.utk.edu>,
        <khandual@linux.vnet.ibm.com>, <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Add branch stack support to perf script
References: <1331842127-27468-1-git-send-email-asharma@fb.com>
In-Reply-To: <1331842127-27468-1-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-15_04:2012-03-15,2012-03-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/12 1:08 PM, Arun Sharma wrote:

> The samples seem to have the sense of call/return
> inverted. If the original callgraph was a ->  b ->  c
> I get samples like:
>
> from	to
> c	b
> b	a
>
> To restore the normal sense, I'm printing them as:
>
> to =>  from

I debugged this some more and something seems to be wrong with the the 
way the kernel maps PERF_SAMPLE_BRANCH_ANY_CALL to MSR_LBR_SELECT.

perf record -aj any_call,u -F 1 --   sleep 300 &

msr[0x1c8] = 0x1d

perf record -aj any_ret,u -F 1 --   sleep 300 &

msr[0x1c8] = 0x1ad

Stephane: does this give a clue about what may be wrong? It doesn't 
match the kernel code:

static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
...
[PERF_SAMPLE_BRANCH_ANY_CALL] =
          LBR_REL_CALL | LBR_IND_CALL | LBR_REL_JMP | LBR_IND_JMP | LBR_FAR,
};

It'd be nice to have *_lbr_sel_map[] in the same order as
enum perf_branch_sample_type. Right now, the call and return entries are 
reversed. Which shouldn't matter in theory, since the initializer has an 
explicit index.

I also got a kernel hang running the two perf record lines above 
simultaneously (without the -F 1).

  -Arun
