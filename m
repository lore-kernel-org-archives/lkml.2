Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0HWTIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:08:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0HWTIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:08:05 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <4C72C2E9.3070408@goop.org>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
	 <1282470917.11348.891.camel@localhost.localdomain>
	 <20100822172548.GB8957@suse.de>
	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
	 <19570.38608.79434.179797@chiark.greenend.org.uk>
	 <1282580751.2605.1997.camel@laptop>
	 <19570.44367.719276.128881@chiark.greenend.org.uk>
	 <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
	 <4C72C2E9.3070408@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 21:07:37 +0200
Message-ID: <1282590457.2605.2200.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 11:50 -0700, Jeremy Fitzhardinge wrote:
> On 08/23/2010 10:34 AM, Linus Torvalds wrote:
> > Quite frankly, I personally believe that people who play games with
> > mlock are misguided. The _one_ special case is for protecting keys or
> > private data that you do not want to hit the disk in some unencrypted
> > mode, and quite frankly, you should strive to handle those way more
> > specially than just putting them in some random place ("on the stack"
> > or "in some malloc()'ed area"). The sane model for doing that is
> > generally to explicitly mmap() and mlock the area, so that you get a
> > very controlled access pattern, and never have to worry about things
> > like COW etc.
> 
> Is that guaranteed to work (in Linux or in general)?  mlock has always
> meant "won't generate disk IO to fault in/evicted", but does it prevent
> dirty pages from being written out so long as they also remain
> resident?  Or does it depend on the precise type of page you're
> mlocking?  For example, what does mlock on a shared writeable mapping mean?

mlock() simply avoids major faults, nothing more.

I think both page migration and page-out for shared pages where some
maps are !mlocked can cause unmaps and thus minor faults.

mlock and dirty do not interact, they will still be cleaned/written out
as normal.
