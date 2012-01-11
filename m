Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2AKANv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:13:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42346 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2AKANs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:13:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120111000448.GA16395@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
	<20120110213104.GI4516@quack.suse.cz>
	<CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
	<20120111000448.GA16395@quack.suse.cz>
Date: Tue, 10 Jan 2012 16:13:46 -0800
Message-ID: <CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
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

Hi Jan,

>>
>>
>> If all the write operations were journaled, then this patch would not allow
>> ext4 filesystem to have any dirty data after its frozen.
>> (as journal_start() would block).
>>
>>  I think the only one candidate that creates dirty data without calling
>> ext4_journal_start() is mmapped?
>  No, the problem is in any write path. The problem is with operations
> that happen during the phase when s_frozen == SB_FREEZE_WRITE. These
> operations dirty the filesystem but running sync may easily miss them.
> During this phase journal is not frozen so that does not help you in any
> way.
>
>                                                                Honza

Ok! No new transaction can really start after the journal is frozen.
But we can have dirty data after SB_FREEZE_WRITE and before
SB_FREEZE_TRANS.
I agree with you. However, can this be fixed by adding a
sync_filesystem() in freeze_super() after the sb->s_op->freeze_fs() is
over?


So then essentially, when freeze_super() returns, the page cache is clean?

I do definitely agree that the fix is to add a lock for mutual
exclusion between freeze filesystem and writes to a frozen filesystem.

Thanks!

Regards,
Surbhi.
