Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1BSHZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 02:25:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1BSHZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 02:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=T8pwQ8b7Xva3Z347Rxd3rDwpxTxfWQuwHMsHfIysdaNawaB/4Enr5dyDjucWsBQsB1
         nk6PO4aQ5zaEHDwCIL4NYVTUjzkQfR8dhbdvc6P71Ht0BAYxcTYj/dGP2+CpKg+oKUWi
         6D5bvUIrV4DFYEJekg32i5ZQjebAcdE6zT6U8=
MIME-Version: 1.0
In-Reply-To: <20110218202744.GA19427@n2100.arm.linux.org.uk>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <201102181928.05911.rjw@sisk.pl> <AANLkTi=j9KeX2TSzMaKMWR6GpXjFcsjp0z8Rt+ArLXiV@mail.gmail.com>
 <201102182120.29977.rjw@sisk.pl> <20110218202744.GA19427@n2100.arm.linux.org.uk>
From: Rabin Vincent <rabin@rab.in>
Date: Sat, 19 Feb 2011 12:54:52 +0530
X-Google-Sender-Auth: AkyY7dgy0q5zrozlB5a__4AyHwQ
Message-ID: <AANLkTinb0zVSUyNBAySH7K7=3bX-ecoQa--CzPJ+OM_b@mail.gmail.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, khilman@ti.com, magnus.damm@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
        linux-i2c@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 01:57, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> Do we have any pressing need to convert AMBA stuff?  I haven't heard any
> reason yet to convert them to runtime PM - they don't even make any
> runtime PM calls.
>
> Maybe Linus can comment on the PM stuff as he has SoCs with these in.
> As my boards don't have any sensible PM support, I don't have any
> visibility of what PM facilities would be required.

The rationale for runtime power control is the same as that for
65500fa94aaeb3 "ARM: 6467/1: amba: optional PrimeCell core voltage
switch".

As compared to the regulator API which that patch is using, the runtime
pm usage is more flexible (for example allowing certain power control
APIs to be called from atomic context), provides callbacks for
asynchronous turnoff with callbacks back to the driver to save/restore
state (runtime_suspend()/runtime_resume()), and provides core support
for things like "autosuspend" which allows delaying suspend until some
time after last inactivity.  Using runtime PM also allows use of the new
device-level power domain support ("PM: Add support for device power
domains", in -next) to easily implement SoC-specific handling.

We need to first add bus support for this to allow drivers to use this
API.  It is possible to make the AMBA patch smaller and touch only the
AMBA bus code by implementing support for the legacy bus-specific
suspend/resume calls, and drivers can be later converted to pm-ops as
needed.
