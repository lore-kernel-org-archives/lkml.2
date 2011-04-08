Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1DHR4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:56:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab1DHR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:56:06 -0400
Date: Fri, 8 Apr 2011 10:56:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Rago <sar@nec-labs.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Allow O_SYNC to be set by fcntl(F_SETFL)
Message-Id: <20110408105602.bb8f1b49.akpm@linux-foundation.org>
In-Reply-To: <4D9F4844.7090908@nec-labs.com>
References: <4D6824A4.6030009@nec-labs.com>
	<20110407143719.4044c00d.akpm@linux-foundation.org>
	<4D9F4844.7090908@nec-labs.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Apr 2011 13:39:16 -0400
Steve Rago <sar@nec-labs.com> wrote:

> > I wonder if we should sync the file when someone sets O_SYNC this way.
> > If we don't then there is a period during which we have an fd which has
> > O_SYNC set, but it has pending unwritten data.  An O_SYNC fd should
> > never be in such a state!
> 
> Why not?

Because it's inconsistent.  An O_SYNC fd never has outstanding writeout. 
Except for in this one new and special time window between a setfl()
and the next write().

It's not a big deal, but it's somewhat ugly and merits thinking about.

>  If I write something in non-synchronous mode, then change the file descriptor to synchronous mode, I should 
> not make any assumptions about what was written prior to this point.  If I care that much, I'll call fsync.

Well.  You can call fsync() after every write() too.

>  All that 
> matters is that the operating system honors the contract as specified by the system call API.

There's a lot more to it than that.  Things like
quality-of-implementation and principle-of-least-surprise.  We used to
have a particular relationship between an O_SYNC fd and the state of
the inode which it represents.  With this patch, that relationship no
longer holds.

As I say: not a big deal IMO, but it should be aired and thought about.
