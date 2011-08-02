Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HBWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:53:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59385 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1HBWxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:53:23 -0400
Date: Tue, 2 Aug 2011 23:53:16 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Subject: Re: MTD-related kobject badness during linux-next boot
Message-ID: <20110802225316.GF5063@pulham.picochip.com>
References: <CAGq3pz4LHRkCqaJfqoMYe-=mn+s5CVZipab7bd8F3z+ou3xxVA@mail.gmail.com>
 <CAN8TOE9mWEmS5YJqNrS9OrG=t+emeLcXNpKR1BiZ6VDJW7_c=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8TOE9mWEmS5YJqNrS9OrG=t+emeLcXNpKR1BiZ6VDJW7_c=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Tue, Aug 02, 2011 at 10:40:29AM -0700, Brian Norris wrote:
> Since Dmitry's change, it looks like cafe_nand will add the master
> device, then parse and register its partitions, if found. However, if
> partitions are NOT found, then mtd_device_parse_register() falls back
> to adding the master device, which was already added. In
> drivers/mtd/mtdcore.c, see:
> 
>      int mtd_device_parse_register(struct mtd_info *mtd, const char **types,
>      ...
>      if (err > 0) {
>      ...
>      } else if (err == 0) {
>              err = add_mtd_device(mtd);
>      ...
> 
> 
> So it looks like perhaps we can solve the problem by just killing the
> "register the whole device first" and allow mtd_device_parse_register
> to do it if there are no partitions. Any cafe_nand developers know if
> this is a problem? i.e., is there a reason we need both the whole
> device AND the partitions sent to add_mtd_device()? I'll send a full
> patch with sign-off and description if there are no objections.

I think that's the right thing to do.  There's actually a comment in 
drivers/mtd/mtdpart.c saying:

	/* NOTE:  we don't arrange MTDs as a tree; it'd be error-prone
         * to have the same data be in two different partitions.
         */

So I do think it should be the whole device *or* the partitions.  In any 
case, your patch looks good to me.

Jamie
