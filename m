Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2GRCgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:36:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41867 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2GRCg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120717172736.GA6854@linux.vnet.ibm.com>
References: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
	<20120717105936.GC28744@somewhere>
	<20120717172736.GA6854@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 10:36:28 +0800
Message-ID: <CACV3sbKBsj288s=2FKKM+zuoga7Jy9QOxgzciTwREFVHLgR=Lw@mail.gmail.com>
Subject: Re: uprobe: checking probe event include directory
From: Jovi Zhang <bookjovi@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 1:27 AM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> [2012-07-17 12:59:39]:
>
>> On Tue, Jul 17, 2012 at 06:12:28PM +0800, Jovi Zhang wrote:
>> > From 16ed13ee9098ae01705e8456005d1ad6d9909128 Mon Sep 17 00:00:00 2001
>> > From: Jovi Zhang <bookjovi@gmail.com>
>> > Date: Wed, 18 Jul 2012 01:16:23 +0800
>> > Subject: [PATCH] uprobe: checking probe event include directory
>> >
>> > Currently below command run successful:
>> > $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
>
> good catch.
>
>> >
>> > this don't make sense, because /bin is a directory,
>> > so make this checking earily, not report error untill probe enable.
>> >
>> > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
>>
>> Adding Srikar in Cc.
>>
>> > ---
>> >  kernel/trace/trace_uprobe.c |    5 +++++
>> >  1 file changed, 5 insertions(+)
>> >
>> > diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
>> > index 85158fa..cf382de 100644
>> > --- a/kernel/trace/trace_uprobe.c
>> > +++ b/kernel/trace/trace_uprobe.c
>> > @@ -259,6 +259,11 @@ static int create_trace_uprobe(int argc, char **argv)
>> >             goto fail_address_parse;
>> >
>> >     inode = igrab(path.dentry->d_inode);
>> > +    if (S_ISDIR(inode->i_mode)) {
>
> How about checking for regular files but not directory.
> i.e it should avoid tracing special files
>
> Something like:
>
>         if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
>
>> > +           ret = -EINVAL;
>> > +           pr_info("probe file cannot be directory.\n");
>
> we could drop the pr_info line here, since we would any print we
> failed to parse the address.
>
> Probably you could change the last pr_info from
>
> pr_info("Failed to parse address.\n");
>
> to
>
> pr_info("Failed to parse address or file.\n");
>
>

Thanks srikar, try below patch:

>From dd37d3cc563e2619ec325d6c11d769a32def411b Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 18 Jul 2012 18:16:44 +0800
Subject: [PATCH] uprobe: checking uprobe event inode valid

Currently below command run successful:
$ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

this don't make sense, because /bin is a directory,
we need to check uprobe event inode valid more earily.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 85158fa..3b5f646 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -259,6 +259,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto fail_address_parse;

 	inode = igrab(path.dentry->d_inode);
+	 if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
+		ret = -EINVAL;
+		goto fail_address_parse;
+	}

 	argc -= 2;
 	argv += 2;
@@ -358,7 +362,7 @@ fail_address_parse:
 	if (inode)
 		iput(inode);

-	pr_info("Failed to parse address.\n");
+	pr_info("Failed to parse address or file.\n");

 	return ret;
 }
-- 
1.7.9.7
