Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1HBSlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:41:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36683 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1HBSk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110802181739.GE6399@redhat.com>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
 <x4939hju2zh.fsf@segfault.boston.devel.redhat.com> <20110802181739.GE6399@redhat.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 2 Aug 2011 14:40:37 -0400
X-Google-Sender-Auth: mJf7kGtFRK8-nLpRFoDKxWi_GEc
Message-ID: <CAMM=eLe38AAU_ArP8poGqkKEs4H_P9yt4nGW_7+WADyys8NLhg@mail.gmail.com>
Subject: Re: [patch] blk-flush: fix flush policy calculation
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 2:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Aug 02, 2011 at 01:39:46PM -0400, Jeff Moyer wrote:

>> So, where do we fix this?  We could just accept Mike's patch to not send
>> such requests down from dm-mpath, but that seems short-sighted.  We
>> could reinstate some checks in __elv_next_request.  Or, we could put the
>> checks into blk_insert_cloned_request.
>>
>> Suggestions?
>
> IMHO, we should fix it at multiple places.
>
> - Your initial fix in blk_insert_flush makes sense. blk_insert_flush()
>  is equivalent of blk_do_flush() so resetting REQ_FLUSH and REQ_FUA there
>  makes sense to me.

Makes sense to me too.

> - Fixing blk_insert_cloned_request() also makes sense to me so that if
>  a request is REQ_FLUSH or REQ_FUA set, we try to add it to underlying
>  device using ELEVATOR_INSERT_FLUSH and not ELEVATOR_INSERT_BACK.

blk_insert_cloned_request is currently only used for request-based DM
(so just dm-mpath).
I don't see a problem with adding logic to it but in practice the DM
change to properly propagate underlying devices' flush_flags is going
to obviate the need (until the kernel grows another
blk_insert_cloned_request caller).

> - Fixing dm-multipath makes sense too as what's the point in dispatching
>  unnecessary flush/fua requests to underlying devices if underlying
>  queue does not have FLUSH capability.

To be clear: It isn't just a fix for dm-multipath.  It fixes all DM
devices (both bio-based and request-based).
That change is already destined for 3.1 via Alasdair's recent DM pull request.

Mike
