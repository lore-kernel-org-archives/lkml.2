Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0JTQPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:15:06 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:36449 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0JTQPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:15:02 -0400
Date: Wed, 20 Oct 2010 19:14:55 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Dave Airlie <airlied@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
        Greg KH <greg@kroah.com>, Anders Larsen <al@alarsen.net>,
        dri-devel@lists.freedesktop.org,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        codalist@telemann.coda.cs.cmu.edu,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-media@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Steven Rostedt <rostedt@goodmis.org>, autofs@linux.kernel.org,
        Jan Harkes <jaharkes@cs.cmu.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Message-ID: <20101020161455.GC24313@sci.fi>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
	Greg KH <greg@kroah.com>, Anders Larsen <al@alarsen.net>,
	dri-devel@lists.freedesktop.org,
	ksummit-2010-discuss@lists.linux-foundation.org,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	codalist@telemann.coda.cs.cmu.edu,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Christoph Hellwig <hch@infradead.org>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-media@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Steven Rostedt <rostedt@goodmis.org>, autofs@linux.kernel.org,
	Jan Harkes <jaharkes@cs.cmu.edu>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de>
 <AANLkTi=oAeuz8ZxcOMpf=3MVY=WMt0BwHiGCUxO7OAEV@mail.gmail.com>
 <201010190926.54635.arnd@arndb.de>
 <201010191526.01887.arnd@arndb.de>
 <AANLkTinw=Wzh2Ucj6zKSoqC8J3Yq9xDr3mKMUB7K6Yyo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinw=Wzh2Ucj6zKSoqC8J3Yq9xDr3mKMUB7K6Yyo@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 06:50:58AM +1000, Dave Airlie wrote:
> On Tue, Oct 19, 2010 at 11:26 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 19 October 2010, Arnd Bergmann wrote:
> >> On Tuesday 19 October 2010 06:52:32 Dave Airlie wrote:
> >> > > I might be able to find some hardware still lying around here that uses an
> >> > > i810. Not sure unless I go hunting it. But I get the impression that if
> >> > > the kernel is a single-CPU kernel there is not any problem anyway? Don't
> >> > > distros offer a non-smp kernel as an installation option in case the user
> >> > > needs it? So in reality how big a problem is this?
> >> >
> >> > Not anymore, which is my old point of making a fuss. Nowadays in the
> >> > modern distro world, we supply a single kernel that can at runtime
> >> > decide if its running on SMP or UP and rewrite the text section
> >> > appropriately with locks etc. Its like magic, and something like
> >> > marking drivers as BROKEN_ON_SMP at compile time is really wrong when
> >> > what you want now is a runtime warning if someone tries to hotplug a
> >> > CPU with a known iffy driver loaded or if someone tries to load the
> >> > driver when we are already in SMP mode.
> >>
> >> We could make the driver run-time non-SMP by adding
> >>
> >>       if (num_present_cpus() > 1) {
> >>               pr_err("i810 no longer supports SMP\n");
> >>               return -EINVAL;
> >>       }
> >>
> >> to the init function. That would cover the vast majority of the
> >> users of i810 hardware, I guess.
> >
> > Some research showed that Intel never support i810/i815 SMP setups,
> > but there was indeed one company (http://www.acorpusa.com at the time,
> > now owned by a domain squatter) that made i815E based dual Pentium-III
> > boards like this one: http://cgi.ebay.com/280319795096
> 
> Also that board has no on-board GPU enabled i815EP (P means no on-board GPU).

A quick search seems to indicate that an i815E variant also existed.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
