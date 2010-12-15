Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0LONwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:52:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:36910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab0LONwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:52:33 -0500
Message-ID: <4D08C81D.8020606@kernel.org>
Date: Wed, 15 Dec 2010 14:52:29 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next-2.6] bnx2: remove cancel_work_sync() from remove_one
References: <4D0796D7.3030309@kernel.org> <1292348880.7394.63.camel@nseg_linux_HP1.broadcom.com>
In-Reply-To: <1292348880.7394.63.camel@nseg_linux_HP1.broadcom.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 13:52:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 06:48 PM, Michael Chan wrote:
> 
> On Tue, 2010-12-14 at 08:09 -0800, Tejun Heo wrote:
>> Michael pointed out that bnx2_close() already cancels bp->reset_task
>> and thus it is guaranteed to be idle when bnx2_remove_one() is called.
>> Remove the unnecessary cancel_work_sync() in remove_one.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Michael Chan <mchan@broadcom.com>
> 
> Acked-by: Michael Chan <mchan@broadcom.com>

After looking through the code, I don't think this is necessarily
correct.  ->ndo_close() doesn't guarantee that the watchdog timer has
finished running (the timer is deleted with del_timer() not
del_timer_sync()).  ie. the watchdog timer could still be running
after ->ndo_close() and may schedule reset_task.  If remove_one
doesn't flush the task, it may still be running when remove_one() is
called.

David, am I missing something?  Wouldn't it cleaner to guarantee that
->ndo_close() is called with the guarantee that the watchdog timer is
not running anymore?

-- 
tejun
