Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab0FKVDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:03:37 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:55154 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756768Ab0FKVDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:03:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r1tTHeQAUQZJJLYOHCUTLqA5usA8mcejKOBEsg+KkQDl1fCJbe4OATSi0ZaeY/DaCdZ4WEofIEsVeUpB3U+RWm+/wD3kJJiolmmCYSjAJ/0O27HPH5BbdyABCan9pacQ;
Date: Fri, 11 Jun 2010 14:02:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20100611140219.6b853478@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.1006091611040.4506@i5.linux-foundation.org>
References: <20100609155321.299cadd9@virtuousgeek.org>
	<alpine.LFD.2.00.1006091611040.4506@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 16:14:10 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, 9 Jun 2010, Jesse Barnes wrote:
> > 
> > Nothing too big here; I do have a couple of fixes in the queue that
> > aren't included here though.  I'll be pulling them together over the
> > next couple of days.
> 
> Hmm. None of these seem to really be relevant. The fact that one is from 
> me doesn't make me any more eager to pull. Are any of these real 
> regressions (the missing parenthesis one seems to be the only one that 
> could be serious, but I didn't grep for actual use).

Ok I've updated the tree to cover the regressions reported so far,
including the printk change so we get fewer spurious reports.  Note it
hasn't gone through linux-next yet, but the patches are all small and
have each been tested individually.

There's one change in particular I'd like you (along with the cc'd
arch maintainers) to review:

commit 837c4ef13c44296bb763a0ca0e84a076592474cf
Author: Yinghai Lu <yinghai.lu@oracle.com>
Date:   Thu Jun 3 13:43:03 2010 -0700

    PCI: clear bridge resource range if BIOS assigned bad one

This fixes a regression rather minimally, but may have side effects I'm
not seeing.  An alternative to that fix would be to revert

commit d65245c3297ac63abc51a976d92f45f2195d2854
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Jan 22 01:02:23 2010 -0800

    PCI: don't shrink bridge resources

but it seems that's a bit more risky at this point, since it could
affect hotplug and rescan cases.  Really this code needs to be
reworked, especially in light of the revert of
977d17bb1749517b353874ccdc9b85abc7a58c2a which tried (and failed)
to perform aggressive reallocation when devices weren't configured.
I'll try to find some time next week to work on that.

The following changes since commit 9dda696f0de87a2e5cfabb147e28c76b7d3c6846:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Bjorn Helgaas (1):
      PCI: change resource collision messages from KERN_ERR to KERN_INFO

Jesse Barnes (1):
      Revert "PCI: create function symlinks in /sys/bus/pci/slots/N/"

Jiri Slaby (1):
      PCI: hotplug/cpqphp, fix NULL dereference

Yinghai Lu (1):
      PCI: clear bridge resource range if BIOS assigned bad one

 Documentation/ABI/testing/sysfs-bus-pci |   40 -------------------------
 arch/microblaze/pci/pci-common.c        |    1 +
 arch/mn10300/unit-asb2305/pci-asb2305.c |    1 +
 arch/powerpc/kernel/pci-common.c        |    1 +
 arch/x86/pci/i386.c                     |    2 +
 drivers/pci/hotplug/cpqphp_core.c       |    7 ++++
 drivers/pci/pci-sysfs.c                 |   37 -----------------------
 drivers/pci/setup-res.c                 |   10 +++---
 drivers/pci/slot.c                      |   48 -------------------------------
 9 files changed, 17 insertions(+), 130 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
