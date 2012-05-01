Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2EANX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:23:58 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:17248 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755866Ab2EANX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:23:57 -0400
Date: Tue, 1 May 2012 09:23:52 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Maarten Maathuis <madman2003@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Martin Peres <martin.peres@labri.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120501132352.GA28696@elliptictech.com>
References: <20120423024558.GD13840@phenom.dumpdata.com>
 <20120424010345.GA30674@elliptictech.com>
 <20120425013537.GA11959@elliptictech.com>
 <1335322574.1821.8.camel@nisroch>
 <1335504021.5311.0.camel@nisroch>
 <20120428003928.GA16805@elliptictech.com>
 <CADnq5_N8Cf4ONL5TNA-Wmif7cty070TRrTOnUpqdiGhWbVbj=w@mail.gmail.com>
 <20120428153350.GA19561@elliptictech.com>
 <20120429223744.GA19382@core.coreip.homeip.net>
 <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-30 11:07 +0200, Maarten Maathuis wrote:
> On Mon, Apr 30, 2012 at 12:37 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Sat, Apr 28, 2012 at 11:33:50AM -0400, Nick Bowler wrote:
> >> On 2012-04-28 02:19 -0400, Alex Deucher wrote:
> >> > On Fri, Apr 27, 2012 at 8:39 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> >> > > While tracking down the black screen issue, I've been having the monitor
> >> > > directly connected to the video card the whole time, but now when I'm
> >> > > connected through my KVM switch (an IOGear GCS1804), it appears that
> >> > > something's going wrong with reading the EDID, because the available
> >> > > modes are all screwed up (both console and X decide they want to drive
> >> > > the display at 1024x768).
[...]
> >> > > Also, looking at /sys/class/drm/card0-VGA-1/edid I see that it
> >> > > is empty on 3.4-rc4+ and it is correct on 3.2.15.  Things seem
> >> > > to work OK when the KVM is not involved.
> >> >
> >> > Were you ever able to fetch a EDID with the KVM involved?  KVMs are
> >> > notorious for not connecting the ddc pins.
> >>
> >> Yes, it works on 3.2.15 as described above.
> >
> > I have the same (or similar) KVM (not in the office at the moment) and I
> > can confirm that with newer kernels EDID fecthing in flaky. It's 50/50
> > if EDED retrieval succeeds or if it fails with:
> >
> > Apr 26 13:06:57 dtor-d630 kernel: [13464.936336] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
[...]
> > Earlier kernels were able to retrieve EDEDs reliably.

FWIW, for me EDID failure on new kernels is 100% reproducible, and there
are no such checksum errors in the log.  It's just missing.

> Just a crazy thought, but didn't we change some timings related to
> EDID retrieval? To make it faster.

OK, this time bisecting started off relatively smoothly (doing the same
"backwards" bisect on the branch-o-reverts as last time), but then my
disk died halfway through...  So I'll post the partial bisection results
now (11 commits left to test), but I clearly have other things to fix
before I can get back to this issue.

  git bisect start 'drivers/gpu/drm'
  # good: [9232969e19ae7251a93ab72e405cf71e5109ec05] drm/nv40/pm: implement first type of pwm fanspeed funcs
  git bisect good 9232969e19ae7251a93ab72e405cf71e5109ec05
  # bad: [dea7e0ac45fd28f90bbc38ff226d36a9f788efbf] ttm: fix agp since ttm tt rework
  git bisect bad dea7e0ac45fd28f90bbc38ff226d36a9f788efbf
  # good: [d2491567cdbcb87b2682e0948a69d73c4dd8987e] drm/nv50/pm: only touch 0x611200 on nv92-
  git bisect good d2491567cdbcb87b2682e0948a69d73c4dd8987e
  # good: [f9f9f536312d4c3ca39502ccf6a3af60cfe38ff4] drm/nouveau/bios: pass drm_device to ROMPTR, rather than nvbios
  git bisect good f9f9f536312d4c3ca39502ccf6a3af60cfe38ff4
  # bad: [d4c2c99bdc8385a0e51ce4ef2df124d14b6b9c9d] drm/nouveau/dp: remove broken display depth function, use the improved one
  git bisect bad d4c2c99bdc8385a0e51ce4ef2df124d14b6b9c9d

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

