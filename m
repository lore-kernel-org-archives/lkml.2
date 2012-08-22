Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2HVIin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:38:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2HVIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:38:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Date: Wed, 22 Aug 2012 08:38:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Alexander Thomas <alexander.thomas@esaturnus.com>,
        Carlos Alberto Lopez Perez <clopez@igalia.com>,
        Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
References: <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com> <CAKr4yMxkrMXpVXmX9zgieTKrWmKtRx+Y2toZ2msrUdrBKFq13w@mail.gmail.com> <20120820132141.GC5197@thunk.org>
In-Reply-To: <20120820132141.GC5197@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220838.25876.arnd@arndb.de>
X-Provags-ID: V02:K0:w+LHTEuWIHoXauyfKg3NcehanKtYOGadvdT0c8x0Hrj
 uX/+nEB+QlNuYJU1CghwsJ/KVTBhEmTMbwMyfbYo81y0Rv9zL4
 4sOqUQdtpobqHPGEnkp1pHNxdHzeRHKO946JIOnFycTXzD7Utr
 Fl77fDvHXp6lBQ4dRhX9dqVQXENdWHV2mB/t6umCoKsAfbBB5c
 uB+t1BZ3Gie3X07NtpcLXTvRu4Hd2l2luL1IUPqi51urNW6dYf
 lRbNRIdaA6XwyRBztQaPwvUn/s0/E2wT2V4DvXGlpo9koQnNvD
 VPre4jGUImw6YQPzA2gDryXzaeupvyLG/vjaL9+XWKXnNu1I6g
 wsDka1nCOqv1Vlv9281c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Theodore Ts'o wrote:
> On Mon, Aug 20, 2012 at 11:12:07AM +0200, Alexander Thomas wrote:
> > 
> > Flash drives are getting faster as well. Copying an 8GB file to/from a
> > USB drive is not excruciatingly slow and may be quicker and more
> > certain than figuring out how to get a working network connection in
> > some random place, if possible at all. If it is some lousy WiFi with
> > the base station at a distance, a flash drive will be faster. And
> > sometimes people just want to be sure that their data will be at a
> > certain place at a certain time without having to rely on a network
> > that may go down due to external reasons.

Actually, flash drives are not really getting faster as much as you
think, at least not any more. The main source for performance improvements
over the last few years was from increasing the flash page and block
sizes. Writing single bits may get slightly faster over time, but
we are writing more of them at the same time now, which leads to
significant problems:

* The page size is now effectively 16kb on most flash drives, and
writing in 4kb alignments as practically all our file systems do
(including the lanyfs proposal) means we're actually slower now
than we would be with smaller pages, unless you get into the
special case of writing large chunks of data.

* The erase block size is increasing insanely. We're seeing 12MB
and 16MB block size devices now, and our simulations have shown that
our file systems that are not aware of this block size are hitting
a wall at around 4MB.

> I used to think that we would need an IP unencumbered file system,
> given issues around TomTom and Microsoft, but these days, given how
> quickly Linux has taken over the embedded and mobile landscape[2] for
> all but the most tiniest of devices, I don't think that's as important
> of an issue, since we can just simply use a native linux file system.
> In the time that it would take to get some other new file system
> adopted across the industry, it's likely Linux will have enough market
> share to perhaps compel the other OS vendors to provide
> interoperability solutions.  (Just as the BSD folks have implemented
> ext2 support; Linux hasn't bothered to implement FFS2 support....)

There will be patches very soon for a new file system from a major
flash vendor that I'm cooperating with. I haven't seen the patches
myself yet, but the design is similar to a prototype that was done
as a thesis I supervised [1]. I hope that the new implementation is
similarly simple to this design, and also able to provide optimum
performance on most flash media.

	Arnd

[1] https://wiki.linaro.org/WorkingGroups/Kernel/Specs/flash-file-system-prototype
