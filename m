Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab1DOVEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:04:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1DOVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:04:41 -0400
Subject: Re: hugetlb locking bug.
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
References: <20110415201652.GA5131@redhat.com>
	 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 23:07:05 +0200
Message-ID: <1302901625.2035.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 13:49 -0700, Linus Torvalds wrote:
> Hmm. Adding the hugetlbfs/lockdep people to the cc.
> 
> This _looks_ like the same kind of false positive we've had with some
> other cases: we're taking the i_mutex lock only dor directory inodes
> (for the readdir) and we take the i_mmap lock only for non-directory
> inodes, so you can't actually get any real circular locking issues.
> 
> So yes, we do mix the order of i_mmap_sem and i_mutex, but it's
> conceptually two "different" kinds of i_mutex that just happen to
> share a name.
> 
> And I really thought we annotated it as such with different
> "lockdep_set_class()" cases (ie the whole
> 
>   lockdep_set_class(&inode->i_mutex,&type->i_mutex_dir_key);
> 
> for the S_ISDIR case in unlock_new_inode().
> 
> Can somebody more alert than me see why this lockdep issue still
> triggers with hugetlbfs? 

afaict hugetlbfs doesn't actually end up calling unlock_new_inode()
which does the whole IS_DIR() lockdep annotation, but then I might have
gotten lost in the whole inode allocation dance.

