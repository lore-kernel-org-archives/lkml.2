Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1GKUoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:44:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GKUop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:44:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LroJf94BvbRcgUyhO1gcdfOASE4G1qz+NA7Za/DiXujY0wILndMy3Bc7LZ0CHDoJS
	deTczwlPNwkGI0+V7A3iw==
MIME-Version: 1.0
In-Reply-To: <20110624220240.GA6455@infradead.org>
References: <1308949107-1962-1-git-send-email-teravest@google.com> <20110624220240.GA6455@infradead.org>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 11 Jul 2011 13:44:22 -0700
Message-ID: <CAN5ZDdfVEvxgwmRPwMVSq7iqTTaQ5fi5A-qtCsiqzTRjhOuL+A@mail.gmail.com>
Subject: Re: [PATCH] fixlet: Remove fs_excl from struct task.
To: Christoph Hellwig <hch@infradead.org>
Cc: jaxboe@fusionio.com, viro@zeniv.linux.org.uk, jeffm@suse.de,
        tytso@google.com, mingo@elte.hu, peterz@infradead.org,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Have you had a chance to look at this? Christoph mentioned you'd
wanted to keep this,
but the last discussion I see is from 2009 and it doesn't look like
much has happened since then.


On Fri, Jun 24, 2011 at 3:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jun 24, 2011 at 01:58:27PM -0700, Justin TerAvest wrote:
>> fs_excl is a poor man's priority inheritance for filesystems to hint to
>> the block layer that an operation is important. It was never clearly
>> specified, not widely adopted, and will not prevent starvation in many
>> cases (like across cgroups).
>>
>> I talked to Ted Ts'o about this, and he said that it used to used more
>> frequently in the 2.4 and prior versions of Linux, back when we were
>> first converting from the Big Kernel Lock to having subsystem level
>> locks, and so it made sense to use fs_excl when a process owned the
>> global fs mutex and was waiting for an I/O to complete, but it's no
>> longer used much at all, and filesystems have better ways to mark an I/O
>> request as high priority.
>
> That's not quite true, it was added in Linux 2.6.13 in commit
> 22e2c507c301c3dbbcf91b4948b88f78842ee6c9:
>
>        [PATCH] Update cfq io scheduler to time sliced design
>
> The users back then where the same as today: a few reiserfs journal
> callsites and lock_super.  In addition to the lock_super uses in various
> fringe filesystems still left today it was also used around ->put_super
> (aka umount) and ->write_super, which at the point had already lost the
> grunt work of sync action to ->sync_fs.
>
> That beeing said I never liked it and asked for a removal a while ago,
> but Jens still wanted to keep it.  As far as I'm concerned we should
> kill it gently, and if any regressions arise fix them with a bio flag.
>
>
