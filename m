Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab0FOSqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:46:36 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40660 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594Ab0FOSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:46:32 -0400
Message-ID: <4C17C353.80708@s5r6.in-berlin.de>
Date: Tue, 15 Jun 2010 20:15:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.24) Gecko/20100228 SeaMonkey/1.1.19
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <20100614145839.8ac7687a.akpm@linux-foundation.org>
In-Reply-To: <20100614145839.8ac7687a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 14 Jun 2010 23:37:17 +0200
> Tejun Heo <tj@kernel.org> wrote:
> 
>> This is the fifth take of cmwq (concurrency managed workqueue)
>> patchset.
> 
> What is a concurrency managed workqueue and why do we want one?

>From what I understood, this is about the following:

  - Right now, a workqueue is backed by either 1 or by #_of_CPUs
    kernel threads.  There is no other option.

  - To avoid creating half a million of kernel threads, driver authors
    resort to either
       - using the globally shared workqueue even if they might queue
         high-latency work in corner cases,
    or
       - creating a single-threaded workqueue even if they put unrelated
         jobs into that queue that should better be executed in
         parallel, not serially.
    (I for one have both cases in drivers/firewire/, and I have similar
    issues in the old drivers/ieee1394/.)

The cmwq patch series reforms workqueues to be backed by a global thread
pool.  Hence:

  + Driver authors can and should simply register one queue for any one
    purpose now.  They don't need to worry anymore about having too many
    or too few backing threads.

  + [A side effect:  In some cases, a driver that currently uses a
    thread pool can be simplified by migrating to the workqueue API.]

Tejun, please correct me if I misunderstood.
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/
