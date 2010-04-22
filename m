Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0DVGJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:09:23 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:65498 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0DVGJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lUBOXU4lS7ycE+vF5UQjJtmx0XhYRA0aJXmpWHeeYTbAKyklkP04WjUjiKucEABm2E
         OOvOyUYHHN8QNdI9YvCTK+/+XAzVrRgbgUtiiDjgY1kfieUY/evtaqm0ptL94KwynzM8
         zcIOHEjt0aO3sAlF33NTjLH+8trowWGnXPc+c=
MIME-Version: 1.0
In-Reply-To: <k2hccf7f6161004212110ze02b6cfbr2b5082441ea6a4d9@mail.gmail.com>
References: <k2hccf7f6161004212110ze02b6cfbr2b5082441ea6a4d9@mail.gmail.com>
Date: Thu, 22 Apr 2010 09:09:19 +0300
Message-ID: <o2gb6fcc0a1004212309scfd2e385p21128db152c164d0@mail.gmail.com>
Subject: Re: [PATCH 2.6.34-rc1] proc: fix badness in fs/proc/generic.c
From: Alexey Dobriyan <adobriyan@gmail.com>
To: GuanJun He <heguanbo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 7:10 AM, GuanJun He <heguanbo@gmail.com> wrote:
> fix badness in fs/proc/generic.c,  Bug 15589 -  2.6.34-rc1: Badness at
> fs/proc/generic.c:316
> this is just to get least waste.

This is already fixed by powerpc folks, I believe.
Without memory leak.

> --- linux-2.6.34-rc1.orig/fs/proc/generic.c
> +++ linux-2.6.34-rc1/fs/proc/generic.c
> @@ -313,7 +313,15 @@ static int __xlate_proc_name(const char
>                                break;
>                }
>                if (!de) {
> -                       WARN(1, "name '%s'\n", name);
> +                       char *dup = kstrdup(name, GFP_KERNEL);
> +                       if (dup) {
> +                               cp = dup;
> +                               while(*dup) {
> +                                       if (*dup == '/')
> +                                               *dup++ = '_';
> +                               }
> +                               WARN(1, "name '%s'\n", cp);
> +                       }
