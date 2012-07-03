Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2GCSAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:00:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab2GCSAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:00:09 -0400
Message-ID: <1341338371.880.1.camel@mop>
Subject: Re: [patch] printk: remove some dead code
From: Kay Sievers <kay@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 03 Jul 2012 19:59:31 +0200
In-Reply-To: <CAPXgP10e5cuNnOqGgBtZQq-6sZ2bpjySbd7thZyLNdij77oaHg@mail.gmail.com>
References: <20120703104511.GA29501@elgon.mountain>
	 <CAPXgP10e5cuNnOqGgBtZQq-6sZ2bpjySbd7thZyLNdij77oaHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 13:21 +0200, Kay Sievers wrote:
> On Tue, Jul 3, 2012 at 12:45 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > Static checkers complain about the impossible condition here.
> >
> > In 084681d14e ('printk: flush continuation lines immediately to
> > console'), we changed msg->level from being a u16 to being an unsigned
> > 3 bit bitfield.  That means we can remove the code here to handle log
> > levels which are in the tens or hundreds column.
> 
> We should do that for the facility value, now that level is split up
> in separate fields. I'll prepare a fix.

Here it is. Nice tool, very useful.

Thanks again,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: add the facility number to the syslog prefix

After the recent split of facility and level into separate variables,
we miss the facility value (always 0 for kernel-originated messages)
in the syslog prefix.

On Tue, Jul 3, 2012 at 12:45 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Static checkers complain about the impossible condition here.
>
> In 084681d14e ('printk: flush continuation lines immediately to
> console'), we changed msg->level from being a u16 to being an unsigned
> 3 bit bitfield.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 kernel/printk.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -818,15 +818,16 @@ static size_t print_time(u64 ts, char *b
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
+	unsigned int prefix = (msg->facility << 3) | msg->level;
 
 	if (syslog) {
 		if (buf) {
-			len += sprintf(buf, "<%u>", msg->level);
+			len += sprintf(buf, "<%u>", prefix);
 		} else {
 			len += 3;
-			if (msg->level > 9)
+			if (prefix > 9)
 				len++;
-			if (msg->level > 99)
+			if (prefix > 99)
 				len++;
 		}
 	}


