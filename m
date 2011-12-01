Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1LAME3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:04:29 -0500
Received: from thoth.sbs.de ([192.35.17.2]:32501 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1LAME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:04:27 -0500
Message-ID: <4ED76D3F.4010108@siemens.com>
Date: Thu, 01 Dec 2011 13:04:15 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] PCI: Rework config space locking, add INTx masking
 services
References: <cover.1320396359.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1320396359.git.jan.kiszka@siemens.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-04 09:45, Jan Kiszka wrote:
> [ Rebase of v1 over yesterday's linux-next ]
> 
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
> Jan Kiszka (3):
>   pci: Rework config space blocking services
>   pci: Introduce INTx check & mask API
>   uio: Convert uio_generic_pci to new intx masking API
> 
>  drivers/pci/access.c          |   76 +++++++++++++++++----------
>  drivers/pci/iov.c             |   12 ++--
>  drivers/pci/pci.c             |  114 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/pci/pci.h             |    2 +
>  drivers/scsi/ipr.c            |   67 +++++++++++++++++++++---
>  drivers/scsi/ipr.h            |    1 +
>  drivers/uio/uio_pci_generic.c |   76 ++-------------------------
>  include/linux/pci.h           |   17 ++++--
>  8 files changed, 248 insertions(+), 117 deletions(-)
> 

I just received yet another request regarding the KVM feature that
depends on this. What's the status of these patches? Were they merged
into some staging tree already (didn't find any traces so far)?

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
