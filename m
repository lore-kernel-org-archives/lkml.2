Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2ISF3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:29:37 -0400
Received: from ares07.inai.de ([5.9.24.206]:48614 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2ISF3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:29:34 -0400
Date: Wed, 19 Sep 2012 07:29:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Jeff Moyer <jmoyer@redhat.com>
cc: Tatyana Brokhman <tlinder@codeaurora.org>, axboe@kernel.dk,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] block: Adding ROW scheduling algorithm
In-Reply-To: <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LNX.2.01.1209190718030.29967@nerf07.vanv.qr>
References: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org> <1344166241-18708-3-git-send-email-tlinder@codeaurora.org> <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2012-08-06 18:35, Jeff Moyer wrote:
>Tatyana Brokhman writes:
>
>> This patch adds the implementation of a new scheduling algorithm - ROW.
>> The policy of this algorithm is to prioritize READ requests over WRITE
>> as much as possible without starving the WRITE requests.
>
>Perhaps you could start off by describing the workload, and describing
>why the existing I/O schedulers do not perform well.

My setup is a 1 GB RAM Atom N450 netbook, combined with the use of
dm-crypt for the 5400 rpm disk, which limits the effective write
throughput to somewhere around 20–26 MB/s. Now try this:

  ddrescue /dev/zero ~/bluntfile (or)

  (remote)# >nullfile
  (remote)# truncate -s 10G nullfile
  (local)# rsync -HPavz remote:nullfile .

The transfer rates of ddrescue/rsync first show 50–60 MB/s. Wait
until writeout is forced - which is after ~700–800 MB in my case when
all buffers are full. The transfer rates then drop to the
aforementioned 20–26 MB/s.

In the so-loaded system, try to start an xterm (preferably by the use
of a shortcut, or starting one from another xterm). The wait time for
the shell prompt to appear is then the measure for interactivity,
with lower being better.

I have casually observed that ROW has 1/4th of the wait time in this
heavy disk write scenario (around 5 s) for the shell to start up than
with CFQ (20–21 s). "Casual" meaning I had a clock with 1.0 s
granularity beside me and ran this for like 3 times for each
scheduler, averaging it out.
