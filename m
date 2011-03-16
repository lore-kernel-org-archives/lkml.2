Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1CPUxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:53:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:42338 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1CPUw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:52:56 -0400
From: Richard Weinberger <richard@nod.at>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Date: Wed, 16 Mar 2011 21:52:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, serge@hallyn.com, eparis@redhat.com,
        jmorris@namei.org, eugeneteo@kernel.org, drosenberg@vsecurity.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <1300303907-22627-1-git-send-email-richard@nod.at> <201103162108.17127.richard@nod.at> <201103162145.45772.arnd@arndb.de>
In-Reply-To: <201103162145.45772.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103162152.49615.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
> On Wednesday 16 March 2011 21:08:16 Richard Weinberger wrote:
> > Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
> > > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
> > > > When containers like LXC are used a unprivileged and jailed
> > > > root user can still write to critical files in /proc/.
> > > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
> > > > 
> > > > This new restricted attribute makes it possible to protect such
> > > > files. When restricted is set to true root needs CAP_SYS_ADMIN
> > > > to into the file.
> > > 
> > > I was thinking about this too. I'd prefer more fine-grained control
> > > in this area, since some sysctl entries aren't strictly controlled by
> > > CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
> > > 
> > > How about this instead?
> > 
> > Good Idea.
> > May we should also consider a per-directory restriction.
> > Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
> > It would be much easier to set the protection on the parent directory
> > instead of protecting file by file...
> 
> How does this interact with the per-namespace sysctls that Eric
> Biederman added a few years ago?

Do you mean CONFIG_{UTS, UPC, USER, NET,}_NS?

> I had expected that any dangerous sysctl would not be visible in
> an unpriviledge container anyway.

No way.
That's why it's currently a very good idea to mount /proc/ read-only into a container.

> 	Arnd
> 
> > > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> > > ---
> > > diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> > > index 8eb2522..5c5cfab 100644
> > > --- a/fs/proc/proc_sysctl.c
> > > +++ b/fs/proc/proc_sysctl.c
> > > @@ -149,6 +149,10 @@ static ssize_t proc_sys_call_handler(struct file
> > > *filp, void __user *buf, if (sysctl_perm(head->root, table, write ?
> > > MAY_WRITE : MAY_READ)) goto out;
> > > 
> > > +	if (write && !cap_isclear(table->write_caps) &&
> > > +            !cap_issubset(table->write_caps,
> > > current_cred()->cap_permitted)) +		goto out;
> > > +
> > > 
> > >  	/* if that can happen at all, it should be -EINVAL, not -EISDIR */
> > >  	error = -EINVAL;
> > >  	if (!table->proc_handler)
> > > 
> > > diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> > > index 11684d9..4e05493 100644
> > > --- a/include/linux/sysctl.h
> > > +++ b/include/linux/sysctl.h
> > > @@ -1018,6 +1018,7 @@ struct ctl_table
> > > 
> > >  	void *data;
> > >  	int maxlen;
> > >  	mode_t mode;
> > > 
> > > +	kernel_cap_t write_caps;	/* Capabilities required to write */
> > > 
> > >  	struct ctl_table *child;
> > >  	struct ctl_table *parent;	/* Automatically set */
> > >  	proc_handler *proc_handler;	/* Callback for text formatting */

