Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0LPOjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:39:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:49427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0LPOji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:39:38 -0500
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D091A20.3060202@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>
	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>
	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>
	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>
	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>
	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org>
	 <1292440246.4688.416.camel@mulgrave.site>  <4D0914B5.20208@kernel.org>
	 <1292441610.4688.457.camel@mulgrave.site>  <4D091A20.3060202@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 09:39:32 -0500
Message-ID: <1292510372.3024.12.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 20:42 +0100, Tejun Heo wrote:
> On 12/15/2010 08:33 PM, James Bottomley wrote:
> > A single flush won't quite work.  The target is a parent of the device,
> > both of which release methods have execute_in_process_context()
> > requirements.  What can happen here is that the last put of the device
> > will release the target (from the function).  If both are moved to
> > workqueues, a single flush could cause the execution of the device work,
> > which then queues up target work (and makes it still pending).  A double
> > flush will solve this (because I think our nesting level doesn't go
> > beyond 2) but it's a bit ugly ...
> 
> Yeap, that's an interesting point actually.  I just sent the patch
> butn there is no explicit flush.  It's implied by destroy_work() and
> it has been a bit bothering that destroy_work() could exit with
> pending works if execution of the current one produces more.  I was
> pondering making destroy_workqueue() actually drain all the scheduled
> works and maybe trigger a warning if it seems to loop for too long.
> 
> But, anyways, I don't think that's gonna happen here.  If the last put
> hasn't been executed the module reference wouldn't be zero, so module
> unload can't initiate, right?

Wrong I'm afraid.  There's a nasty two level complexity in module
references:  Anything which takes an external reference (like open or
mount) does indeed take the module reference and prevent removal.
Anything that takes an internal reference doesn't ... we wait for all of
them to come back in the final removal of the bus type.  The is to
prevent a module removal deadlock.  The callbacks are internal
references, so we wait for them in module_exit() but don't block
module_exit() from being called ... meaning the double callback scenario
could be outstanding.

James


