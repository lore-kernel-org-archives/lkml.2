Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab0FQI3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:29:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab0FQI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:29:38 -0400
Message-ID: <4C19DCC2.9070708@kernel.org>
Date: Thu, 17 Jun 2010 10:28:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<4C18DC69.10704@kernel.org>	<1276698880.9309.44.camel@m0nster>	<4C18E4B7.5040702@kernel.org>	<1276701074.9309.60.camel@m0nster>	<4C18F2B8.9060805@kernel.org>	<1276705838.9309.94.camel@m0nster>	<4C1901E9.2080907@kernel.org>	<1276712547.9309.172.camel@m0nster>	<4C191BE9.1060400@kernel.org>	<4C192404.7000004@kernel.org> <20100617072920.2b09912d@schatten.dmk.lab>
In-Reply-To: <20100617072920.2b09912d@schatten.dmk.lab>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 08:28:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/17/2010 07:29 AM, Florian Mickler wrote:
> Once you have the priority in the driver you could pass it to the
> workqueue subsystem (i.e. set the priority of the work) and the worker
> could then assume the priority of its work.
> 
> The tricky part is probably to pass the priority from the userspace
> thread to the kernel?

There are several things to consider.  First of all, workqueue
latencies would be much lower with cmwq because works don't need to
wait for other works on the same wq to complete.  So, in general, the
latencies will be more predictable and lower.

Secondly, work items don't tend to burn a lot of cpu cycles.  Combined
with the first point, there might not be much benefit to doing all the
extra work for prioritizing work items (as what matters is getting
them to start running quickly and cmwq helps a lot in that direction).

Thirdly, on !RT kernel, RT doesn't have any guarantee anyway.  It's
just higher priority.  For real RT, if work items should be capable of
being part of critical path, implementing proper priority inheritance
is necessary so that flush_work() and possibly flush_workqueue() can
bump the waited works on behalf of RT thread waiting on them.  Whether
that would be a worth investment or just not using work items in
critical path is better, I don't know.

Thanks.

-- 
tejun
