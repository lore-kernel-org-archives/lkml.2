Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1DRThc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:37:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:61189 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1DRTha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:37:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,234,1301900400"; 
   d="scan'208";a="911253411"
Date: Mon, 18 Apr 2011 12:37:22 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        balbi@ti.com,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20110418193722.GB7194@xanatos>
References: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 04:36:15PM +0300, Tatyana Brokhman wrote:
> This patch implements the infrastructure for the UAS gadget driver.
> The UAS gadget driver registers as a second configuration of the MS
> gadet driver.
> 
> A new module parameter was added to the mass_storage module:
> bool use_uasp. (default = 0)
> If this parameter is set to true, the mass_storage module will register
> with the UAS configuration as the devices first configuration and
> operate according to the UAS protocol.

I'm a bit confused by this statement.  Do you mean the UAS alternate
interface setting, rather than the UAS configuration?  I thought that
UAS devices would have one configuration with two alternate interface
settings: a bulk-only-transport interface, and a UAS interface.

Wasn't there a requirement in the USB-IF UAS compliance test that UAS
devices have the UAS alternate interface setting as the second alternate
interface setting, to make sure OSes without UAS support would still be
able to operate with the device?  Is that what you're doing in these
patches?

The other comment I saw was that you chose to run a thread per LUN:

> + * Several kernel threads are created as part of the init sequence:
> + * - UASP main thread
> + * - A thread for each of the existing LUNs
> + * The UASP main thread handles all of the generic commands/task
> + * management requests and routes LUN specific requests to be handled by
> + * the appropriate LUNs task.
> + * The approach of "task per LUN" was chosen due to the UAS protocol
> + * enhancement over the BOT protocol. The main retouch of the UAS
> + * protocol of the BOT protocol is the fact that independent commands can
> + * be performed in parallel. For example a READ command for two different
> + * LUNS. Thus in order to implement this concurrency a separate thread is
> + * needed for each of the existing LUNS.
> + * As long as the LUN threads are alive they keep an open reference to the
> + * backing file. This prevents the unmounting of the backing file's
> + * underlying file system and cause problems during system shutdown.

Why not a thread per SCSI command TAG (i.e. per stream ID)?  I think
that most USB storage devices only have one LUN.  You would get better
performance if you could, say, kick off several READ commands for the
same LUN when you receive two separate SCSI commands on different stream
IDs.

I think the SCSI host-side layer will ensure that all outstanding
asynchronous commands complete before issuing a command that overlaps
with previous commands.  For example, if it issues a WRITE for sector 2,
a READ of sector 1, and then the host-side SCSI stack receives a WRITE
for sectors 1-3, then the SCSI stack will wait for the first two
commands to complete.  Wouldn't you want those first two commands to be
working in parallel on different threads?

Sarah Sharp
