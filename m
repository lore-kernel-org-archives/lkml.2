Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab1KHQdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:33:43 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49594 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1KHQdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:33:42 -0500
Date: Tue, 8 Nov 2011 11:33:31 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vince@deater.net>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
 repository, tools/perf/ and tools/kvm/
Message-ID: <20111108163331.GJ24234@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
	Avi Kivity <avi@redhat.com>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125509.GB1022@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108125509.GB1022@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 01:55:09PM +0100, Ingo Molnar wrote:
> I guess you can do well with a split project as well - my main claim 
> is that good compatibility comes *naturally* with integration.

Here I have to disagree; my main worry is that integration makes it
*naturally* easy for people to skip the hard work needed to keep a
stable kernel/userspace interface.

The other worry which I've mentioned, but which I haven't seen
addressed, is that the even if you can use a perf from a newer kernel
with an older kernel, this causes distributions a huge amount of pain,
since they have to package two different kernel source packages, and
only compile perf from the newer kernel source package.  This leads to
all sorts of confusion from a distribution packaging point of view.

For example, assume that RHEL 5, which is using 2.6.32 or something
like that, wants to use a newer e2fsck that does a better job fixing
file system corruptions.  If it were bundled with the kernel, then
they would have to package up the v3.1 kernel sources, and have a
source RPM that isn't used for building kernel sources, but just to
build a newer version of e2fsck.  Fortunately, they don't have to do
that.  They just pull down a newer version of e2fsprogs, and package,
build, test, and ship that.

In addition, suppose Red Hat ships a security bug fix which means a
new kernel-image RPM has to be shipped.  Does that mean that Red Hat
has to ship new binary RPM's for any and all tools/* programs that
they have packaged as separate RPM's?  Or should installing a new
kernel RPM also imply dropping new binaries in /usr/bin/perf, et. al?
There are all sorts of packaging questions that are raised
integration, and from where I sit I don't think they've been
adequately solved yet.


> Did you consider it a possibility that out of tree projects that have 
> deep ties to the kernel technically seem to be at a relative 
> disadvantage to in-kernel projects because separation is technically 
> costly with the costs of separation being larger than the advantages 
> of separation?

As the e2fsprogs developer, I live with the costs all the time; I can
testify to the facy that they are very slight.  Occasionally I have to
make parallel changes to fs/ext4/ext4.h in the kernel and
lib/ext2fs/ext2fs.h in e2fsprogs, and we use various different
techniques to detect whether the ext4 kernel code supports a
particular feature (we use the presence or absence of some sysfs
files), but it's really not been hard for us.

> But note that there are several OS projects that succeeded doing the 
> equivalent of a 'whole world' single Git repo, so i don't think we 
> have the basis to claim that it *cannot* work.

There have indeed, and there has speculation that this was one of many
contributions to why they lost out in the popularity and adoption
competition with Linux.  (Specifically, the reasoning goes that the
need to package up the kernel plus userspace meant that we had
distributions in the Linux ecosystem, and the competition kept
everyone honest.  If one distribution started making insane decisions,
whether it's forcing Unity on everyone, or forcing GNOME 3 on
everyone, it's always possible to switch to another distribution.  The
*BSD systems didn't have that safety valve....)


> But why do you have to think in absolutes and extremes all the time? 
> Why not excercise some good case by case judgement about the merits 
> of integration versus separation?

I agree that there are tradeoffs to both approaches, and I agree that
case by case judgement is something that should be done.  One of the
reasons why I've spent a lot of time pointing out the downsides of
integration and the shortcomings in the integration position is that
I've seen advocates claiming that the fact that was perf was
integrated was a precedent that meant that choice for kvm-tool was
something that should not be questioned since tools/perf justified
anything they wanted to do, and that if we wanted to argue about
whether kvm-tool should have been bundled into the kernel, we should
made different decisions about perf.

Regards,

						- Ted
