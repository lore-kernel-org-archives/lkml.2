Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab1ISNZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:25:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39673 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab1ISNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:25:04 -0400
Date: Mon, 19 Sep 2011 07:25:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stephen Frost <sfrost@snowman.net>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Andres Freund <andres@anarazel.de>,
        Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        robertmhaas@gmail.com, pgsql-hackers@postgresql.org
Subject: Re: [HACKERS] Improve lseek scalability v3
Message-ID: <20110919132500.GA16740@parisc-linux.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161616.50004.andres@anarazel.de> <20110916153620.GA9913@parisc-linux.org> <201109161927.34472.andres@anarazel.de> <20110916200817.GD28519@kvack.org> <20110919123100.GJ12765@tamriel.snowman.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919123100.GJ12765@tamriel.snowman.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 08:31:00AM -0400, Stephen Frost wrote:
> * Benjamin LaHaise (bcrl@kvack.org) wrote:
> > For such tables, can't Postgres track the size of the file internally?  I'm 
> > assuming it's keeping file descriptors open on the tables it manages, in 
> > which case when it writes to a file to extend it, the internally stored size 
> > could be updated.  Not making a syscall at all would scale far better than 
> > even a modified lseek() will perform.
> 
> We'd have to have it in shared memory and have a lock around it, it
> wouldn't be cheap at all.

Yep, that makes perfect sense.  After all, the kernel does basically the
same thing to maintain this information; why should we have userspace
duplicating the same infrastructure?

I must admit, I'd never heard of this usage of lseek to get the current
size of a file before; I'd assumed everybody used fstat.  Given this
legitimate reason for a high-frequency calling of lseek, I withdraw my
earlier objection to the patch series.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
