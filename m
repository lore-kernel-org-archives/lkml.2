Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1LAPGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:06:18 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:43204 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754846Ab1LAPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:06:16 -0500
Date: Thu, 1 Dec 2011 15:06:09 +0000
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] PCI: Rework config space locking, add INTx
 masking services
Message-ID: <20111201150609.566d2e42@jbarnes-x220>
In-Reply-To: <4ED76D3F.4010108@siemens.com>
References: <cover.1320396359.git.jan.kiszka@siemens.com>
	<4ED76D3F.4010108@siemens.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 87.82.56.166 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011 13:04:15 +0100
Jan Kiszka <jan.kiszka@siemens.com> wrote:

> On 2011-11-04 09:45, Jan Kiszka wrote:
> > [ Rebase of v1 over yesterday's linux-next ]
> > 
> > This series tries to heal the currently broken locking scheme
> > around PCI config space accesses.
> > 
> > We have an interface lock out access via sysfs, but that service
> > wrongly assumes it is only called by one instance at a time for
> > some device. So two loops doing
> > 
> > echo 1 > /sys/bus/pci/devices/<some-device>/reset
> > 
> > in parallel will trigger a kernel BUG at the moment.
> > 
> > Besides synchronizing with user space, we also need to manage config
> > space access of generic PCI drivers. They need to mask legacy
> > interrupt lines while the specific driver runs in user space or a
> > guest OS.
> > 
> > The approach taken here is provide mutex-like locking for general
> > access - which still requires a special mechanism due to
> > requirements of the IBM Power RAID SCSI driver. Furthermore, INTx
> > masking is now available via the PCI core and synchronized via the
> > internal pci_lock.
> > 
> > Jan Kiszka (3):
> >   pci: Rework config space blocking services
> >   pci: Introduce INTx check & mask API
> >   uio: Convert uio_generic_pci to new intx masking API
> > 
> >  drivers/pci/access.c          |   76 +++++++++++++++++----------
> >  drivers/pci/iov.c             |   12 ++--
> >  drivers/pci/pci.c             |  114
> > ++++++++++++++++++++++++++++++++++++++++-
> > drivers/pci/pci.h             |    2 +
> > drivers/scsi/ipr.c            |   67 +++++++++++++++++++++---
> > drivers/scsi/ipr.h            |    1 +
> > drivers/uio/uio_pci_generic.c |   76 ++-------------------------
> > include/linux/pci.h           |   17 ++++-- 8 files changed, 248
> > insertions(+), 117 deletions(-)
> > 
> 
> I just received yet another request regarding the KVM feature that
> depends on this. What's the status of these patches? Were they merged
> into some staging tree already (didn't find any traces so far)?

Yeah I think it's ok now; I'll give it one more look and pull it into
-next.

Thanks,
Jesse
