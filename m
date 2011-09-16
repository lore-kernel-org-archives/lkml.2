Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1IPVCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:02:46 -0400
Received: from mail.anarazel.de ([217.115.131.40]:45484 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab1IPVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:02:45 -0400
From: Andres Freund <andres@anarazel.de>
To: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: Improve lseek scalability v3
Date: Fri, 16 Sep 2011 23:02:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc5-andres; KDE/4.6.5; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, robertmhaas@gmail.com,
        pgsql-hackers@postgresql.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161927.34472.andres@anarazel.de> <20110916200817.GD28519@kvack.org>
In-Reply-To: <20110916200817.GD28519@kvack.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109162302.38780.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 16, 2011 10:08:17 PM Benjamin LaHaise wrote:
> On Fri, Sep 16, 2011 at 07:27:33PM +0200, Andres Freund wrote:
> > many tuples does the table have. Those statistics are only updated every
> > now and then though.
> > So it uses those old stats to check how many tuples are normally stored
> > on a page and then uses that to extrapolate the number of tuples from
> > the current nr of pages (which is computed by lseek(SEEK_END) over the
> > 1GB segements of a table).
> > 
> > I am not sure how interested you are on the relevant postgres internals?
> 
> For such tables, can't Postgres track the size of the file internally?  I'm
> assuming it's keeping file descriptors open on the tables it manages, in
> which case when it writes to a file to extend it, the internally stored
> size could be updated.  Not making a syscall at all would scale far better
> than even a modified lseek() will perform.
Yes, it tracks the fds internally. The problem is that postgres is process 
based so those tables are not reachable by all processes. It could start 
tracking those in shared memory but the synchronization overhead for that 
would likely be more expensive than the syscall overhead (Given that the 
fdsets are possibly (and realistically) disjunct between the individual 
backends you would have to reserve enough shared memory for a fully seperate 
fds between each process... Which would complicate efficient lookup).

Also with fstat() instead of lseek() there was no bottleneck anymore, so I 
don't think the benefits would warrant that.

Greetings,

Andres
