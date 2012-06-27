Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2F0OB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:01:57 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23994 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2F0OB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:01:56 -0400
Date: Wed, 27 Jun 2012 16:01:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 0/3 v2] i2c: i801: enable irq
Message-ID: <20120627160121.3c3c3a88@endymion.delvare>
In-Reply-To: <CAGS+omDYaPBQiKBiVewbwZR2Vnjv+NfqbZxc+fknpCBNvRFRKw@mail.gmail.com>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<20120627112402.26576746@endymion.delvare>
	<CAGS+omDYaPBQiKBiVewbwZR2Vnjv+NfqbZxc+fknpCBNvRFRKw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:56:34 +0800, Daniel Kurtz wrote:
> On Wed, Jun 27, 2012 at 5:24 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > I planned on testing this on my ICH3-M system, but it turns out your
> > interrupt-based implementation only works for ICH5 and later chips. As
> > ICH5 and later chips all implement the block buffer, there's no reason
> > for the byte-by-byte-code to ever be used for SMBus block transactions.
> > However, the block buffer feature can be disabled for testing purpose
> > by passing module parameter disable_features=0x0002.
> >
> > I just did, and actually it doesn't work. i2cdump shows 32 bytes no
> > matter what the device said. Debug log shows that the driver reads
> > fewer bytes from the device though, as it is supposed to. So I think
> > the problem is simply that the interrupt path is missing this compared
> > to the polled path:
> >
> >                if (i == 1 && read_write == I2C_SMBUS_READ
> >                 && command != I2C_SMBUS_I2C_BLOCK_DATA) {
> >                        len = inb_p(SMBHSTDAT0(priv));
> >                        (...)
> >                        data->block[0] = len;
> >                }
> >
> > I.e. we don't let the caller know how many bytes we actually read from
> > the device. I fixed it with:
> >
> 
> I was just in the middle of finalizing a new patchset when I saw your
> last email.
> I incorporated (and tested for no-regressions) the snippet below.
> Unfortunately, I'm not set up to test this type of transaction, so
> hopefully you can double check my version of this patch with your
> setup.

Sure, no problem, I will do another full round of testing on the new
patchset.

-- 
Jean Delvare
