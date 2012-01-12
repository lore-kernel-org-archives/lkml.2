Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2ALIGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:06:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51391 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ALIGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:06:39 -0500
Message-ID: <1326355594.1999.7.camel@lappy>
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
From: Sasha Levin <levinsasha928@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lizf@cn.fujitsu.com, penberg@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>, ecryptfs@vger.kernel.org
Date: Thu, 12 Jan 2012 10:06:34 +0200
In-Reply-To: <20120111141219.271d3a97.akpm@linux-foundation.org>
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>
	 <20120111141219.271d3a97.akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 14:12 -0800, Andrew Morton wrote:
> There's nothing particularly special about memdup_user(): there are
> many ways in which userspace can trigger GFP_KERNEL allocations.
> 
> The problem here (one which your patch carefully covers up) is that
> ecryptfs_miscdev_write() is passing an unchecked userspace-provided
> `count' direct into kmalloc().  This is a bit problematic for other
> reasons: it gives userspace a way to trigger heavy reclaim activity and
> perhaps even to trigger the oom-killer.
> 
> A better fix here would be to validate the incoming arg before using
> it.  Preferably by running ecryptfs_parse_packet_length() before taking
> a copy of the data.  That would require adding a small copy_from_user()
> to peek at the message header. 

Let's split it to two parts: the specific ecryptfs issue I've given as
an example here, and a general view about memdup_user().

I fully agree that in the case of ecryptfs there's a missing validity
check, and just calling memdup_user() with whatever the user has passed
to it is wrong and dangerous. This should be fixed in the ecryptfs code
and I'll send a patch to do that.

The other part, is memdup_user() itself. Kernel warnings are usually
reserved (AFAIK) to cases where it would be difficult to notify the user
since it happens in a flow which the user isn't directly responsible
for.

memdup_user() is always located in path which the user has triggered,
and is usually almost the first thing we try doing in response to the
trigger. In those code flows it doesn't make sense to print a kernel
warnings and taint the kernel, instead we can simply notify the user
about that error and let him deal with it any way he wants.

There are more reasons kalloc() can show warnings besides just trying to
allocate too much, and theres no reason to dump kernel warnings when
it's easier to notify the user.

-- 

Sasha.

