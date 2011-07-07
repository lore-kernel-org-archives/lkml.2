Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1GGOkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:40:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33366 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab1GGOj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:39:58 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <20110707112302.GB8227@elte.hu>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 16:38:48 +0200
Message-ID: <1310049528.3282.583.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 13:23 +0200, Ingo Molnar wrote:
> 
> The +1.5% increase in vanilla kernel context switching performance is 
> unfortunate - where does that overhead come from?

Looking at the asm output, I think its partly because things like:

@@ -602,6 +618,8 @@ static void update_curr(struct cfs_rq *c
                cpuacct_charge(curtask, delta_exec);
                account_group_exec_runtime(curtask, delta_exec);
        }
+
+       account_cfs_rq_runtime(cfs_rq, delta_exec);
 }


+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+               unsigned long delta_exec)
+{
+       if (!cfs_rq->runtime_enabled)
+               return;
+
+       cfs_rq->runtime_remaining -= delta_exec;
+       if (cfs_rq->runtime_remaining > 0)
+               return;
+
+       assign_cfs_rq_runtime(cfs_rq);
+}

generate a call, only to then take the first branch out, marking that
function __always_inline would cure the call problem. Going beyond that
would be using static_branch() to track if there is any bandwidth
tracking required at all.
