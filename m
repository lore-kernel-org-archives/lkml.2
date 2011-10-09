Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1JIOLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 10:11:08 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:46288 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751200Ab1JIOLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 10:11:05 -0400
Date: Sun, 9 Oct 2011 14:11:09 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: handai handai <handai.szj@gmail.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com
Subject: Re: [Fwd: Re: cgroup umount bug]
Message-ID: <20111009141109.GA32276@hallyn.com>
References: <1318146066.2168.10.camel@handai-OptiPlex-780>
 <CAFj3OHWK+wSVjvWQAv5TH55xSQy3nk1p3Z_e_zLOfxSa+5NGTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFj3OHWK+wSVjvWQAv5TH55xSQy3nk1p3Z_e_zLOfxSa+5NGTg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting handai handai (handai.szj@gmail.com):
> From: "Serge E. Hallyn" <serge@hallyn.com>
> > To: 含黛 <handai.szj@taobao.com>
> > Date: Sat, 8 Oct 2011 18:18:13 +0000
> > Subject: Re: cgroup umount bug
> > Quoting 含黛 (handai.szj@taobao.com):
> > > Hi,
> > >
> > >     I found a mount/umount problem while using cgroup: I mount a cpu
> > > cgroup (or other subsystems) and create some subgroups under it, but
> > > later I try to umount it without rmdir those subgroups. I find that I
> > > can umount it without any errors but actually the super block still
> > > exist. This is because the sb->s_active count is greater than 1 which
> > > was added by cgroup_create. But later if I want to mount both cpu and
> > > memory subsystems, it will be unsuccessful indicating that the
> > > device(cpu subsystem) is busy. This situation will not happen if I rmdir
> > > the subgroups manually before umount it. So my question is:
> > >     Should the umount return success when there are still some subgroups
> >
> > Yes.  The fs was unmounted from that directory.
> >
> > > exist ? If this is okay, then it may lead to some *strange* errors using
> > > cgroup later. If it can not be umount, then it should inform that the
> > > mount point is still busy.
> >
> > > Following is an example of this problem:
> > >
> > > mount -t cgroup -o cpu cgroup /mnt
> > > mkdir /mnt/test
> > >
> > > …..// do some tests
> > >
> > > umount /mnt      /* return successfully */
> > >
> > > /* do other subsystems test */
> > > mount -cgroup -o cpu,cpuset cgroup /mnt
> > > mount: cgroup already mounted or /mnt busy  /*??? which is strange */
> >
> > I'm not sure from what you write whether you're aware of this, but
> > to work around this, you can then
> >
> >  mount -t cgroup -o cpu /mnt
> >  for i in `cat /mnt/test/tasks`; do
> >  echo $i > /mnt/tasks
> >  done
> >  rmdir /mnt/test
> >  umount /mnt
> >
> > and now you can
> >
> >  mount -cgroup -o cpu,cpuset cgroup /mnt
> >
> 
> 
> I know that I can bypass this problem by deleting subgroups before unmount.

Or (my point was) after remount.

> But there is no document mentioning that I should do this to avoid it. But

Patches to Documentation/ are welcom.

> even if there is, users may still directly umount it accidentally, then he
> should try to remember what he has done and back to the scene to make it up,

It's not just any user, it's the admin.  If he's not paying attention to
what he's doing, you've got problems.

> or he may need to reboot his server to do another test : ( .
> So, since there is nothing good to permit incompletely unmount,

I disagree.

>  why not
> prevent the potential problem by prohibiting this behavior at first ?

-serge
