Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1IPOXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:23:42 -0400
Received: from mail.anarazel.de ([217.115.131.40]:39599 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1IPOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:23:40 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 10:23:40 EDT
From: Andres Freund <andres@anarazel.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Improve lseek scalability v3
Date: Fri, 16 Sep 2011 16:16:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20110916130054.GA8997@parisc-linux.org>
In-Reply-To: <20110916130054.GA8997@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161616.50004.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 Sep 2011 15:00:55 Matthew Wilcox wrote:
> On Thu, Sep 15, 2011 at 04:06:46PM -0700, Andi Kleen wrote:
> > Currently generic_file_llseek users synchronize all on the inode i_mutex,
> > which is very heavy handed because it affects even different processes.
> > 
> > This patchkit attempts to make generic_file_llseek (mostly) lockless.
> 
> Yes, but, are there any real workloads which care?  I know will-it-scale
> says that lseek doesn't scale, but any real app which has a seek-heavy
> workload is surely using pread()/pwrite() by now ... after all, they
> were in UNIX98 so they've been a standard for 13 years.
I sent an email containing benchmarks from Robert Haas regarding the Subject. 
Looking at lkml.org I can't see it right now, Will recheck when I am at home.

He replaced lseek(SEEK_END) with fstat() and got speedups up to 8.7 times the 
lseek performance.
The workload was 64 clients hammering postgres with a simple readonly workload 
(pgbench -S).

For reference see the thread in the postgres archives which also links to 
performance data: http://archives.postgresql.org/message-
id/CA+TgmoawRfpan35wzvgHkSJ0+i-W=VkJpKnRxK2kTDR+HsanWA@mail.gmail.com

You likely won't be able to see the bottlenecks with any of the released 
postgres versions as there are bottlenecks fixed in HEAD that throttle way 
before that.

In the other mail I wrote that I forward ported v1 of this patch to v3.1-rc1 
and tested it on the biggest machine I could easily reboot into an 
experimental kernel.
That machine was only a 2 socket x 4 cores (+ht) nehalem machine though. The 
benefits I measured at it were between 1-3% if memory serves right. Its not 
surprising though that the problem is not that visible at such a comparatively 
low concurrency.
In Roberts Tests the concurrency difference started to show at around 40 
clients.

I looked at all the patches (as I said V1 some weeks back) and they looked 
reasonable to me.
My aforementioned machine runs v1 rebased onto newer kernels for the last 
weeks without problems.

Greetings,

Andres
