Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab2EBBVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:21:23 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:16577 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758008Ab2EBBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:20:47 -0400
Date: Tue, 1 May 2012 21:20:29 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Maarten Maathuis <madman2003@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Martin Peres <martin.peres@labri.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120502012029.GA24097@elliptictech.com>
References: <20120424010345.GA30674@elliptictech.com>
 <20120425013537.GA11959@elliptictech.com>
 <1335322574.1821.8.camel@nisroch>
 <1335504021.5311.0.camel@nisroch>
 <20120428003928.GA16805@elliptictech.com>
 <CADnq5_N8Cf4ONL5TNA-Wmif7cty070TRrTOnUpqdiGhWbVbj=w@mail.gmail.com>
 <20120428153350.GA19561@elliptictech.com>
 <20120429223744.GA19382@core.coreip.homeip.net>
 <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
 <20120501132352.GA28696@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120501132352.GA28696@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-adding Ben to the Cc because he was apparently dropped somewhere in
this thread)

On 2012-05-01 09:23 -0400, Nick Bowler wrote:
> On 2012-04-30 11:07 +0200, Maarten Maathuis wrote:
> > On Mon, Apr 30, 2012 at 12:37 AM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > On Sat, Apr 28, 2012 at 11:33:50AM -0400, Nick Bowler wrote:
> > >> On 2012-04-28 02:19 -0400, Alex Deucher wrote:
> > >> > On Fri, Apr 27, 2012 at 8:39 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > >> > > While tracking down the black screen issue, I've been having the monitor
> > >> > > directly connected to the video card the whole time, but now when I'm
> > >> > > connected through my KVM switch (an IOGear GCS1804), it appears that
> > >> > > something's going wrong with reading the EDID, because the available
> > >> > > modes are all screwed up (both console and X decide they want to drive
> > >> > > the display at 1024x768).
> [...]
> > >> > > Also, looking at /sys/class/drm/card0-VGA-1/edid I see that it
> > >> > > is empty on 3.4-rc4+ and it is correct on 3.2.15.  Things seem
> > >> > > to work OK when the KVM is not involved.
> > >> >
> > >> > Were you ever able to fetch a EDID with the KVM involved?  KVMs are
> > >> > notorious for not connecting the ddc pins.
> > >>
> > >> Yes, it works on 3.2.15 as described above.
> > >
> > > I have the same (or similar) KVM (not in the office at the moment) and I
> > > can confirm that with newer kernels EDID fecthing in flaky. It's 50/50
> > > if EDED retrieval succeeds or if it fails with:
> > >
> > > Apr 26 13:06:57 dtor-d630 kernel: [13464.936336] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> [...]
> > > Earlier kernels were able to retrieve EDEDs reliably.
> 
> FWIW, for me EDID failure on new kernels is 100% reproducible, and there
> are no such checksum errors in the log.  It's just missing.
> 
> > Just a crazy thought, but didn't we change some timings related to
> > EDID retrieval? To make it faster.
> 
> OK, this time bisecting started off relatively smoothly (doing the same
> "backwards" bisect on the branch-o-reverts as last time), but then my
> disk died halfway through...
[...]

OK, system is back online and I finished the bisection.  The commit that
broke it for me is the following, and reverting it on top of 3.3.4 + the
"make VGA work at all" patch fixes this particular issue for me.

commit f553b79c03f0dbd52f6f03abe8233a2bef8cbd0d
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Dec 21 18:09:12 2011 +1000

    drm/nouveau/i2c: handle bit-banging ourselves
    
    i2c-algo-bit doesn't actually work very well on one card I have access to
    (NVS 300), random single-bit errors occur most of the time - what we're
    doing now is closer to what xf86i2c.c does.
    
    The original plan was to figure out why i2c-algo-bit fails on the NVS 300,
    and fix it.  However, while investigating I discovered i2c-algo-bit calls
    cond_resched(), which makes it a bad idea for us to be using as we execute
    VBIOS scripts from a tasklet, and there may very well be i2c transfers as
    a result.
    
    So, since I already wrote this code in userspace to track down the NVS 300
    bug, and it's not really much code - lets use it.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

