Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1F2VaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:30:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1F2VaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:30:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=YS9a7LnYeFuWMAglpolAV7xmjpLcqiWtfbaMYMS14Inb3PGKX0N5hLtQqfM1b/3lf
	1V7B93ow6vVEOkgotrNeQ==
MIME-Version: 1.0
In-Reply-To: <20110629180010.GB32236@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
	<20110629005422.GQ32466@dastard>
	<BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
	<20110629081155.GA5558@infradead.org>
	<BANLkTinoFOnQoo3k3KiDgqd7+uBH6shNesxhmVRo9wWr0WCkEw@mail.gmail.com>
	<20110629180010.GB32236@infradead.org>
Date: Wed, 29 Jun 2011 14:30:17 -0700
Message-ID: <BANLkTi=5Jgrb_wQ_AKn3LJOYERTcTix01BCGPYnjGi4iJZhxgA@mail.gmail.com>
Subject: Re: [PATCH] writeback: Don't wait for completion in writeback_inodes_sb_nr
From: Curt Wohlgemuth <curtw@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 29, 2011 at 10:26:33AM -0700, Curt Wohlgemuth wrote:
>> The semantics did change between 2.6.34 and 2.6.35 though.  When the
>> work item queue was introduced in 2.6.32, the semantics changed from
>> what you describe above to what's present through 2.6.34:
>> writeback_inodes_sb() would enqueue a work item, and return.  Your
>> commit 83ba7b07 ("writeback: simplify the write back thread queue")
>> added the wait_for_completion() call, putting the semantics back to
>> where they were pre-2.6.32.
>
> Yes.  The kernels inbetween had that nasty writeback vs umount races
> that we could trigger quite often.

My apologies for not being aware of these races (I tried to search
mailing lists) -- how did they manifest themselves?  I don't see
anything about it in your commit message of 83ba7b07.  I do see that
we are not taking s_umount for sys_sync any longer (only in
sync_filesystem(), e.g., for sys_syncfs)...

>> Though one additional change between the old way (pre-2.6.32) and
>> today:  with the old kernel, the pdflush thread would operate
>> concurrently with the first (and second?) sync path through writeback.
>>  Today of course, they're *all* serialized.  So really a call to
>> sys_sync() will enqueue 3 work items -- one from
>> wakeup_flusher_threads(), one from writeback_inodes_sb(), and one from
>> sync_inodes_sb().
>
> Yes.  And having WB_SYNC_NONE items from both wakeup_flusher_threads vs
> writeback_inodes_sb is plain stupid.  The initial conversion to the
> new sync_filesystem scheme had removed the wakeup_flusher_threads
> call, but that caused a huge regression in some benchmark.
>
> As mentioned before Wu was working on some code to introduce tagging
> so that the WB_SYNC_ALL call won't start writing pages dirtied after
> the sync call, which should help with your issue.  Although to
> completely solve it we really need to get down to just two passes.

I can definitely see how tagging with the start of sync would be
helpful; also how going from three to two passes seems like a
no-brainer.

But what's the real point of doing even two passes -- one SYNC_NONE
followed by one SYNC_ALL?  Is it try to get through as many inodes as
possible before we potentially lock up by waiting on an inode on an
unavailable device?

Thanks,
Curt
