Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2EAQPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:15:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37623 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab2EAQPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <1335778207-6511-1-git-send-email-jack@suse.cz>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 12:15:11 -0400
Message-ID: <CAHGf_=qqiast+6XzGnq+LRdFXoWG9h2MkofmjS1h5OeNPRyWfw@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
To: Jan Kara <jack@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +suffices. However, if the user buffer is not page aligned and direct read

One more thing. direct write also makes data corruption. Think
following scenario,

1) P1-T1 uses DIO write (and starting dma)
2) P1-T2 call fork() and makes P2
3) P1-T3 write to the dio target page. and then, cow break occur and
original dio target
    pages is now owned by P2.
4) P2 write the dio target page. It now does NOT make cow break. and
now we break
    dio target page data.
5) DMA transfer write invalid data to disk.

The detail is described in your refer URLs.


> +runs in parallel with a
> +.BR fork (2)
> +of the reader process, it may happen that the read data is split between
> +pages owned by the original process and its child. Thus effectively read
> +data is corrupted.
>  .LP
>  The
>  .B O_DIRECT
