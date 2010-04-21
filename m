Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0DUTXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:23:17 -0400
Received: from exhub016-4.exch016.msoutlookonline.net ([207.5.72.225]:15751
	"EHLO EXHUB016-4.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033Ab0DUTXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:23:15 -0400
Message-ID: <4BCF509E.2040903@cfl.rr.com>
Date: Wed, 21 Apr 2010 15:23:10 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Evgeniy Polyakov <zbr@ioremap.net>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org>
In-Reply-To: <20100421185124.GM27575@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2010 2:51 PM, Jamie Lokier wrote:
> Fwiw, I found sorting directories by inode and reading them in that
> order help to reduce seeks, some 10 years ago.  I implemented
> something like 'find' which works like that, keeping a queue of
> directories to read and things to open/stat, ordered by inode number
> seen in d_ino before open/stat and st_ino after.  However it did not
> try to readahead the blocks inside a directory, or sort operations by
> block number.  It reduced some 'find'-like operations to about a
> quarter of the time on cold cache.  I still use that program sometimes
> before "git status" ;-)  Google "treescan" and "lokier" if you're
> interested in trying it (though I use 0.7 which isn't published).

That helps with open()ing or stat()ing the files since you access the
inodes in order, but ureadahead already preloads all of the inode tables
so this won't help.

>> it is not about readdir(). Plain read() is synchronous too. But
>> filesystem can respond to readahead calls and read next block to current
>> one, while it won't do this for next direntry.
> 
> I'm surprised it makes much difference, as directories are usually not
> very large anyway.

That's just it; it doesn't help.  That's why I want to readahead() all
of the directories at once instead of reading them one block at a time.

> But if it does, go on, try FIEMAP and blockdev reading, you know you
> want to :-)

Why reinvent the wheel when that's readahead()'s job?  As a workaround
I'm about to try just threading all of the calls to open().  Each one
will queue a read and block, but with them all doing so at once should
fill the queue with plenty of reads.  It is inefficient, but better than
one block at a time.
