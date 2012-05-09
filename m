Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab2EIQhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:37:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288Ab2EIQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:37:33 -0400
Date: Wed, 9 May 2012 17:37:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: INFO: possible circular locking dependency detected
Message-ID: <20120509163732.GN22082@ZenIV.linux.org.uk>
References: <1336577114.3638.23.camel@lappy>
 <20120509161203.GK22082@ZenIV.linux.org.uk>
 <CA+1xoqdEFOBPSng99jFcgj9Un9ZguXqKhXYdDCeKv3k5nLrC6Q@mail.gmail.com>
 <20120509162854.GM22082@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509162854.GM22082@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 05:28:54PM +0100, Al Viro wrote:
> On Wed, May 09, 2012 at 06:23:30PM +0200, Sasha Levin wrote:
> > On Wed, May 9, 2012 at 6:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > On Wed, May 09, 2012 at 05:25:14PM +0200, Sasha Levin wrote:
> > >> Hi all,
> > >>
> > >> I've started seeing the following warning while fuzzing inside a KVM guest with the latest -next:
> > > ? ? ? ?It's not a realistic attack, fortunately, since you need root
> > > to get past open_exec() on any of those... ?Wait. ?How _did_ you get
> > > past open_exec(), anyway? ?MAY_EXEC is not supposed to be granted on
> > > anything that has no exec bits at all and AFAICS none of those files
> > > have them.
> > 
> > You could chmod +x and run them, no?
> 
> Can't.  proc_setattr() will give you -EPERM and refuse to do anything
> if you call it with ATTR_MODE in ->ia_valid.

OTOH, you probably can do that on unrelated seq_file outside of per-process
part of procfs.  So, yes, one could get a warning like that if they, as root,
would do e.g.
chmod +x /proc/swaps
attempt to execve() /proc/swaps
cat /proc/self/environ
and enjoy the hard-earned false positive (it's a different seq_file, so
we have no deadlock).  If that's _all_ that happened, I'm not particulary
concerned; it's not pretty, but saying "thou shalt not grab ->cred_guard_mutex
anywhere in ->read() on anything that has exec bits or might get one" is
not too terrible.  If that's something else, though, we might have a real
problem...
