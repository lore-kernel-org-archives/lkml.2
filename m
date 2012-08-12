Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2HLGe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 02:34:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50749 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2HLGeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 02:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120808121938.GA9995@albatros>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
	<1343262548-21743-2-git-send-email-keescook@chromium.org>
	<20120808121938.GA9995@albatros>
Date: Sat, 11 Aug 2012 23:34:20 -0700
X-Google-Sender-Auth: QzeofJD2eAjQaS9bpFaDsmej2VQ
Message-ID: <CAGXu5j+AUmNFLYmm-097JD-LgxKaYXxTmpnCdsdsqA+jLztXZQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
From: Kees Cook <keescook@chromium.org>
To: Vasily Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
        Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 5:19 AM, Vasily Kulikov <segoon@openwall.com> wrote:
> Hi Kees,
>
> On Wed, Jul 25, 2012 at 17:29 -0700, Kees Cook wrote:
>> +/**
>> + * safe_hardlink_source - Check for safe hardlink conditions
>> + * @inode: the source inode to hardlink from
>> + *
>> + * Return false if at least one of the following conditions:
>> + *    - inode is not a regular file
>> + *    - inode is setuid
>> + *    - inode is setgid and group-exec
>> + *    - access failure for read and write
>> + *
>> + * Otherwise returns true.
>> + */
>> +static bool safe_hardlink_source(struct inode *inode)
>> +{
>> +     umode_t mode = inode->i_mode;
>> +
>> +     /* Special files should not get pinned to the filesystem. */
>> +     if (!S_ISREG(mode))
>> +             return false;
>> +
>> +     /* Setuid files should not get pinned to the filesystem. */
>> +     if (mode & S_ISUID)
>> +             return false;
>
> We don't want to make hardlinks of SUID files, but we still allow to create
> hardlinks to SUID'ish cap'ed files.  Probably check whether the inode is
> setcap'ed?

Excellent idea. It doesn't look like there is anything "simple" to do
this already. It'd be close to get_file_caps() but without the bprm.
Maybe just get_vfs_caps_from_disk() and a walk of the caps? What would
you recommend?

> Probably we can enhance this further and allow LSMs to define whether this
> particular file is special in LSM's point of view (IOW, it can be able to move
> a process to another security domain which is served by LSM).

Yeah. Perhaps implementing the needed check above with a new security
check and have commoncaps do the vfs fetch with LSMs able to override?

-Kees

-- 
Kees Cook
Chrome OS Security
