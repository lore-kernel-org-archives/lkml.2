Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2ATOCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:02:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2ATOCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:02:01 -0500
Date: Fri, 20 Jan 2012 15:01:57 +0100
From: Jan Kara <jack@suse.cz>
To: Tomer Margalit <tomermargalit@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nezer Zaidenberg <nzaidenberg@mac.com>
Subject: Re: Failing a bio right
Message-ID: <20120120140157.GA11241@quack.suse.cz>
References: <CAG3n4CS5vyx2sn9t0geQoxa+kE+Nk9Q-0fwTCU6o9iQ33bORjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG3n4CS5vyx2sn9t0geQoxa+kE+Nk9Q-0fwTCU6o9iQ33bORjA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Thu 19-01-12 18:04:19, Tomer Margalit wrote:
> I have a make_request function that blocks writes (by using
> wait_event_interruptible on some event).
> I want the user to be able to stop the function if it takes too long
> (that's the reason for the interruptible version).
> So when the call is interrupted I call bio_endio with the EINTR error
> to signal the interruption.
> Usually this works fine, but after a lot of writes, the system says
> "lost page write due to I/O error on device".
  This is because end_buffer_write_sync() doesn't really distinguish
errors.  So when some error happens it complains about I/O error.

> At this point the process hangs.
  That is strange - you should probably collect stack trace of the failing
process (e.g. via 'echo w >/proc/sysrq-trigger'). That should tell us more.

> Is this the right way to do what I'm trying to do?
  I'm not sure how is it supposed to work. Writes happen usually in an
async manner (through page cache and flusher thread) or are you using
direct IO? Also if a write is interrupted at this point, you just lost the
content of the buffer (as it is marked clean and !uptodate). Users usually
don't like that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
