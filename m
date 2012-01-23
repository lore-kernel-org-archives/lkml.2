Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2AWQcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:32:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60110 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2AWQcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:32:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Earl Chew <echew@ixiacom.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org>
	<4F1D8180.9030509@ixiacom.com>
Date: Mon, 23 Jan 2012 08:35:15 -0800
In-Reply-To: <4F1D8180.9030509@ixiacom.com> (Earl Chew's message of "Mon, 23
	Jan 2012 07:49:20 -0800")
Message-ID: <m1mx9enzr0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/kAjuwBFnH7XNU8bYU98qC4MUi7R1z1IQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earl Chew <echew@ixiacom.com> writes:

> On 23/01/2012 6:47 AM, Eric W. Biederman wrote:
>> The difference between strings and integers is that with strings
>> single byte reads/writes actually make sense.
>> 
>> Single decimal digits reads don't make much sense at all for integers.
>> 
>> Is there any compelling reason to support this complete idiocy from user
>> space programs?
>
> Eric,
>
> [ I also note that the patch allows multiple short reads (not necessarily
>   just a single byte at a time) from these entries in procfs. ]
>
> I think there is a reasonable userspace expectation that entities
> that present themselves as text files to produce results that are
> consistent with the userspace model of a text file.
>
> For a more concrete example, consider the following BusyBox ash(1) code:
>
> read X < /proc/sys/kernel/threads-max
> Y=$(cat /proc/sys/kernel/threads-max)
>
> read A < /proc/sys/kernel/core_pattern
> B=$(cat /proc/sys/kernel/core_pattern)


> The fact that these yield different results is surprising given that
> the user sees these as text files.
>
> I think it is worthwhile asking the opposite question,
>
> " Is there any compelling reason for the kernel to require userspace
>   programs to access /proc/sys/kernel/threads-max any differently
>   from, say, /etc/fstab ? "
>
> If the answer is in the affirmative, then it requires some layer in
> the userspace program (presumably the IO layer) to make some
> special accommodation for some entries in /proc.
>
> As can be seen in the case of BusyBox, this approach might be difficult
> to swallow in something as generic as ash(1), so it is left to the user to
> puzzle out why read fails, but cat works -- but only sometimes.

read X < file seems like a reasonable case to support.
Bash doesn't have that problem so presumably BusyBox is simply
inefficient.

If you are interested in fixing this properly with a tiny buffer
reachable from struct file I think this can be worth fixing.  I think
this is doable by using seq_file in proc_sys_read.

Rereading different bytes of the integer multiple times when the integer
may be changing does not seem like a reasonable implementation.

Eric
