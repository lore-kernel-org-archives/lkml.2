Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1H2Srm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:47:42 -0400
Received: from goliath.siemens.de ([192.35.17.28]:16908 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1H2Srj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:47:39 -0400
Message-ID: <4E5BDEAB.5000405@siemens.com>
Date: Mon, 29 Aug 2011 20:47:07 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Broken pci_block_user_cfg_access interface
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com>
In-Reply-To: <4E5BB358.3060705@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-29 17:42, Jan Kiszka wrote:
> I still don't get what prevents converting ipr to allow plain mutex
> synchronization. My vision is:
>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)

I'm starting to like your proposal: I had a look at ipr, but it turned
out to be anything but trivial to convert that driver. It runs its
complete state machine under spin_lock_irq, and the functions calling
pci_block/unblock_user_cfg_access are deep inside this thing. I have no
hardware to test whatever change, and I feel a bit uncomfortable asking
Brian to redesign his driver that massively.

So back to your idea: I would generalize pci_block_user_cfg_access to
pci_block_cfg_access. It should fail when some other site already holds
the access lock, but it should remain non-blocking - for the sake of ipr.

We should still provide generic pci-2.3 IRQ masking services, but that
could be done in a second step. I could have a look at this.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
