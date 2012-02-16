Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2BPNcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:32:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2BPNcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:32:08 -0500
MIME-Version: 1.0
In-Reply-To: <1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
	<1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
Date: Thu, 16 Feb 2012 21:32:08 +0800
Message-ID: <CAJd=RBBr4EkCwAaS3xZZrm0QE71Z0soyZXTuwXyBn6ohp3pU2Q@mail.gmail.com>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than PAGE_SIZE
From: Hillf Danton <dhillf@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 8:01 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> @@ -416,17 +417,20 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
>         * Writing zeroes into userspace here is OK, because we know that if
>         * the zero gets there, we'll be overwriting it.
>         */
> -       ret = __put_user(0, uaddr);
> +       while (uaddr <= end) {
> +               ret = __put_user(0, uaddr);
> +               if (ret != 0)
> +                       return ret;
> +               uaddr += PAGE_SIZE;
> +       }

What if
             uaddr & ~PAGE_MASK == PAGE_SIZE -3 &&
                end & ~PAGE_MASK == 2
