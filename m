Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1H2QPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:15:12 -0400
Received: from goliath.siemens.de ([192.35.17.28]:18300 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1H2QPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:15:05 -0400
Message-ID: <4E5BBAEF.8020808@siemens.com>
Date: Mon, 29 Aug 2011 18:14:39 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Broken pci_block_user_cfg_access interface
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com> <20110829155835.GB7480@redhat.com>
In-Reply-To: <20110829155835.GB7480@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-29 17:58, Michael S. Tsirkin wrote:
> On Mon, Aug 29, 2011 at 05:42:16PM +0200, Jan Kiszka wrote:
>> I still don't get what prevents converting ipr to allow plain mutex
>> synchronization. My vision is:
>>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
>>  - require mutex synchronization for common config space access
> 
> Meaning pci_user_ read/write config?

And pci_dev_reset, yes.

> 
>>     and the
>>    full reset cycle
>>  - only exception: INTx status/masking access
>>     => use pci_lock + test for reset_in_progress, skip operation if
>>        that is the case
>>
>> That would allow to drop the whole block_user_cfg infrastructure.
>>
>> Jan
> 
> We still need to block userspace access while INTx does
> the status/masking access, right?

Yes, pci_lock would do that for us.

We should consider making the related bits for INTx test & mask/unmask
generic PCI services so that no user (uio_pci_generic, kvm, vfio) needs
to worry about the locking details.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
