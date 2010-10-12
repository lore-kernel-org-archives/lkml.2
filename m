Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab0JLNus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:50:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:35132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab0JLNun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:50:43 -0400
Message-ID: <4CB467A3.4010200@kernel.org>
Date: Tue, 12 Oct 2010 15:50:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect,
 and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <4CB3148C.5040902@kernel.org> <tkrat.1386de42b88d7218@s5r6.in-berlin.de>
In-Reply-To: <tkrat.1386de42b88d7218@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 13:50:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/11/2010 11:27 PM, Stefan Richter wrote:
>> Hmmm... from glancing the code, there doesn't seem to anything which
>> can guarantee sbp2_release_target/reconnect() are finished before
>> sbp2_cleanup() returns, so the code section might go away with code
>> still running.  It seems like the right thing to do here would be
>> using alloc_workqueue(KBUILD_MODNAME, WQ_NON_REENTRANT, 0).  Am I
>> missing something?
> 
> There are indeed situations where the last module reference was already
> put down before the work is run for the last time.  Thanks for the hint.
> 
> What is preferable, an own workqueue instance whose destroy_workqueue()
> lets sbp2_cleanup wait for unfinished work, or module ref-counting like
> below?

The best would be flushing the specific works but that isn't possible
when works are used to do the final put.  I would go for using a
separate workqueue.  With cmwq, each workqueue is much cheaper than
before anyway.

Thanks.

-- 
tejun
