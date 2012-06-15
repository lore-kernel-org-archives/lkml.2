Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab2FOWjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:39:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46674 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2FOWjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:39:13 -0400
MIME-Version: 1.0
In-Reply-To: <1339794567-17784-1-git-send-email-greg.pearson@hp.com>
References: <1339794567-17784-1-git-send-email-greg.pearson@hp.com>
Date: Fri, 15 Jun 2012 15:39:13 -0700
X-Google-Sender-Auth: sHglSMrmYWDIJ3GlEAImiZZlI4g
Message-ID: <CAE9FiQWGSDw7R2gbVYKfL6wmRVivaKhSALqXof1TsjgMNNf1hQ@mail.gmail.com>
Subject: Re: [PATCH] mm/memblock: fix overlapping allocation when doubling
 reserved array
From: Yinghai Lu <yinghai@kernel.org>
To: Greg Pearson <greg.pearson@hp.com>
Cc: tj@kernel.org, hpa@linux.intel.com, akpm@linux-foundation.org,
        shangw@linux.vnet.ibm.com, mingo@elte.hu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 2:09 PM, Greg Pearson <greg.pearson@hp.com> wrote:
> The __alloc_memory_core_early() routine will ask memblock for a range
> of memory then try to reserve it. If the reserved region array lacks
> space for the new range, memblock_double_array() is called to allocate
> more space for the array. If memblock is used to allocate memory for
> the new array it can end up using a range that overlaps with the range
> originally allocated in __alloc_memory_core_early(), leading to possible
> data corruption.
>
> @@ -399,7 +401,8 @@ repeat:
>         */
>        if (!insert) {
>                while (type->cnt + nr_new > type->max)
> -                       if (memblock_double_array(type) < 0)
> +                       /* Avoid possible overlap if range is being reserved */
> +                       if (memblock_double_array(type, base) < 0)

should use obase here.

Yinghai

>                                return -ENOMEM;
>                insert = true;
>                goto repeat;
