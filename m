Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0JKPjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:39:54 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37679 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0JKPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:39:53 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2cK98dN2f55kzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LA4U65-01-BFI-02
X-M-MSG: 
Date: Mon, 11 Oct 2010 17:39:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        William Cohen <wcohen@redhat.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] oprofile: disable write access to oprofilefs while
 profiler is running
Message-ID: <20101011153942.GU13563@erda.amd.com>
References: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
 <20101005163338.GI13563@erda.amd.com>
 <4CB31592.2080508@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CB31592.2080508@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.10.10 09:48:02, Maynard Johnson wrote:
> Robert, I don't have any issue with this patch except I'm not sure what problem 
> it's fixing.  From my read of oprofile userland code, I don't see where 
> profiling parameters are ever written to oprofilefs when profiling is active. 
> Is your patch intended to guard against potential non-intentional cases 
> occurring in userland code?  Or is there some case existing right now?

The kernel updates the counter configuration during profiling only
when the counters are started. Since sampling data and its
representation depends on the counter configuration, we do not want to
change the configuration in-flight. Otherwise the daemon may not know
which configuration was used for which sample.

Instead, userland is required to restart profiling which also flushes
cpu buffers. Thus, the daemon always is aware of the configuration
which was used when the kernel wrote a sample.

This may happen e.g. for IBS samples, where certain options may be
enabled using oprofilefs. We want to know which options are set while
a sample is written and make sure, the options do not change. There is
another case, the latest patch I sent that implements IBS branch
target address reporting extends the IBS sample size if its option is
set. To always proper parse the sampling data by the daemon, we must
ensure the sampling data is consistent over one profiling session and
sample size does not change.

As we rely on not writing to the configuration while profiling and
since this works with the current daemon, I added the check.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

