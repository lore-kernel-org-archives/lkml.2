Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2BBBGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:06:12 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45413 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab2BBBGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:06:10 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Hitoshi Mitake" <h.mitake@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Thread-Topic: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Thread-Index: AQHM1xHls21BccflDEy/19ecM9NCB5YXBWeAgAB8iQCAABHVAIADFb2AgAAOjgCACNixgIAC0R4AgACVg4CAAALrAIAAAoEAgAABfYCAAk4YgIAAGTcA
Date: Thu, 2 Feb 2012 01:05:56 +0000
Message-ID: <1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
References: <20120121082857.GC32134@elte.hu>
	 <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
	 <20120121165830.GA9216@elte.hu>
	 <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
	 <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
	 <CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
	 <CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
	 <20120131115855.5861bad7@pyramind.ukuu.org.uk>
	 <20120131120922.GD32010@elte.hu>
	 <20120131121820.58a1db97@pyramind.ukuu.org.uk>
	 <20120131122339.GG32010@elte.hu>
	 <CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com>
In-Reply-To: <CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D582F8FDB749B4A94EA3B70838219A9@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1216GW3024765

On Wed, 2012-02-01 at 15:35 -0800, Linus Torvalds wrote:
> On Tue, Jan 31, 2012 at 4:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > non-atomic sounds good to me too.
> 
> You both apparently missed the related discussion that some devices
> really do care about order, even if they don't care about atomicity.
> 
> So we'd actually have two versions of the header file, one
> little-endian, and one big-endian. Then the driver that knows it
> doesn't need the atomic 'readq()' that is always defined, but wants a
> low-bytes-first version would just do
> 
>    #include <linux/io64-little-endian.h>
> 
> (or "big-endian" if it wants to read/write high bits first). Most
> drivers probably don't care, but apparently NVMe does.

And this was about the point I concluded last time that it simply wasn't
worth it with the number of different possibilities for the primitives
and trying to come up with a sensible naming scheme ... it's just easier
to open code because then you get exactly what you meant.

Incidentally, the last time this came up was with mpt fusion: for a
write to a 64 bit register, it didn't care about order, but it did care
about interleaving as in if you write one half of a 64 bit register and
then write to another register, the 64 bit register effectively gets
written with zeros in the part you didn't write to, so we had to put a
spin lock in the open coded writeb/w/l/q() to make sure the card didn't
get interleaved writes.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
