Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab0JEKJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:09:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63992 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab0JEKJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u19m2/4vgxR5Ws7W0rzChYO1Weh/QHry4rihSda6+nhLjnZsEvr13loZTpIXMsDVxR
         RFAdIzkultd6rMG8WRixb426/wI4Idy03HlvplxNjHR5w9owHMsByPNzv+URPPYLB1oK
         qL/yFHA3PHzesYb89av39RpuPPMG8O4vyQ0gw=
MIME-Version: 1.0
In-Reply-To: <20101004092107.GJ4681@dastard>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
	<20100920191355.GA28443@infradead.org>
	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
	<4CA997DF.5030008@kernel.org>
	<20101004092107.GJ4681@dastard>
Date: Tue, 5 Oct 2010 12:09:10 +0200
Message-ID: <AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
Subject: Re: -mm: xfs lockdep warning
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 11:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 04, 2010 at 11:01:19AM +0200, Tejun Heo wrote:
>> Hello,
>>
>> On 09/25/2010 03:08 PM, Torsten Kaiser wrote:
>> > [adding Tejun Heo, because I'm partly blaming his workqueues]
>>
>> :-) Sorry about the delay.  I was away the last week.
>>
>> > After that I enabled lockdep and retried the same update: This time no
>> > hang, only the same lockdep report that Yang Ruirui had.
>> >
>> > So I'm currently at a loss how I should continue from here. The XFS
>> > false positive drowns any other lockdep problems, but XFS had some
>> > hang problems with the new workqueues. (Personally I had no other hang
>> > with earlier 2.6.36-rcs)
>
> What XFS hang problem? I've seen temporary livelocks from the new
> workqueue code, but thay have been fixed. I haven't come across any
> deadlocks or hangs. Do you have a pointer to a bug report in case my
> memory is failing me?

I was referring to the hang that prompted to increase of the priority
of the xfslogd thread. Its commit
51749e47e191db8e588ad5cebea731caf7b705d7 in Linus' tree. But it seems
I have misremembered that one as a hang.

The hang I have seen is describe here:
http://marc.info/?l=linux-kernel&m=128542018414916&w=2

As 2.6.36-rc5 already includes this priority fix, I believe this hang
is something different and wrote that mail.

>> If workqueue lockdep annotations are triggering spuriously, just nuke
>> all lockdep annotations in workqueue.c.  Currently the annotations are
>> the same as before and trigger even when an actual deadlock won't
>> happen anymore around flushes (but then again all the current users
>> should be operating under the same constraints as before).  I'm
>> looking into how to improve the lockdep annotations but in the end it
>> might be best to leave it as it is.  I'll try to analyze the warnings.
>
> It looks like there's been some discussion that has been private so
> I'm clueless as to the context being discussed here.  Can someone
> fill me in on whatever is going on?

I only send the above message both to the lkml and the XFS mailing list.

But it could have been wrong to make it a reply in this thread,
because now there are three different things mixed up.

1) the old livelock, that I was referring too -> That is already fixed
in mainline, I just wanted to note, that this is unrelated to the hang
I have seen.
2) the hang with 2.6.35-rc5 I have seen twice (triggered probably by
high load while building KOffice on an tmpfs)
3) the lockdep issue that started this thread and that I am seeing in
mainline 2.6.36-rc5 and -rc6 and that seems to be rather easy to
trigger for me.

Because 3) is regarded as a false positive, it should not be the cause
of 2). But because 3) triggers on my system I can't see if lockdep
might give better pointers to what might be the real cause of 2).

So, I would like to test the patch Christoph was testing in
http://marc.info/?l=linux-kernel&m=128501006509743&w=2 to see, if that
helps to debug my hang. (And because I did not see that patch on the
lkml, I replied to Christophs mail.)

I CC'ed Tejun, because I believe the primary suspect for my hang was
the stuck kworker/u:8:845 and I was hoping he might see something
obvious wrong in that stacktrace.

Torsten
