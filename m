Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab1ENAUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 20:20:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37647 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab1ENAUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 20:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w7lPcpwgwsyECMECnqF6QiTawhLFIwuyhIS7/zOSmKQYl0pO8xj5SH0j3EkNg8fjI4
         3uPYUb4NDU5j7kQBKd3Jscm1isbHZzpNBiVeByy5u4fERrdRqtS+U+A5X8hyYcRdvGZO
         L8l3PeGsmy+wuNjqRjnsF9f7bYgKsy9nFnkrI=
MIME-Version: 1.0
In-Reply-To: <20110513135154.GB31888@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
	<20110513124523.GM13984@redhat.com>
	<BANLkTimoqYZMs15H8wRqEEe=UyBJtAwipw@mail.gmail.com>
	<20110513135154.GB31888@redhat.com>
Date: Sat, 14 May 2011 08:20:40 +0800
Message-ID: <BANLkTiktuq3vMXKOdChm03SF6V4c2GhDVw@mail.gmail.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 9:51 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, May 13, 2011 at 09:17:13PM +0800, huang ying wrote:
>> Hi, Don,
>>
>> On Fri, May 13, 2011 at 8:45 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Fri, May 13, 2011 at 04:23:38PM +0800, Huang Ying wrote:
>> >> In general, unknown NMI is used by hardware and firmware to notify
>> >> fatal hardware errors to OS. So the Linux should treat unknown NMI as
>> >> hardware error and go panic upon unknown NMI for better error
>> >> containment.
>> >
>> > I have a couple of concerns about this patch.  One I don't think BIOSes
>> > are ready for this.  I have Intel Westmere boxes that say they have a
>> > valid HEST, GHES, and EINJ table, but when I inject an error there is no
>> > GHES record.  This leaves me with an unknown NMI and panic.  Yeah, it is a
>> > BIOS bug I guess, but I think vendors are going to be slow fixing all this
>> > stuff (my Nehalem box is in even worse shape with this stuff).
>>
>> Although there is no GHES record, I think the Westmere box behavior is
>> acceptable, an unknown NMI is used by BIOS to notify hardware error,
>> this is what we want to deal with in this patch.
>
> I don't think having HEST changes the situation.  I agree with your
> statement above, but I can also generate unknown NMIs from stressing perf.

Yes. perf can still generate unknown NMIs.  Maybe we should turn off
panic on unknown NMI logic if perf is running.  Maybe add warning to
users that if you use perf, you may lose some RAS feature.

> Broken hardware usually generated NMIs, sometimes they propogated to the
> cpu, other times, the were swallowed by the chipset.  Which means having
> HEST or not having HEST doesn't improve anything nor make it any worse.
>
> IOW I don't think we gain anything with this patch.

Without this patch, a real fatal hardware error may silently ruin your
disk data.  But with this patch, you can panic before that.  I think
this is what we gain with this patch.

>>
>> > Also, is there any known issues with x86_64 platforms with bad NMIs?  RHEL
>> > has had unknown NMI's panic on x86_64 since x86_64 first came out, I don't
>> > recall any exceptions we had to add to handle 'quirky' hardware.
>> >
>> > Then for the i686 case, because the 'quirky' hardware is so old, can't we
>> > just leave it a kernel config option to switch between using a 'printk'
>> > vs. a 'panic'?  Or even a kernel command line option.
>> >
>> > I figure these 'quirky' hardware machines are more the exception nowdays,
>> > do we really need to add code to whitelist machines?
>> >
>> > Granted I am not familiar enough with the quirky hardware (in fact I don't
>> > think I have seen any mainly because I haven't been around long enough).
>> > Most cases I see when trolling through the fedora bugzilla list for
>> > unknown NMIs, is just bad firmware or acpi power configurations.
>> >
>> > Just wondering if we could just simplify the patch somehow with better
>> > assumptions.
>>
>> So there is still unknown NMIs on real hardware now. I am afraid turn
>> on panic on unknown NMI by default may be not acceptable for someone.
>
> The opposite could be said too.  I think that was Ingo's point.  The
> policy should be left in the hands of the user or distro because there is
> no right answer.

IMHO, Linux is not X, so Linux kernel will not push all policy to user
space.  And for fatal hardware error processing, there may be no
opportunity for user space to run.

Best Regards,
Huang Ying
