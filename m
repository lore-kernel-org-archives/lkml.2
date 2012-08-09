Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796Ab2HIM4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:56:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14190 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2HIM4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:56:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Aug 2012 05:51:15 -0700
Date: Thu, 9 Aug 2012 15:56:24 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] debugfs: Allow debugfs_create_dir() to take data
Message-ID: <20120809155624.b781edae9efa7c51faf6c31c@nvidia.com>
In-Reply-To: <20120808133427.GA14417@kroah.com>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
	<1344407073-12030-2-git-send-email-hdoyu@nvidia.com>
	<20120808133427.GA14417@kroah.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Felipe,

On Wed, 8 Aug 2012 15:34:27 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Aug 08, 2012 at 09:24:32AM +0300, Hiroshi Doyu wrote:
> > Add __debugfs_create_dir(), which takes data passed from caller.
> 
> Why?
> 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> >  fs/debugfs/inode.c      |    7 ++++---
> >  include/linux/debugfs.h |    9 ++++++++-
> >  2 files changed, 12 insertions(+), 4 deletions(-)
.....
> What are you trying to do here?  This patch doesn't look right at all.

I missed to send the cover letter of this patch series to LKML, which
explained the background. I attached that cover letter below. Please
read the following explanation too.

The point was that, since directory hierarchy itself already has
the necessary info, like parent <- child relationships, among each
entities(here, smmu?, mc?, cache{tlb,ptc}), I just wanted to avoid to
have those *residual* info embedded in normal data hierarchy, because
cache{tlb,ptc} is used only in debugfs, not in the normal path. With
directory/file hierarchy, we could get necessary data at any time
on-the-fly.

OTOH, if debugfs has the assumption that it has to be always projected
from the existing data hierarchy, I should fix to have the same
hierarchy in entities(here, smmu?, mc?, cache{tlb,ptc}), as Felipe
pointed out in another thread.

It might not be so bad that debugfs has the ability to manage its own
hierarchy with i_private, apart from the original data hierarchy
too. In our case, cache{tlb,ptc} data is used only for debugfs. They
don't have to be in the normal data hierarchy. This depends on the
above assumption, does debugfs have to be always projected from the
normal data hierarchy?

The original tegra smmu debugfs patch is:
  http://lists.linuxfoundation.org/pipermail/iommu/2012-August/004507.html

Here's the original missed cover letter:

Subject:[RFC][PATCH 0/2] debugfs: Allow debugfs_create_dir() to take data from caller
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 8 Aug 2012 08:24:31 +0200
Thread-Index: Ac11LoTHb+fK/MOMRX2RFTvtP89jeg==
Accept-Language: en-US, en-CA, fi-FI

The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
used only for regulars" doesn't allow to use debugfs_create_file() for
creating directory, and the current debugfs_create_dir() cannot take
the private data from caller. There are some cases that we want to pass some
client data to dir, especially when dir is nested deeply. We can work
around to pass all necessary data with some invented data structure to
the end files, but if directory itself had private data, we could
avoid to introduce new structures just to pass data to end files.

For example, tegra iommu(smmu) case, debugfs structure could be as
below.

sys/
└── kernel
    └── debug
        ├── smmu.0
        │   ├── mc
        │   │   ├── ptc
        │   │   └── tlb
        │   └── mc0
        │       ├── ptc
        │       └── tlb
        └── smmu.1
            ├── mc
            │   ├── ptc
            │   └── tlb
            ├── mc0
            │   ├── ptc
            │   └── tlb
            └── mc1
                ├── ptc
                └── tlb

The end files, {ptc,tlb} depend on which mc? to belong to, and
which smmu.? to belong to. The parent data can be accessed from those
end files if necessary.

  dent = d_find_alias(s->private);
  cache = (int)dent->d_inode->i_private;
  mc = (int)dent->d_parent->d_inode->i_private;
  smmu = dent->d_parent->d_parent->d_inode->i_private;

The original tegra smmu debugfs patch is:
  http://lists.linuxfoundation.org/pipermail/iommu/2012-August/004507.html

Hiroshi Doyu (2):
  debugfs: Allow debugfs_create_dir() to take data
  iommu/tegra: smmu: Use __debugfs_create_dir

 drivers/iommu/tegra-smmu.c |    4 +---
 fs/debugfs/inode.c         |    7 ++++---
 include/linux/debugfs.h    |    9 ++++++++-
 3 files changed, 13 insertions(+), 7 deletions(-)

--
1.7.5.4

