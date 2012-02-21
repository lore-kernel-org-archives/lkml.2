Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2BUCeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:34:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56928 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2BUCeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:34:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of pjt@google.com designates 10.52.26.176 as permitted sender) smtp.mail=pjt@google.com; dkim=pass header.i=pjt@google.com
MIME-Version: 1.0
In-Reply-To: <87aa4dq1tq.fsf@abhimanyu.in.ibm.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <87k43lde0r.fsf@linux.vnet.ibm.com> <CAPM31RLWpF0mO2faCfY+HOeThz0iW6_7D+S++pGHtJi6hhiAVQ@mail.gmail.com>
 <87aa4dq1tq.fsf@abhimanyu.in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 20 Feb 2012 18:33:44 -0800
Message-ID: <CAPM31R+NXhsnjG6XoL9GT53XK29LxtgWM4uF39WWBmRmeeHGoA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 1:41 AM, Nikunj A Dadhania
<nikunj@linux.vnet.ibm.com> wrote:
> On Fri, 17 Feb 2012 02:48:06 -0800, Paul Turner <pjt@google.com> wrote:
>>
>> This is almost certainly a result of me twiddling with the weight in
>> calc_cfs_shares (using average instead of instantaneous weight) in
>> this version -- see patch 11/14.  While this had some nice stability
>> properties it was not hot for fairness so I've since reverted it
>> (snippet attached below).
>>
> For my understanding, what do you mean by stability here?

The result is stable; meaning repeating the experiment returns the same number.

>
>>
>> 24-core:
>> Starting task group fair16...done
>> Starting task group fair32...done
>> Starting task group fair48...done
>> Waiting for the task to run for 120 secs
>> Interpreting the results. Please wait....
>> Time consumed by fair16 cgroup:  12628615 Tasks: 96
>> Time consumed by fair32 cgroup:  12562859 Tasks: 192
>> Time consumed by fair48 cgroup:  12600364 Tasks: 288
>>
> "Tasks:" should be 16,32,48?
>

Ah, I ran your script multiple times (for stability) above, it must
not have been killing itself properly (notice each of those numbers is
the respective tasks per run times 6).

A correct first run on a 24-core looks like:
Starting task group fair16...done
Starting task group fair32...done
Starting task group fair48...done
Waiting for the task to run for 120 secs
Interpreting the results. Please wait....
Time consumed by fair16 cgroup:  1332211 Tasks: 16
Time consumed by fair32 cgroup:  1227356 Tasks: 32
Time consumed by fair48 cgroup:  1217174 Tasks: 48

The small boost to the tasks=16 case is almost certainly tied to our
current handling of sleeper credit and entity placement -- since there
are less tasks than cores, whenever a task moves to a core it has not
been previously executing on it gets a vruntime boost.

Thanks,

- Paul


> Regards,
> Nikunj
>
