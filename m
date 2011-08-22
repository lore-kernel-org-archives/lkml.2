Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1HVOfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:35:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59696 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1HVOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:35:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 22 Aug 2011 16:35:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>, Tejun Heo <tj@kernel.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire-sbp2: fix panic after rmmod with slow targets
Message-ID: <20110822163526.5b76d535@stein>
In-Reply-To: <1314017561-1976-1-git-send-email-bootc@bootc.net>
References: <1314017561-1976-1-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 22 Chris Boot wrote:
> If firewire-sbp2 starts a login to a target that doesn't complete ORBs
> in a timely manner (and has to retry the login), and the module is
> removed before the operation times out, you end up with a null-pointer
> dereference and a kernel panic.
> 
> This happens because the code in sbp2_remove() just does a
> sbp2_target_put(), assuming it will be the last remaining reference. If
> there are jobs in the workqueue, this is not the case, and the module is
> successfully unloaded while references still exist.

The problem is not that sbp2_target_put()'s caller assumes that it is
putting the last reference.  sbp2_target_put()'s very purpose is to clean
up when, and only when, the last reference is gone.

The problem is that sbp2_target_get() does not take a reference to the
module.  scsi_device_get() does.  But as long as SCSI Inquiry was not
completed and e.g. somebody mounts a filesystem on an SBP-2 attached
device, there is no module reference kept by the SCSI core, hence
firewire-sbp2 can be unloaded.

> This patch cancels pending work for each unit in sbp2_remove(), which
> hopefully means there are no extra references around that prevent us
> from unloading. This fixes my crash.

The fix looks good to me.  On thing to watch out for is that sbp2_remove()
may be executed by the very same workqueue which also executes lu->work.
(This is fw_workqueue = alloc_workqueue("firewire", WQ_NON_REENTRANT |
WQ_MEM_RECLAIM, 0).)  But AFAIU, the workqueue infrastructure is able to
handle this without deadlock since kernel 2.6.36.  Tejun, is this
understanding correct?

> Signed-off-by: Chris Boot <bootc@bootc.net>
> ---
>  drivers/firewire/sbp2.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 41841a3..3867aaa 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1198,6 +1198,11 @@ static int sbp2_remove(struct device *dev)
>  {
>  	struct fw_unit *unit = fw_unit(dev);
>  	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
> +	struct sbp2_logical_unit *lu, *next;
> +
> +	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
> +		cancel_delayed_work_sync(&lu->work);
> +	}
>  
>  	sbp2_target_put(tgt);
>  	return 0;

list_for_each_entry() is sufficient here.  You are not changing the list
while you iterate over it.

Would you please resend the patch with list_for_each_entry()?

More importantly, I think the whole sbp2_target instance reference
counting can be removed with his work canceling in place.  But I have not
analyzed this fully yet, and I don't expect you to do this for me.  Though
if you like to do so, that would of course be welcome.
-- 
Stefan Richter
-=====-==-== =--- =-==-
http://arcgraph.de/sr/
