Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0DMJ10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:27:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0DMJ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:27:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Tue, 13 Apr 2010 11:26:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201004121934.18307.arnd@arndb.de> <20100412215320.GF8285@nowhere>
In-Reply-To: <20100412215320.GF8285@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004131126.27482.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Vp1A5wIvi+r9zfw7a5uScBslDVSFXuTitWD/
 P5Y2uoncYqKL5TDLp2vZpsolYEMzd23XFGgJLXDoYGEI2xb2Ql
 1fhCaHA/8wJY3mCxkC+8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 April 2010, Frederic Weisbecker wrote:
> On Mon, Apr 12, 2010 at 07:34:17PM +0200, Arnd Bergmann wrote:
> > 
> > I think the rule set for the conversion needs to be one that can
> > be done purely based on the code. How about this:
> > 
> > For each file operation {
> >       if (uses f_pos) {
> >               if (same module uses BKL)
> >                       -> default_llseek
> >               else
> >                       -> generic_file_llseek
> >       } else {
> >               if (driver maintained)
> >                       -> no_llseek (with maintainer ACK)
> >               else
> >                       -> noop_llseek
> >       }
> > }
> 
> It is also hard to determine a given driver really doesn't use
> the bkl. A sole lock_kernel() grep in its files is not sufficient.
> But a manual second pass should do the trick.

Why not? In my 2.6.33 based series, I have removed all implicit
uses of the BKL, so we can be sure that it doesn't use the BKL
unless the module is part of that series. The only two cases
I can think of are:

- ioctl callback, which we should do in the same change, like I
originally did. If a driver defines ->ioctl(), make it use
deprecated_ioctl() and default_llseek()/deprecated_llseek.

- Any of the file systems from Jan's series.

	Arnd
