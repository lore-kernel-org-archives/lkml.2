Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2ACTSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:18:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42812 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2ACTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:17:40 -0500
MIME-Version: 1.0
In-Reply-To: <1325616312.2095.26.camel@falcor>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
 <20111213180707.GI11747@quack.suse.cz> <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
 <20120102115222.GA3626@quack.suse.cz> <20120103010826.GF3626@quack.suse.cz>
 <20120103123841.GA31457@quack.suse.cz> <1325604356.2095.23.camel@falcor>
 <CA+55aFzwq6XiAnX26uV+-mNsbGbnj0S=4nP5avPqKPw8OT+cmw@mail.gmail.com> <1325616312.2095.26.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 11:17:18 -0800
X-Google-Sender-Auth: 7XS42709tXH57FY59JzxBlA2-oE
Message-ID: <CA+55aFwhrk_qYd6Fff8Ezhotta5dxcVYy8g9573uML8V1-=1Sg@mail.gmail.com>
Subject: Re: Reiserfs.c bug in 3.2-rc5
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Morris <jmorris@namei.org>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 10:45 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> Just clarifying not all of commit fb88c2b, but only the
> security_old_inode_init_security() hunk.

Is it really sane to have different semantics like that for the
security[_old]_inode_init_security functions?

Look at ocfs2, for example: it does nothing if
ocfs2_init_security_get() returns 0. That does not sound like the
correct thing to do, when the fallback is to do ocfs2_init_acl() under
the lock.

And ocfs2_init_security_get() just calls either
security_inode_init_security() or security_old_inode_init_security()
depending on whether ocfs2_security_xattr_info is NULL or not. So I
really think callers expect the same kind of semantics regardless of
whether it's the "old" or not version. Which would make sense anyway.

Also, the *documentation* in include/linux/security.h very much says
that it returns 0 only if @name and @value have been successfully set.
So my gut feel says that both security_inode_init_security and
security_old_inode_init_security should return -EOPNOTSUPP (although
the "new" version doesn't really have "name/value", so maybe returning
0 is ok)

Anyway, I'd love for (multiple) people who really know the code to
give me a clean agreement on exactly what the correct patch is.
Please?

                                 Linus
