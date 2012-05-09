Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab2EIQZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:25:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39560 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760204Ab2EIQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:25:04 -0400
Date: Wed, 9 May 2012 17:25:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: INFO: possible circular locking dependency detected
Message-ID: <20120509162459.GL22082@ZenIV.linux.org.uk>
References: <1336577114.3638.23.camel@lappy>
 <20120509161203.GK22082@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509161203.GK22082@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 05:12:03PM +0100, Al Viro wrote:
> On Wed, May 09, 2012 at 05:25:14PM +0200, Sasha Levin wrote:
> > Hi all,
> > 
> > I've started seeing the following warning while fuzzing inside a KVM guest with the latest -next:
> 
> [->read() may grab ->cred_guard_mutex, but it may itself be called by
> prepare_binprm() after having ->cred_guard_mutex grabbed]
> 
> Nasty, that...  What's more, it's not just prepare_binprm() itself -
> ->load_binary() might end up calling read(); it doesn't have to
> limit itself to mmap(), so essentially anything that can be grabbed
> by ->read() of a regular file might nest under ->cred_guard_mutex.
> 
> 	AFAICS, /proc/*/stack, /proc/*/syscall, /proc/*/personality,
> /proc/*/io_accounting, /proc/*/auxv, /proc/*/environ, /proc/*/*maps
> and /proc/*/pagemap have ->cred_guard_mutex grabbed on read.  seq_file
> is a red herring here - io_accounting has the same issue and it does
> things directly, without seq_read().
> 
> 	It's not a realistic attack, fortunately, since you need root
> to get past open_exec() on any of those...  Wait.  How _did_ you get
> past open_exec(), anyway?  MAY_EXEC is not supposed to be granted on
> anything that has no exec bits at all and AFAICS none of those files
> have them.

FWIW, that's _probably_ a false positive, but I really wonder what has
triggered it.  It would take seq_file-based file somewhere with _some_
exec bits set (otherwise it shouldn't have been seen by prepare_binprm()).
The file itself isn't one of those that grab ->cred_guard_mutex anywhere
in their ->read(), but since lockdep can't tell one seq_file from another,
we get the warning.

	The interesting part is who the hell had managed to do executable
seq_file-based anything - false positive or not, it's almost certainly
a bug...
