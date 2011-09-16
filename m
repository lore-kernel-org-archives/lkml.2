Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1IPPgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 11:36:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40990 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1IPPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 11:36:22 -0400
Date: Fri, 16 Sep 2011 09:36:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andres Freund <andres@anarazel.de>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        robertmhaas@gmail.com, pgsql-hackers@postgresql.org
Subject: Re: Improve lseek scalability v3
Message-ID: <20110916153620.GA9913@parisc-linux.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20110916130054.GA8997@parisc-linux.org> <201109161616.50004.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109161616.50004.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 04:16:49PM +0200, Andres Freund wrote:
> I sent an email containing benchmarks from Robert Haas regarding the Subject. 
> Looking at lkml.org I can't see it right now, Will recheck when I am at home.
> 
> He replaced lseek(SEEK_END) with fstat() and got speedups up to 8.7 times the 
> lseek performance.
> The workload was 64 clients hammering postgres with a simple readonly workload 
> (pgbench -S).

Yay!  Data!

> For reference see the thread in the postgres archives which also links to 
> performance data: http://archives.postgresql.org/message-
> id/CA+TgmoawRfpan35wzvgHkSJ0+i-W=VkJpKnRxK2kTDR+HsanWA@mail.gmail.com

So both fstat and lseek do more work than postgres wants.  lseek modifies
the file pointer while fstat copies all kinds of unnecessary information
into userspace.  I imagine this is the source of the slowdown seen in
the 1-client case.

There have been various proposals to make the amount of information returned
by fstat limited to the 'cheap' (for various definitions of 'cheap') fields.

I'd like to dig into the requirement for knowing the file size a little
better.  According to the blog entry it's used for "the query planner".
Does the query planner need to know the exact number of bytes in the file,
or is it after an order-of-magnitude?  Or to-the-nearest-gigabyte?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
