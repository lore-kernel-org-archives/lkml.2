Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1IWAAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:00:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1IWAAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:00:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=UYl/xJEaUAOCE3N84R/yRqp7AkekbQS0FTI0S4Uy9Z6UM9kGDKrj0st61l8gi6i4D
	ejgy9UqpihAGmYIKhuJKg==
MIME-Version: 1.0
In-Reply-To: <20110922212328.GA30679@infradead.org>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	<20110922212328.GA30679@infradead.org>
Date: Thu, 22 Sep 2011 17:00:17 -0700
X-Google-Sender-Auth: mPkQveUvlJ9FJh3v8lNjB-YWi2I
Message-ID: <CAMbhsRRiQi-KqbSCtDGLTeBVtD-d1LVwSY+u_0it6ZRgUoR4MA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Replace kmalloc with vmalloc in seq_files
From: Colin Cross <ccross@android.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:23 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 22, 2011 at 01:57:06PM -0700, Colin Cross wrote:
>> seq_files are often used for debugging data.  When the system is under
>> memory pressure, and dumping debugging data starts trying to allocate
>> large physically contiguous buffers, it often makes the problem worse.
>
> Please fix the instances that you see issues with by using the full
> seq_file interface which was designed for his instead of the simplified
> "single" interface that is only designed for small amounts of data.

You're probably right, but it's not always easy.  For files that need
to show an atomic snapshot of some data, the data needs to go
somewhere.  It would be possible to allocate a smaller data structure
and atomically copy a snapshot into it, then use the iterator
interface to push the data out to userspace, but that's a lot harder
than a vmalloc and a few seq_printfs.

If seq_file used a list of buffers, it could allocate much smaller
chunks (a page?), and add new buffers to the list instead of
reallocating and calling the read function again.
