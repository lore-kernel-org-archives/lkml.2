Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0JVI1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:27:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:43464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0JVI1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:27:16 -0400
Message-ID: <4CC14ADA.9080706@kernel.org>
Date: Fri, 22 Oct 2010 10:27:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2.6.36-rc7] init: don't call flush_scheduled_work() from
 do_initcalls()
References: <4CB86F94.7080702@kernel.org> <20101021171203.37d0d6d6.akpm@linux-foundation.org>
In-Reply-To: <20101021171203.37d0d6d6.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 08:27:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/22/2010 02:12 AM, Andrew Morton wrote:
>> Index: work/init/main.c
>> ===================================================================
>> --- work.orig/init/main.c
>> +++ work/init/main.c
>> @@ -778,9 +778,6 @@ static void __init do_initcalls(void)
>>
>>  	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
>>  		do_one_initcall(*fn);
>> -
>> -	/* Make sure there is no pending stuff from the initcall sequence */
>> -	flush_scheduled_work();
>>  }
>>
> 
> hm, that predates the initial 2002 BK tree.
> 
> If some initcall function leaves a work scheduled and doesn't flush it
> then free_initmem() can come along and pull the rug out from under its
> feet.  Then you will own both pieces :)

Ah, okay, so that's the rationale behind it.  That at least explains
why it made sense back then.  :-)

I don't think it makes much sense anymore tho for the following
reasons.

* As I wrote in the patch description, there are many other workqueues
  and, after auditing many workqueue users in kernel, my impression is
  that switching to different or dedicated workqueues is done quite
  casually and I've never seen any caller which notes explicit
  dependency on the auto flush behvaior.

* I don't think using workqueue that way is common and we already have
  a specialized mechanism for parallel probing - async - which has
  well defined flushing/ordering behavior during booting.

* System workqueue now can happily host long running works.  We can
  end up sitting there for undetermined amount of time.

> If you really don't like people sending you angry emails then I suppose
> you could add some warning here if a scheduled work is pending, and
> that the scheduled work's callback existed in init.text memory.  Which
> would be a bit of a pain to implement.
> 
> Oh well.  The oops traces will make it fairly clear what happened.

I haven't pushed the patch to Linus yet.  I'll remove it for now and
try to implement something which at least checks the text section of
pending and running works.

Thanks.

-- 
tejun
