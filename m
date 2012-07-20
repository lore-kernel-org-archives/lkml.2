Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab2GTEaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 00:30:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2GTEac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 00:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120718161023.GE4495@opensource.wolfsonmicro.com>
References: <20120717185749.GJ4477@opensource.wolfsonmicro.com> <20120718161023.GE4495@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 19 Jul 2012 22:30:11 -0600
X-Google-Sender-Auth: lNX2wPf7ZLC0VJLuexympeSAMA8
Message-ID: <CACxGe6utvV6XbJEck_UuVJxsqckPFZXG3psEgeQ1vZSBGAwm9Q@mail.gmail.com>
Subject: Re: Boot breaks in -next from LEGACY to LINEAR conversion
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 10:10 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jul 17, 2012 at 07:57:49PM +0100, Mark Brown wrote:
>> -next fails to boot for me today on my s3c64xx based systems.  Walking
>> back to the last time I tried and bisecting likely branches I find that
>> commit 910139 (irqdomain: Replace LEGACY mapping with LINEAR) is the one
>> that introduces the build break.  Unfortunately the boot fails before I
>> get a console which makes diagnosis somewhat more tricky than would be
>> ideal.  Any ideas?
>
> Further data: the irq_domain_associate_many() calls that we're now doing
> are also causing WARN_ON()s to go off during boot after commit 98aa46
> (irqdomain: Support for static IRQ mapping and association) causing
> breakage for my interrupt using MFDs.

Okay, I've got a theory about what the issue is now. The .map()
callback is failing (returning non-zero) for one of the hwirqs. The
new code is stricter about associations, and actually unwinds the
associations if one of them fails. The old legacy code simply called
all the .map() hooks blindly without any error checking. Can you send
me the kernel log after backing out those changes.

The other possibility is that irqs aren't being reserved correctly.
Seeing the backtrace will tell me which issue it is.

In the mean time I've backed out the top three commits from irqdomain/next.

g.
