Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab0JJTbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0JJTbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:31:47 -0400
Message-ID: <4CB21492.8050101@redhat.com>
Date: Sun, 10 Oct 2010 21:31:30 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <20101010170151.GD28828@agk-dp.fab.redhat.com> <20101010174454.GA21681@basil.fritz.box> <20101010181736.GE28828@agk-dp.fab.redhat.com> <20101010185100.GB21681@basil.fritz.box> <20101010190734.GH28828@agk-dp.fab.redhat.com> <20101010191640.GC21681@basil.fritz.box>
In-Reply-To: <20101010191640.GC21681@basil.fritz.box>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 09:16 PM, Andi Kleen wrote:
>> Not if in_interrupt is set though?
>> +       if (per_cpu(io_wq_cpu, cpu) == current && !in_interrupt()) {
>>
>> What I am missing here?
> 
> The interrupt doesn't block on the task.
> 
> Actually most likely that check isn't needed anyways because
> that should not happen, was just pure paranoia from my side.

I don't think so. If you run crypto in async mode, you get asynchronous
callback (kcryptd_asynnc_done() here).

AFAIK this callback is called in interrupt context. This callback
decreases pending counter and if it reach zero it calls
kcryptd_crypt_write_io_submit() -> kcryptd_queue_io().

You cannot call direct encryption if it is called from async callback,
so the IO must be always queued to IO workqueue for later.

So the in_interrupt() is IMHO equivalent of async flag and it is
properly placed there.

But previously, there were threads per device, so if one IO thread blocks,
others stacked mappings can continue
Now I see possibility for deadlock there because we have one io thread now
(assuming that 1 CPU situation Alasdair mentioned).

Or is there a mistake in my analysis?

> 
>>
>> (And assume there is only 1 CPU too for worst case behaviour, presumably.)
> 
> One per process, previously it was always one per CPU.

Nope, one singlethread per crypt device (resp. two: io + crypt).

Milan
