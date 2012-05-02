Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2EBE7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 00:59:38 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58944 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2EBE7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 00:59:37 -0400
Message-ID: <4FA0BE55.2000305@cs.wisc.edu>
Date: Tue, 01 May 2012 23:55:49 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 05/11] block: drop custom queue draining used by scsi_transport_{iscsi|fc}
References: <1335477561-11131-1-git-send-email-tj@kernel.org> <1335477561-11131-6-git-send-email-tj@kernel.org>
In-Reply-To: <1335477561-11131-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 04:59 PM, Tejun Heo wrote:
> iscsi_remove_host() uses bsg_remove_queue() which implements custom
> queue draining.  fc_bsg_remove() open-codes mostly identical logic.
> 
> The draining logic isn't correct in that blk_stop_queue() doesn't
> prevent new requests from being queued - it just stops processing, so
> nothing prevents new requests to be queued after the logic determines
> that the queue is drained.
> 
> blk_cleanup_queue() now implements proper queue draining and these
> custom draining logics aren't necessary.  Drop them and use
> bsg_unregister_queue() + blk_cleanup_queue() instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Smart <james.smart@emulex.com>
> ---
>  block/bsg-lib.c                     |   53 -----------------------------------
>  drivers/scsi/scsi_transport_fc.c    |   38 -------------------------
>  drivers/scsi/scsi_transport_iscsi.c |    2 +-

iSCSI changes worked ok for me. I replicated the problem that the old
code was supposed to fix and verified the new code worked ok. I also
tested the FC code briefly (I do not have a proper setup to really
stress it), and it worked ok.

Thanks for killing that code for us.

Reviewed-by: Mike Christie <michaelc@.cs.wisc.edu>
