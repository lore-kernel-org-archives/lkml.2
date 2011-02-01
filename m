Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1BAP7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:59:43 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:39177 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1BAP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:59:41 -0500
Subject: Re: [PATCH] security/selinux: fix /proc/sys/ labeling
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Nick Piggin <npiggin@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <AANLkTimiV_2SAwXuH-SjGav5XJixN=SnjrPrtFRRQF05@mail.gmail.com>
References: <1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com>
	 <1296572538.12605.4.camel@moss-pluto>
	 <AANLkTimiV_2SAwXuH-SjGav5XJixN=SnjrPrtFRRQF05@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Tue, 01 Feb 2011 10:59:35 -0500
Message-ID: <1296575975.12605.18.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 17:53 +0200, Lucian Adrian Grijincu wrote:
> On Tue, Feb 1, 2011 at 5:02 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > Is this patch really from Eric or just derived from an earlier patch by him?
> 
> 
> No, sorry for the confusion.
> I seem to have triggered a git send-email bug.
> 
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >
> > And did Eric truly sign off on this patch or just on an earlier one?
> 
> 
> Just the earlier one. I added his sign-off because of this paragraph
> in SubmittingPatches:
> | The Signed-off-by: tag indicates that the signer was involved in the
> | development of the patch, or that he/she was in the patch's delivery path.
> 
> >
> >> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >> index e276eb4..7c5dfb1 100644
> >> --- a/security/selinux/hooks.c
> >> +++ b/security/selinux/hooks.c
> >> @@ -1317,9 +1311,9 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
> >>
> >>               if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
> >>                       struct proc_inode *proci = PROC_I(inode);
> >> -                     if (proci->pde) {
> >> +                     if (opt_dentry && (proci->pde || proci->sysctl)) {
> >>                               isec->sclass = inode_mode_to_security_class(inode->i_mode);
> >> -                             rc = selinux_proc_get_sid(proci->pde,
> >> +                             rc = selinux_proc_get_sid(opt_dentry,
> >>                                                         isec->sclass,
> >>                                                         &sid);
> >>                               if (rc)
> >
> > It would be nice if we could eliminate the last remaining piece of proc
> > internal knowledge from this code - why do we need the proci->pde ||
> > proci->sysctl test here?  What changes without it?
> 
> 
> Without we label all nodes in /proc/ through selinux_proc_get_sid.
> 
> /proc/1/limits should not get it's sid from here, but from
> security_task_to_inode -> selinux_task_to_inode.
> 
> Without the check we send "/1/limits" to selinux_proc_get_sid, which
> strips off "/1" leaving "/limits". This will be labeled with "proc_t"
> IIRC.

Are you sure?  Those inodes should be labeled by proc_pid_make_inode()
-> security_task_to_inode() -> selinux_task_to_inode(), which will set
the inode SID to match the associated task SID, and set the
isec->initialized flag.  Then when inode_doinit_with_dentry gets called
later, it should bail immediately due to isec->initialized already being
set.

-- 
Stephen Smalley
National Security Agency

