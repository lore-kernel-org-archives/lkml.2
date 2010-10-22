Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0JVLQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:16:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35228 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0JVLQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:16:28 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593023458C2BA@dbde02.ent.ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com> <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com> <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com> <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <B85A65D85D7EB246BE421B3FB0FBB5930233F94602@dbde02.ent.ti.com>
 <AANLkTi=dfw==t+u1Ap26iwPHH9A2M-cEU0hs92Gxdkxc@mail.gmail.com> <B85A65D85D7EB246BE421B3FB0FBB593023458C2BA@dbde02.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 22 Oct 2010 13:16:06 +0200
Message-ID: <AANLkTi=G_OM806-10Z_objj30Tats_RM4oiP=xKWUOnR@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
To: "Kamoolkar, Mugdha" <mugdha@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "Kamat, Nishant" <nskamat@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>, "Anna, Suman" <s-anna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 11:59 AM, Kamoolkar, Mugdha <mugdha@ti.com> wrote:
>> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
>> I agree.
>>
>> But we seem to have this sort of problem anyway:
>>
...
> That is true. Perhaps we should consider adding a software
> implementation over HW spinlocks.

Yes, this is probably inevitable.

It would also be useful for the user space implementation of TI's
RingIO and FrameQueue protocols coming in Syslink 3.0, which will also
not be able to directly use the hwspinlock because of the same
reasons.

This layer would maintain the owner of each (virtual) lock in a
non-cacheable shared memory entry, together with the id of the
hwspinlock that would protect that 'owner' entry.

This way we no longer need to use predefined hwspinlocks (the id of
the hwspinlock is announced in the shared memory entry). So we can
ditch the _request_specific() API, and we can move to arch_initcall
(just to beat the current race with i2c-omap).

> We were anyway considering doing this,
> because the number of hw spinlocks available for our usage are not
> sufficient when we look at multi-channel use-cases.

Sure, this layer can provide any number of locks over a single
hwspinlock (with the obvious price of hwspinlock contention).
