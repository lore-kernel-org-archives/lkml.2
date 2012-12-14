Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2LNRtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:49:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55255 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2LNRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:49:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com>
	<CALCETrWxXZ1OzZeH_SGeg1E16rssxBwg+hjG09N5dkqweVKeRA@mail.gmail.com>
	<87mwxhff2e.fsf@xmission.com>
	<CALCETrXagfjy4o0_JCZpMfdocYK-MpOp3eH-tPZhgazvJAy-EQ@mail.gmail.com>
Date: Fri, 14 Dec 2012 09:48:54 -0800
In-Reply-To: <CALCETrXagfjy4o0_JCZpMfdocYK-MpOp3eH-tPZhgazvJAy-EQ@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 13 Dec 2012 21:34:22 -0800")
Message-ID: <87vcc47ce1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/7G/WWMjlThMugKEA6pEJjp89e0YM4v4A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3783]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes for 3.8
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Thu, Dec 13, 2012 at 8:11 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> One more issue: the requirement that both upper and lower uids (etc.)
>>> in the maps are in order is rather limiting.  I have no objection if
>>> you only require upper ids to be monotonic, but currently there's no
>>> way to may root outside to uid n (for n > 0) and some nonroot user
>>> outside to uid 0.
>>
>> There is.  You may set up to 5 (extents).  You just have to use a second
>> extent for the non-contiguous bits.  My reader is lazy and you have to
>> set all of the extents with a single write, so you may have missed the
>> ability to set more than one extent.
>>
>
> If I'm wrong, I'll happily eat my words.  Both:
>
> 0 1 1
> 1 0 1
>
> and
>
> 1 0 1
> 0 1 1
>
> are rejected, unless I totally messed up.

Duh.  You are right.  

It is this check:

		/* For now only accept extents that are strictly in order */
		if (last &&
		    (((last->first + last->count) > extent->first) ||
		     ((last->lower_first + last->count) > extent->lower_first)))
			goto out;

Fundamentally every value mapped must be distinct.  Aka the direction of
the mapping must be reversible without loss of information.  

Ensuring all of the values were increasing in the extents was just a
lame way of ensuring that the same value was not mapped twice in either
the upper or lower ranges.

That check can most certainly be relaxed (patches welcome).  But that
probably isn't 3.8 material as that is feature work.

Not having bumped into this limitation myself I'm not certain the value
in removing this check.  But there is no good reason not to replace the
current check with a more general one either.

So your example should work, and that it doesn't is a misfeature.

Eric

