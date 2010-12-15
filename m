Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0LOTT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:19:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:59277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab0LOTTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:19:24 -0500
Message-ID: <4D0914B5.20208@kernel.org>
Date: Wed, 15 Dec 2010 20:19:17 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org> <1292440246.4688.416.camel@mulgrave.site>
In-Reply-To: <1292440246.4688.416.camel@mulgrave.site>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 19:19:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2010 08:10 PM, James Bottomley wrote:
>> Yes, it would do, but we were already too far with the existing
>> implementation and I don't agree we need more when replacing it with
>> usual workqueue usage would remove the issue.  So, when we actually
>> need them, let's consider that or any other way to do it, please.
>> A core API with only a few users which can be easily replaced isn't
>> really worth keeping around.  Wouldn't you agree?
> 
> Not really ... since the fix is small and obvious.

IMHO, it's a bit too subtle to be a good API.  The callee is called
under different (locking) context depending on the callsite and I've
been already bitten enough times from implicit THIS_MODULEs.  Both
properties increase possbility of introducing problems which can be
quite difficult to detect and reproduce.

> Plus now it can't be moved into SCSI because I need the unremovable
> call chain.

Yes, with the proposed change, it cannot be moved to SCSI.

> Show me how you propose to fix it differently first, since we both agree
> the initial attempt doesn't work, and we can take the discussion from
> there.

Given that the structures containing the work items are dynamically
allocated, I would introduce a scsi_wq, unconditionally schedule
release works on them and flush them before unloading.  Please note
that workqueues no longer require dedicated threads, so it's quite
cheap.

Thanks.

-- 
tejun
