Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2ITB21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:28:27 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56200 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2ITB2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:28:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Abhijith Das <adas@redhat.com>
References: <87lih2h6i4.fsf@xmission.com> <87harqecvk.fsf@xmission.com>
	<20120827085034.GA8998@quack.suse.cz> <87wr0j7u3j.fsf_-_@xmission.com>
	<20120828090544.GC5146@quack.suse.cz> <87a9xe7wfn.fsf@xmission.com>
	<20120828175101.GF5146@quack.suse.cz> <87y5ky6dff.fsf_-_@xmission.com>
	<20120829021029.GC13691@dastard> <87r4qqnixd.fsf@xmission.com>
	<20120831011758.GH15292@dastard>
Date: Wed, 19 Sep 2012 18:28:06 -0700
In-Reply-To: <20120831011758.GH15292@dastard> (Dave Chinner's message of "Fri,
	31 Aug 2012 11:17:58 +1000")
Message-ID: <87vcf91o0p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ASGvq+B2YxiLQY3NupJlHV0Lu/+cbvq4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3663]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Chinner <david@fromorbit.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: Add basic quota support v4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave thank you earlier taking some time to do review.  It made me
realize that my code was not as mature as it needed to be.

That said you missed a lot of important details, and I will aim at
to address some of the highlights.

Precedent in naming. <uidgid.h> that has been merged since 3.5, earlier
there is make_pte.   Much of your review sounds like you are unhappy
with the general infrastructure that was built for user namespaces,
and already merged.  Short of an overwhelmingly better suggestion
at this point I am not going to revisit naming.

Passing structures by value is a core part of the design and a necessity
for strong type safety in C, and again already in common use in the
kernel.

Using BUG on code paths that can not be triggered, simply means that
in that rare and unlikely event there is a clear trace to follow,
and xfs already has plenty of invocations of BUG, some of which
I managed to trigger with the xfs test suite.  So I can not find
much sense in your arguments about being clear that something is a BUG.

Your comments on where xfs uses projid are just laughable.

>> So I am inclined to rename this field projid, but I don't know if it is
>> worth respinning the patch for something so trivial.
>
> I'd like to think you are joking, given that the patch series is all
> about using consistent, verifiable identifiers... :/

The patch series is all about implementing the user namespace.

To make it hard to miss places where conversions need to between the
internal kernel form and the form stored in filesystems or the form that
userspace uses I use types that are not assignment compatible.  Pushing
the types deeper in the code keeps me honest and let's me find cases
I was not expecting like the ioctl interface of xfs that largely
duplicates much of the vfs functionality.

Eric
