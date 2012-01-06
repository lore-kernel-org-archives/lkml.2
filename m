Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2AFEMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 23:12:24 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47307 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758616Ab2AFEMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 23:12:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAP=VYLpP393c0MYxPPR2j6jkLyyUQWjQBWg3RfbpJyuWxi+psA@mail.gmail.com>
References: <1325472276.13595.200.camel@deadeye>
	<CAOesGMgXRev24e0bmGD71J04=Aon7bs0YeK7mwX8Na12uR_b6A@mail.gmail.com>
	<20120103144538.GU2914@n2100.arm.linux.org.uk>
	<CAP=VYLpP393c0MYxPPR2j6jkLyyUQWjQBWg3RfbpJyuWxi+psA@mail.gmail.com>
Date: Thu, 5 Jan 2012 20:12:22 -0800
X-Google-Sender-Auth: NVaB__YiGLW1FvomHQpUXIBDpg4
Message-ID: <CAPnjgZ0Q1Y0Um0fm8fHxd1tN_rFe+5Y0DPOvUYFZnodG2Q-cUA@mail.gmail.com>
Subject: Re: Circular dependency between <linux/kernel.h> and <asm/bug.h> on ARM
From: Simon Glass <sjg@chromium.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 7:43 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Tue, Jan 3, 2012 at 9:45 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Sun, Jan 01, 2012 at 11:01:27PM -0800, Olof Johansson wrote:
>>> On Sun, Jan 1, 2012 at 6:44 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>> > Commit 87e040b6456fd3416a1f6831c1eedaef5c0a94ff ("ARM: 7017/1: Use
>>> > generic BUG() handler") makes BUG() use BUILD_BUG_ON().  However,
>>> > BUILD_BUG_ON() is not defined in <linux/bug.h> but in <linux/kernel.h>.
>>> >
>>> > arch/include/asm/bug.h does not include <linux/kernel.h> and *cannot* do
>>> > so because the latter already includes <asm/bug.h>.
>>>
>>> Sure it can, but it's not ideal. Since the BUILD_BUG_ON is only used
>>> in bug.h in a #define, it will be resolved below the includes of
>>> either so there should be no ordering issue between the two.
>>
>> I disagree - we should not be creating circular dependencies.  This
>> creates a mess, and uncertain results.  For instance, if we include
>> linux/bug.h or asm/bug.h before linux/kernel.h has been included,
>> then we end up with linux/kernel.h being parsed without a definition
>> for BUG_ON().
>>
>> However, if linux/kernel.h is included first, we start parsing that,
>> include asm/bug.h, asm/bug.h then includes linux/kernel.h which produces
>> an empty file, and then we continue parsing asm/bug.h _without_
>> BUILD_BUG_ON() defined.
>>
>> So, adding linux/kernel.h does _not_ solve the problem.  It solves the
>> problem for _some_ cases only.
>>
>>> > Maybe BUILD_BUG_ON() should be moved out to a header of its own, or else
>>> > this particular use should be moved to some other file.  This needs to
>>> > be fixed somehow, as it obviously leads to build failures, e.g.:
>>> >
>>> > https://buildd.debian.org/status/fetch.php?pkg=linux-2.6&arch=armel&ver=3.2~rc7-1~experimental.1&stamp=1325142904
>>>
>>> Or perhaps moving BUILD_BUG_ON to include/linux/bug.h?
>>
>> and change linux/kernel.h to include linux/bug.h rather than asm/bug.h.
>
> Actually, kernel.h doesn't need to include any variant of bug.h at all.
>
> I started on cleaning this up a few weeks back, but didn't have the time
> to get it ready for 3.3 -- so my intent is to do so for linux-next that will
> be the 3.4 release.  The Work In Progress can be seen here:
>
> http://git.kernel.org/?p=linux/kernel/git/paulg/linux.git;a=shortlog;h=refs/heads/bug.h-cleanup-WIP
>
> I only mention it here since I'd hate to see anyone waste time on
> duplicating work that is already done.

Thanks Paul, I hope it goes well.

Regards,
Simon

>
> Thanks,
> Paul.
>
> ---
>
>>
>>> The quickest fix for now might be to take out the BUILD_BUG_ON(),
>>> especially so close to 3.2-final.
>>
>> I think just remove the BUILD_BUG_ON.  Other architectures have done
>> without it, so I see no reason we can't do as well.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
