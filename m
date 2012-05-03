Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2ECJqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:46:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2ECJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:46:02 -0400
Date: Thu, 3 May 2012 02:44:38 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/3] vmevent: Implement 'low memory' attribute
Message-ID: <20120503094438.GA17744@lizard>
References: <20120501132409.GA22894@lizard>
 <CAOJsxLGxKdDnw6RU=1C3VVrwZJ53k_r6gOddYkjxQxjc1-kRXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOJsxLGxKdDnw6RU=1C3VVrwZJ53k_r6gOddYkjxQxjc1-kRXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:10:12AM +0300, Pekka Enberg wrote:
> On Tue, May 1, 2012 at 4:24 PM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > Accounting only free pages is very inaccurate for low memory handling,
> > so we have to be smarter here.
> 
> Can you elaborate on what kind of problems there are with tracking free pages?

Well, there's no problem with tracking itself, the word 'inaccurate'
was probably misleading. Tracking just free pages is inaccurate for
our "low memory" notification needs, but NR_FREE_PAGES tracking
itself is fine.

The thing is that NR_FREE_PAGES accounts only completely unused
(wasted) pages. Most of the time we have very low NR_FREE_PAGES,
and lots of page cache and block buffers (i.e. NR_FILE_PAGES).

The file pages are easily reclaimable (except shmem/tmpfs and
locked pages), so file pages may be considered as "somewhat
free" pages.

The cache might contain very stale data (or not), so we have to
maneuver between the two strategies: sacrifice caches, or start
freeing memory (which prevents caches draining).

The strategy is described in the third patch in the series.
It might be not ideal, but the logic itself is not part of
the ABI (this is very similar "not ABI" rules as we have for
OOM scoring logic), and is subject for changes.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
