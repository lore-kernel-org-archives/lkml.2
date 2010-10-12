Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0JLNz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:55:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:56970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab0JLNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:55:28 -0400
Message-ID: <4CB468C1.8000004@kernel.org>
Date: Tue, 12 Oct 2010 15:55:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect,
 and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <4CB3148C.5040902@kernel.org> <tkrat.1386de42b88d7218@s5r6.in-berlin.de> <tkrat.dd9197843f6a0a54@s5r6.in-berlin.de>
In-Reply-To: <tkrat.dd9197843f6a0a54@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 13:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/11/2010 11:39 PM, Stefan Richter wrote:
> Stefan Richter wrote:
>> There are indeed situations where the last module reference was already
>> put down before the work is run for the last time.  Thanks for the hint.
>>
>> What is preferable, an own workqueue instance whose destroy_workqueue()
>> lets sbp2_cleanup wait for unfinished work, or module ref-counting like
>> below?
> 
> Anoher thing:  Somebody might have swap space on a FireWire disk.

It doesn't have to be swap.  Having a rw filesystem mounted is enough
to be in the memory reclaim path.

> Yet the system workqueues that firewire-core and (perhaps)
> firewire-sbp2 are using are created without WQ_RESCUER.
> 
> Does this --- fringe use case as it might be --- call for private
> workqueues in firewire-core (for fw_device.work) and firewire-sbp2 (for
> sbp2_logical_unit.work)?
> 
> Besides the less interesting cases of device discovery and shutdown,
> both of these works are also involved in SBP reconnect which needs to be
> performed at each FireWire bus reset (which can happen anytime for a
> variety of reasons).

Yes, it would definitely be better to put them in a workqueue with
WQ_RESCUER (or the new WQ_MEM_RECLAIM).

Thanks.

-- 
tejun
