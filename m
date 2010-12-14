Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0LNOTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:19:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:37868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0LNOTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:19:11 -0500
Message-ID: <4D077CD9.6050907@kernel.org>
Date: Tue, 14 Dec 2010 15:19:05 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org> <1292335754.3058.2.camel@mulgrave.site>
In-Reply-To: <1292335754.3058.2.camel@mulgrave.site>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 14:19:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On 12/14/2010 03:09 PM, James Bottomley wrote:
> That's the point ... it's purely for operations which require user
> context which may not have it.  There's no synchronisation by design
> (it's a simple API).

Well, the problem is that you do require proper synchornization
anyway; otherwise, there is no way to make sure that the work is
finished before the SCSI module is about to be unloaded.  Currently,
the code uses flush_scheduled_work() for this, which is going away
because the latency can grow arbitrarily large and the behavior is
dependent on completely unrelated work items.  So, either we need to
add a separate flush interface for ew's, flush the work item inside
ew's or schedule them to a dedicated workqueue.

>> So, unless there's a compelling reason, let's remove it.
> 
> The open coding of if (in_atomic()) { do workqueue stuff } else
> { execute function } is rather bug prone (most people tend to do
> in_interrupt()).  It's better to encapsulate it in an API.

Compelling reason for it to exist.  Why not just use work when you
need execution context and the caller might or might not have one?

> It was in SCSI ... I got told to make it generic.

Heh, yeah, that would feel quite silly.  Sorry about that.  :-)

But, really, let's just remove it.  At this point, we either need to
fortify the interface or remove it and given the current usage, I
think we're better off with the latter.  If any pressing need arises,
we can always add a proper API with all the necessary bells and
whistles later.

Thank you.

-- 
tejun
