Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2BRQaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 11:30:14 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49550 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab2BRQaN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 11:30:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amit.sahrawat83@gmail.com designates 10.152.112.132 as permitted sender) smtp.mail=amit.sahrawat83@gmail.com; dkim=pass header.i=amit.sahrawat83@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120217191522.GB13870@infradead.org>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
	<20120217191522.GB13870@infradead.org>
Date: Sat, 18 Feb 2012 22:00:11 +0530
Message-ID: <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Nam-Jae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

There are ‘2’ scenarios which results in the similar problem related
to flushing. Both related to handling of buffer callbacks after the
corresponding mount point passed in the transactions is destroyed.

The first one reported 2 months back (in umount path) – which was
related with the asynchronous callback of buf-iodone handlers being
called after the freeing up of the mount point in:
void xfs_log_unmount(xfs_mount_t *mp)
{
	xfs_trans_ail_destroy(mp);
	xlog_dealloc_log(mp->m_log);
}

The complete tracing information for the first issue is available at:
http://patchwork.xfs.org/patch/2485/

For which the solution was also provided by you as -> xfs: fix buffer
flushing during unmount
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=87c7bec7fc3377b3873eb3a0f4b603981ea16ebb)

Now, we have encountered a similar issue in mount failure path.
In this scenarios also – it is the calling of ‘xfs_log_umount’ without
waiting for the dependent buffer callbacks to be flushed.
xfs_mountfs()
{
…
…
error = xfs_log_mount_finish(mp);
	if (error) {
		cmn_err(CE_WARN, "XFS: log mount finish failed");
		goto out_rtunmount;
	}
…
..
out_log_dealloc:
	xfs_log_unmount(mp);
…
}
xfs_fs_fill_super()
{
…
	error = xfs_mountfs(mp);
	if (error)
		goto out_filestream_unmount;
…
…
out_filestream_unmount:
	xfs_filestream_unmount(mp);
 out_free_sb:
	xfs_freesb(mp);
 out_destroy_counters:
	xfs_icsb_destroy_counters(mp);
	xfs_close_devices(mp);
}

Now, in xfs_close_devices() – it tries to flush all the pending buffer
callbacks – but because xfs_log_umount has resulted in destroying of
ail mountpoint in xfs_trans_ail_destroy(mp);
This again results in crash at
xfs_buf_iodone()
{
…
	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
…
}
The backtrace and exact problem was shared as part of the reply to the
patch submission mail.

So a solution to this – also we need to flush buffers.

And because it is a similar situation and also – we can make this a
generic solution.
The fix from the patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=87c7bec7fc3377b3873eb3a0f4b603981ea16ebb
was removed and instead tried to put it at one place which could solve
the similar issues.

Please let me know incase I am not able to clarify properly.

Thanks & Regards,
Amit Sahrawat

On Sat, Feb 18, 2012 at 12:45 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> Whenever there is a mount/unmount failure - there is a chance of calling the
>> callbacks functions once - transaction ail mount pointer is destroyed. So, it results
>> in NULL pointer exception followed by hang. So, before unmount of the log - flush all
>> the pending buffers.
>
>>  void
>>  xfs_log_unmount(xfs_mount_t *mp)
>>  {
>> +     int error = 0;
>> +     /*
>> +      * Make sure all buffers have been flushed and completed before
>> +      * unmounting the log.
>> +      */
>> +     error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
>> +     if (error)
>> +             cmn_err(CE_WARN, "%d busy buffers during log unmount.", error);
>> +     xfs_wait_buftarg(mp->m_ddev_targp);
>> +
>
> We do exactly that sequence before the xfs_log_unmount_write call on
> umount.  Care to explain what code in xfs_log_unmount_write would
> require this to be called again?
>
