Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0IAArb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:47:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64198 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0IAAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mcfSrhIylMlmowjy6jV38/Z964H51dNS3PjtH1dqUpCDvb0fjibI1A4GjE7EY0DvN8
         UBZrsKuhtDC2GvmKOXiZMQn7ybKVLYkxTJHCmaDa0yFM1hI+Y+J+DEaKdvTmXnemj97c
         chHIlkZOEuMqADxtNEnN9wXoXSpZgyc1MBO5I=
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
In-Reply-To: <1283236978.6083.28.camel@wall-e.seibold.net>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
	 <1281362069.20181.16.camel@wall-e.seibold.net>
	 <1283081435.2131.24.camel@brekeke>
	 <1283236978.6083.28.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 03:47:23 +0300
Message-ID: <1283302043.2018.92.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani,

you have strong points, but I'm still not entirely convinced.

On Tue, 2010-08-31 at 08:42 +0200, Stefani Seibold wrote:
> > I would like to change the option name so that it would reflect the
> > exact use-case we are creating it for: wiped out flash. So I'd be
> > happier with something like --pristine-flash.
> 
> "Pristine" is not a word which non native speaker have in its
> vocabulary.

Agree, not very simple word, when I met it in JFFS2 sources, I looked it
up in the dictionary :-)

>  Quick-format is the best, because it is exactly what it is
> doing.

No, it is misleading. If I was a dumb user, I'd be thinking: oh, why I
should do slow format if I can do quick? It is probably like my FAT32
partition formatting in Windows, I always shoos quick format.

This is why I do not like your naming - it encourages to use it, while
my name discourages.

Also, your use-case is new/virgin/pristine/whatever NOR chips, which are
guaranteed to be erased, and I wanted to use option name which reflects
your use-case.

How about:

--virgin
--factory
--brand-new
--all-erased

Or --do-not-use-me :-)

> > OK. But did you consider to pre-create the image with ubinize and
> > mkfs.ubifs tools and just flash the raw image in production? This is the
> > fastest possible way.
> > 
> 
> This did not work in our NSN transport environment. It would take to
> much time to explain why, because the PCU software managment server is a
> 10 year old application which handles a wide range of transport boards
> in the same way, including the old JFFS2 systems and the new UBIFS based
> boards.

OK :-)

> > It does assume that if the beginning of the flash contains 0xFFs then it
> > is safe to treat it as erased. Instead, I think you should just trust
> > the user and not even check the beginning of the flash. And this will be
> > also faster.
> > 
> 
> Never trust the user. And why should we remove this check? The coast is
> very minimal and it will make live much easier.

Well, this is a good principle, no doubts. But on NAND, it will hurt
performance, because we'll end up with reading whole page. And since
NAND erase is ultra-fast, comparing to NOR, reading whole page will
introduce a noticeable overhead.

IOW, as the maintainer, I have to care about code in general, not only
specific use-cases.

How about checking only the first and last eraseblocks? It would give
_some_ sanity check at least, with less overhead?

Or, do the check only if this is NOR, but I'm less happy about this
approach.

> For example: In our production environment everything is automated by
> scripts, so the software bring up did not know if the flash is already
> erased or not. It is possible that an broken used board is returned into
> the production after it was repaired.

Well, you can check the flash before running ubiformat.

> What you assume is that the user or the scripts does know the status of
> the flash, but this is not true in real production environment, where
> thousands of boards are prepared.

Again, I do not mind to add checks if they are cheap in general, but
this one is not cheap for NAND.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

