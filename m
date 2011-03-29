Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1C2Nhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:37:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:46110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1C2Nhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:37:35 -0400
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
	 <20110328171217.GA8529@home.goodmis.org>
	 <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 15:39:44 +0200
Message-ID: <1301405984.2250.402.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 13:30 +0900, Tetsuo Handa wrote:

> static int locktest_open1(struct inode *inode, struct file *file)
> {
> 	write_seqlock(&seqlock1);
> 	msleep(1000); /* Open /proc/locktest2 while sleeping here. */
> 	br_read_lock(brlock1);
> 	br_read_unlock(brlock1);
> 	write_sequnlock(&seqlock1);
> 	return -EINVAL;
> }
> 
> static int locktest_open2(struct inode *inode, struct file *file)
> {
> 	br_write_lock(brlock1);
> 	read_seqbegin2(&seqlock1);
> 	br_write_unlock(brlock1);
> 	return -EINVAL;
> }
> 
> static int locktest_open3(struct inode *inode, struct file *file)
> {
> 	static DEFINE_MUTEX(mutex1);
> 	mutex_lock(&mutex1);
> 	locktest_open1(inode, file);
> 	mutex_unlock(&mutex1);
> 	return -EINVAL;
> }


That's quite horrid as far as test-cases go, why bother with the
userspace part at all?

In order to hit your inversion you need to do something like:

cat /proc/locktest1 & cat /proc/locktest2

if you do them serialized you'll never hit that inversion.


That said, there are some out-standing issues with rw_locks and lockdep,
Gautham and I worked on that for a while but we never persevered and
finished it..

  http://lkml.org/lkml/2009/5/11/203

And I think you're hitting that case.

