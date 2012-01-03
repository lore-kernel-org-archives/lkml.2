Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2ACSdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:33:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44765 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490Ab2ACSdl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120103144538.GU2914@n2100.arm.linux.org.uk>
References: <1325472276.13595.200.camel@deadeye>
	<CAOesGMgXRev24e0bmGD71J04=Aon7bs0YeK7mwX8Na12uR_b6A@mail.gmail.com>
	<20120103144538.GU2914@n2100.arm.linux.org.uk>
Date: Tue, 3 Jan 2012 10:33:40 -0800
X-Google-Sender-Auth: 1EmENlFJKgg3nldWERSa5puzBz4
Message-ID: <CAPnjgZ0ugMyC26VmuiDn772fE5i6zd6FO57xkU4n_HrYQee+gw@mail.gmail.com>
Subject: Re: Circular dependency between <linux/kernel.h> and <asm/bug.h> on ARM
From: Simon Glass <sjg@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, Jan 3, 2012 at 6:45 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jan 01, 2012 at 11:01:27PM -0800, Olof Johansson wrote:
>> On Sun, Jan 1, 2012 at 6:44 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > Commit 87e040b6456fd3416a1f6831c1eedaef5c0a94ff ("ARM: 7017/1: Use
>> > generic BUG() handler") makes BUG() use BUILD_BUG_ON().  However,
>> > BUILD_BUG_ON() is not defined in <linux/bug.h> but in <linux/kernel.h>.
>> >
>> > arch/include/asm/bug.h does not include <linux/kernel.h> and *cannot* do
>> > so because the latter already includes <asm/bug.h>.
>>
>> Sure it can, but it's not ideal. Since the BUILD_BUG_ON is only used
>> in bug.h in a #define, it will be resolved below the includes of
>> either so there should be no ordering issue between the two.
>
> I disagree - we should not be creating circular dependencies.  This
> creates a mess, and uncertain results.  For instance, if we include
> linux/bug.h or asm/bug.h before linux/kernel.h has been included,
> then we end up with linux/kernel.h being parsed without a definition
> for BUG_ON().
>
> However, if linux/kernel.h is included first, we start parsing that,
> include asm/bug.h, asm/bug.h then includes linux/kernel.h which produces
> an empty file, and then we continue parsing asm/bug.h _without_
> BUILD_BUG_ON() defined.
>
> So, adding linux/kernel.h does _not_ solve the problem.  It solves the
> problem for _some_ cases only.
>
>> > Maybe BUILD_BUG_ON() should be moved out to a header of its own, or else
>> > this particular use should be moved to some other file.  This needs to
>> > be fixed somehow, as it obviously leads to build failures, e.g.:
>> >
>> > https://buildd.debian.org/status/fetch.php?pkg=linux-2.6&arch=armel&ver=3.2~rc7-1~experimental.1&stamp=1325142904
>>
>> Or perhaps moving BUILD_BUG_ON to include/linux/bug.h?
>
> and change linux/kernel.h to include linux/bug.h rather than asm/bug.h.
>
>> The quickest fix for now might be to take out the BUILD_BUG_ON(),
>> especially so close to 3.2-final.
>
> I think just remove the BUILD_BUG_ON.  Other architectures have done
> without it, so I see no reason we can't do as well.

OK I will send a patch to do this, it is safest. Any interest in (for
a later release) putting a check in the C file as I suggested?

Regards,
Simon
