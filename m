Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0DDJQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 05:16:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54091 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0DDJQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 05:16:09 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       nhorman@redhat.com, nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
	<20100403012820.229410717@sous-sol.org>
	<20100403172224.GO24846@8bytes.org> <m18w94l9c9.fsf@fess.ebiederm.org>
	<20100404084435.GT24846@8bytes.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 04 Apr 2010 02:16:00 -0700
In-Reply-To: <20100404084435.GT24846@8bytes.org> (Joerg Roedel's message of "Sun\, 4 Apr 2010 10\:44\:36 +0200")
Message-ID: <m1fx3befxr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: joro@8bytes.org, vgoyal@redhat.com, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, nhorman@tuxdriver.com, nhorman@redhat.com, joerg.roedel@amd.com, chrisw@sous-sol.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Sat, Apr 03, 2010 at 10:44:22AM -0700, Eric W. Biederman wrote:
>> Joerg Roedel <joro@8bytes.org> writes:
>
>> > Hmm, I think for this we need to change the gart code too and disable
>> > the gart before its initialization runs to not re-introduce issues fixed
>> > in commit bc2cea6a34fdb30f118ec75db39a46a191870607, no?
>> 
>> That is a different code path with a different set of assumptions and
>> restrictions.  On a normal kexec of course we want to do an orderly shutdown.
>
> Thats another problem with this patch. It introduces a difference
> between the panic-shutdown kexec and the ordinary kexec.

Of course there is.  kexec on panic does no shutdown, and should not.
That is fundamental.  That is documented.

This make them symmetric crap is a bad idea, because we can not reliably
do it.  999 times out of 1000 we can actually handle everything we
need to in the kdump kernel in the initialization path and when
we succeed it makes linux much more robust.

>> For the gart with a little luck we can just ignore it on kexec on
>> panic.
>
> The commit I mentioned above already proves this assumption wrong.

Now that I look at that commit again I am stunned.  That commit
already says it is doing things wrong.  

What I meant by ignore it is that we should be able to not use it.

>> Unlike a virtualization capable iommu it doesn't prevent access
>> to devices, when it is enabled.   Worst case is that we have to start
>> including iommu=off for gart systems.
>
> No no no. This is a maintenance nightmare for almost everybody. Where do
> you want to Document this special cases that 'if kernel uses gart then
> and only then boot the kexec kernel with iommu=off'.
> Always passing iommu=off to the kexec kernel doesn't work too for
> obvious reasons.

I agree.  I would like to see something better, but the situation
with the current set of patches is workable.  Getting autodetection
in there an automatically doing the right thing would be much better.

Do you happen to have a patch you would like to submit to handle this?

>> The best case is that we can figure out how to have the gart code
>> reinitialize itself sanely, starting from some arbitrary point.
>
> Yes, that is missing in this patch. But to keep changes small and don't
> bother with the gart code at all I suggest to remove the shutdown
> routine from the amd-iommu code only and not the whole shutdown call in
> the machine_crash_shutdown path.

Which will only encourage further abuse of that code path.  The reliability
has been continually decreasing lately and I believe this is one of those
reasons.  The hpet junk in there appears to be an even bigger reason.

I have machines right now that can not reliably crash dump because
someone tried papering over problems by putting code in the
machine_crash_shutdown path which must have worked for their test cast
but does not work for real world failures, and right now I am very
grumpy about it all.

I guess what I am saying is that I do not believe shutting down the
gart in machine_crash_shutdown actually works.  It is definitely not
the right place to do that work.  So I don't see why we should keep
any of that code there.

Eric
