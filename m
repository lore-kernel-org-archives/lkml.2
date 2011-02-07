Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1BGVbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:31:35 -0500
Received: from sentry-three.sandia.gov ([132.175.109.17]:43180 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1BGVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:31:31 -0500
X-WSS-ID: 0LG9NSE-0C-7O9-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Subject: Re: [PATCH 17/46] fs: Use rename lock and RCU for multi-step
 operations
From: "Jim Schutt" <jaschut@sandia.gov>
To: "Yehuda Sadeh Weinraub" <yehudasa@gmail.com>
cc: "Nick Piggin" <npiggin@gmail.com>, "Nick Piggin" <npiggin@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sage Weil" <sage@newdream.net>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
In-Reply-To: <AANLkTinhfZcr-Mz2jAZodSrH-914D7iJREmVSD-i8Fb-@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <d44ddcf1d1e0813b3ce2b3872c7c702a31b62894.1290852959.git.npiggin@kernel.dk>
 <AANLkTi=pj-pLYVSrU+6+BtioCWLod2ueZecNaap619fw@mail.gmail.com>
 <AANLkTik3ScP5rvR2bOXOEEH8SNZGg+xO6Gy32CW3XmU6@mail.gmail.com>
 <AANLkTinVP=OuJ-3u9pHdDuuKJoVrP4Unr5Dx1x=qHtXC@mail.gmail.com>
 <AANLkTimUjC8B0=nn5+yDshzp0hy6Zk1wxYHWEZbk83Tf@mail.gmail.com>
 <AANLkTi=or1Ya21Am8Dr4KVHgqkwvNxFwgn407=wxRfVa@mail.gmail.com>
 <AANLkTinmaojfNDYk1i4jMP33MmEQDur9XZvFp=qhV01e@mail.gmail.com>
 <1297104732.15475.60.camel@sale659.sandia.gov>
 <AANLkTinhfZcr-Mz2jAZodSrH-914D7iJREmVSD-i8Fb-@mail.gmail.com>
Date: Mon, 7 Feb 2011 14:31:19 -0700
Message-ID: <1297114279.15475.65.camel@sale659.sandia.gov>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5)
X-TMWD-Spam-Summary: TS=20110207213120; ID=1; SEV=2.3.1;
 DFV=B2011020721; IFV=NA; AIF=B2011020721; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230362E34443530363441382E303133432C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAACADrBBQCbCiIAAAAAAAAAAAAAAAAAAAB9
X-MMS-Spam-Filter-ID: B2011020721_5.03.0010
X-WSS-ID: 614EBB220YW2584455-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2011-02-07 at 14:04 -0700, Yehuda Sadeh Weinraub wrote:
> On Mon, Feb 7, 2011 at 10:52 AM, Jim Schutt <jaschut@sandia.gov> wrote:
> >
> > On Wed, 2011-01-26 at 22:18 -0700, Nick Piggin wrote:
> >> On Wed, Jan 26, 2011 at 9:10 AM, Yehuda Sadeh Weinraub
> >> <yehudasa@gmail.com> wrote:
> >> > On Wed, Jan 19, 2011 at 2:32 PM, Nick Piggin <npiggin@gmail.com> wrote:
> >> >> On Thu, Jan 20, 2011 at 9:27 AM, Yehuda Sadeh Weinraub
> >> >> <yehudasa@gmail.com> wrote:
> >> >>> On Tue, Jan 18, 2011 at 2:42 PM, Nick Piggin <npiggin@gmail.com> wrote:
> >> >>>> On Wed, Jan 19, 2011 at 9:32 AM, Yehuda Sadeh Weinraub
> >> >>>
> >> >>>>> There's an issue with ceph as it references the
> >> >>>>> dentry->d_parent(->d_inode) at dentry_release(), so setting
> >> >>>>> dentry->d_parent to NULL here doesn't work with ceph. Though there is
> >> >>>>> some workaround for it, we would like to be sure that this one is
> >> >>>>> really required so that we don't exacerbate the ugliness. The
> >> >>>>> workaround is to keep a pointer to the parent inode in the private
> >> >>>>> dentry structure, which will be referenced only at the .release()
> >> >>>>> callback. This is clearly not ideal.
> >> >>>>
> >> >>>> Hmm, I'll have to think about it. Probably we can check for
> >> >>>> d_count == 0 rather than parent != NULL I think?
> >> >>>>
> >> >>>
> >> >>> That'll solve ceph's problem, don't know about how'd affect other
> >> >>> stuff. We'll need to know whether this is the solution, or whether
> >> >>> we'd need to introduce some other band aid fix.
> >> >>
> >> >> No I think it will work fine. Basically we just need to know whether
> >> >> we have been deleted, and if so then we restart rather than walking
> >> >> back up the parent.
> >> >>
> >> >> I'll send a patch in a few days. For the meantime, it's a rathe
> >> >> small window for ceph to worry about. So we'll have something
> >> >> before -rc2 which should be OK.
> >> >>
> >> >
> >> > I guess that it's a bit late for -rc2, should we assume that it'll be on -rc3?
> >>
> >> Yeah, I'm sorry I've been travelling and a bit disconnected.
> >>
> >> NFS folk are having a similar problem and looks like similar
> >> proposed fix will do it.
> >>
> >> http://marc.info/?l=linux-fsdevel&m=129599823927039&w=2
> >>
> >> So I think it is the best way to go to restore behaviour back to what
> >> filesystems already expect, to avoid more surprises in future.
> >
> > I think the following BUG indicates I'm hitting this problem?
> > All I have to do to cause it is unlink a file.
> >
> > My ceph client kernel is 8dbdea8444 (master branch) from
> >  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > + e41cdbb6c5 (master branch) + a3f5274e53 (unstable branch)
> >  from git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
> >
> > Are there any patches available for this I can test?
> >
> > Thanks -- Jim
> >
> 
> It does look like this specific problem.
> You can try cherry-pick commit 9c3db35 off the ceph git. It is just a
> temporary workaround, and it wasn't tested too much. Hopefully Nick
> will push his fix soon so that it wouldn't be needed.

That commit doesn't seem to be in
  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git

Maybe there's another tree I should be looking at?

Thanks -- Jim

> 
> Thanks,
> Yehuda
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


