Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1JPOYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 10:24:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1JPOYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 10:24:50 -0400
Date: Sun, 16 Oct 2011 16:25:41 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        kvm@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] PCI: Rework config space locking, add INTx masking
 services
Message-ID: <20111016142541.GA18956@redhat.com>
References: <cover.1315846441.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1315846441.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 06:54:01PM +0200, Jan Kiszka wrote:
> This series tries to heal the currently broken locking scheme around PCI
> config space accesses.
> 
> We have an interface lock out access via sysfs, but that service wrongly
> assumes it is only called by one instance at a time for some device. So
> two loops doing
> 
> echo 1 > /sys/bus/pci/devices/<some-device>/reset
> 
> in parallel will trigger a kernel BUG at the moment.
> 
> Besides synchronizing with user space, we also need to manage config
> space access of generic PCI drivers. They need to mask legacy interrupt
> lines while the specific driver runs in user space or a guest OS.
> 
> The approach taken here is provide mutex-like locking for general
> access - which still requires a special mechanism due to requirements of
> the IBM Power RAID SCSI driver. Furthermore, INTx masking is now
> available via the PCI core and synchronized via the internal pci_lock.
> 
> Not sure who may want to take this, so I'm CC'ing broadly.
> 
> CC: Brian King <brking@linux.vnet.ibm.com>
> 
> Jan Kiszka (3):
>   pci: Rework config space blocking services
>   pci: Introduce INTx check & mask API
>   uio: Convert uio_generic_pci to new intx masking API

For the series:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


>  drivers/pci/access.c          |   76 +++++++++++++++++----------
>  drivers/pci/iov.c             |   12 ++--
>  drivers/pci/pci.c             |  114 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/pci/pci.h             |    2 +
>  drivers/scsi/ipr.c            |   66 +++++++++++++++++++++---
>  drivers/scsi/ipr.h            |    1 +
>  drivers/uio/uio_pci_generic.c |   82 +++---------------------------
>  include/linux/pci.h           |   17 ++++--
>  8 files changed, 248 insertions(+), 122 deletions(-)
> 
> -- 
> 1.7.3.4
