Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2LQVpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:45:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab2LQVp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:45:28 -0500
Date: Mon, 17 Dec 2012 16:45:06 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH v2 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking
 paths
Message-ID: <20121217214506.GF60946@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A22EFA@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A22EFA@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 08:56:27PM +0000, Seiji Aguchi wrote:
> Changelog v1 -> v2
>  - Erase a logic checking the number of online cpus.
>  - Create a patchset to fix deadlocking issue in both pstore filesystem and
>    efi_pstore driver.
>    - Introduce a function, is_non_blocking_path(), to check if pstore 
>      is in panic and emergency-restart paths (PATCH 1/2)
>    - Avoid efi_pstore_driver is blocked in non-blocking paths
>      such as nmi, panic and emergency-restart paths (PATCH 2/2)

This patch set seems cleaner.  Though it seems most of patch2 should have
been in patch1 (except for the efi part).

The only nitpick I have is the name 'is_non_blocking_path'.  I don't know
why, but the name doesn't seem exactly right to me.  I was thinking
something like 'pstore_cannot_block_path' or something.  But it is just a
nitpick, so it doesn't matter either way to me.

Cheers,
Don

> 
> [Issue]
> 
> There are some paths which shouldn't be blocked in kernel, like NMI, panic case after stopping cpus, 
> emergency-restart.
> 
> On the other hand, current pstore avoids blocking in a NMI path but it may be blocked in other paths.
> Also, an efi_pstore driver may be blocked in all of those paths because it simply takes a spin lock 
> at writing time.
> 
> If they are blocked in those paths, the system will hang up and it has a big impact for users.
> 
> Here is an example scenario which pstore is blocked in panic path.
> 
>  - cpuA grabs psinfo->buf_lock
>  - cpuB panics and calls smp_send_stop
>  - smp_send_stop sends IRQ to cpuA
>    after 1 second, cpuB gives up on cpuA and sends an NMI instead
>  - cpuA is now in an NMI handler while still holding buf_lock.
>    And then, cpuB is deadlocked by taking efi_pstore->lock again.
> 
> This case may happen if a firmware has a bug and cpuA is stuck in it.
> 
> [Solution]
> 
> This patchset avoids that pstore and efi_pstore driver are blocked in the non-blocking paths 
> like NMI, panic, and emrgency-restart by introducing a function checking if they are in those paths.
> Please see each patch for detailed explanations.
> 
> Seiji Aguchi (2):
>   [PATCH v2 1/2] pstore: Avoid deadlock in panic and emergency-restart path
>   [PATCH v2 2/2] efi_pstore: Avoid deadlock in non-blocking paths
> 
>  drivers/firmware/efivars.c |   11 ++++++++++-
>  fs/pstore/platform.c       |   34 ++++++++++++++++++++++++++++------
>  include/linux/pstore.h     |    6 ++++++
>  3 files changed, 44 insertions(+), 7 deletions(-)
