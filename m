Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3AFQbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:31:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37714 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab3AFQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:31:04 -0500
Date: Sun, 6 Jan 2013 16:31:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Meredydd Luff <meredydd@senatehouse.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH signal#execve2] syscalls,x86: Add execveat() system call
 (v3)
Message-ID: <20130106163100.GI4939@ZenIV.linux.org.uk>
References: <1347411352-12392-1-git-send-email-meredydd@senatehouse.org>
 <20120912011654.GQ13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912011654.GQ13973@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, now that sys_execve() unification has settled down, let's get back
to this one.  The real problem is what you are doing with bprm->filename
and bprm->interp; blind use of ->d_name is completely wrong.

For what it's worth, how should it work for e.g. shell scripts?  That's
the main user of bprm->{filename,interp}, after all - other places are
either seriously exotic or are just using it for printks.

For shell scripts, however, these guys are really used - we have the original
argv[0] removed and <shell name> <optional argument> <filename> pushed in
its place.

How will it work with execveat()?  If we have procfs in place, we can
cook an equivalent pathname (/proc/self/fd/<n>/<relative part of pathname>),
but then why not do just that in userland and be done with that?
