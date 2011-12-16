Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab1LPMlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:41:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1LPMlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:41:02 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=-YAZRknjPdYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=D19gQVrFAAAA:8 a=pGLkceISAAAA:8 a=bDutdN0_0ZJS8IUayg0A:9 a=kcW0Hj0i8duS9fZ5pbcA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324039259.23971.127.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] Fix Compilation Warning in kernel/trace/trace.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Dec 2011 07:40:59 -0500
In-Reply-To: <1324019724-3422-1-git-send-email-devendra.aaru@gmail.com>
References: <1324019724-3422-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 02:15 -0500, Devendra Naga wrote:
> there was a compilation warning saying
> kernel/trace/trace.c:3644:8: warning: ‘page2’ may be used uninitialized in this function

Nacked-by: Steven Rostedt <rostedt@goodmis.org>

And I also nacked this same fix here:

https://lkml.org/lkml/2011/11/28/287


> 
> The page2 pointer is used only when nr_pages = 2.
> 
> Assigned a null value to the page2 to get rid of warning.


Please please please, do not just fix warnings without actually looking
at the code.

1) this is a bug in the compiler, which happens to be fixed in newer
compilers (which does not produce this warning). It just happens that
gcc couldn't tell the simple usage of:

	if (nr_pages == 2)
		page2 = kmap_atomic(pages[1]);

and later:

	if (nr_pages == 2) {
		len = PAGE_SIZE - offset;
		memcpy(&entry->buf, page1 + offset, len);
		memcpy(&entry->buf[len], page2, cnt - len);

and finally:

	if (nr_pages == 2)
		kunmap_atomic(page2);

nr_pages never changes during this code. Gcc probably got confused
because on error exit, it does change (to unmap everything).

2) But your fix is still wrong!

Initializing it to NULL is wrong! Because it would hide a kernel bug if
page2 was really used uninitialized. As passing NULL as the source of
memcpy will panic the kernel.

Again, do not just randomly post fixes to gcc warnings without
understanding the real fix.

Thanks,

-- Steve



> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f2bd275..80dfd92 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3641,7 +3641,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  	int nr_pages = 1;
>  	ssize_t written;
>  	void *page1;
> -	void *page2;
> +	void *page2 = NULL;
>  	int offset;
>  	int size;
>  	int len;


