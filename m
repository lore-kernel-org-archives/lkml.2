Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2FERTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:19:07 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47888 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2FERTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:19:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org, kir@parallels.com,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com>
	<20120604165117.GA13091@redhat.com>
Date: Tue, 05 Jun 2012 10:18:52 -0700
In-Reply-To: <20120604165117.GA13091@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Jun 2012 18:51:17 +0200")
Message-ID: <874nqp7k3n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/e8/wooDeGEx1X3o7FWO+ru4fFNPvjAkc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0719]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] allow a task to join a pid namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/04, Glauber Costa wrote:
>>
>> Currently, it is possible for a process  to join existing
>> net, uts and ipc namespaces. This patch allows a process to join an
>> existing pid namespace as well.
>
> I can't understand this patch... but probably I missed something,
> I never really understood setns.

The idea with setns is akin to callusermodehelper in the kernel.

>From outside a container we want to allow an appropriately privileged
user to create a process inside the container.

We run into all kinds of interesting gotchas with entering the
pid namespace:
 - Disjoint process trees.
 - Ensuring all processes are gone when we exit a pid namespace.
 - Not letting an empty pid namespace accept more processes.

We really only have two possbilities here.
- Allocate a new struct pid that is a superset of our current struct
  pid but having additional processes ids inside a new pid namespace.

  Along with all of the appropriate sanity checks to make that safe.

- Just modify the pid namespace the child processes of setns will use.

I lean towards the second option as that seems to have the best semantic
match to practical applications, and fewer kernel races to contend with,
but I might be persuadable.

However we do this we need to fix the bugs in pid namespace cleanup,
and deal with the issues that disjoint process trees bring to waiting
for all processes in a pid namespace to exit.

Ugh.  Getting the waking up of zap_pid_ns_processes right and handling
the reaping of zombines in the cases of disjoint process trees is going
to be interesting.

Eric
