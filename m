Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0ESP5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:57:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43253 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0ESP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:57:00 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: miklos@szeredi.hu, npiggin@suse.de, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, peterz@infradead.org,
       fweisbec@gmail.com, tardyp@gmail.com, mingo@elte.hu, acme@redhat.com,
       tzanussi@gmail.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org, ziga.mahkovec@gmail.com, davem@davemloft.net,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, tj@kernel.org,
       jens.axboe@oracle.com
In-reply-to: <alpine.LFD.2.00.1005190831460.23538@i5.linux-foundation.org>
	(message from Linus Torvalds on Wed, 19 May 2010 08:32:15 -0700 (PDT))
Subject: Re: Unexpected splice "always copy" behavior observed
References: <20100518153440.GB7748@Krystal> <1274197993.26328.755.camel@gandalf.stny.rr.com> <1274199039.26328.758.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org> <20100519063116.GR2516@laptop>
 <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org> <E1OElCI-0005v6-4D@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190831460.23538@i5.linux-foundation.org>
Message-Id: <E1OEldM-00063C-Ew@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 May 2010 17:56:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Linus Torvalds wrote:
> On Wed, 19 May 2010, Miklos Szeredi wrote:
> > 
> > Another limitation I found while splicing from one file to another is
> > that stealing from the source file's page cache does not always
> > succeed.  This turned out to be because of a reference from the lru
> > cache for freshly read pages.  I'm not sure how this could be fixed.
> 
> It should be fixed by saying "you can't always just move the page".
> 
> Copying is not evil. Complexity  to avoid copies is evil.

And predictability is good.  The thing I don't like about the above is
that it makes it totally unpredictable which pages will get moved, if
any.

Another related thing: if splicing from a file knowing that it will
need to be stolen, then it makes zero sense to first insert the pages
into the page cache then remove them shortly to be inserted into
another file's cache.  So we could have a flag saying "don't cache
newly read pages, just put them in the pipe buffer", which would solve
the above problem as well as speeding up the operation.

Miklos
