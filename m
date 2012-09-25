Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2IYC44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:56:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34359 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IYC4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:56:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <raven@themaw.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	<87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
	<1348447130.2318.1.camel@perseus.themaw.net>
	<87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
	<1348537604.2307.8.camel@perseus.themaw.net>
Date: Mon, 24 Sep 2012 19:56:46 -0700
In-Reply-To: <1348537604.2307.8.camel@perseus.themaw.net> (Ian Kent's message
	of "Tue, 25 Sep 2012 09:46:44 +0800")
Message-ID: <87mx0estch.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18FGlyVska4YBZkWxB2RiM4qTBMNBHM1qs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0015]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ian Kent <raven@themaw.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Mon, 2012-09-24 at 15:34 +0200, Miklos Szeredi wrote:
>> Ian Kent <raven@themaw.net> writes:
>> 
>> > On Fri, 2012-09-21 at 17:44 +0200, Miklos Szeredi wrote:
>> >> Miklos Szeredi <miklos@szeredi.hu> writes:
>> >> 
>> >> > These two patches change autofs4 to store struct pid pointers instead of pid_t
>> >> > values.
>> >> >
>> >> > Fixed various issues with the previous post.  Not tested, handle with
>> >> > care!
>> >> 
>> >> Customer gave positive test results.
>> >
>> > For what exactly, there's no problem description in these patches?
>> 
>> From what I understand (and I'm not an expert by any means) is that
>> autofs doesn't work if containers are used.  The first patch fixes this.
>
> Yeah, the problem with that is that "autofs doesn't work if containers
> are used" is ill defined since there are use cases where it does, I
> believe. At the very least, ill defined in my view of things.

An easy complaint is that task->pid and task->tgid are deprecated fields
in the task structure.  Things that use pids should in use struct pid
values instead.

The trick part of using struct pid values is that there are times when
you need to interact with userspace.  And the question is which pid
namespace is your userspace process in so that you can convert
to and from the proper pid namespace.

The pgrp option on the mount of autofs is buggy because the pid
namespace of the process group is not captured at the time of mount
and so userspace could think it is talking about one process group
while autofs is talking about another process group.  This is a
practical problem if the process that mounts autofs is not running
in the initial pid namespace.

There is a second question.  What happens if the oz_pgrp exists
and then pids wrap around and another process uses the same process
group number.  Currently the autofs code will treat the new proces
group like the old one leading to unexpected behavior.  Which I believe
will be autofs mounts not happening when desired.

Another problem is what happens when a process triggers an automount.
Today we will report the pid and the tgid in the initial pid namespace
of the process that triggered the mount.

So what I can see is that today if the process that mounts autofs
(aka the process at the other end of the autofs pipe) is not in
the initial pid namespace things will go awry, as autofs will report
pid values that make no sense to anyone.

I would like to say the patches fix that problem (and they come close)
however they still translate everything into the initial pid namespace.

> But I can't even sensibly discuss it because of the lack of specified
> use cases and requirements for each. So, there's a chance this will
> break another case that does work.

That seems to be a reasonable concern.  Education so that the
differences in the code are comprehensible.

I am also curious about which case people were seeing problems with as
these patches were reported to be tested and to have fixed a customer
problem.  The only case that is particularly clear to me that these
patches will fix is the case of process group wrap around, but proces
group wrap around should be exceedingly rare.

To handle mounts made outside of the initial pid namespace it appears
that all that is needed is to caputure the pid namespace of the process
that mounts autofs and uses pid_nr_ns to format pids into that
namespace, inside of autofs

It is my feeling that in addition to capture oz_pgrp on mount the
automount and autofs_dev_ioctl_set_pipefd should capture a pid namespace
for formating pids delivered into the pipe.  That would allow the
automount process itself to live outside of the initial pid namespace.

Eric

