Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1FLA6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 20:58:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36416 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1FLA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 20:58:42 -0400
Date: Sat, 11 Jun 2011 17:58:34 -0700 (PDT)
Message-Id: <20110611.175834.1802167158365693401.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: minipli@googlemail.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110611234415.GE11521@ZenIV.linux.org.uk>
References: <1307711453-17412-1-git-send-email-minipli@googlemail.com>
	<20110611.160842.2135350880385482648.davem@davemloft.net>
	<20110611234415.GE11521@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 17:58:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 12 Jun 2011 00:44:15 +0100

> On Sat, Jun 11, 2011 at 04:08:42PM -0700, David Miller wrote:
>> From: Mathias Krause <minipli@googlemail.com>
>> Date: Fri, 10 Jun 2011 15:10:53 +0200
>> 
>> > @@ -368,9 +368,6 @@ void flush_thread(void)
>> >  
>> >  	/* Clear FPU register state. */
>> >  	t->fpsaved[0] = 0;
>> > -	
>> > -	if (get_thread_current_ds() != ASI_AIUS)
>> > -		set_fs(USER_DS);
>> >  }
>> 
>> Yeah but now you're doing it unconditionally, the guard is here
>> because the %asi register write which set_fs() does is extremely
>> expensive on sparc64 and %99.99999 of the time we can avoid it.
> 
> OTOH, get_thread_current_ds() is cheap and moving that into set_fs()
> itself wouldn't be particulary bad idea...

The reason the test is only in this specific spot, is that's the only
place where the optimization makes any sense.

The rest of the time it's in compat layer code or similar, where we
know the set_fs() is actually necessary.

Therefore, expanding the test into every set_fs() call would be
wasteful.
