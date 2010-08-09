Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0HIL3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 07:29:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab0HIL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 07:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lo+M1KIt3DtoWQrquEwXi/pam9ZhAhwAgOHE3yEloIyevFE/6wLoOKzFcn9ZASLX4h
         agdqB9fQjaF3l5XE3QEShuHjez0xeVMzauS5oENrPHMcztMNMs1E/YOlbKhV1CZMbgfd
         J3DODHKtggOiGhPQiebMGXH6d6u0m8Cy7NfKE=
Subject: Re: [PATCH] Add quick erase format option
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stefani Seibold <stefani@seibold.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
In-Reply-To: <1281343974.18398.13.camel@wall-e.seibold.net>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 14:29:04 +0300
Message-ID: <1281353344.2332.8.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 10:52 +0200, Stefani Seibold wrote:
> Am Montag, den 09.08.2010, 09:37 +0100 schrieb David Woodhouse:
> > On Mon, 2010-08-09 at 09:25 +0100, stefani@seibold.net wrote:
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > This patch add a quick format option which skips erasing of already erased
> > > flash blocks. This is useful for first time production environments where
> > > the flash arrived erased.
> > > 
> > > Signed-off-by: Stefani Seibold <stefani@seibold.net> 
> > 
> > This scares me, given the lengths we had to go to in JFFS2 to cope with
> > blocks which *look* like they're erased, but which actually start losing
> > data as soon as you start writing to them because the erase didn't
> > complete.
> > 
> 
> I know the drawback. This is why it is only an option which must be
> enabled. And in most use cases there is a subsequent ubimkvol, which
> will fail if the flash is not correct initialized.
> 
> Flash are normally delivered erased. So this save in our production
> environment (Nokia Siemens Networks) about 5 minutes per device (256 MB
> NOR CFI Flash).
> 
> The old JFFS2 was very fast to install the first time on a flash, it was
> only a simple mount of the MTD partition. 

Not sure what you do, but both UBI and UBIFS auto-format flash if it is
empty, and attaching empty flash should be very fast.

But yes, the first volume creation ioctl will block until everything is
erased, although this is just an implementation issue and in theory,
fixable.

> Which the quick format option i have now only a slightly first time
> installation overhead compared to JFFS2. Without this option the
> overhead is more than 5 minutes.

Are you flashing an UBI image in production? Then what you can do if you
want to be faster is to flash only the blocks which contain image date,
and leave the rest intact, UBI will erase them and write EC header to
them when you first boot the device.

So I think it is better to add an --pristine-flash option, or something
like this. In this case ubiformat won't erase anything, and will assume
everything is 0xFFed without reading. This should be faster and I think
is better to do.


