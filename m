Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab0LOAtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:49:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32824 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926Ab0LOAtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:49:07 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: dedekind1@gmail.com
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Date: Tue, 14 Dec 2010 18:49:02 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-19-generic; KDE/4.2.2; x86_64; ; )
Cc: Jason Lunz <lunz@acm.org>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com> <20101214195124.GA6010@falooley.org> <1292356893.29257.1.camel@koala>
In-Reply-To: <1292356893.29257.1.camel@koala>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012141849.03926.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 December 2010 14:01:33 Artem Bityutskiy wrote:
> > > Instead, you should solve this problem in UML code. I do not know how,
> > > but may be you can add readb/writeb there which actually do nothing or
> > > print a scary warning, or do BUG(), and let things which use them just
> > > fail run-time.
> >
> > Something like this could work, but it would be error-prone for anyone
> > else who attempts using iomem-requiring drivers on uml. Instead of
> > getting obvious compile failures we'd have broken drivers that BUG() or
> > emit scary warnings. That doesn't seem to me like an improvement.
>
> This problem does not seem to be mtd-specific, right? So my point was
> that it would be nicer to come up with a general solution.

The problem is that jffs2 is a filesystem, and thus something people would 
really like to be able to loopback mount, but it's hardwired to assume it's 
only ever stored on a certain type of hardware, and thus requies incestuous 
knowledge of the erase granularity of the flash layer in order to function.

It would be really nice to have either the loopback driver or jffs2 be able to 
fake the mtd thing with some kind of "granularity=262144" option to let it 
know "you're not on flash right now, but the flash you'll eventually be on is 
X".  This might require padding the image at the beginning and being mounted 
with an offset if the filesystem doesn't start at the beginning of an erase 
block when copied to the final hardware, but losetup already supports offsets.

What any of this has to do with UML is an open question.  I don't want to 
require UML to loopback mount a jffs2 image, I want to be able to do it from my 
host.  From my perspective, you're solving the wrong problem.

Rob
-- 
GPLv3: as worthy a successor as The Phantom Menace, as timely as Duke Nukem 
Forever, and as welcome as New Coke.
