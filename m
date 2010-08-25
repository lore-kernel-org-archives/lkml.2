Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0HYLnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:43:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab0HYLmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:42:51 -0400
Date: Wed, 25 Aug 2010 21:42:32 +1000
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        Tejun Heo <tj@kernle.org>
Subject: Re: [PATCH UPDATED 4/5] md: implment REQ_FLUSH/FUA support
Message-ID: <20100825214232.4a502c47@notabene>
In-Reply-To: <4C74FCF2.2090809@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
	<1281977523-19335-5-git-send-email-tj@kernel.org>
	<20100824154102.7b68818b@notabene>
	<4C74FCF2.2090809@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 13:22:26 +0200
Tejun Heo <tj@kernel.org> wrote:

> This patch converts md to support REQ_FLUSH/FUA instead of now
> deprecated REQ_HARDBARRIER.  In the core part (md.c), the following
> changes are notable.
> 
> * Unlike REQ_HARDBARRIER, REQ_FLUSH/FUA don't interfere with
>   processing of other requests and thus there is no reason to mark the
>   queue congested while FLUSH/FUA is in progress.
> 
> * REQ_FLUSH/FUA failures are final and its users don't need retry
>   logic.  Retry logic is removed.
> 
> * Preflush needs to be issued to all member devices but FUA writes can
>   be handled the same way as other writes - their processing can be
>   deferred to request_queue of member devices.  md_barrier_request()
>   is renamed to md_flush_request() and simplified accordingly.
> 
> For linear, raid0 and multipath, the core changes are enough.  raid1,
> 5 and 10 need the following conversions.
> 
> * raid1: Handling of FLUSH/FUA bio's can simply be deferred to
>   request_queues of member devices.  Barrier related logic removed.
> 
> * raid5: Queue draining logic dropped.  FUA bit is propagated through
>   biodrain and stripe resconstruction such that all the updated parts
>   of the stripe are written out with FUA writes if any of the dirtying
>   writes was FUA.  preread_active_stripes handling in make_request()
>   is updated as suggested by Neil Brown.
> 
> * raid10: FUA bit needs to be propagated to write clones.
> 
> linear, raid0, 1, 5 and 10 tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Neil Brown <neilb@suse.de>
> ---
> Rebased on top of -rc2 and updated as suggested.  Can you please
> review and ack it?

Reviewed-by: NeilBrown <neilb@suse.de>

Thanks!

NeilBrown
