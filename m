Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2CGMlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:41:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38668 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2CGMlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:41:24 -0500
MIME-Version: 1.0
In-Reply-To: <aefc95$3e4bn0@orsmga001.jf.intel.com>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
 <1331121050-17857-7-git-send-email-djkurtz@chromium.org> <aefc95$3e4bn0@orsmga001.jf.intel.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 7 Mar 2012 20:41:03 +0800
X-Google-Sender-Auth: JH5JDOPmNts_5q2htjtM7h8uVgo
Message-ID: <CAGS+omByuSWzV1Pa_ODugq9rrZ2DtgU_LPWDAfbrR_q_zuDvYQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] drm/i915/intel_i2c: return -ENXIO for device NAK
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 8:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed,  7 Mar 2012 19:50:47 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> Return -ENXIO if a device NAKs a transaction.
>>
>> Note: We should return -ETIMEDOUT, too if the transaction times out,
>> however, that error path is currently handled by the 'bit-bang fallback'.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>
> Can you clarify what the rule is if an error is detected part-way
> through a xfer?

A priceless comment from drivers/i2c/i2c-core::i2c_transfer...

/* REVISIT the fault reporting model here is weak:
 *
 *  - When we get an error after receiving N bytes from a slave,
 *    there is no way to report "N".
 *
 *  - When we get a NAK after transmitting N bytes to a slave,
 *    there is no way to report "N" ... or to let the master
 *    continue executing the rest of this combined message, if
 *    that's the appropriate response.
 *
 *  - When for example "num" is two and we successfully complete
 *    the first message but get an error part way through the
 *    second, it's unclear whether that should be reported as
 *    one (discarding status on the second message) or errno
 *    (discarding status on the first one).
 */

As for which error code to use, all I have found is this:

Documentation/i2c/fault-codes:
ENXIO
	Returned by I2C adapters to indicate that the address phase
	of a transfer didn't get an ACK.  While it might just mean
	an I2C device was temporarily not responding, usually it
	means there's nothing listening at that address.

This doesn't specify what to do if the transfer doesn't get an ACK
during another phase of the transfer.
However, it does say to send -ENXIO "if no ACK during address phase",
which is a subset of the possible no-ACK conditions during a transfer.
 Thus, I choose to return ENXIO in all no-ACK cases, to ensure we send
it during the one case that is specified.

For different i2c adapters i've seen wildly different behavior:
   -ENXIO (i2c-algo-pca)
   -EIO (i2c-algo-bit)
   -EREMOTEIO (i2c-algo-pcf).

-Dan
