Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1GKAZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 20:25:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55323 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1GKAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 20:25:16 -0400
Date: Sun, 10 Jul 2011 20:25:02 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jbd2,rcu: correctly use RCU
Message-ID: <20110711002502.GC28763@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:47:04AM +0800, Lai Jiangshan wrote:
> In read site, we need to use local_ptr = rcu_dereference(),
> and then use this local_ptr to read the content.
> 
> In update site, we should assign/publish the new object/pointer after
> the content of the new object/pointer is fully initialized,
> and we can't not touch the object after the pointer assignment.
> rcu_assign_pointer() is need for the assignement.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks, applied.

> @@ -2447,24 +2447,25 @@ const char *jbd2_dev_to_name(dev_t device)
>  	int	i = hash_32(device, CACHE_SIZE_BITS);
>  	char	*ret;
>  	struct block_device *bd;
> -	static struct devname_cache *new_dev;
> +	static struct devname_cache *cache;

I also removed the static modifier to the struct devname_cache
pointer.  It's pointless, and in fact introduces a bug if two CPU's
try to run jbd2_dev_to_name() at the same time.

						- Ted
