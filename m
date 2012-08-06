Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2HFTQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:16:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57753 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2HFTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:16:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
	<20120806190014.GA15267@mail.hallyn.com>
Date: Mon, 06 Aug 2012 12:16:29 -0700
In-Reply-To: <20120806190014.GA15267@mail.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 6 Aug 2012 19:00:14 +0000")
Message-ID: <87r4rjn84y.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+6QY/F8uc7OiIR7GrDi/UOhy2oXOjUz9o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Daniel P. Berrange (berrange@redhat.com):
>> From: "Daniel P. Berrange" <berrange@redhat.com>
>> 
>> The following commit
>> 
>>     commit cf3f89214ef6a33fad60856bc5ffd7bb2fc4709b
>>     Author: Daniel Lezcano <daniel.lezcano@free.fr>
>>     Date:   Wed Mar 28 14:42:51 2012 -0700
>> 
>>     pidns: add reboot_pid_ns() to handle the reboot syscall
>> 
>> introduced custom handling of the reboot() syscall when invoked
>> from a non-initial PID namespace. The intent was that a process
>> in a container can be allowed to keep CAP_SYS_BOOT and execute
>> reboot() to shutdown/reboot just their private container, rather
>> than the host.
>> 
>> Unfortunately the kexec_load() syscall also relies on the
>> CAP_SYS_BOOT capability. So by allowing a container to keep
>> this capability to safely invoke reboot(), they mistakenly
>> also gain the ability to use kexec_load(). The solution is
>> to make kexec_load() return -EPERM if invoked from a PID
>> namespace that is not the initial namespace
>> 
>> Signed-off-by: Daniel P. Berrange <berrange@redhat.com>
>> Cc: Serge Hallyn <serge.hallyn@canonical.com>
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>
> (Please see my previous email explaining why I believe the pidns
> is an appropriate check)

Serge as to your objects.

If we define kexec_load in terms of the pid namespace then something
makes sense, but the error should be EINVAL, or something of that sort.

That is what we did with reboot.  We defined reboot in terms of the pid
namespace.

Not defining kexec_load in terms of the pid namespace and then returning
EPERM because having we happen to have CAP_SYS_BOOT for other reasons is
semantically horrible.

At the end of the day the effect is the same, but I think it matters a
great deal in how we think about things.

We have CAP_SYS_BOOT in the initial user namespace.  We do have
permission to make the system call.

So I continue to see this patch the way it is current constructed as
broken.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
