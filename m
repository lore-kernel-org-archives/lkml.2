Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2AJVzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:55:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64974 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2AJVzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:55:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120110213104.GI4516@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
	<20120110213104.GI4516@quack.suse.cz>
Date: Tue, 10 Jan 2012 13:55:17 -0800
Message-ID: <CAMBkX3dXrxRUSoRWWPzxaii-D0PF-1T2v9=RPhaApnCS2+x0FQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
From: Surbhi Palande <csurbhi@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>, Kamal Mostafa <kamal@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Valerie Aurora <val@vaaconsulting.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Surbhi Palande <surbhi.palande@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hrm let me think through this a little more; we actually do:
> >
> > t16) ext4_journal_start()
> >   t17) ext4_journal_start_sb()
> >     t18) handle = ext4_journal_current_handle();
> >     t19) if (!handle) vfs_check_frozen()
> >     t20) ... jbd2_journal_start()
>  Ah, right. I forgot.
>
> > So actually we *do* block new handles, but let *existing* ones
> > continue (see commits 6b0310fbf087ad6e9e3b8392adca97cd77184084
> > and be4f27d324e8ddd57cc0d4d604fe85ee0425cba9)
> >
> > So your assertion that a new handle is started is incorrect
> > in general, isn't it?  So then does the fix seem necessary?
> > Or, at least, in the fashion below - maybe we need to just make
> > sure all started handles complete before the unlock_updates?
> > Or am I missing something...?
>  Well, the problem with running operations and freezing is more
> fundamental I believe. See my email
> http://marc.info/?l=linux-fsdevel&m=132585911925796&w=2
>
> So I believe we'll need some better exclusion mechanism already in VFS.
>
>                                                                Honza
>

If all the write operations were journaled, then this patch would not
allow ext4 filesystem to have any dirty data after its frozen.
(as journal_start() would block).

 I think the only one candidate that creates dirty data without
calling ext4_journal_start() is mmapped?

Regards,
Surbhi.
