Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0DWPCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:02:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab0DWPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:02:51 -0400
Date: Fri, 23 Apr 2010 08:00:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH] cleanup block based fiemap
In-Reply-To: <20100423144420.GC2351@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004230753480.3739@i5.linux-foundation.org>
References: <20100423144420.GC2351@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Apr 2010, Josef Bacik wrote:
> 
> I'm resending this patch again since it doesn't seem to have made it in yet.
> The generic block fiemap stuff doesn't use the right typing and has a problem
> with not setting the last extent flag properly.  Also there is an issue with
> GFS2 where it doesn't like non-block aligned requests, so this fixes all these
> issues.  Thanks,

I'd really like the patch to clean up the crazy stuff too.

As-is, there's at least two remaining issues I see from just reading the 
patch:

> +	if (len >= i_size_read(inode)) {
> +		whole_file = true;
> +		len = i_size_read(inode);
> +	}
...
>  			if (!past_eof &&
>  			    blk_to_logical(inode, start_blk) >=
> -			    blk_to_logical(inode, 0)+i_size_read(inode))
> +			    blk_to_logical(inode, 0) + i_size_read(inode))
>  				past_eof = 1;

Issue #1: it does that i_size_read() several times. What happens if the 
file grows? Maybe we hold the i_mutex already, although I don't see it. 
Regardless, it seems bogus to read the size several times.

Issue #2: "blk_to_logical(inode, 0)"? WTF? Since when has shifting zero 
ever resulted in anything interesting or relevant? There's at least two of 
those things.

		Linus
