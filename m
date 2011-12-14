Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1LNMLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:11:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53090 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1LNMLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:11:43 -0500
Subject: Re: hugetlb locking bug.
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>,
        Tyler Hicks <tyhicks@canonical.com>
Date: Wed, 14 Dec 2011 06:59:13 -0500
In-Reply-To: <BANLkTinSytqYA6ozOQEQ16VkRU4gFYpqvg@mail.gmail.com>
References: <20110415201652.GA5131@redhat.com>
	 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
	 <20110415205712.GA13049@infradead.org> <1302901766.2035.39.camel@laptop>
	 <BANLkTimg+sVCAE17jLE9oz301oruVZbdbw@mail.gmail.com>
	 <BANLkTinSytqYA6ozOQEQ16VkRU4gFYpqvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323863956.1954.50.camel@falcor>
Mime-Version: 1.0
x-cbid: 11121412-6148-0000-0000-000001F362D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 14:27 -0700, Linus Torvalds wrote:
> On Fri, Apr 15, 2011 at 2:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > (Warning: whitespace damage and TOTALLY UNTESTED)
> 
> Gaah. That won't work. Or rather, it probably may work, but while
> working it will spam the logs with that
> 
>     WARN_ON(!(inode->i_state & I_NEW));
> 
> thing from unlock_new_inode.
> 
> So the sane thing to do would be apparently one of
> 
>  (a) ignore the whole thing, and just accept the false lockdep warning.
> 
>       which I'd be willing to do, but it might be hiding some real
> ones, so we probably shouldn't.
> 
>  (b) just remove that WARN_ON(), and use the one-liner I suggested
> 
>  (c) extract the "set directory i_mutex key" logic into a new helper
> function for the case of filesystems like hugetlbfs that don't want to
> use unlock_new_inode() for one reason or another.
> 
> Personally, I don't have any really strong preferences and would
> probably just go for (b) to keep the patch small and simple. Anybody?
> 
>                      Linus

Since this discussion, commit "e096d0c lockdep: Add helper function for
dir vs file i_mutex annotation" defined a helper function
lockdep_annotate_inode_mutex_key(), but only hugetlbfs calls it.  There
are plenty of other places where new_inode() is called without
unlock_new_inode() (eg. proc, devpts, debugfs, ramfs, ...).  Is this
omission intentional or should they be annotated?  

An incomplete patch was posted
http://marc.info/?l=linux-fsdevel&m=132369346810326&w=2

(Tyler Hicks' "vfs: Correctly set the dir i_mutex lockdep class" patch
http://marc.info/?l=linux-fsdevel&m=132370587315054&w=2 should be
prereq'ed.)

thanks,

Mimi

