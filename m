Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184Ab1CXUiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:38:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59008 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1CXUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:38:00 -0400
Date: Thu, 24 Mar 2011 20:37:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Reichelt <debian@nachtgeist.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for
 /proc/<pid> dirs
Message-ID: <20110324203758.GF22723@ZenIV.linux.org.uk>
References: <4D8AC408.9000503@nachtgeist.net>
 <20110324073225.GA3806@p183.telecom.by>
 <4D8B03D6.2090204@nachtgeist.net>
 <20110324182230.GB5187@p183.telecom.by>
 <4D8B991E.5070604@nachtgeist.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B991E.5070604@nachtgeist.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:18:54PM +0100, Daniel Reichelt wrote:
> Well, my patch is about modes of the pid-dirs themselves, not their
> contents. And it changes procfs' behaviour about modes both on initial
> creation and during revalidation on access. However flattening all the
> piddir's entries DOES pose a security risk. Have a look at the
> "traditional behaviour": piddir world-readable, however e.g.
> <pid>/environ isn't. Often it's a workaround for broken software to
> specify a password within an environment variable instead of by cmdline.
> Since up until now all processes including their full cmdlines are
> visible to everyone, environ must be considered more sensitive than a
> cmdline.

Bull.  /proc/<pid>/foo contents is sensitive, your patch doesn't do
you any good.  fork(), open /proc/<child's PID>/foo in parent, then
exec suid-root binary in child.  At that point mode_t of any files
or directories does not matter anymore.

You *must* do whatever access checks at read(2) time for these files.
And if you do that, the checks at open(2) time do not matter.

In particular, /proc/*/environ does ptrace_may_access() on read(2) (with
a race fixed by today's merge, BTW).  It could very well be r--r--r--;
having it r-------- does not increase security at all.
