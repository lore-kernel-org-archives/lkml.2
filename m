Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1FOKUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:20:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59830 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1FOKU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MlOCvFUWubEaE0ZOZa/NsnL8JwL+PDiGY8rznWYaRnzodUiX5HPfnMt6F7JOpV/MVc
         KJ8QeLTz8Xpw7V1d1MSrKsrBXuZMfocwDuzn+gGhUihPcZG2BHdzFi4dBMQ+BVzVeqBJ
         CS2riYQIiAmS+1mSr/joCvn6LykolaWs+vTwI=
Date: Wed, 15 Jun 2011 12:20:22 +0200
From: Tejun Heo <tj@kernel.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH RESEND] scsi: don't use execute_in_process_context()
Message-ID: <20110615102022.GV8141@htj.dyndns.org>
References: <20110430145602.GL29280@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430145602.GL29280@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 04:56:02PM +0200, Tejun Heo wrote:
> SCSI is the only subsystem which uses execute_in_process_context() and
> its use is racy against module unload.  ie. the reap work is not
> properly flushed and could still be running after the scsi module is
> unloaded.
> 
> Although execute_in_process_context() can be more efficient when the
> caller already has a context, in this case, the call paths are quite
> cold and the difference is practically meaningless.  With commit
> c8efcc25 (workqueue: allow chained queueing during destruction), the
> race condition can easily be fixed by using a dedicated workqueue and
> destroying it on module unload.
> 
> Create and use scsi_wq instead of execute_in_process_context().
> 
> * scsi_device->ew is replaced with release_work.  scsi_target->ew is
>   replaced with reap_work.
> 
> * Both works are initialized with the respective release/reap function
>   during device/target init.  scsi_target_reap_usercontext() is moved
>   upwards to avoid needing forward declaration.
> 
> * scsi_alloc_target() now explicitly flushes the reap_work of the
>   found dying target before putting it instead of depending on
>   flush_scheduled_work().
> 
> For more info on the issues, please read the following threads.
> 
>  http://thread.gmane.org/gmane.linux.scsi/62923
>  http://thread.gmane.org/gmane.linux.kernel/1124773
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> --
> James, can we please get rid of execute_in_process_context()?  It
> didn't help the recent crash case which was a separate issue but
> didn't break anything either, and this is one of the last several
> users of flush_scheduled_work() that I really want to remove.

(resending due to devlivery failure on suse address)

James, ping.

-- 
tejun
