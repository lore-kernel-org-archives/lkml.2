Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2GKKUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:20:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51528 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096Ab2GKKUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:20:34 -0400
Message-ID: <4FFD536B.8010603@mev.co.uk>
Date: Wed, 11 Jul 2012 11:20:27 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/83] staging: comedi: rtd520: initial cleanup
References: <201207101636.23561.hartleys@visionengravers.com>
In-Reply-To: <201207101636.23561.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-11 00:36, H Hartley Sweeten wrote:
> The 'devpriv' macro usage in this driver is holding up other cleanup
> of the comedi drivers.
>
> This patch series removes all the macros used to read/write the
> hardware registers. All of them are simple wrappers around standard
> {read,write}[rwl] calls with some of them caching the write value
> in a shadow variable in the private data.
>
> Each of the macros is removed in a separate patch to ease reviewing.
> They can all be squashed into one patch if desired.
>
> After all the macros are gone, the devpriv macro itself can be removed
> along with the boardinfo macro.
>
> The "find pci device" code is also refactored to follow the style of
> the other comedi pci drivers.
>
> The range tables are also cleaned up for aesthetic reasons. The large
> whitespace causes some pretty nasty line breaks in order to keep the
> lines < 80 characters.

My main concern with this series of patches is they make it harder to 
determine what the register accesses actually do, mainly due to the 
removal of useful comments.  For example:

-	RtdPacerStart(dev);	/* Start PACER */
+	readl(devpriv->las0 + LAS0_PACER);

And:

-	RtdPacerStop(dev);	/* Stop PACER */
+	writel(0, devpriv->las0 + LAS0_PACER);

The comments in the original code were quite superfluous, but they would 
be useful for the replacement code.  In the above cases you could figure 
it out after looking at the rtd520.h header file where its reasonably 
clear that reading the LAS0_PACER register starts the pacer and writing 
the register (presumably with any value) stops the pacer.  But it's less 
clear in cases such as:

-		RtdAdcConversionSource(dev, 2);	/* BURST triggers ADC */
+		writel(2, devpriv->las0 + LAS0_ADC_CONVERSION);

Since the values for the LAS0_ADC_CONVERSION register are no longer 
documented anywhere.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


