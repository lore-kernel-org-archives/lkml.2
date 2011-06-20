Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1FTWpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:45:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55602 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab1FTWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:45:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, akpm@linux-foundation.org,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com, daniel.lezcano@free.fr, oleg@redhat.com,
        xemul@openvz.org, Cedric Le Goater <clg@vnet.ibm.com>
References: <20110615145527.4016.70157.stgit@bahia.local>
	<BANLkTimSC_OSrbekhM=wd2Gie4np3Q4F5A@mail.gmail.com>
	<1308570316.8230.140.camel@bahia.local>
	<BANLkTiknqo0iKry7mjq+mc4iOWj_A_mrrw@mail.gmail.com>
Date: Mon, 20 Jun 2011 15:44:57 -0700
In-Reply-To: <BANLkTiknqo0iKry7mjq+mc4iOWj_A_mrrw@mail.gmail.com> (Bryan
	Donlan's message of "Mon, 20 Jun 2011 13:37:24 -0400")
Message-ID: <m1ei2o9l7a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wTnmaBFMRV3oryeGlRaZhV0viLuSB6tU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bryan Donlan <bdonlan@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was Vpid:)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan <bdonlan@gmail.com> writes:

> On Mon, Jun 20, 2011 at 07:45, Greg Kurz <gkurz@fr.ibm.com> wrote:
>> On Thu, 2011-06-16 at 13:54 -0400, Bryan Donlan wrote:
>
>>> Although getting the in-namespace PID is a useful thing, wouldn't a
>>> truly race-free API be preferable? Any access by PID has the race
>>> condition in which the target process could die, and its PID get
>>> recycled between retrieving the PID and doing something with it.
>>
>> Well the PID is a racy construct when used by another task than the
>> parent... fortunately, most userland code can cope with it ! :)
>
> That doesn't mean we shouldn't try to fix the race! :)
>
>>> Perhaps a file-descriptor API would be better, such as something like
>>> this:
>>>
>>> int openpid(int id, int flags);
>>> int rt_sigqueueinfo_fd(int process_fd, int sig, siginfo_t *info);
>>> int sigqueue_fd(int process_fd, int sig, const union sigval value); //
>>> glibc wrapper
>>>
>>
>> The race still exists: openpid() is being passed a PID... Only the
>> parent can legitimately know that this PID identifies a specific
>> unwaited child.
>
> Yes, the idea would be either the parent process, or the target
> process itself would open the PID, then pass the resulting file
> descriptor to whatever process is actually doing the killing.
> Alternately, one could add additional calls to help identify whether
> the right process was opened (perhaps a call to get a directory handle
> to the corresponding /proc directory?)

fd = open("/proc/self/", O_DIRECTORY);
?

Doing something based on proc files seems like a reasonable direction to
head if we are working on a race free api.

I suspect all we need is a sigqueue file.

Eric

