Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2ASIFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:05:04 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54101 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab2ASIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:05:00 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.29.3]
In-Reply-To: <CAK=WgbbZBUiQkCOd=XqT9X_KexKKPft3NB6MCPK1DXfPcqAZ2w@mail.gmail.com>
References: <CAK=WgbbZBUiQkCOd=XqT9X_KexKKPft3NB6MCPK1DXfPcqAZ2w@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 19 Jan 2012 10:04:38 +0200
Message-ID: <CAK=WgbZqbNbjvxWY9Rs7tN91g_1Pket=EnKv8Pnb1fKx5DMkAQ@mail.gmail.com>
Subject: [RESEND][GIT PULL] adding rpmsg and remoteproc to 3.3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, "Grosen, Mark" <mgrosen@ti.com>,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, "Shah, Bhavin" <bshah@ti.com>,
        Iliyan Malchev <malchev@google.com>, "Anna, Suman" <s-anna@ti.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending, this time with the new signed-tag-based request pulls that
git v1.7.9 offers]

Hi Linus,

Please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git rpmsg-for-3.3

To get the remoteproc and rpmsg frameworks, and a few fixes that were
collected after the frameworks were already merged into linux-next.

All the patches have been sitting in linux-next for awhile now
(except the small last two which are there for only slightly more than
two weeks,
because I waited a bit longer than usually needed after posting
and before committing).

The commit date of the entire patch-set is only ~two weeks old,
because I felt it's worth rebasing that branch in order to add
Acks I've just received from Grant. Other than adding those Acks to
the commit logs there is virtually no other change (neither in the
code nor in the commit logs) from the original for-next branch (which
we have merged in linux-next today). I hope my decision was reasonable. If
not, and you prefer the non-rebased for-next branch, then it still exists in my
tree.

At some point we did briefly discuss whether this should perhaps go through the
arm-soc tree. Either way seemed fine, but eventually Arnd tended that
I do send it to you directly, because (unfortunately) Arnd didn't get to
do a detailed review of the last iteration of the patches. So we do
have Arnd's support, but (unfortunately) not his explicit Acked-by.

And now for some background on this (as I recently wrote in a side
thread with you, so sorry if you already read it):

Almost every SoC today have several extra cores (DSP or whatnot)
which usually employ some hardware multimedia accelerators and are
used to offload CPU-intensive tasks from the main application
processor. These other cores are used in an asymmetric multiprocessing
configurations, i.e. they run their own instance of operating system
(which can be some flavor of RTOS, or Linux, or whatnot. anything
goes).

Virtually every SoC vendor have this (lots of ARM vendors, but it's
definitely not limited to ARM), and they all have their own stack of drivers for
controlling, and communicating with, those remote cores. And it's
usually quite huge (tens of thousands loc) and very vendor-specific and
out-of-tree code.

So we're trying to fix this by introducing some generic code that'd
control those remote cores and let drivers talk to them, which all
vendors could then use.

Remoteproc is the framework for controlling those cores
(acquire/configure hardware resources, load firmware, power up/down),
and rpmsg is an inter-processor communication bus which allows drivers
to talk with remote services (simply by sending and receiving messages
over dedicated channels).

Rpmsg is using virtio (as suggested by Arnd) to avoid re-implementing
another shared memory "wire" protocol. And of course to be able to reuse all the
existing virtio drivers (e.g. net, block, console) with a remote core backend.

Much more details can be found in the commit logs, in the detailed
documentations and in the cover letter of the public submissions:

- https://lkml.org/lkml/2011/6/21/47 (first submission)
- https://lkml.org/lkml/2011/10/25/139 (second submission)

The general feedback is good and it looks like there's support across the
board for this, with no expressed objection. Ideally, though, I would prefer to
have more explicit Acks on the patches, so the support we received
would be explicitly reflected in the commit logs too. However, I do understand
this requires folks to carve out considerable time for review, which
isn't always possible...

This patch set only provides basic functionality (boot a remote core
and start talking with it, essentially). There's still more work to do
upstream until a real product can ship with mainline code (e.g.
runtime PM, error recovery, productive rpmsg drivers, ...), but as an
increasing number of parties (spanning several vendors) are now
starting to work with remoteproc/rpmsg, I feel it'd be beneficial to
merge it at this point in order to make collaboration easier. But If
you feel additional explicit Acks are required then by no means we can
wait another round and go harvest those Acks.

If you do decide to merge this then there are two simple merge-related
issues to expect with the 3.3 virtio changes:
1. adopt the recent s/virtqueue_add_buf_gfp/virtqueue_add_buf/ rename
2. tell vring_new_virtqueue() we're not interested in weak smp barriers

For reference, I already fixed those two issues on top of a rebased
branch called 'for-next-acked-merged'. Or if you prefer I can also
just send you the patches for this separately. I could have also
pulled Rusty's branch in and fixed the issues in my tree before
sending you the pull request, but I wasn't sure if that was
preferable.

After the initial rpmsg/remoteproc support will be merged, I expect to
start maintaining those two frameworks using two dedicated trees,
because their development is quite orthogonal.

Another small detail, which isn't very relevant to this pull request but
is still nice to know, is that the recently announced Galaxy Nexus
phone is already using remoteproc and rpmsg to control OMAP4's
two M3 cores and offload tasks to the hardware multimedia accelerators
which they employ. And I'm really happy we managed to submit the
patches to LKML much _before_ the phone was shipped :)

Last but not least: the homogeneous authorship of the patch set as
reflected below is somewhat misleading: this whole work is the result of
an effort done by many people, including (but not limited to) Mark Grosen,
Brian Swetland, Fernando Guzman Lugo, Suman Anna, Iliyan Malchev,
Anthony Gil and more. And also thanks to great review comments from
Grant Likely, Arnd Bergmann, Stephen Boyd and more. So thanks everyone!

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
rpmsg-for-3.3

for you to fetch changes up to 4c0fd1360fd29bc4f99487e2d4984727d4cfaf5a:

  rpmsg: depends on EXPERIMENTAL (2012-01-07 22:36:06 +0200)

----------------------------------------------------------------
Adding the rpmsg and remoteproc frameworks, together with
several bug fixes that were collected along the way.

Only basic functionality is available at this point (boot a remote
processor, possibly after configuring its iommu, and then be able to talk
with it).

And there's a small rpmsg driver sample that shows how easy it is
now to talk with a service running on a remote processor.

At this point only OMAP4 is supported, but support for other platforms
is coming soon too.

Note: the plat-omap device creation patch isn't merged yet because it depends
on CMA. As soon as CMA will make it to mainline, we'll merge that patch too.

----------------------------------------------------------------
Mark Grosen (2):
      remoteproc: do not require an iommu
      remoteproc: avoid registering a virtio device if not supported

Ohad Ben-Cohen (13):
      remoteproc: add framework for controlling remote processors
      remoteproc: add debugfs entries
      remoteproc: create rpmsg virtio device
      remoteproc/omap: add a remoteproc driver for OMAP4
      rpmsg: add virtio-based remote processor messaging bus
      samples/rpmsg: add an rpmsg driver sample
      remoteproc: remove unused resource type
      remoteproc/omap: utilize module_platform_driver
      remoteproc: look for truncated firmware images
      remoteproc: add Kconfig menu
      rpmsg: add Kconfig menu
      remoteproc: depends on EXPERIMENTAL
      rpmsg: depends on EXPERIMENTAL

 Documentation/ABI/testing/sysfs-bus-rpmsg    |   75 ++
 Documentation/remoteproc.txt                 |  324 ++++++
 Documentation/rpmsg.txt                      |  293 ++++++
 MAINTAINERS                                  |    7 +
 arch/arm/plat-omap/include/plat/remoteproc.h |   57 +
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/remoteproc/Kconfig                   |   29 +
 drivers/remoteproc/Makefile                  |    9 +
 drivers/remoteproc/omap_remoteproc.c         |  238 +++++
 drivers/remoteproc/omap_remoteproc.h         |   69 ++
 drivers/remoteproc/remoteproc_core.c         | 1438 ++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_debugfs.c      |  179 ++++
 drivers/remoteproc/remoteproc_internal.h     |   44 +
 drivers/remoteproc/remoteproc_rpmsg.c        |  295 ++++++
 drivers/rpmsg/Kconfig                        |   10 +
 drivers/rpmsg/Makefile                       |    1 +
 drivers/rpmsg/virtio_rpmsg_bus.c             | 1026 ++++++++++++++++++
 include/linux/mod_devicetable.h              |    9 +
 include/linux/remoteproc.h                   |  264 +++++
 include/linux/rpmsg.h                        |  326 ++++++
 include/linux/virtio_ids.h                   |    1 +
 samples/Kconfig                              |    8 +
 samples/Makefile                             |    2 +-
 samples/rpmsg/Makefile                       |    1 +
 samples/rpmsg/rpmsg_client_sample.c          |  100 ++
 26 files changed, 4810 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
 create mode 100644 Documentation/remoteproc.txt
 create mode 100644 Documentation/rpmsg.txt
 create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
 create mode 100644 drivers/remoteproc/Kconfig
 create mode 100644 drivers/remoteproc/Makefile
 create mode 100644 drivers/remoteproc/omap_remoteproc.c
 create mode 100644 drivers/remoteproc/omap_remoteproc.h
 create mode 100644 drivers/remoteproc/remoteproc_core.c
 create mode 100644 drivers/remoteproc/remoteproc_debugfs.c
 create mode 100644 drivers/remoteproc/remoteproc_internal.h
 create mode 100644 drivers/remoteproc/remoteproc_rpmsg.c
 create mode 100644 drivers/rpmsg/Kconfig
 create mode 100644 drivers/rpmsg/Makefile
 create mode 100644 drivers/rpmsg/virtio_rpmsg_bus.c
 create mode 100644 include/linux/remoteproc.h
 create mode 100644 include/linux/rpmsg.h
 create mode 100644 samples/rpmsg/Makefile
 create mode 100644 samples/rpmsg/rpmsg_client_sample.c
