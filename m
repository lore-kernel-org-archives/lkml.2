Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2BQLjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:39:54 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39794 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQLjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:39:52 -0500
MIME-Version: 1.0
In-Reply-To: <1329408142.2293.241.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.47587.stgit@kitami.mtv.corp.google.com> <1329408142.2293.241.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 03:39:22 -0800
Message-ID: <CAPM31R+uu9wmF-We0y2HZykVa8XSS8u+W4i4Gb0z+igtxU0x7A@mail.gmail.com>
Subject: Re: [RFC PATCH 05/14] sched: account for blocked load waking back up
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 8:02 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>
>>         u64 last_runnable_update, decay_count;
>
>> +       /* we track migrations using entity decay_count == 0 */
>> +       if (unlikely(se->avg.decay_count <= 0)) {
>
> !sleep dequeue isn't migrate only,

Well they mostly are these days; but in the == 0 case we're either a
load-balancer migration or someone doing a dequeue/enqueue pair on an
entity about some sort of update.

The key is that when it is an load-balancer move we'll resync
appropriately on enqueue (which we need to do).  We will essentially
sync with ourselves in the other cases, but they have no bearing on
why we do this.

> also, <= 0 on an unsigned is weird.

Yeah that should be a s64 not u64 (fixed).

>
