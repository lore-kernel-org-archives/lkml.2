Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2ACWbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:31:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38654 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2ACWbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:31:38 -0500
Subject: Re: Reiserfs.c bug in 3.2-rc5
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Morris <jmorris@namei.org>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Date: Tue, 03 Jan 2012 17:28:36 -0500
In-Reply-To: <CA+55aFwhrk_qYd6Fff8Ezhotta5dxcVYy8g9573uML8V1-=1Sg@mail.gmail.com>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
	 <20111213180707.GI11747@quack.suse.cz>
	 <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
	 <20120102115222.GA3626@quack.suse.cz> <20120103010826.GF3626@quack.suse.cz>
	 <20120103123841.GA31457@quack.suse.cz> <1325604356.2095.23.camel@falcor>
	 <CA+55aFzwq6XiAnX26uV+-mNsbGbnj0S=4nP5avPqKPw8OT+cmw@mail.gmail.com>
	 <1325616312.2095.26.camel@falcor>
	 <CA+55aFwhrk_qYd6Fff8Ezhotta5dxcVYy8g9573uML8V1-=1Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1325629717.2095.81.camel@falcor>
Mime-Version: 1.0
x-cbid: 12010322-3270-0000-0000-000002F811C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 11:17 -0800, Linus Torvalds wrote:
> On Tue, Jan 3, 2012 at 10:45 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > Just clarifying not all of commit fb88c2b, but only the
> > security_old_inode_init_security() hunk.
> 
> Is it really sane to have different semantics like that for the
> security[_old]_inode_init_security functions?

No, but unfortunately it seems necessary.

> Look at ocfs2, for example: it does nothing if
> ocfs2_init_security_get() returns 0. That does not sound like the
> correct thing to do, when the fallback is to do ocfs2_init_acl() under
> the lock.

The original code did the same for -EOPNOTSUPP.

7192        ret = ocfs2_init_security_get(inode, dir, qstr, &si);
7193        if (!ret) {
7194                ret = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
7195                                      si.name, si.value, si.value_len,
7196                                      XATTR_CREATE);
7197                if (ret) {
7198                        mlog_errno(ret);
7199                        goto leave;
7200                }
7201        } else if (ret != -EOPNOTSUPP) {
7202                mlog_errno(ret);
7203                goto leave;
7204        }
7205
7206        ret = ocfs2_inode_lock(dir, &dir_bh, 0);
7207        if (ret) {
7208                mlog_errno(ret);
7209                goto leave;
7210        }
7211
7212        ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
7213        if (ret)
7214                mlog_errno(ret);
7215

> And ocfs2_init_security_get() just calls either
> security_inode_init_security() or security_old_inode_init_security()
> depending on whether ocfs2_security_xattr_info is NULL or not. So I
> really think callers expect the same kind of semantics regardless of
> whether it's the "old" or not version. Which would make sense anyway.
> 
> Also, the *documentation* in include/linux/security.h very much says
> that it returns 0 only if @name and @value have been successfully set.
> So my gut feel says that both security_inode_init_security and
> security_old_inode_init_security should return -EOPNOTSUPP (although
> the "new" version doesn't really have "name/value", so maybe returning
> 0 is ok)

The original security_inode_init_security() version queried the LSM for
the security xattr, leaving writing the xattr up to the caller.  The
caller changed -EOPNPTSUPP to 0, before returning.  The new version
combines the querying and writing the xattr.  Like the previous version
it converts the -EOPNOTSUPP to 0, before returning.

reiserfs_security_init() is dependent on
security_old_inode_init_security() to return -EOPNOTSUPP to initialize
some variables and return, but before returning it changes -EOPNOTSUPP
to 0.

Unfortunately this leaves security_old/security_inode_init_security()
needing to return different things.

Mimi

> Anyway, I'd love for (multiple) people who really know the code to
> give me a clean agreement on exactly what the correct patch is.
> Please?
> 
>                                  Linus
> 


