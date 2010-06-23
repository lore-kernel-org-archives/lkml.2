Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0FWGUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:20:50 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:47557 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab0FWGUs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:20:48 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Viresh KUMAR <viresh.kumar@st.com>
Date: Wed, 23 Jun 2010 08:20:28 +0200
Subject: RE: [PATCH] DMAENGINE: runtime config for slave channels
Thread-Topic: [PATCH] DMAENGINE: runtime config for slave channels
Thread-Index: AcsSZigN2rryqeQiRXKoc0OGlTh15QANHBRA
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025E8B0A1E@EXDCVYMBSTM006.EQ1STM.local>
References: <1277072356-18048-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTikRRVPijSpkG8elztu_PS1p_0XM_fhiVrWOTqxZ@mail.gmail.com>
In-Reply-To: <AANLkTikRRVPijSpkG8elztu_PS1p_0XM_fhiVrWOTqxZ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan Williams]

> Is there a guarantee that all devices that implement this command will
> support all the fields?

No. They may be ignored on some controllers.

> The presence of private_config concerns me
> because that still seems to imply some hard coded knowledge about the
> specific dma engine from the client.

Yes that is the idea.

> ...which is fine, but only if this is a common way to express
> arch-specific extensions. In other words it's not clear where the
> line is drawn between "this is a common operation that different dma
> drivers can use / extend incompatibly" versus "this truly a generic
> api that a client driver can depend on to run unmodified across
> architectures that have a supporting dma driver".  Clarifying that
> would help end point device driver authors to know what they can rely
> on... to date all the slave implementations have been written by the
> same author who wrote the driver, so the information hiding has been
> blurred.  It would be nice to define / document what is and is not
> expected to work for this command across implementations.

OK the idea is to have the generic stuff in
struct dma_slave_channel_config, and the only criteria I have for
deciding what is generic is what COH901318, DMA40 and PL08x need
to runtime configure to handle things like UART RX/TX and SPI 
DMA with varying wordwidth which is currently my most complex
usecases.

There may be DMA controllers that cannot specify the word width
for example, but most can. Those that cannot do this will ignore
that field, and as a consequence cannot be used to feed drivers
that make use of it with DMA.

This is a hardware restriction though: if your DMA controller cannot
control the word width you cannot use the PL022 driver with DMA
for example.

The private_config is intended for stuff that can never be
expressed in a generic way. For example Viresh told me that they
may need to runtime-control which bus master the PL080 is using.
Then the driver needs to take platform-specific actions, and
there will be some struct pl08x_slave_config passed in this
opaque pointer so the PL08x can be set up properly.

Since you don't seem to be totally against this approach I
will attempt to submit a more elaborate patch set.

Yours,
Linus Walleij
