Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2JJIQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 04:16:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54745 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2JJIQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 04:16:07 -0400
Date: Wed, 10 Oct 2012 00:53:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
Message-ID: <20121010045351.GE17429@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Jaegeuk Kim <jaegeuk.kim@samsung.com>,
	'Namjae Jeon' <linkinjeon@gmail.com>,
	'Vyacheslav Dubeyko' <slava@dubeyko.com>,
	'Marco Stornelli' <marco.stornelli@gmail.com>,
	'Jaegeuk Kim' <jaegeuk.kim@gmail.com>,
	'Al Viro' <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, chur.lee@samsung.com,
	cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
	linux-fsdevel@vger.kernel.org
References: <1349553966.12699.132.camel@kjgkr>
 <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <CAKYAXd_Y0Y0kLyqEm1FVO5TpvrN-WwnF40H3hMe5B7_cTe0nMw@mail.gmail.com>
 <004a01cda542$f398e2c0$dacaa840$%kim@samsung.com>
 <alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com>
 <007c01cda60b$43e7fae0$cbb7f0a0$%kim@samsung.com>
 <alpine.LFD.2.00.1210091250590.11244@dhcp-1-104.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210091250590.11244@dhcp-1-104.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 01:01:24PM +0200, Lukáš Czerner wrote:
> Do not get me wrong, I do not think it is worth to wait for vendors
> to come to their senses, but it is worth constantly reminding that
> we *need* this kind of information and those heuristics are not
> feasible in the long run anyway.

A number of us has been telling flash vendors exactly this.  The
technical people do seem to understand.  It's management who seem to
be primarily clueless, even though this information can be extracted
by employing timing attacks on the media.  I've pointed this out
before, and the technical people agree that trying to keep this
information as a "trade secret" is pointless, stupid, and
counterproductive.  Trying to get the pointy-haired bosses to
understand may take quite a while.

That being said, in many cases, it doesn't really matter.  For
example, if a manufacturer has a production run of a million Android
mobile devices, (a) all of the eMMC devices will be the same (or at
least come from a handful of suppliers in the worst case), and (b) the
menufacturers *will* be able to get this information under NDA, and so
they can just feed it straight to the mkfs program.  There's no need
in many cases to have mkfs burn write cycles carrying out a timing
attack on which flash device that it is formatting.


My concern is a different one.  We shouldn't just be focusing on
sqlite performance assuming that its characteristics are fixed, to the
point where it drives file system design and benchmarking.  Currently
sqllite does a lot of pointless writes at every single transaction
boundary which could be optimized if you relax the design constraint
that the database has to be in a single file --- something which is a
nice-to-have for some applications, but which really doesn't matter in
an embedded/mobile handset use case.

It may very well be that f2fs is still going to be better since it is
trying to minimize the number of erase blocks that are "open" for
writing at one time.  And even if eMMC devices become more
intelligent, optimizing for erase blocks is still a good thing
(although it may not result in as spectacular wins on flash devices
with more sophisticated FTL's.).

However, it may also be that we'll be able to teach some existing file
systme how to be more intelligent about optimizing for erase blocks
that could be made production stable faster.  (I have some ideas of
how to do this for ext4.)

But the point I'm trying to drive home here is that we shouldn't
assume that the only thing we can do is do optimize the file system.
Given the amount of time it takes to test, performance tune, and
confidence that the file system is sound and stable (look at how long
btrfs has taken to mature), it is likely that both flash technology
and workload characteristics will change before f2fs is fully mature
--- and this is no slight on the good work Jaegeuk and his team have
done.

Long experience with file systems show us that they are like fine
wine; they take time to mature.  Whether you're talking about
ext2/3/4, btrfs, Sun's ZFS, Digital's ADVFS, IBM's JFS or GPFS etc.,
and whether you're talking about file systems developed using open
source or more traditional corporate development processes, it takes a
minimum of 3-5 years and 50-200 PY's of effort to create a fully
production-ready file system from scratch (and some of the people
which I surveyed for the Nxxt Generation File System task force, some
of which had decades of experience creating and working with file
systems, thought the 50-75 Person-Year estimate was a lowball --- note
that Sun's ZFS took *seven* years to develop, even with a generously
staffed team.)

As an open source example, the NGFS system task force, decided to
claim, in its November 2007 report-out, that btrfs would be ready for
community distro's in two years, since otherwise the managers and
other folks who control corporate budgets at the companies involved
would be scared off and decide not to fund the project.  And yet here
we are in 2012, five years later, and we're just starting to see btrfs
support show up in community distro's as a supported option, and I
don't think most people would claim it is ready for production use in
enterprise distro's yet.

Given that, we might as well make sure we can do what we can to
optimize performance up and down the storage stack --- not just at the
file system level, but also by optimizing sqlite for embedded/handset
use cases.

Regards,

					- Ted
