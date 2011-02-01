Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1BAPyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:54:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57219 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1BAPyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:54:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PHOfGJKksCcoEbpa9m62uK19VRS/Q+JFn2sIO0hSWnGUsQ3yofcgTP4UvDrNsqrwpC
         7fiJFffyGnEnyzAVB7i1smZRgJPX6EAYG/uFRI4yuEtLONptrNtkeHqSlWCy1lMnlRf9
         8PkJ/rCn4ykIYc2y2H8q1Xi6ajZ0UEtv9tR08=
MIME-Version: 1.0
In-Reply-To: <1296572538.12605.4.camel@moss-pluto>
References: <1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com> <1296572538.12605.4.camel@moss-pluto>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Tue, 1 Feb 2011 17:53:40 +0200
Message-ID: <AANLkTimiV_2SAwXuH-SjGav5XJixN=SnjrPrtFRRQF05@mail.gmail.com>
Subject: Re: [PATCH] security/selinux: fix /proc/sys/ labeling
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Nick Piggin <npiggin@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 5:02 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> Is this patch really from Eric or just derived from an earlier patch by him?


No, sorry for the confusion.
I seem to have triggered a git send-email bug.

>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> And did Eric truly sign off on this patch or just on an earlier one?


Just the earlier one. I added his sign-off because of this paragraph
in SubmittingPatches:
| The Signed-off-by: tag indicates that the signer was involved in the
| development of the patch, or that he/she was in the patch's delivery path.

>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index e276eb4..7c5dfb1 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -1317,9 +1311,9 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
>>
>>               if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
>>                       struct proc_inode *proci = PROC_I(inode);
>> -                     if (proci->pde) {
>> +                     if (opt_dentry && (proci->pde || proci->sysctl)) {
>>                               isec->sclass = inode_mode_to_security_class(inode->i_mode);
>> -                             rc = selinux_proc_get_sid(proci->pde,
>> +                             rc = selinux_proc_get_sid(opt_dentry,
>>                                                         isec->sclass,
>>                                                         &sid);
>>                               if (rc)
>
> It would be nice if we could eliminate the last remaining piece of proc
> internal knowledge from this code - why do we need the proci->pde ||
> proci->sysctl test here?  What changes without it?


Without we label all nodes in /proc/ through selinux_proc_get_sid.

/proc/1/limits should not get it's sid from here, but from
security_task_to_inode -> selinux_task_to_inode.

Without the check we send "/1/limits" to selinux_proc_get_sid, which
strips off "/1" leaving "/limits". This will be labeled with "proc_t"
IIRC.


-- 
 .
..: Lucian
