Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0KXXen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:34:43 -0500
Received: from smtp-out.google.com ([74.125.121.35]:10500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0KXXek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Wlj2myMHjvXorF12JRaeeCIkcJCBz4Yb81GK1FpsSG+7CDdqP23EI1PNLJIuBMhcQT
         2BbcSdtlME72x3N5kJ5w==
MIME-Version: 1.0
In-Reply-To: <1290640396-24179-1-git-send-email-slavapestov@google.com>
References: <1290640396-24179-1-git-send-email-slavapestov@google.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 24 Nov 2010 15:34:17 -0800
Message-ID: <AANLkTinzoH69xwCYcAQUKdeutYrq_DjDO9MYP8AbSRGR@mail.gmail.com>
Subject: Re: [PATCH] ftrace: Fix panic when lseek() called on "trace" opened
 for writing
To: Slava Pestov <slavapestov@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 3:13 PM, Slava Pestov <slavapestov@google.com> wrote:
> The file_ops struct for the "trace" special file defined llseek as seq_lseek().
> However, if the file was opened for writing only, seq_open() was not called,
> and the seek would dereference a null pointer, file->private_data.
>
> This patch introduces a new wrapper for seq_lseek() which checks if the file
> descriptor is opened for reading first. If not, it does nothing.
>
> This patch is for Linux 2.6.36.1.
>
> Signed-Off-By: Slava Pestov <slavapestov@google.com>

Cc: Steven Rostedt <rostedt@goodmis.org>

> ---
>
> Change-Id: Iaabc50d84fb541c04e3efabd4788cebadbadbb4c
> ---
>  kernel/trace/trace.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9ec59f5..7702f5a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2320,11 +2320,19 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
>        return count;
>  }
>
> +static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
> +{
> +       if (file->f_mode & FMODE_READ)
> +               return seq_lseek(file, offset, origin);
> +       else
> +               return 0;
> +}
> +
>  static const struct file_operations tracing_fops = {
>        .open           = tracing_open,
>        .read           = seq_read,
>        .write          = tracing_write_stub,
> -       .llseek         = seq_lseek,
> +       .llseek         = tracing_seek,
>        .release        = tracing_release,
>  };
>
> --
> 1.7.3.1
>
>
