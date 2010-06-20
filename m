Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0FTVAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:00:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43890 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab0FTVAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:00:16 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com>
	<20100617212003.GA4182@redhat.com>
	<20100618082033.GD16877@hawkmoon.kerlabs.com>
	<20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com>
	<20100618173320.GG16877@hawkmoon.kerlabs.com>
	<20100618175541.GA13680@redhat.com>
	<20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com>
	<m1pqzmqema.fsf_-_@fess.ebiederm.org>
	<20100620180335.GA17120@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 20 Jun 2010 14:00:05 -0700
In-Reply-To: <20100620180335.GA17120@redhat.com> (Oleg Nesterov's message of "Sun\, 20 Jun 2010 20\:03\:35 +0200")
Message-ID: <m14ogxctd6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: oleg@redhat.com, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, xemul@openvz.org, louis.rilling@kerlabs.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/6] Unshare support for the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/20, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 06/18, Oleg Nesterov wrote:
>> >>
>> >> I only try to discuss the idea to break the circular reference.
>> >
>> > I don't know what I have missed, but this looks really right to me.
>> > Besides, we have yet another problem: proc_flush_task()->mntput()
>> > is just wrong. Consider the multithreaded execing init.
>> >
>> > I am going to simplify, test, and send the fix which moves mntput()
>> > into free_pid_ns() paths.
>>
>> free_pid_ns is comparatively late, to release the kern_mount.
>
> Why?
>
> Once again, it is very possible I am wrong. I forgot this code if ever
> knew. But could you please explain?

There are two kinds of dead for a pid namespace. There are:
- no processes left.
- no more references to struct pid_namespace.

I just looked and I don't see any references to proc_mnt except from
living processes.

So while it isn't necessary that we kill the proc_mnt earlier it does
mean that we hold the resources longer then necessary.

>> > But first of all I think we should cleanup the pid_ns_prepare_proc()
>> > logic. Imho, this code is really ugly. Please see the patches.
>>
>> Since I have a patchset that makes it possible to unshare the pid
>> namespace about ready to send I figure we should combine the two
>> efforts.
>>
>> This patchset is a prerequisite to my patches for giving namespaces
>> file descriptors and allowing you to join and existing namespace.
>
> I do not understand.
>
> Eric, why you can't do these changes on top of the cleanups I sent?

Because there are conflicts, and if we are going to be going to
be working on this we should all be on the same page.


> OK, personally I certainly dislike 1/6, but perhaps it is needed for
> 6/6 which I didn't read yet. But, in any case, it is orthogonal to
> pid_ns_prepare_proc() cleanups?

1/6 is.  If you unshare a pid namespace.  Your first child is pid one.
Which means we can on longer count on CLONE_PID.

Frankly that 1/6 is also a cleanup.

> Now. You joined the first 2 patches I sent into 2/6. It is not that
> I care about the "From:" tag, but why? And (unless I missed something)
> you added the following changes compared to my patches:

I wrote that patch in March. So it is equally fair to say you split
my patch in two.


> 	- remove the MS_KERNMOUNT check around ei->pid = find_pid(1).
> 	  OK, I agree it was not strictly needed, but imho makes the
> 	  code cleaner.
>
> 	  Or I missed something and this check was wrong?

The MS_KERNMOUNT check was simply unnecessary, and it makes the code
uglier to read and more brittle.  Since I already had something
that was only looking at the essential details I didn't see the
point of such and ugly addition.

> 	- introduce the bug in create_pid_namespace(). If
> 	  pid_ns_prepare_proc() fails, we return the wrong error
> 	  code and leak parent_pid_ns().

Because I goofed, in March when I wrote it.  Your patch got that right
mine gets it wrong.

> So. Afaics - nack to 2/6 at least. Could you please do this on top of
> the cleanups I sent? Of course, unless you think they are wrong.

Well I think that entire MS_KERNMOUNT test is unnecessary and
too horrible to live.

> And. I do not think these series can fix the discussed problems. ns->dead
> definitely can't, no?

I'm am fairly confident that we have the signal sending races fixed so
we can reasonably expect having sent SIGKILL to all processes in a pid
namespace

ns->dead certainly doesn't help in it's current form.  I do think my
series informs us of the direction the code is going, and that is
important in it's own way.

> I think we should fix the bugs first.

Your patchset currently goes beyond the minimal that would make sense
for 2.6.35.  So we are talking about code for 2.6.36, and I think the
unshare of the pid namespace code is certainly close enough that it
can also be ready for 2.6.36.

So what we get is more brains engaged and caring on the project so
hopefully get better code review.

Eric
