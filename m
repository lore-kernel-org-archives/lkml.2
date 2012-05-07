Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2EGSt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:49:57 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16917
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab2EGSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:49:56 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dI9371IfecI1432N98dKzz1202hzzz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4FA8195E.2010706@am.sony.com>
Date: Mon, 7 May 2012 11:50:06 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at
 boot
References: <4FA4673C.7010209@am.sony.com> <20120504233707.GA24213@kroah.com>
In-Reply-To: <20120504233707.GA24213@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 04:37 PM, Greg KH wrote:
> On Fri, May 04, 2012 at 04:33:16PM -0700, Tim Bird wrote:
>> +#define MAX_LOGS	5
>> +struct logger_log *logs_array[MAX_LOGS];
> 
> You are going to make this a list and not a static array in the
> future, right?

Would that be better?  The for-loop is IMHO simpler than a
list walk for finding matches.  I anticipate that the size of
this array should never (famous last words) be bigger than about
20 entries, even in the dynamic-allocation-per-application
case.  And that's a ways off in implementation.

I'll be happy to switch to a linked list once it looks like we're
going to have more than 5 entries.  Or I can switch to a linked
list now if you think it's better form to code for the longer-term
anticipated features.

Not a big deal to me either way.

> 
>> -static int __init init_log(struct logger_log *log)
>> +static int __init add_log(struct logger_log *log)
>>  {
>> -	int ret;
>> +	int i;
>>
>> +	for (i = 0; i < MAX_LOGS; i++) {
>> +		if (logs_array[i] == 0) {
>> +			logs_array[i] = log;
>> +			return 0;
>> +		}
>> +	}
>> +	return -1;
>> +}
> 
> I see you didn't run your patch through sparse :(

Indeed - shame on me. :-(

> Care to fix up the sparse warnings and resend?
OK - this patch has 2 sparse issues, and there were
2 already in the code.  Do you want me to send the
other 2 sparse fixes as an independent patch, or could
I cheat and throw them in this one?

Below is what the fixes look like. (BTW - these are
formatted for human review but not for mainline submission.)

Thanks for your help.
 -- Tim

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index fa5fd71..9f4ed84 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -61,7 +61,7 @@ struct logger_reader {
 };

 /* logger_offset - returns index 'n' into the log via (optimized) modulus */
-size_t logger_offset(struct logger_log *log, size_t n)
+static size_t logger_offset(struct logger_log *log, size_t n)
 {
        return n & (log->size-1);
 }
@@ -349,7 +349,7 @@ static ssize_t do_write_log_from_user(struct logger_log *log,
  * writev(), and aio_write(). Writes are our fast path, and we try to optimize
  * them above all else.
  */
-ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
+static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
                         unsigned long nr_segs, loff_t ppos)
 {
        struct logger_log *log = file_get_log(iocb->ki_filp);
@@ -566,7 +566,7 @@ static const struct file_operations logger_fops = {
 };

 #define MAX_LOGS       5
-struct logger_log *logs_array[MAX_LOGS];
+static struct logger_log *logs_array[MAX_LOGS];

 static struct logger_log *get_log_from_minor(int minor)
 {
@@ -584,7 +584,7 @@ static int __init add_log(struct logger_log *log)
        int i;

        for (i = 0; i < MAX_LOGS; i++) {
-               if (logs_array[i] == 0) {
+               if (logs_array[i] == NULL) {
                        logs_array[i] = log;
                        return 0;
                }

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

