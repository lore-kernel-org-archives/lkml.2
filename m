Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2K1Tn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:43:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2K1TnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:43:25 -0500
Date: Wed, 28 Nov 2012 19:43:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Message-ID: <20121128194314.GF4939@ZenIV.linux.org.uk>
References: <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk>
 <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk>
 <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk>
 <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:15:12AM -0800, Linus Torvalds wrote:
> No, this is crap.
> 
> We don't introduce random hooks like this just because the block layer
> has shit-for-brains and cannot be bothered to do things right.
> 
> The fact is, the whole locking in the block layer open routine is
> total and utter crap. It doesn't lock the right thing, even with your
> change *anyway* (or with the change Jens had). Absolutely nothing in
> "mmap_region()" cares at all about the block-size anywhere - it's
> generic, after all - so locking around it is f*cking pointless. There
> is no way in hell that the caller of ->mmap can *ever* care about the
> block size, since it never even looks at it.
> 
> Don't do random crap like this.
> 
> Why does the code think that mmap matters so much anyway? As you say,
> the mmap itself does *nothing*. It has no impact for the block size.

... and here I was, trying to massage a reply into form that would be
at least borderline printable...  Anyway, this is certainly the wrong
way to go.  We want to catch if the damn thing is mapped and mapping_mapped()
leaves a race?  Fine, so let's not use mapping_mapped() at all.  Have a
private vm_operations - a copy of generic_file_vm_ops with ->open()/->close()
added to it.  Incrementing/decrementing a per-block_device atomic counter,
with increment side done under your rwsem, to make sure that 0->positive
transition doesn't change in critical section of set_blocksize().  And don't
use generic_file_mmap(), just do file_accessed() and set ->vm_ops to that
local copy.
