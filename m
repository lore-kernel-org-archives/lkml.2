Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0I2G4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:56:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50758 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0I2Gz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vW+07lE3hy5MH/6djGStdJzKspWGmCKYQOtTfnr5DogP7O81wicvddlP/TsKa7gpxR
         +HRjNofm1KQvFEGGvI+EsHbnZDIpoRCrubWYJEIuNwY6GeEC6EYbCIJ8vsK3wrDV3AHj
         uK+KpookdZJ1YETaPLT6VQoOOcndv2kAoHJd8=
MIME-Version: 1.0
In-Reply-To: <20100928151924.GJ26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-7-git-send-email-ying.huang@intel.com>
	<20100927104426.GD32222@erda.amd.com>
	<AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
	<20100927134341.GQ13563@erda.amd.com>
	<20100927151607.GX26290@redhat.com>
	<1285633705.20791.84.camel@yhuang-dev>
	<20100928151924.GJ26290@redhat.com>
Date: Wed, 29 Sep 2010 14:55:58 +0800
Message-ID: <AANLkTinuNKfTBYTK1+Ks-QSPbQ3qz5cCZC6vUwUZ+zCh@mail.gmail.com>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

On Tue, Sep 28, 2010 at 11:19 PM, Don Zickus <dzickus@redhat.com> wrote:
>> If NMI comes from watchdog, nmi_watchdog_tick() will return 1. So
>> do_nmi_callback() is NOT for watchdog NMI, but for unknown NMI. Why do
>> we call DIE_NMIWATCHDOG for unknown NMI (NOT watchdog NMI)? die_nmi is
>> for watchdog, not unknown NMI.
>
> I think watchdog is an overloaded term.  I was under the impression that
> once the nmi watchdog determined a problem, it called the DIE_NMIWATCHDOG
> die chain to see if any other drivers wanted to clean up or do their thing
> first before panic'ing (namely drivers in drivers/char/watchdog).

Yes. I think so too. And in original code, almost all DIE_NMIxxx is
used in this way:

DIE_NMI is called after read port 0x61, to see if any other driver
wanted to recover the error notified based on reason read from port
0x61.

DIE_NMIWATCHDOG is used to see if any other drivers wanted to clean up
or do their thing before panic

DIE_NMIUNKNOWN is used to see if any other driver wanted to clean up
or debug before default unknown logic (such as panic).

DIE_NMI_IPI is used to see if any driver want to process the NMI (sent
via APIC? Maybe named after that).

So the original implementation of defualt_do_nmi() is:

- determine the reason/source of NMI in default_do_nmi(). Although the
exact reason/source is not determined, such as perf.

- notify_die() for corresponding NMI reason/source, to see if any
driver want to process this instead of the default operation

- If no other driver processed it, call default operation, such as
panic for DIE_NMIUNKNOWN.


The original implementation need to be changed, because it only uses
port 0x61 to determine the reason/source of NMI. We need a order based
scheme to determine the reason/source of NMI. The order is as follow:

CPU-specific (CPU local) NMI
non-CPU-specific (global) NMI
port 0x61
NMI Watchdog

I think we all agree that to use order to determine the reason/source
of NMI. The difference is that I want to keep as many direct calls in
default_do_nmi() as possible, while you guys want to wrap almost all
code in default_do_nmi() into notifier handler and leave only one
notify_die() in defualt_do_nmi(). And I want to use different die_val
(and their calling order in default_do_nmi()) to determine the order
while you guys want to use priority (based on its value) to determine
the order.

On the other hand, I think we should call corresponding DIE_NMIxxx
before the default operations, such as for watchdog, call
DIE_NMIWATCHDOG before go panic, for unknown nmi, call DIE_NMIUNKNOWN
before the default processing (may panic).

I think it is important to distinguish between die chain used to
determine the source/reason of NMI and the die chain used to see if
any other driver wanted to do some processing before the default
operation.

Best Regards,
Huang Ying
