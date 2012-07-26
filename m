Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2GZVRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:17:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10649 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2GZVRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:17:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Jul 2012 14:16:52 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 26 Jul 2012 14:16:51 -0700
Subject: RE: [PATCH 1/1] kthread: disable preemption during complete()
Thread-Topic: [PATCH 1/1] kthread: disable preemption during complete()
Thread-Index: Ac1rHCNq0j2OYZo9SViAVcLPid3/VQAVRVV6
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F379D364860@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>
  <20120725000901.GA5304@google.com>
  <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>
  <20120725224044.GC32378@google.com>
 <1343289850.26034.79.camel@twins>,<alpine.LFD.2.02.1207261242240.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207261242240.32033@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > tglx has patches that make the kthread create/destroy stuff from hotplug
> > go away.. that seems like the better approach.

> Right. That cpu hotplug setup/teardown stuff is ugly.

If that stuff gets removed complete that's great. The only change I'm aware of right now is the workqueue one: http://thread.gmane.org/gmane.linux.kernel/1329164

> > The main thing is avoiding the wakeup preemption from the complete()
> > because we're going to sleep right after anyway.

You are very likely to be preempted by the complete(), since the newly created thread has a relatively high vruntime.

> > The comment doesn't really make that clear.

> Right, the comment is crap. It has nothing to do with kthread_bind()
> and stuff. The whole purpose is to avoid the pointless preemption
> after wakeup.

The only case I want to solve is the kthread_bind()->wait_task_inactive() scenario. On our platforms this patch reduces average cpu_up() time from about 9ms to 8ms, but max time goes down from 37ms to 8.5ms. cpu_up() latency becomes much more predictable.


PeterB