Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1HQAmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:42:52 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:53053 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1HQAmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:42:51 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQ1R67-01-82X-02
X-M-MSG: 
Date: Wed, 17 Aug 2011 02:39:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: Mike Waychison <mikew@google.com>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofilefs: Handle zero-length writes.
Message-ID: <20110817003941.GC11702@erda.amd.com>
References: <1313192539-19581-1-git-send-email-mikew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1313192539-19581-1-git-send-email-mikew@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.11 19:42:19, Mike Waychison wrote:
> Currently in oprofilefs, files that use ulong_fops mis-handle writes of
> zero length.  A count of 0 causes oprofilefs_ulong_from_user to return
> 0 (success), which then leads to oprofile_set_ulong being called to
> stuff "value" into file->private_data without it being initialized.
> 
> Fix this by moving the check for a zero-length write up into
> ulong_write_file.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  drivers/oprofile/oprofilefs.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
> index e9ff6f7..ee14e6e 100644
> --- a/drivers/oprofile/oprofilefs.c
> +++ b/drivers/oprofile/oprofilefs.c
> @@ -65,9 +65,6 @@ int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_
>  	char tmpbuf[TMPBUFSIZE];
>  	unsigned long flags;
>  
> -	if (!count)
> -		return 0;
> -

Yes, *val is clearly used uninitialized for !count.

But it might be ok, not to touch it in oprofilefs_ulong_from_user.
>From man 3 write:

 "if nbyte is zero and the file is a regular file ... the write()
 function shall return zero and have no other results"

Actually, oprofilefs_ulong_from_user() must be called with an
initialized value ...

>  	if (count > TMPBUFSIZE - 1)
>  		return -EINVAL;
>  
> @@ -97,6 +94,8 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
>  
>  	if (*offset)
>  		return -EINVAL;
> +	if (count == 0)
> +		return 0;

... or we add this check to all other users of
oprofilefs_ulong_from_user() too. Without those checks they would set
its value to 0 if count is 0.

A small nitpick: I would prefer

	if (!count) ...

-Robert

>  
>  	retval = oprofilefs_ulong_from_user(&value, buf, count);
>  	if (retval)
> -- 
> 1.7.3.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

