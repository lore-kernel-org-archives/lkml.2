Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2BPW7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:59:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab2BPW7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:59:35 -0500
Date: Thu, 16 Feb 2012 14:59:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dave@gnu.org
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locks: export device name
Message-Id: <20120216145934.5fd9772e.akpm@linux-foundation.org>
In-Reply-To: <1329431831.2753.3.camel@offbook>
References: <1328907967.3138.1.camel@offbook>
	<20120213163425.dd9adfde.akpm@linux-foundation.org>
	<20120214190906.GA5115@fieldses.org>
	<1329303162.3356.6.camel@offbook>
	<20120215124230.GA11393@fieldses.org>
	<20120215123929.6888c867.akpm@linux-foundation.org>
	<1329431831.2753.3.camel@offbook>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 23:37:11 +0100
Davidlohr Bueso <dave@gnu.org> wrote:

> On Wed, 2012-02-15 at 12:39 -0800, Andrew Morton wrote:
> > On Wed, 15 Feb 2012 07:42:30 -0500
> > "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > 
> > > > > Perhaps safest would be to replace /proc/locks by another interface and
> > > > > deprecate this one.
> > > > 
> > > > If exporting the name in the current /proc/locks file is out of the
> > > > question, then IMHO I don't think it would be worth adding a new
> > > > interface just for such a small change.
> > > 
> > > OK.
> > > 
> > > If you want to just change this over, I guess the thing to do would be
> > > to stick something in feature-removal-schedule.txt saying "we'll switch
> > > this in 2 years" (or however long you think before there are
> > > realistically no more lslk users left), then do it then.
> > > 
> > > Switching to a new api would be better as we could warn users of the old
> > > api then.  Maybe it'd be worth it if there was some other change we'd
> > > been wanting to make?   Can't think of anything off the top of my head.
> > > 
> > > We may be adding more lock types--will lslk and lslocks handle that
> > > gracefully?
> > 
> > Adding a whole new interface is pretty attractive.  It lets us get it
> > right this time.  In particular, something which is extensible given
> > certain simple rules.  As we've learned, the current /proc/locks didn't
> > get that right!
> 
> Ok, however I'm a bit confused on what you mean by extensible; since
> what we decide to export to userspace is pretty much permanent, how can
> we change (extend) it later? We'd pretty much be running into
> the /proc/locks situation now.

Mainly by avoiding the use of implicit identification via fixed
positions.  Look at /proc/stat and weep.

If we use a name:value format then we can add new fields later and
things work OK.  We add stuff to /proc/meminfo and /proc/vmstat all the
time.

Removing things is of course much harder.  The best fix is to avoid
adding things which we might ever have a reason for removing!  If we
have a field which we simply can no longer support and which we think
we must retain for back-compat reasons then we just have to find some
way to emulate it.  In extremis we could hardwire the value to "0" so
tools won't crash.

sysfs has a different convention: one-value-per-file.  That means
there's no need for the name part of name:value.  Extensibility means
"go add another sysfs file".

