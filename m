Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0LOTmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:42:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:44539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab0LOTme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:42:34 -0500
Message-ID: <4D091A20.3060202@kernel.org>
Date: Wed, 15 Dec 2010 20:42:24 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org>	 <1292440246.4688.416.camel@mulgrave.site>  <4D0914B5.20208@kernel.org> <1292441610.4688.457.camel@mulgrave.site>
In-Reply-To: <1292441610.4688.457.camel@mulgrave.site>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 19:42:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 08:33 PM, James Bottomley wrote:
> A single flush won't quite work.  The target is a parent of the device,
> both of which release methods have execute_in_process_context()
> requirements.  What can happen here is that the last put of the device
> will release the target (from the function).  If both are moved to
> workqueues, a single flush could cause the execution of the device work,
> which then queues up target work (and makes it still pending).  A double
> flush will solve this (because I think our nesting level doesn't go
> beyond 2) but it's a bit ugly ...

Yeap, that's an interesting point actually.  I just sent the patch
butn there is no explicit flush.  It's implied by destroy_work() and
it has been a bit bothering that destroy_work() could exit with
pending works if execution of the current one produces more.  I was
pondering making destroy_workqueue() actually drain all the scheduled
works and maybe trigger a warning if it seems to loop for too long.

But, anyways, I don't think that's gonna happen here.  If the last put
hasn't been executed the module reference wouldn't be zero, so module
unload can't initiate, right?

> execute_in_process_context() doesn't have this problem because the first
> call automatically executes the second inline (because it now has
> context).

Yes, it wouldn't have that problem but it becomes subtle to high
heavens.

I don't think the queue destroyed with pending works problem exists
here because of the module refcnts but I could be mistaken.  Either
way, I'll fix destroy_workqueue() such that it actually drains the
workqueue before destruction, which actually seems like the right
thing to do so that scsi doesn't have to worry about double flushing
or whatnot.  How does that sound?

Thanks.

-- 
tejun
