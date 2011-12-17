Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1LQTZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 14:25:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61845 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1LQTZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 14:25:31 -0500
MIME-Version: 1.0
In-Reply-To: <20111216163549.GD12397@aftab>
References: <CA+8MBb+T_y7CHkxjRHr8VK0gk1zo1m-ib71A5k5N4NDn0PtEzw@mail.gmail.com>
	<0279870@agluck-desktop.sc.intel.com>
	<20111216163549.GD12397@aftab>
Date: Sat, 17 Dec 2011 11:25:31 -0800
X-Google-Sender-Auth: vGcqihEd09JYv4E2Ehekc9QEkGs
Message-ID: <CA+8MBbK1mCteGxkKS-3_9=ivrX0LJUC_hMrU6wPMf7+2cXnMUQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86, mce: handle "action required" errors (unjumbled version)
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 8:35 AM, Borislav Petkov <bp@amd64.org> wrote:
>>  #ifndef CONFIG_MEMORY_FAILURE
>>  int memory_failure(unsigned long pfn, int vector, int flags)
>>  {
>> +     if (flags & MF_ACTION_REQUIRED)
>> +             return -ENXIO; /* panic? */
>
> Yes, an AR error _is_ an uncorrectable error so in order to stay
> backwards-compatible, we should panic here unconditionally IMO.

I just thought of a better way ... I'll change part 6 of this patch set to
put the severity recognition entries for "AR" errors inside of #ifdef
CONFIG_MEMORY_FAILURE. It makes no sense to mark these
as action required severity if we don't have the code configured that
can take the action. It makes more sense for the severity analysis
to just flag them as "PANIC" events (which the catch-all AR=1 case
in the severity table will do without the MCACOD=0x134 entries).

Then I can simplify here ... perhaps put:
        BUG_ON(flags & MF_ACTION_REQUIRED);
here so if a future change to the severity parser does let an action
required error slip through, we'll be able to see that was the problem
was in the severity analysis.

-Tony
