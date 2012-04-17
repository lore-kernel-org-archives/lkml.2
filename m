Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2DQWBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:01:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33234 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2DQWBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:01:12 -0400
Date: Tue, 17 Apr 2012 15:01:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120417220106.GF19975@google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <20120411192231.GF16008@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411192231.GF16008@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 11, 2012 at 09:22:31PM +0200, Jan Kara wrote:
> > So all the metadata IO will happen thorough journaling thread and that
> > will be in root group which should remain unthrottled. So any journal
> > IO going to disk should remain unthrottled.
>
>   Yes, that is true at least for ext3/ext4 or btrfs. In principle we don't
> have to have the journal thread (as is the case of reiserfs where random
> writer may end up doing commit) but let's not complicate things
> unnecessarily.

Why can't journal entries keep track of the originator so that bios
can be attributed to the originator while committing?  That shouldn't
be too difficult to implement, no?

> > Now, IIRC, fsync problem with throttling was that we had opened a
> > transaction but could not write it back to disk because we had to
> > wait for all the cached data to go to disk (which is throttled). So
> > my question is, can't we first wait for all the data to be flushed
> > to disk and then open a transaction for metadata. metadata will be
> > unthrottled so filesystem will not have to do any tricks like bdi is
> > congested or not.
>
>   Actually that's what's happening. We first do filemap_write_and_wait()
> which syncs all the data and then we go and force transaction commit to
> make sure all metadata got to stable storage. The problem is that writeout
> of data may need to allocate new blocks and that starts a transaction and
> while the transaction is started we may need to do some reads (e.g. of
> bitmaps etc.) which may be throttled and at that moment the whole
> filesystem is blocked. I don't remember the stack traces you showed me so
> I'm not sure it this is what your observed but it's certainly one possible
> scenario. The reason why fsync triggers problems is simply that it's the
> only place where process normally does significant amount of writing. In
> most cases flusher thread / journal thread do it so this effect is not
> visible. And to precede your question, it would be rather hard to avoid IO
> while the transaction is started due to locking.

Probably we should mark all IOs issued inside transaction as META (or
whatever which tells blkcg to avoid throttling it).  We're gonna need
overcharging for metadata writes anyway, so I don't think this will
make too much of a difference.

Thanks.

-- 
tejun
