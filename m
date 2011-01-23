Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1AWDjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 22:39:52 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45456 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1AWDjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 22:39:49 -0500
MIME-Version: 1.0
In-Reply-To: <1295645135.3403.31.camel@localhost.localdomain>
References: <1294266337.3237.45.camel@localhost.localdomain>
	<20110111220201.GA6446@localhost>
	<1295034658.2816.16.camel@localhost.localdomain>
	<AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
	<1295645135.3403.31.camel@localhost.localdomain>
Date: Sat, 22 Jan 2011 19:39:47 -0800
X-Google-Sender-Auth: hfiAUdCcmgzhrKK1HThBSXVKKxs
Message-ID: <AANLkTinPGMijRFnn8T=fndnCCGAsNq_6qCOzKcuhZE8H@mail.gmail.com>
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, sgrubb@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 1:25 PM, Eric Paris <eparis@redhat.com> wrote:
> On Sun, 2011-01-16 at 19:16 -0800, Andrew G. Morgan wrote:
>
>> I'm not a supporter of system-wide security contexts changing under
>> running programs. Previous experience has taught me that tricking a
>> program into thinking it has one sort of privilege and then
>> withdrawing it without notice can be dangerous.
>
> But a bounding set doesn't affect a running program's abilities, the
> bset is only applied at exec().  So if it's fcaps based you have all
> that wacky kill logic.
>
>>  Since privileged
>> programs include shells that invoke privileged commands to perform
>> system admin tasks, I consider a global bounding set to be trouble in
>> the making.
>
> No question, but then again, if you have CAP_SYS_MODULE there are a lot
> easier ways to make trouble   :)

But I thought the issue at hand was not protecting a system from root,
but protecting a system from kernel auto-exec'd programs.

>> If we were to delete that special code what I think is missing from
>> the current kernel model, is not a global bounding set, but a 'kernel
>> auto-exec' securebits value. One that can be set by an admin at
>> runtime to suppress the root-is-all-capable behavior of the auto-exec
>> process, and defer the privilege escalation to carefully audited file
>> capabilities on the relevant helper binaries.
>
> But how can that leave us with an impotent root?  Root would be easily
> able to craft a file with any caps it wants in fI and fP on any of the
> plethora of helper programs the kernel calls and escalate away it's
> impotence.

Again, assuming that you are really trying to limit the power of
kernel auto-exec'd programs, then you can see how secure bits can make
root-power harder to obtain. (Examples using libcap utilities.)

[root@pip foo]# whoami
root
[root@pip foo]# ls -l foo.sh
-rwx------ 1 bin nobody 31 2011-01-22 19:07 foo.sh
[root@pip foo]# /sbin/capsh --secbits=0x0 -- ./foo.sh
Hello, Root
[root@pip foo]# /sbin/capsh --secbits=0x2f -- ./foo.sh
/bin/bash: ./foo.sh: Permission denied
[root@pip foo]#

That is, the 0x2f value of the secure bits turns off root's privilege.
This includes the privilege to add capabilities to files (run this
from the progs subdirectory of the libcap source, after a build):

[root@pip progs]# /sbin/capsh --secbits=0 -- \
-c "/sbin/setcap cap_setfcap=ep setcap"
[root@pip progs]# /sbin/getcap -v setcap
setcap = cap_setfcap+ep
[root@pip progs]# /sbin/setcap -r setcap
[root@pip progs]# /sbin/getcap -v setcap
setcap
[root@pip progs]# /sbin/capsh --secbits=0x2f -- \
-c "/sbin/setcap cap_setfcap=ep setcap"
unable to set CAP_SETFCAP effective capability: Operation not permitted
[root@pip progs]#

So, my point is that if the kernel threads were launched with a
user-space configurable set of secure bits, and the regular exec()
rules were used by these kernel-launched processes to obtain
privilege, you could block the kernel from getting any user-space
privileges via secure bits.

> I'd really like to drop a cap from an entire system never to return.
> Maybe I can get there by exposing the bset of the kthread which launches
> the helpers (makes me feel very dirty).  But that is smaller than the
> global bset....

Does any of the above help clarify how else to achieve your ends?

Cheers

Andrew
