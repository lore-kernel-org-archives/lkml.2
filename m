Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0LWDmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 22:42:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63904 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0LWDmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 22:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=c4sN7qGDC/AMIgUuZmkzij8r8LjWE8iPI5NZCptx8CQJPRJ9IeDJZxJBWVm4qYSVHL
         ejDBwqBGVEDFjHjaED/+1qgs76qbdPOATDtb/nocn9jz0NuyOAzb1rfgO8OgDBCt2agY
         i7fw+SPc5HEA6xTN26fjLd7OE0GUVMO/WQP8Q=
Date: Thu, 23 Dec 2010 04:42:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in 2.6.36
Message-ID: <20101223034229.GF1739@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
 <20101202174328.GA1750@nowhere>
 <201012161449.52318.roucaries.bastien@gmail.com>
 <201012221850.51242.roucaries.bastien@gmail.com>
 <20101222180428.GD1739@nowhere>
 <AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 07:11:43PM +0100, Bastien ROUCARIES wrote:
> On Wed, Dec 22, 2010 at 7:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Dec 22, 2010 at 06:50:48PM +0100, Bastien ROUCARIES wrote:
> >> Le jeudi 16 décembre 2010 14:49:48, Bastien ROUCARIES a écrit :
> >> > Le jeudi 2 décembre 2010 18:43:32, vous avez écrit :
> >> > > On Fri, Nov 26, 2010 at 05:57:05PM +0100, Bastien ROUCARIES wrote:
> >> > > > Dear frederic,
> >> I achieve to reproduce it. BTW it is my home partition with acl enable
> >
> > How do you know you reproduced it? You had a crash before using SysRq?
> > Or you felt a deadlock or so?
> >
> > What's interesting is that report is that there is no blocked task
> > that holds the reiserfs lock.
> >
> > So I really feel the problem is that someone opened the journal but did not
> > release it.
> 
> Could you add a virtual lock for testing this hypothesis ? This lock
> will be held during journal opening and releasing during journal
> closing, using lockdep for testing this hypothesis ?


That's a good idea. But we can get the same result with traces more easily.
Plus I would like one more level of details about the origin of the issue.
We shouldn't skimp on dumping informations, given how hard it is to
reproduce ;)

So here is a patch that inserts some debug tracing points in the journal
opening and journal closing points, so that we can find if there is any
imbalance here, namely to find if the problem is some path that forgets
to close the journal (calling do_journal_end()).

But the reason could be something else. Like for some reasons writers
queue themselves waiting when they shouldn't. 
So I've inserted two more points that will let us know why the hung tasks
have put themselves in queue.

This all should narrow down the possible origins of the issue.

You will need to select CONFIG_TRACING. Just select

Kernel Hacking
	Tracers
		[*] Trace process context switches and events

Or whatever option inside Tracers menu.


And when your problem triggers, type the sysrq combination
to dump ftrace buffers: Sysrq z

Ah and also boot with the ftrace=nop parameter, this will give you
enough size for the buffer, although I guess the default size should
be enough but we never know.

Thanks.

The patch:

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index d31bce1..e1737c8 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3073,6 +3073,7 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 		    (journal->j_len_alloc * 75)) {
 			if (atomic_read(&journal->j_wcount) > 10) {
 				sched_count++;
+				trace_printk("queue log 1\n");
 				queue_log_writer(sb);
 				goto relock;
 			}
@@ -3083,6 +3084,7 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 		if (atomic_read(&journal->j_jlock)) {
 			while (journal->j_trans_id == old_trans_id &&
 			       atomic_read(&journal->j_jlock)) {
+				trace_printk("queue log 2\n");
 				queue_log_writer(sb);
 			}
 			goto relock;
@@ -3116,6 +3118,8 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 	unlock_journal(sb);
 	INIT_LIST_HEAD(&th->t_list);
 	get_fs_excl();
+	trace_printk("begin %p ret = 0\n", sb);
+	trace_dump_stack();
 	return 0;
 
       out_fail:
@@ -3124,6 +3128,8 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 	 * persistent transactions there are. We need to do this so if this
 	 * call is part of a failed restart_transaction, we can free it later */
 	th->t_super = sb;
+	trace_printk("begin %p ret = %d\n", sb, retval);
+	trace_dump_stack();
 	return retval;
 }
 
@@ -4295,6 +4301,8 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 		flush_commit_list(sb, jl, 1);
 	}
       out:
+	trace_printk("end %p ret = %d\n", sb, journal->j_errno);
+	trace_dump_stack();
 	reiserfs_check_lock_depth(sb, "journal end2");
 
 	memset(th, 0, sizeof(*th));

