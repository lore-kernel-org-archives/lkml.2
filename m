Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2BOQVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:21:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2BOQVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:21:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+rthh-JU-CE2t=BvpuZyZt5_1sm4urWrmZN8MmA4iC5JorDmQ@mail.gmail.com>
References: <CA+rthh-JU-CE2t=BvpuZyZt5_1sm4urWrmZN8MmA4iC5JorDmQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Feb 2012 08:20:42 -0800
X-Google-Sender-Auth: zZkI4EekBMmwVXCGrwa1Las80Iw
Message-ID: <CA+55aFxWKns=BFo=bw-DDRLwTYjznGbAT+PA5aB-mGTSDieWxQ@mail.gmail.com>
Subject: Re: AES-NI data corruption issues
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 12:51 AM, Mathias Krause <minipli@googlemail.com> wrote:
>
>    So this explicitly verifies that we will not touch the TS_USEDFPU bit,
>    and adds a few related sanity-checks.  Because it seems that somehow
>    AES-NI is corrupting user FP state.  The cause is not clear, and this
>    patch doesn't fix it, but while debugging it I really wanted the code to
>    be more obviously correct and robust.
>
> Can you please elaborate a little more on the AES-NI issues you're
> seeing as I cannot find any information about them on
> LKML/bugzilla/linux-crypto? Are they limited to the 3.3-rc kernels or
> are they happening on released kernels as well? Are they happening on
> 32 bit, 64 bit or both?

So far we have reports from just one person, and it's seems limited to
32-bit and using the AES instructions from interrupts - by the WiFi
layer.

We have not figured out what's wrong yet, but it doesn't look like
it's AES-NI itself: it seems to be some FP state mixup (right now it
looks like the TS_USEDFPU bit we use to track it gets confused). It is
probably just triggered by the very unusual case of the mac80211 code
wanting to use FP state from interrupts.

There's a few other reports that *may* be the same thing, but they
also seem to be about wireless, and using WPA with AES. In fact, we
have no real reason to even consider them related to AES-NI at all,
other than that commonality.

Anyway, AES-NI itself seems to be fine, everything we have so far
points to the FPU/MMX state handling being very subtly broken.

                    Linus
