Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0H2Lan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 07:30:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63580 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0H2Lal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 07:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HKYmLEx3qGFQNx3NtOOGLKRhW+KjSXbXIL42vTQrbMO4T1OfuWYDO/yIyIquDm1xeP
         lcfyxi5YvKzvjJdzJYfZamSfpmI1hBJWa9oD04Lb7FNy9I8oX7LPOIfNXJTNaQcSqT/o
         Zv3/ijYef4VNAMnohziqc+RrVuBuILAjViAdI=
Subject: Re: [PATCH] Add quick erase format option
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stefani Seibold <stefani@seibold.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Enzinger, Robert (EXT-Other - DE/Munich)" 
	<robert.enzinger.ext@nsn.com>
In-Reply-To: <1281362069.20181.16.camel@wall-e.seibold.net>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
	 <1281362069.20181.16.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Aug 2010 14:30:35 +0300
Message-ID: <1283081435.2131.24.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 15:54 +0200, Stefani Seibold wrote:
> > Not sure what you do, but both UBI and UBIFS auto-format flash if it is
> > empty, and attaching empty flash should be very fast.
> > 
> 
> I was never able to mount a UBIFS without a previous ubimkvol, despite
> the flash is already erased.
> 
> Here are my timing results mounting an already erased flash as UBIFS:
> 
> ubiattach /dev/ubi_ctrl -m 5 -d 1              -->   2.023s

UBI scans the flash and schedules all PEBs for erasure. They will be
erased by the back ground thread.

So after this command returns, UBI is still erasing your flash.

> ubimkvol /dev/ubi1 -m -N flash                 --> 294.574s

this calls the mkvol ioctl, which will first flush the erase queue, and
only after it is flushed (all PEBs scheduled for erasure are erased), it
will create the volume.

The reason why this flushing is needed is that we want to make sure that
there are no PEBs which belonged to a volume with the same ID. Indeed,
imaging you have volume 5 with many used LEBs. Then you remove this
volume, so that all its LEBs are scheduled for erasure. Then you create
a new volume with the same ID = 5. If we do not flush the queue, we may
end up with rubbish from the older volume 5 in the new one.

However, we can optimize UBI and make ubimkvol to not flush empty PEBs,
because they anyway do not contain any data. In this case your ubimkvol
will be very fast. This should not be too difficult to do.

> mount -t ubifs -o sync ubi1:flash /mnt         -->   0.221s
> 
> And this are the timing results when i do an ubiformat first:
> 
> ubiformat /dev/mtd5                            --> 299.111s

Right, ubiformat will erase all PEBs, and this is slow.

> ubiattach /dev/ubi_ctrl -m 5 -d 1              -->   0.129s
> ubimkvol /dev/ubi1 -m -N flash                 -->   1.784s
> mount -t ubifs -o sync ubi1:flash /mnt         -->   0.220s
> 
> And this are the results with my patched version of the ubiformat tool
> using an already erased flash:
> 
> ubiformat /dev/mtd5 -E                         -->   5.475s
> ubiattach /dev/ubi_ctrl -m 5 -d                -->   0.130s
> ubimkvol /dev/ubi1 -m -N flash                 -->   1.699s
> mount -t ubifs -o sync ubi1:flash /mnt         -->   0.220s

Right, with your patch you do not erase.

> As you can see this is 296.818s vs. 7.524 or 40 times faster.
> 
> Maybe i do something wrong, but i have no idea. Can u explain it to me?

No, it is ok. The only thing I do not really like is the name of the
option and the fact that you still read the beginning of PEBs and check
for 0xFFs. And if you hit a PEB with non-0xFF, you erase it, for other
PEBs you skip the erasure - this is error prone, because if you have one
PEB with non-FF data, then you may have PEBs with 0xFFs at the beginning
and garbage at the end, and you will not catch these.

I would like to change the option name so that it would reflect the
exact use-case we are creating it for: wiped out flash. So I'd be
happier with something like --pristine-flash.

Also, I think you should not read the beginning of the flash and check
for 0xFFs. If the user gave us this option, he knows what he is doing
and we can trust him, so no need to read and check, assume all PEBs are
pristine (contain 0xFFs).

> No, we only initialize the flash, mount it as UBIFS and copy files.

OK. But did you consider to pre-create the image with ubinize and
mkfs.ubifs tools and just flash the raw image in production? This is the
fastest possible way.

> > So I think it is better to add an --pristine-flash option, or something
> > like this. In this case ubiformat won't erase anything, and will assume
> > everything is 0xFFed without reading. This should be faster and I think
> > is better to do.
> > 
> 
> This patch assumes nothing, it will skip the erase of the PEB if all
> bytes in the EC header are 0xff. I think this is safer than your
> suggestion.

It does assume that if the beginning of the flash contains 0xFFs then it
is safe to treat it as erased. Instead, I think you should just trust
the user and not even check the beginning of the flash. And this will be
also faster.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

