Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2AJWAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:00:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36367 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2AJWAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:00:09 -0500
MIME-Version: 1.0
In-Reply-To: <4F0C9D87.8010006@sandeen.net>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
Date: Tue, 10 Jan 2012 14:00:07 -0800
Message-ID: <CAMBkX3fxRKP-o-ccz7KaEZ-mvh_Q7xzB2=r42KEUOW2NPsjKfQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
From: Surbhi Palande <csurbhi@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Kamal Mostafa <kamal@canonical.com>, Jan Kara <jack@suse.cz>,
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

> Hrm let me think through this a little more; we actually do:
>
> t16) ext4_journal_start()
>  t17) ext4_journal_start_sb()
>    t18) handle = ext4_journal_current_handle();
>    t19) if (!handle) vfs_check_frozen()
>    t20) ... jbd2_journal_start()
>
> So actually we *do* block new handles, but let *existing* ones
> continue (see commits 6b0310fbf087ad6e9e3b8392adca97cd77184084
> and be4f27d324e8ddd57cc0d4d604fe85ee0425cba9)
>
> So your assertion that a new handle is started is incorrect
> in general, isn't it?  So then does the fix seem necessary?
> Or, at least, in the fashion below - maybe we need to just make
> sure all started handles complete before the unlock_updates?
> Or am I missing something...?
>
> -Eric

This patch addresses the race that occurs between filesystem freeze
and jbd2_journal_start().

     Task1                                              Task2
t1) vfs_check_frozen()
t2) ---------------------------------------------------------------------
t3)                                                   filesystem is frozen.
t4) jbd2_journal_start()

Without this patch a new handle can be started because of the race.
With this patch, no new journaled transaction can start after the
journal is frozen and hence no new journaled writes can be made.

Regards,
Surbhi



>
>>
>> BugLink: https://bugs.launchpad.net/bugs/897421
>> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
>> Acked-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: Kamal Mostafa <kamal@canonical.com>
>> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
>> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>> ---
>>  fs/jbd2/journal.c     |    1 +
>>  fs/jbd2/transaction.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/jbd2.h  |    7 +++++++
>>  3 files changed, 50 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 0fa0123..f0170cc 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -894,6 +894,7 @@ static journal_t * journal_init_common (void)
>>       init_waitqueue_head(&journal->j_wait_checkpoint);
>>       init_waitqueue_head(&journal->j_wait_commit);
>>       init_waitqueue_head(&journal->j_wait_updates);
>> +     init_waitqueue_head(&journal->j_wait_frozen);
>>       mutex_init(&journal->j_barrier);
>>       mutex_init(&journal->j_checkpoint_mutex);
>>       spin_lock_init(&journal->j_revoke_lock);
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index a0e41a4..340ee35 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -173,6 +173,17 @@ repeat:
>>                               journal->j_barrier_count == 0);
>>               goto repeat;
>>       }
>> +     /* Don't let a new handle start when a journal is frozen.
>> +      * jbd2_journal_freeze calls jbd2_journal_unlock_updates() only after
>> +      * the j_flags indicate that the journal is frozen. So if the
>> +      * j_barrier_count is 0, then check if this was made 0 by the freezing
>> +      * process
>> +      */
>> +     if (journal->j_flags & JBD2_FROZEN) {
>> +             read_unlock(&journal->j_state_lock);
>> +             wait_event(journal->j_wait_frozen, (journal->j_flags & JBD2_FROZEN));
>> +             goto repeat;
>> +     }
>>
>>       if (!journal->j_running_transaction) {
>>               read_unlock(&journal->j_state_lock);
>> @@ -492,6 +503,37 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
>>  }
>>  EXPORT_SYMBOL(jbd2_journal_restart);
>>
>> +int jbd2_journal_freeze(journal_t *journal)
>> +{
>> +     int error = 0;
>> +     /* Now we set up the journal barrier. */
>> +     jbd2_journal_lock_updates(journal);
>> +
>> +     /*
>> +      * Don't clear the needs_recovery flag if we failed to flush
>> +      * the journal.
>> +      */
>> +     error = jbd2_journal_flush(journal);
>> +     if (error >= 0) {
>> +             write_lock(&journal->j_state_lock);
>> +             journal->j_flags |= JBD2_FROZEN;
>> +             write_unlock(&journal->j_state_lock);
>> +     }
>> +     jbd2_journal_unlock_updates(journal);
>> +     return error;
>> +}
>> +EXPORT_SYMBOL(jbd2_journal_freeze);
>> +
>> +void jbd2_journal_thaw(journal_t * journal)
>> +{
>> +     write_lock(&journal->j_state_lock);
>> +     journal->j_flags &= ~JBD2_FROZEN;
>> +     write_unlock(&journal->j_state_lock);
>> +     wake_up(&journal->j_wait_frozen);
>> +}
>> +EXPORT_SYMBOL(jbd2_journal_thaw);
>> +
>> +
>>  /**
>>   * void jbd2_journal_lock_updates () - establish a transaction barrier.
>>   * @journal:  Journal to establish a barrier on.
>> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
>> index 2092ea2..bfa0752 100644
>> --- a/include/linux/jbd2.h
>> +++ b/include/linux/jbd2.h
>> @@ -658,6 +658,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
>>   * @j_wait_checkpoint:  Wait queue to trigger checkpointing
>>   * @j_wait_commit: Wait queue to trigger commit
>>   * @j_wait_updates: Wait queue to wait for updates to complete
>> + * @j_wait_frozen: Wait queue to wait for journal to thaw
>>   * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
>>   * @j_head: Journal head - identifies the first unused block in the journal
>>   * @j_tail: Journal tail - identifies the oldest still-used block in the
>> @@ -775,6 +776,9 @@ struct journal_s
>>       /* Wait queue to wait for updates to complete */
>>       wait_queue_head_t       j_wait_updates;
>>
>> +     /* Wait queue to wait for journal to thaw*/
>> +     wait_queue_head_t       j_wait_frozen;
>> +
>>       /* Semaphore for locking against concurrent checkpoints */
>>       struct mutex            j_checkpoint_mutex;
>>
>> @@ -953,6 +957,7 @@ struct journal_s
>>  #define JBD2_ABORT_ON_SYNCDATA_ERR   0x040   /* Abort the journal on file
>>                                                * data write error in ordered
>>                                                * mode */
>> +#define JBD2_FROZEN  0x080 /* Journal thread frozen along with filesystem */
>>
>>  /*
>>   * Function declarations for the journaling transaction and buffer
>> @@ -1060,6 +1065,8 @@ extern void      jbd2_journal_invalidatepage(journal_t *,
>>                               struct page *, unsigned long);
>>  extern int    jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
>>  extern int    jbd2_journal_stop(handle_t *);
>> +extern int    jbd2_journal_freeze(journal_t *);
>> +extern void   jbd2_journal_thaw(journal_t *);
>>  extern int    jbd2_journal_flush (journal_t *);
>>  extern void   jbd2_journal_lock_updates (journal_t *);
>>  extern void   jbd2_journal_unlock_updates (journal_t *);
>
