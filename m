Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab0J1R54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:57:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40569 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760293Ab0J1R5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=CMDklT6OCetkneRiPnpDVMb+XxRDsMNXAl3t9m92iMZ83zm6A06QdYsVnTSHgJBnVV
         zKFZ4Rud253Hv9rRiviZYFbNTyGt6K5vfk0UVlbLxVjb/Isi67MPmVcv9axOUQHJmb3d
         Ma22GwtFkFB1Ob9eMAeB3EQQPujtM1D1zgdrQ=
MIME-Version: 1.0
In-Reply-To: <20101028170132.GY27796@think>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
	<AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
	<AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	<AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	<AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	<20101028090002.GA12446@elte.hu>
	<AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
	<20101028133036.GA30565@elte.hu>
	<20101028170132.GY27796@think>
Date: Thu, 28 Oct 2010 20:57:49 +0300
X-Google-Sender-Auth: TgU0R7flTuoV0bUEg9yI4o_9xGE
Message-ID: <AANLkTikgO=n88ZAQ6EYAg1+aC1d0+o923FYyhkOouaH5@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Pekka Enberg <penberg@kernel.org>
To: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 03:30:36PM +0200, Ingo Molnar wrote:
>> "Many seconds freezes" and slowdowns wont be fixed via the VFS scalability patches
>> i'm afraid.
>>
>> This has the appearance of some really bad IO or VM latency problem. Unfixed and
>> present in stable kernel versions going from years ago all the way to v2.6.36.

On Thu, Oct 28, 2010 at 8:01 PM, Chris Mason <chris.mason@oracle.com> wrote:
> Hmmm, the workload you're describing here has two special parts.  First
> it dramatically overloads the disk, and then it has guis doing things
> waiting for the disk.
>
> The virtualbox part of the workload is probably filling the queue with
> huge amounts of synchronous random IO (I'm assuming it is going in via
> O_DIRECT), and this will defeat any attempts from the filesystem to tell
> the elevator "hey look, my IO is synchronous, please do hurry"
>
> So, I'd try mounting ext4 in data=writeback mode.  I can't make ext4
> stall fsyncs on non-fsync IO locally and it looks like they have solved
> the ext3 data=ordered problem.  But I still like to rule out old and
> known issues before we dig into new things.
>
> I'd also suggest something like the below patch which is entirely
> untested and must be blessed by an actual ext4 developer.  I think we
> can make fsync faster if we put the mutex locking down in the FS, but
> until then it should be ok to drop the mutex while we are doing the
> expensive log commits:
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 592adf2..1b7a637 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -114,6 +114,7 @@ int ext4_sync_file(struct file *file, int datasync)
>        if (ext4_should_journal_data(inode))
>                return ext4_force_commit(inode->i_sb);
>
> +       mutex_unlock(&inode->i_mutex);
>        commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
>        if (jbd2_log_start_commit(journal, commit_tid)) {
>                /*
> @@ -133,5 +134,7 @@ int ext4_sync_file(struct file *file, int datasync)
>        } else if (journal->j_flags & JBD2_BARRIER)
>                blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
>                        BLKDEV_IFL_WAIT);
> +
> +       mutex_lock(&inode->i_mutex);
>        return ret;
>  }

Don't we need to call ext4_should_writeback_data() before we drop the
lock? It pokes at ->i_mode which needs ->i_mutex AFAICT.
