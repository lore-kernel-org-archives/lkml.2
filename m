Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1A3K0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 05:26:33 -0500
Received: from smtp-out.google.com ([74.125.121.67]:27892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1A3K0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 05:26:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CldN4hf1gGbjlX2VswOO6ALalt10SnF2u02fgjX0ljmLxl0L7v9gMQdGvAA7P7WKBL
         MqB/MCNsKt6noNrcOewA==
MIME-Version: 1.0
In-Reply-To: <1296371720-4176-1-git-send-email-tm@tao.ma>
References: <1296371720-4176-1-git-send-email-tm@tao.ma>
Date: Sun, 30 Jan 2011 02:26:27 -0800
Message-ID: <AANLkTik1dt1Q9TA+JmdvkuOqmt5LB2iZ1X2B5GbBFx1+@mail.gmail.com>
Subject: Re: [PATCH] mlock: revert the optimization for dirtying pages and
 triggering writeback.
From: Michel Lespinasse <walken@google.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 29, 2011 at 11:15 PM, Tao Ma <tm@tao.ma> wrote:
>        buf = mmap(NULL, file_len, PROT_WRITE, MAP_SHARED, fd, 0);
>        if (buf == MAP_FAILED) {
>                perror("mmap");
>                goto out;
>        }
>
>        if (mlock(buf, file_len) < 0) {
>                perror("mlock");
>                goto out;
>        }

Thanks Tao for tracing this to an individual change. I can reproduce
this on my system. The issue is that the file is mapped without the
PROT_READ permission, so mlock can't fault in the pages. Up to 2.6.37
this worked because mlock was using a write.

The test case does show there was a behavior change; however it's not
clear to me that the tested behavior is valid.

I can see two possible resolutions:

1- do nothing, if we can agree that the test case is invalid

2- restore the previous behavior for writable, non-readable, shared
mappings while preserving the optimization for read/write shared
mappings. The test would then look like:
        if ((vma->vm_flags & VM_WRITE) && (vma->vm_flags & (VM_READ |
VM_SHARED)) != VM_SHARED)
                gup_flags |= FOLL_WRITE;

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
