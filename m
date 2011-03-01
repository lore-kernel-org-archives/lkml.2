Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1CAXHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:07:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1CAXHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:07:32 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=dutORJ2A7aAA:10 a=kj9zAlcOel0A:10 a=ZorOx4O2c87vg0jdnx9q1w==:17 a=ybZZDoGAAAAA:8 a=DJz_usjlXeFRRpzQOqkA:9 a=A8WFYC2hy8zlg9rBXecKmsmQWVwA:4 a=CjuIK1q_8ugA:10 a=qIVjreYYsbEA:10 a=ZorOx4O2c87vg0jdnx9q1w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.141.2
Date: Tue, 1 Mar 2011 17:07:29 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        LSM <linux-security-module@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 09/10] userns: check user namespace for task->file uid
 equivalence checks
Message-ID: <20110301230729.GA28694@hallyn.com>
References: <20110224150150.GA8262@mail.hallyn.com>
 <20110224150315.GI8262@mail.hallyn.com>
 <1299018281.461.16.camel@tp-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299018281.461.16.camel@tp-t61>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nathan Lynch (ntl@pobox.com):
> On Thu, 2011-02-24 at 15:03 +0000, Serge E. Hallyn wrote:
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1446,8 +1446,13 @@ enum {
> >  #define put_fs_excl() atomic_dec(&current->fs_excl)
> >  #define has_fs_excl() atomic_read(&current->fs_excl)
> >  
> > -#define is_owner_or_cap(inode)	\
> > -	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
> > +/*
> > + * until VFS tracks user namespaces for inodes, just make all files
> > + * belong to init_user_ns
> > + */
> > +extern struct user_namespace init_user_ns;
> 
> init_user_ns gets declared in fs.h in this patch, utsname.h in patch #1,
> capability.h in #2, ipc_namespace.h in #7.  Could this declaration be
> kept to a single header?
> 

ipc/msgutil.c includes security.h which includes fs.h, so we should be
able to drop the one in ipc_namespace.h.  The one in utsname.h is
there for init/version.c and needed AFAICS.

The one in capability.h should be able to go when has_capability* are
turned into functions.  They couldn't be turned into static functions
in capability.h (left as exercise for reader), but they can be made
full-fledged functions in kernel/capability.c.  I will do that in a
follow-on patch and try to remove the extra init_user_ns defines as
well.

thanks,
-serge
