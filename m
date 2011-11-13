Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1KMNfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:35:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46839 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1KMNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:35:54 -0500
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Mike Dunn <mikedunn@newsguy.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 13 Nov 2011 15:35:49 +0200
In-Reply-To: <1321189398.2021.5.camel@shinybook.infradead.org>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	 <1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
	 <4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr>
	 <1321188825.2273.4.camel@koala>
	 <1321189398.2021.5.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321191352.2273.14.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 13:03 +0000, David Woodhouse wrote:
> On Sun, 2011-11-13 at 14:53 +0200, Artem Bityutskiy wrote:
> > On Sun, 2011-11-13 at 11:18 +0100, Robert Jarzmik wrote:
> > > I personally think this should be provided by the MTD API. A function
> > > is_page_blank(ofs) could tell if the page was written or not. Now if the
> > > function is NULL, the upper layer (UBIFS, ...) could decide _by itself_ to
> > > assign a free OOB byte to that meaning. But IMHO it's not the drivers duty to
> > > take these decisions to restrict the OOB, let it be done at an upper level.
> > 
> > Probably it is a good idea to introduce an mtd_is_page_blank. But it
> > should either work for all flashes or not introduced at all. I do not
> > think upper layers should use OOB at all. And this interface should also
> > work for NOR flash. Probably it should just fall-back to comparing the
> > data with 0xFF if the driver cannot offer anything special. 
> 
> We *tried* comparing with 0xFF in JFFS2 and found that it wasn't good
> enough (it could be *mostly* erased before a powerfail but not
> completely, so as soon as you start to program it you get a lot of
> bitflips). Hence the cleanmarkers.
> 
> The only way you can treat a page as erased is if you *know* it was
> successfully erased. So I'd be reluctant to introduce a function that
> encourages people to draw inferences they shouldn't.

That's a bit different. Nowadays no one tries to compare to 0xFFs to
check if an eraseblock is erased or not :-)

This is about the situation when you have an eraseblock with data, and
you want to find where it ends, e.g., you want to find the first blank
NAND page. Both JFFS2 and UBIFS search for 0xFFs. It worked for many
years, but modern NANDs have bit-flips even in empty space, so reading a
never written NAND page may return mostly 0xFFs, but with few bits set
to 0. Modern NANDs have strong ECC which can handle 4 bit errors and
above. According to Ivan, manufacturers say it is expected and OK.

No make SW like JFFS2 and UBIFS work, modern drivers need to
either correct bit-flips on blank pages automatically, or be able to
quickly distinguish between blank and non-blank pages and memset the
buffer with 0xFFs for the former case.

What Robert says is that we probably need an is_page_blank() and let the
driver implement it optimally, or make MTD fall-back to 0xFFs
comparison.

This is my understanding.

Artem.

