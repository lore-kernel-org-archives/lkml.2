Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1EGN5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 09:57:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53436 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1EGN5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 09:57:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 2/7] ns: Introduce the setns syscall
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<1304735101-1824-1-git-send-email-ebiederm@xmission.com>
	<1304735101-1824-2-git-send-email-ebiederm@xmission.com>
	<201105071101.10950.remi@remlab.net>
Date: Sat, 07 May 2011 06:57:06 -0700
In-Reply-To: <201105071101.10950.remi@remlab.net> (=?utf-8?Q?=22R=C3=A9mi?=
 Denis-Courmont"'s
	message of "Sat, 7 May 2011 11:01:08 +0300")
Message-ID: <m1bozepqa5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+g5BvCC307J44IWopoJ9qtVnIHKOkXz8Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rémi Denis-Courmont" <remi@remlab.net> writes:

> Le samedi 7 mai 2011 05:24:56 Eric W. Biederman, vous avez écrit :
>> Pieces of this puzzle can also be solved by instead of
>> coming up with a general purpose system call coming up
>> with targed system calls perhaps socketat that solve
>> a subset of the larger problem.  Overall that appears
>> to be more work for less reward.
>
> socketat() is still required for multithreaded namespace-aware userspace, I 
> believe.

The network namespace is a per task property so there are no problems
with multithreaded network namespace aware userspace applications.  The
implementation of a userspace socketat will still need to disable signal
handling around the network namespace switch to be signal safe.  Which
means that ultimately a kernel version of socketat may be desirable,
for performance reasons but I know of know correctness reasons to need
it.

For the time being I have simply removed socketat from what I plan to
merge because it is not strictly needed, I don't yet have a test case
for socketat, and I don't have as much time to work on this as I
would like.

There is one bug a multi-threaded network namespace aware user space
application might run into, and that is /proc/net is a symlink to
/proc/self.  Which means that if you open /proc/net/foo from a task with
a different network namespace than your the task whose tid equals your
tgid, the /proc/net will return the wrong file.  Still you can
avoid even that silliness by opening /proc/<tid>/net.

Eric
