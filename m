Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0I0WgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:36:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33697
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757411Ab0I0WgT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:36:19 -0400
Date: Mon, 27 Sep 2010 15:36:39 -0700 (PDT)
Message-Id: <20100927.153639.212415479.davem@davemloft.net>
To: dipankar@in.ibm.com
Cc: eric.dumazet@gmail.com, holt@sgi.com, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, den@openvz.org, mingo@elte.hu, mszeredi@suse.cz,
        cmm@us.ibm.com, npiggin@kernel.dk, xemul@openvz.org,
        linux-kernel@vger.kernel.org
Subject: Re: When booting a 16TB system, unix_create1 fails due to integer
 overflow.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100923141037.GA3811@in.ibm.com>
References: <20100923121704.GR14064@sgi.com>
	<1285246384.362.3.camel@edumazet-laptop>
	<20100923141037.GA3811@in.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dipankar Sarma <dipankar@in.ibm.com>
Date: Thu, 23 Sep 2010 19:40:37 +0530

> On Thu, Sep 23, 2010 at 02:53:04PM +0200, Eric Dumazet wrote:
>> Le jeudi 23 septembre 2010 à 07:17 -0500, Robin Holt a écrit : 
>> > I do not know which direction to take, but here is the summary of the
>> > problem.
>> > 
>> > We recently started trying to boot a customer's two new machines which
>> > are configured with 384GB short of 16TB of memory.
>> > 
>> > We were seeing a failure which prevented boot.  The kernel was incapable
>> > of creating either a named pipe or unix domain socket.  This comes down
>> > to a common kernel function called unix_create1() which does:
>> > 
>> > 	atomic_inc(&unix_nr_socks);
>> > 	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
>> > 		goto out;
>> > 
>> 
>> Hi Robin
>> 
>> I would say : We can use atomic_long_t instead of atomic_t
>> 
>> And make get_max_files(void) return a long ?
>> 
>> Something like :
>> 
>> 
>>  fs/file_table.c    |   10 +++++-----
>>  include/linux/fs.h |    2 +-
>>  net/unix/af_unix.c |   14 +++++++-------
>>  3 files changed, 13 insertions(+), 13 deletions(-)
>> 
>> diff --git a/fs/file_table.c b/fs/file_table.c
>> 
>>  	n = (mempages * (PAGE_SIZE / 1024)) / 10;
>> -	files_stat.max_files = n; 
>> +	files_stat.max_files = min(n, 0x7FFFFFFFUL);
> 
> It may be cleaner to just convert both the file counters and
> the file limits to usnsigned long.
> 
> Other than that, this seems like a reasonable thing to do.

Is someone following up on integrating this upstream so this thing
gets fixed?

Thanks.
