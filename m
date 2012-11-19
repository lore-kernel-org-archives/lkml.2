Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2KSVKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:10:11 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60239 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2KSVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:10:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87lidx8wbo.fsf@xmission.com>
	<1353337961-12962-1-git-send-email-ebiederm@xmission.com>
	<1353337961-12962-12-git-send-email-ebiederm@xmission.com>
	<20121119180322.GC1883@serge-ThinkPad-X130e>
	<87fw451m5i.fsf@xmission.com> <20121119210153.GA11904@sergelap>
Date: Mon, 19 Nov 2012 13:09:54 -0800
In-Reply-To: <20121119210153.GA11904@sergelap> (Serge Hallyn's message of
	"Mon, 19 Nov 2012 15:01:53 -0600")
Message-ID: <877gphz4d9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Il0BImdXfbBsa8lL4QKbezZ9QiFHqeEo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 12/16] userns: For /proc/self/{uid, gid}_map derive the lower userns from the struct file
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@canonical.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Serge Hallyn <serge.hallyn@canonical.com> writes:
>> 
>> > Quoting Eric W. Biederman (ebiederm@xmission.com):
>> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> 
>> >> To keep things sane in the context of file descriptor passing derive the
>> >> user namespace that uids are mapped into from the opener of the file
>> >> instead of from current.
>> >> 
>> >> When writing to the maps file the lower user namespace must always
>> >> be the parent user namespace, or setting the mapping simply does
>> >> not make sense.  Enforce that the opener of the file was in
>> >> the parent user namespace or the user namespace whose mapping
>> >> is being set.
>> >
>> > Is there a reasonable use case for writing from the ns whose mapping
>> > is being set?  Are you expecting cases where the child opens the file
>> > and passes it back to the parent to set the mappings?
>> 
>> Passing the open mappings file no.  Although by using seq_user_ns I do
>> make certain the semantics are correct if the file descriptor is passed,
>> but I did that on general principles.
>> 
>> I expect a process in the user namespace to be able to meaningfully set
>> the mapping to some the current uid and the current gid.
>
> Sorry, I think a word is missing there.  To be precise (bc I haven't
> thought about this much before as it's not my target goal :) you're
> saying if I'm uid 1000 gid 1000, I can create a new user namespace
> and, from inside that new userns (where I'm first uid/gid -1) I can
> map any uid+gid in the container to 1000 in the parent ns?  Or is there
> something more?

Only that for now.  I had once imagined magic would happen in the
background to verify the parent.

> It still seems to me no less flexible to require being in the parent
> ns, so
>
>> >> +	if ((seq_ns != ns) && (seq_ns != ns->parent))
>> >> +		return -EPERM;
>
> would become
>
>> >> +	if (seq_ns != ns->parent)
>> >> +		return -EPERM;
>

In practice when playing around it is the difference between.
unshare -U /bin/bash
echo 0 1000 1 > /proc/self/uid_map

And the need to pre-plan something.  You can set the uid_map from the
parent in a shell script but it is a real pain.  So for just messing
around allowing seq_ns == ns is a real advantage.

> I also wonder if -EINVAL would be a more appropriate choice here.
> We're trying to keep things sane, rather than saying "not allowed"
> for its own sake.

A different error code might be better.

Eric

